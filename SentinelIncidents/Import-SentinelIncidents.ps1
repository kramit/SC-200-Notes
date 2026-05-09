<#
.SYNOPSIS
Imports sample Microsoft Sentinel incidents into an existing Sentinel workspace.

.DESCRIPTION
Reads a CSV of lab incidents and creates or updates Microsoft.SecurityInsights
incident resources in an existing Log Analytics workspace that has Microsoft
Sentinel enabled. It can also create related bookmarks, mapped entities, and
comments so the incident page has timeline and investigation content to explore.
The script uses Azure CLI and `az rest`, so it works well in Azure Cloud Shell
without requiring Az PowerShell modules.

.EXAMPLE
.\Import-SentinelIncidents.ps1 -ResourceGroupName defender-RG -WorkspaceName defenderWorkspace
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $true)]
    [string]$WorkspaceName,

    [string]$SubscriptionId,

    [string]$CsvPath,

    [string]$EvidenceCsvPath,

    [string]$ApiVersion = "2024-03-01",

    [switch]$SkipEvidence,

    [switch]$PassThru
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-AzCli {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI is required. In Cloud Shell it is already installed; otherwise install it and run 'az login'."
    }
}

function Resolve-Subscription {
    param([string]$ProvidedSubscriptionId)

    if ($ProvidedSubscriptionId) {
        az account set --subscription $ProvidedSubscriptionId | Out-Null
        return $ProvidedSubscriptionId
    }

    $currentSubscriptionId = (az account show --query id -o tsv 2>$null).Trim()
    if (-not $currentSubscriptionId) {
        throw "No Azure CLI subscription context found. Run 'az login' or pass -SubscriptionId."
    }

    return $currentSubscriptionId
}

function Test-WorkspaceExists {
    param(
        [string]$ResourceGroupName,
        [string]$WorkspaceName
    )

    $workspaceId = (az monitor log-analytics workspace show `
        --resource-group $ResourceGroupName `
        --workspace-name $WorkspaceName `
        --query id `
        -o tsv).Trim()

    if (-not $workspaceId) {
        throw "Could not find workspace '$WorkspaceName' in resource group '$ResourceGroupName'."
    }

    return $workspaceId
}

function ConvertTo-IncidentLabels {
    param([string]$LabelNames)

    if (-not $LabelNames) {
        return @()
    }

    $labels = @(
        $LabelNames -split ";" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ } |
            ForEach-Object {
                @{
                    labelName = $_
                    labelType = "User"
                }
            }
    )

    return ,$labels
}

function ConvertTo-StringArray {
    param([string]$Value)

    if (-not $Value) {
        return @()
    }

    $items = @(
        $Value -split ";" |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ }
    )

    return ,$items
}

function Add-EntityMapping {
    param(
        [System.Collections.ArrayList]$Mappings,
        [string]$EntityType,
        [string]$Identifier,
        [string]$Value
    )

    if (-not $Value) {
        return
    }

    [void]$Mappings.Add(@{
        entityType    = $EntityType
        fieldMappings = @(
            @{
                identifier = $Identifier
                value      = $Value
            }
        )
    })
}

function ConvertTo-BookmarkEntityMappings {
    param([pscustomobject]$Evidence)

    $mappings = [System.Collections.ArrayList]::new()
    Add-EntityMapping -Mappings $mappings -EntityType "Account" -Identifier "FullName" -Value $Evidence.Account
    Add-EntityMapping -Mappings $mappings -EntityType "Host" -Identifier "HostName" -Value $Evidence.Host
    Add-EntityMapping -Mappings $mappings -EntityType "IP" -Identifier "Address" -Value $Evidence.IpAddress
    Add-EntityMapping -Mappings $mappings -EntityType "URL" -Identifier "Url" -Value $Evidence.Url

    return ,@($mappings)
}

function New-IncidentBody {
    param([pscustomobject]$Incident)

    $now = (Get-Date).ToUniversalTime()
    $firstOffset = if ($Incident.FirstActivityOffsetHours) { [int]$Incident.FirstActivityOffsetHours } else { -1 }
    $lastOffset = if ($Incident.LastActivityOffsetHours) { [int]$Incident.LastActivityOffsetHours } else { 0 }

    return @{
        properties = @{
            title                = $Incident.Title
            description          = $Incident.Description
            severity             = $Incident.Severity
            status               = $Incident.Status
            firstActivityTimeUtc = $now.AddHours($firstOffset).ToString("o")
            lastActivityTimeUtc  = $now.AddHours($lastOffset).ToString("o")
            labels               = ConvertTo-IncidentLabels -LabelNames $Incident.LabelNames
        }
    }
}

