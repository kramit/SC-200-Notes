<#
.SYNOPSIS
Imports Microsoft Sentinel Training Lab telemetry into an existing Log Analytics workspace.

.DESCRIPTION
Downloads the Training Lab ingestion helper and telemetry files from the Azure-Sentinel
GitHub repository, then runs the helper against an existing workspace. The helper creates
the required Data Collection Endpoint, Data Collection Rules, custom tables, and ingests
the CSV/JSON telemetry through the Azure Monitor Logs Ingestion API.

Requires Azure CLI and an authenticated session from `az login`.
#>
[CmdletBinding()]
param(
    [string]$SubscriptionId,

    [string]$ResourceGroupName = "defender-RG",

    [string]$WorkspaceName = "defenderWorkspace",

    [string]$RepoBaseUrl = "https://raw.githubusercontent.com/Azure/Azure-Sentinel/master/Tools/Microsoft-Sentinel-Training-Lab/Artifacts",

    [string]$WorkDir = (Join-Path $env:TEMP "sentinel-training-lab-ingest"),

    [string]$DceName = "sentinel-training-dce",

    [string]$DcrPrefix = "sentinel-training-",

    [string]$BuiltInDcrPrefix = "sentinel-training-builtin-",

    [string]$AssigneeObjectId,

    [bool]$IncludeBuiltIn = $true,

    [switch]$DownloadOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-AzCli {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI is required. Install it, then run 'az login' before using this script."
    }
}

function Resolve-SubscriptionId {
    param([string]$ProvidedSubscriptionId)

    if ($ProvidedSubscriptionId) {
        az account set --subscription $ProvidedSubscriptionId | Out-Null
        return $ProvidedSubscriptionId
    }

    $subscription = az account show --query id -o tsv 2>$null
    if (-not $subscription) {
        throw "No Azure CLI subscription context found. Run 'az login' and select a subscription, or pass -SubscriptionId."
    }

    return $subscription
}

function Get-GitHubApiInfo {
    param([string]$RawBaseUrl)

    if ($RawBaseUrl -notmatch '^https://raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.+)$') {
        throw "RepoBaseUrl must be a raw.githubusercontent.com URL. Got: $RawBaseUrl"
    }

    return @{
        Owner  = $Matches[1]
        Repo   = $Matches[2]
        Branch = $Matches[3]
        Path   = $Matches[4]
        Base   = "https://api.github.com/repos/$($Matches[1])/$($Matches[2])/contents/$($Matches[4])"
        Query  = "?ref=$($Matches[3])"
    }
}

function Get-RepoFiles {
    param(
        [hashtable]$ApiInfo,
        [string]$SubFolder,
        [string[]]$Extensions
    )

    $headers = @{
        "User-Agent" = "SentinelTrainingLabImport"
        "Accept"     = "application/vnd.github.v3+json"
    }
    $url = "$($ApiInfo.Base)/$SubFolder$($ApiInfo.Query)"
    $response = Invoke-RestMethod -Uri $url -Headers $headers
    $items = @($response)
    if ($response -and $response.PSObject.Properties.Name -contains "name" -and $response.name -is [array]) {
        $items = for ($i = 0; $i -lt $response.name.Count; $i++) {
            [pscustomobject]@{
                name = $response.name[$i]
                type = $response.type[$i]
            }
        }
    }

    return @(
        $items |
            Where-Object {
                $_.type -eq "file" -and
                $Extensions -contains ([System.IO.Path]::GetExtension($_.name).ToLowerInvariant())
            } |
            Select-Object -ExpandProperty name
    )
}

function Save-RepoFile {
    param(
        [string]$Url,
        [string]$OutFile
    )

    $parent = Split-Path -Path $OutFile -Parent
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $maxAttempts = 4
    for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
        try {
            Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
            return
        }
        catch {
            if ($attempt -eq $maxAttempts) {
                throw "Failed to download $Url after $maxAttempts attempts. Last error: $($_.Exception.Message)"
            }

            $delay = [math]::Min(30, [math]::Pow(2, $attempt))
            Write-Warning "Download failed for $Url. Retrying in $delay seconds..."
            Start-Sleep -Seconds $delay
        }
    }
}

Assert-AzCli
$SubscriptionId = Resolve-SubscriptionId -ProvidedSubscriptionId $SubscriptionId

$apiInfo = Get-GitHubApiInfo -RawBaseUrl $RepoBaseUrl

$scriptsDir = Join-Path $WorkDir "Scripts"
$customTelemetryPath = Join-Path $WorkDir "Telemetry\Custom"
$builtInTelemetryPath = Join-Path $WorkDir "Telemetry\BuildIn"
$templatesPath = Join-Path $WorkDir "DCRTemplates"

foreach ($dir in @($scriptsDir, $customTelemetryPath, $builtInTelemetryPath, $templatesPath)) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

Write-Host "Using subscription: $SubscriptionId"
Write-Host "Target workspace: $ResourceGroupName/$WorkspaceName"
Write-Host "Working folder: $WorkDir"

$ingestScriptPath = Join-Path $scriptsDir "IngestCSV.ps1"
Write-Host "Downloading ingestion helper..."
Save-RepoFile -Url "$RepoBaseUrl/Scripts/IngestCSV.ps1" -OutFile $ingestScriptPath

Write-Host "Discovering telemetry files..."
$customFiles = Get-RepoFiles -ApiInfo $apiInfo -SubFolder "Telemetry/Custom" -Extensions @(".csv")
$builtInFiles = if ($IncludeBuiltIn) {
    Get-RepoFiles -ApiInfo $apiInfo -SubFolder "Telemetry/BuildIn" -Extensions @(".csv", ".json")
} else {
    @()
}

Write-Host "Downloading $($customFiles.Count) custom telemetry file(s)..."
foreach ($file in $customFiles) {
    Save-RepoFile -Url "$RepoBaseUrl/Telemetry/Custom/$file" -OutFile (Join-Path $customTelemetryPath $file)
}

if ($IncludeBuiltIn) {
    Write-Host "Downloading $($builtInFiles.Count) built-in telemetry file(s)..."
    foreach ($file in $builtInFiles) {
        Save-RepoFile -Url "$RepoBaseUrl/Telemetry/BuildIn/$file" -OutFile (Join-Path $builtInTelemetryPath $file)
    }
}

if ($DownloadOnly) {
    Write-Host "DownloadOnly was set. Files are ready in: $WorkDir"
    return
}

$ingestArgs = @{
    SubscriptionId      = $SubscriptionId
    ResourceGroupName   = $ResourceGroupName
    WorkspaceName       = $WorkspaceName
    DceName             = $DceName
    DcrPrefix           = $DcrPrefix
    TelemetryPath       = $customTelemetryPath
    TemplatesOutputPath = $templatesPath
    Deploy              = $true
    Ingest              = $true
}

if ($AssigneeObjectId) {
    $ingestArgs["AssigneeObjectId"] = $AssigneeObjectId
}

if ($IncludeBuiltIn) {
    $ingestArgs["BuiltInTelemetryPath"] = $builtInTelemetryPath
    $ingestArgs["BuiltInDcrPrefix"] = $BuiltInDcrPrefix
    $ingestArgs["DeployBuiltInDcr"] = $true
}

Write-Host "Starting ingestion. This will create/update DCE, DCR, and table resources as needed..."
& $ingestScriptPath @ingestArgs
