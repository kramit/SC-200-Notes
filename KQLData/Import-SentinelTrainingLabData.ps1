<#
.SYNOPSIS
Imports the SC-200 training CSV data into an existing Log Analytics workspace.

.DESCRIPTION
Downloads CSV files from this repository's KQLData/Artifacts/Telemetry folder and
posts them to the Azure Monitor Log Analytics Data Collector API. The only required
inputs are the resource group and workspace name; the script resolves the workspace
ID and shared key with Azure CLI.

Requires Azure CLI and an authenticated session from `az login`.

.EXAMPLE
.\Import-SentinelTrainingLabData.ps1 -ResourceGroupName rg-sc200-lab -WorkspaceName law-sc200-lab
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceName,

    [string]$SubscriptionId,

    [string]$RepoBaseUrl = "https://raw.githubusercontent.com/kramit/SC-200-Notes/main/KQLData/Artifacts",

    [string]$WorkDir = (Join-Path ([System.IO.Path]::GetTempPath()) "sc200-training-data"),

    [int]$MaxBatchBytes = 25MB,

    [switch]$SkipDownload
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$TelemetryFiles = [ordered]@{
    "securityEvents.csv"                    = "SecurityEvent"
    "disable_accounts.csv"                  = "SigninLogs"
    "office_activity_inbox_rule.csv"        = "OfficeActivity"
    "azureActivity_adele.csv"               = "AzureActivity"
    "azure_activity.csv"                    = "AzureActivity"
    "office_activity.csv"                   = "OfficeActivity"
    "sign-in_adelete.csv"                   = "SigninLogs"
    "signinLogs.csv"                        = "SigninLogs"
    "model_evasion_detection_CL_alerts.csv" = "OfficeActivity"
    "solarigate-beacon-umbrella.csv"        = "Cisco_Umbrella_dns"
    "AuditLogs_Hunting.csv"                 = "AuditLogs"
    "solarigate_CEFevent.csv"               = "CommonSecurityLog"
    "HighRiskApps.csv"                      = "HighRiskApps"
    "PenTestsIPaddresses.csv"               = "PenTestsIPaddresses"
    "ABAPAppLog_CL.csv"                     = "ABAPAppLog"
    "ABAPAuditLog_CL.csv"                   = "ABAPAuditLog"
    "ABAPChangeDocsLog_CL.csv"              = "ABAPChangeDocsLog"
    "ABAPCRLog_CL.csv"                      = "ABAPCRLog"
    "ABAPJobLog_CL.csv"                     = "ABAPJobLog"
    "ABAPSpoolLog_CL.csv"                   = "ABAPSpoolLog"
}

function Assert-AzCli {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI is required. Install it, then run 'az login' before using this script."
    }
}

function Resolve-Subscription {
    param([string]$ProvidedSubscriptionId)

    if ($ProvidedSubscriptionId) {
        az account set --subscription $ProvidedSubscriptionId | Out-Null
        return $ProvidedSubscriptionId
    }

    $currentSubscriptionId = az account show --query id -o tsv 2>$null
    if (-not $currentSubscriptionId) {
        throw "No Azure CLI subscription context found. Run 'az login' or pass -SubscriptionId."
    }

    return $currentSubscriptionId
}

function Get-WorkspaceCredentials {
    param(
        [string]$ResourceGroupName,
        [string]$WorkspaceName
    )

    $customerId = az monitor log-analytics workspace show `
        --resource-group $ResourceGroupName `
        --workspace-name $WorkspaceName `
        --query customerId `
        -o tsv

    if (-not $customerId) {
        throw "Could not find workspace '$WorkspaceName' in resource group '$ResourceGroupName'."
    }

    $sharedKey = az monitor log-analytics workspace get-shared-keys `
        --resource-group $ResourceGroupName `
        --workspace-name $WorkspaceName `
        --query primarySharedKey `
        -o tsv

    if (-not $sharedKey) {
        throw "Could not read the primary shared key for workspace '$WorkspaceName'."
    }

    return [pscustomobject]@{
        CustomerId = $customerId
        SharedKey  = $sharedKey
    }
}