function New-BookmarkBody {
    param(
        [pscustomobject]$Evidence,
        [pscustomobject]$Incident,
        [string]$IncidentName
    )

    $now = (Get-Date).ToUniversalTime()
    $eventOffset = if ($Evidence.EventOffsetHours) { [int]$Evidence.EventOffsetHours } else { -1 }
    $eventTime = $now.AddHours($eventOffset)

    return @{
        properties = @{
            displayName    = $Evidence.DisplayName
            notes          = $Evidence.Notes
            query          = $Evidence.Query
            queryResult    = $Evidence.QueryResult
            eventTime      = $eventTime.ToString("o")
            queryStartTime = $eventTime.AddMinutes(-30).ToString("o")
            queryEndTime   = $eventTime.AddMinutes(30).ToString("o")
            labels         = ConvertTo-StringArray -Value $Evidence.Labels
            tactics        = ConvertTo-StringArray -Value $Evidence.Tactics
            techniques     = ConvertTo-StringArray -Value $Evidence.Techniques
            entityMappings = ConvertTo-BookmarkEntityMappings -Evidence $Evidence
            incidentInfo   = @{
                incidentId   = $IncidentName
                relationName = "Contains"
                severity     = $Incident.Severity
                title        = $Incident.Title
            }
        }
    }
}

function New-CommentBody {
    param(
        [pscustomobject]$Incident,
        [pscustomobject[]]$EvidenceRows
    )

    $evidenceText = if ($EvidenceRows.Count -gt 0) {
        ($EvidenceRows | ForEach-Object { "- $($_.DisplayName): $($_.Notes)" }) -join "`n"
    }
    else {
        "- No supporting evidence rows were supplied."
    }

    return @{
        properties = @{
            message = @"
SC-200 lab investigation notes

Scenario: $($Incident.Title)
Severity: $($Incident.Severity)
Status: $($Incident.Status)

Suggested student actions:
1. Review the Timeline and Bookmarks tabs.
2. Inspect related account, host, IP, or URL entities.
3. Decide whether this should remain open, be assigned, or be closed with a classification.

Evidence to review:
$evidenceText
"@
        }
    }
}

function New-IncidentName {
    param([string]$IncidentId)

    if ($IncidentId -and $IncidentId -match '^[a-zA-Z0-9][a-zA-Z0-9-]{0,63}$') {
        return $IncidentId
    }

    return [guid]::NewGuid().ToString()
}

function New-ResourceName {
    param([string]$Prefix)

    $candidate = ($Prefix -replace '[^a-zA-Z0-9-]', '-').Trim("-")
    if ($candidate.Length -lt 3) {
        $candidate = "lab-$candidate"
    }
    if ($candidate.Length -gt 63) {
        $candidate = $candidate.Substring(0, 63).Trim("-")
    }

    return $candidate
}

function New-DeterministicGuid {
    param([string]$Value)

    $md5 = [System.Security.Cryptography.MD5]::Create()
    try {
        $hash = $md5.ComputeHash([Text.Encoding]::UTF8.GetBytes($Value))
        return ([guid]::new($hash)).ToString()
    }
    finally {
        $md5.Dispose()
    }
}

function Invoke-AzRestJsonPut {
    param(
        [string]$Uri,
        [string]$JsonBody
    )

    $tempFile = Join-Path ([System.IO.Path]::GetTempPath()) ("sentinel-incident-{0}.json" -f ([guid]::NewGuid()))
    try {
        Set-Content -Path $tempFile -Value $JsonBody -Encoding UTF8
        $rawResponse = az rest --method put --uri $Uri --headers "Content-Type=application/json" --body "@$tempFile" -o json
        if ($LASTEXITCODE -ne 0) {
            throw "az rest failed with exit code $LASTEXITCODE."
        }

        return $rawResponse | ConvertFrom-Json
    }
    finally {
        if (Test-Path -Path $tempFile) {
            Remove-Item -Path $tempFile -Force
        }
    }
}

Assert-AzCli
$resolvedSubscriptionId = Resolve-Subscription -ProvidedSubscriptionId $SubscriptionId
$workspaceResourceId = Test-WorkspaceExists -ResourceGroupName $ResourceGroupName -WorkspaceName $WorkspaceName

if (-not $CsvPath) {
    $scriptFolder = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $CsvPath = Join-Path $scriptFolder "Sample-SentinelIncidents.csv"
}

if (-not $EvidenceCsvPath) {
    $scriptFolder = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $EvidenceCsvPath = Join-Path $scriptFolder "Sample-SentinelIncidentEvidence.csv"
}

if (-not (Test-Path -Path $CsvPath)) {
    throw "CSV file not found: $CsvPath"
}

$incidents = @(Import-Csv -Path $CsvPath)
if ($incidents.Count -eq 0) {
    throw "CSV file has no incidents: $CsvPath"
}

$evidenceRows = @()
if (-not $SkipEvidence) {
    if (-not (Test-Path -Path $EvidenceCsvPath)) {
        throw "Evidence CSV file not found: $EvidenceCsvPath"
    }

    $evidenceRows = @(Import-Csv -Path $EvidenceCsvPath)
}

Write-Host "Using subscription: $resolvedSubscriptionId"
Write-Host "Target Sentinel workspace: $ResourceGroupName/$WorkspaceName"
Write-Host "CSV: $CsvPath"
if (-not $SkipEvidence) {
    Write-Host "Evidence CSV: $EvidenceCsvPath"
}

$results = foreach ($incident in $incidents) {
    foreach ($requiredField in @("Title", "Severity", "Status")) {
        if (-not $incident.$requiredField) {
            throw "Incident '$($incident.IncidentId)' is missing required field '$requiredField'."
        }
    }

    $incidentName = New-IncidentName -IncidentId $incident.IncidentId
    $uri = "https://management.azure.com$workspaceResourceId/providers/Microsoft.SecurityInsights/incidents/$incidentName" + "?api-version=$ApiVersion"
    $body = New-IncidentBody -Incident $incident | ConvertTo-Json -Depth 10

    Write-Host "Creating incident: $($incident.Title)"
    if ($PSCmdlet.ShouldProcess($incidentName, "Create or update Sentinel incident")) {
        $response = Invoke-AzRestJsonPut -Uri $uri -JsonBody $body
        $incidentResourceId = $response.id
        $relatedEvidence = @($evidenceRows | Where-Object { $_.IncidentId -eq $incident.IncidentId })
        $bookmarkCount = 0
        $commentCount = 0

        if (-not $SkipEvidence) {
            foreach ($evidence in $relatedEvidence) {
                if (-not $evidence.EvidenceId) {
                    throw "Evidence row for incident '$($incident.IncidentId)' is missing EvidenceId."
                }

                $bookmarkName = New-DeterministicGuid -Value "$incidentName-$($evidence.EvidenceId)"
                $bookmarkUri = "https://management.azure.com$workspaceResourceId/providers/Microsoft.SecurityInsights/bookmarks/$bookmarkName" + "?api-version=2024-01-01-preview"
                $bookmarkBody = New-BookmarkBody -Evidence $evidence -Incident $incident -IncidentName $incidentName | ConvertTo-Json -Depth 20

                Write-Host "  Creating bookmark: $($evidence.DisplayName)"
                $bookmarkResponse = Invoke-AzRestJsonPut -Uri $bookmarkUri -JsonBody $bookmarkBody
                $bookmarkCount++

                $relationName = New-DeterministicGuid -Value "$incidentName-$($evidence.EvidenceId)-relation"
                $relationUri = "https://management.azure.com$incidentResourceId/relations/$relationName" + "?api-version=2024-03-01"
                $relationBody = @{
                    properties = @{
                        relatedResourceId = $bookmarkResponse.id
                    }
                } | ConvertTo-Json -Depth 10

                Write-Host "  Linking bookmark to incident"
                Invoke-AzRestJsonPut -Uri $relationUri -JsonBody $relationBody | Out-Null
            }

            $commentName = New-DeterministicGuid -Value "$incidentName-notes"
            $commentUri = "https://management.azure.com$incidentResourceId/comments/$commentName" + "?api-version=2022-11-01"
            $commentBody = New-CommentBody -Incident $incident -EvidenceRows $relatedEvidence | ConvertTo-Json -Depth 10

            Write-Host "  Creating investigation comment"
            Invoke-AzRestJsonPut -Uri $commentUri -JsonBody $commentBody | Out-Null
            $commentCount = 1
        }

        [pscustomobject]@{
            IncidentId = $incidentName
            Title      = $response.properties.title
            Severity   = $response.properties.severity
            Status     = $response.properties.status
            Number     = $response.properties.incidentNumber
            Bookmarks  = $bookmarkCount
            Comments   = $commentCount
        }
    }
}

$results | Format-Table -AutoSize

if ($PassThru) {
    $results
}