function Save-TrainingFile {
    param(
        [string]$FileName,
        [string]$OutputPath
    )

    $url = "$RepoBaseUrl/Telemetry/$FileName"
    $parent = Split-Path -Path $OutputPath -Parent
    if (-not (Test-Path -Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    Write-Host "Downloading $FileName"
    Invoke-WebRequest -Uri $url -OutFile $OutputPath -UseBasicParsing
}

function New-LogAnalyticsSignature {
    param(
        [string]$CustomerId,
        [string]$SharedKey,
        [string]$Date,
        [int]$ContentLength,
        [string]$Method,
        [string]$ContentType,
        [string]$Resource
    )

    $xHeaders = "x-ms-date:$Date"
    $stringToHash = "$Method`n$ContentLength`n$ContentType`n$xHeaders`n$Resource"
    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($SharedKey)
    $sha256 = [System.Security.Cryptography.HMACSHA256]::new($keyBytes)
    $hash = $sha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($hash)

    return "SharedKey ${CustomerId}:$encodedHash"
}

function Send-LogAnalyticsBatch {
    param(
        [string]$CustomerId,
        [string]$SharedKey,
        [string]$LogType,
        [object[]]$Records
    )

    if (-not $Records -or $Records.Count -eq 0) {
        return $null
    }

    $body = $Records | ConvertTo-Json -Depth 30
    $bodyBytes = [Text.Encoding]::UTF8.GetBytes($body)
    $method = "POST"
    $contentType = "application/json"
    $resource = "/api/logs"
    $date = (Get-Date).ToUniversalTime().ToString("r")
    $contentLength = $bodyBytes.Length
    $signature = New-LogAnalyticsSignature `
        -CustomerId $CustomerId `
        -SharedKey $SharedKey `
        -Date $date `
        -ContentLength $contentLength `
        -Method $method `
        -ContentType $contentType `
        -Resource $resource

    $headers = @{
        "Authorization" = $signature
        "Log-Type"      = $LogType
        "x-ms-date"     = $date
    }

    $uri = "https://$CustomerId.ods.opinsights.azure.com$resource" + "?api-version=2016-04-01"
    $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $bodyBytes -UseBasicParsing
    return $response.StatusCode
}

function Send-CsvToLogAnalytics {
    param(
        [string]$Path,
        [string]$LogType,
        [string]$CustomerId,
        [string]$SharedKey
    )

    $records = @(Import-Csv -Path $Path)
    $batch = @()
    $batchBytes = 0
    $sent = 0

    foreach ($record in $records) {
        $recordBytes = [Text.Encoding]::UTF8.GetByteCount(($record | ConvertTo-Json -Depth 30 -Compress))
        if ($batch.Count -gt 0 -and ($batchBytes + $recordBytes) -ge $MaxBatchBytes) {
            if ($PSCmdlet.ShouldProcess($LogType, "Ingest $($batch.Count) records")) {
                Send-LogAnalyticsBatch -CustomerId $CustomerId -SharedKey $SharedKey -LogType $LogType -Records $batch | Out-Null
            }
            $sent += $batch.Count
            $batch = @()
            $batchBytes = 0
        }

        $batch += $record
        $batchBytes += $recordBytes
    }

    if ($batch.Count -gt 0) {
        if ($PSCmdlet.ShouldProcess($LogType, "Ingest $($batch.Count) records")) {
            Send-LogAnalyticsBatch -CustomerId $CustomerId -SharedKey $SharedKey -LogType $LogType -Records $batch | Out-Null
        }
        $sent += $batch.Count
    }

    return $sent
}

Assert-AzCli
$resolvedSubscriptionId = Resolve-Subscription -ProvidedSubscriptionId $SubscriptionId
$credentials = Get-WorkspaceCredentials -ResourceGroupName $ResourceGroupName -WorkspaceName $WorkspaceName
$telemetryPath = Join-Path $WorkDir "Telemetry"

Write-Host "Using subscription: $resolvedSubscriptionId"
Write-Host "Target workspace: $ResourceGroupName/$WorkspaceName"
Write-Host "Source artifacts: $RepoBaseUrl"
Write-Host "Working folder: $telemetryPath"

if (-not $SkipDownload) {
    foreach ($fileName in $TelemetryFiles.Keys) {
        Save-TrainingFile -FileName $fileName -OutputPath (Join-Path $telemetryPath $fileName)
    }
}

$summary = foreach ($fileName in $TelemetryFiles.Keys) {
    $path = Join-Path $telemetryPath $fileName
    if (-not (Test-Path -Path $path)) {
        throw "Missing telemetry file '$path'. Remove -SkipDownload or check RepoBaseUrl."
    }

    $logType = $TelemetryFiles[$fileName]
    Write-Host "Ingesting $fileName into $logType"
    $count = Send-CsvToLogAnalytics `
        -Path $path `
        -LogType $logType `
        -CustomerId $credentials.CustomerId `
        -SharedKey $credentials.SharedKey

    [pscustomobject]@{
        File    = $fileName
        LogType = $logType
        Records = $count
        Table   = if ($logType.EndsWith("_CL")) { $logType } else { "${logType}_CL" }
    }
}

$summary | Format-Table -AutoSize

if ($WhatIfPreference) {
    Write-Host "WhatIf was set. No data was posted."
}
else {
    Write-Host "Ingestion requests completed. Tables can take several minutes to appear in Log Analytics."
}
