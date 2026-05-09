# Sample Microsoft Sentinel Incidents

This folder contains sample lab incidents, related bookmark evidence, and a PowerShell script to import them into an existing Microsoft Sentinel workspace.

## Azure Cloud Shell

Run this one-liner in PowerShell Cloud Shell for the standard lab workspace:

```powershell
iwr https://raw.githubusercontent.com/kramit/SC-200-Notes/main/SentinelIncidents/Import-SentinelIncidents.ps1 -OutFile ./Import-SentinelIncidents.ps1; iwr https://raw.githubusercontent.com/kramit/SC-200-Notes/main/SentinelIncidents/Sample-SentinelIncidents.csv -OutFile ./Sample-SentinelIncidents.csv; iwr https://raw.githubusercontent.com/kramit/SC-200-Notes/main/SentinelIncidents/Sample-SentinelIncidentEvidence.csv -OutFile ./Sample-SentinelIncidentEvidence.csv; ./Import-SentinelIncidents.ps1 -ResourceGroupName defender-RG -WorkspaceName defenderWorkspace -CsvPath ./Sample-SentinelIncidents.csv -EvidenceCsvPath ./Sample-SentinelIncidentEvidence.csv
```

## Local Usage

From the repository root:

```powershell
.\SentinelIncidents\Import-SentinelIncidents.ps1 -ResourceGroupName <resource-group-name> -WorkspaceName <workspace-name>
```

The target workspace must already have Microsoft Sentinel enabled. The script uses Azure CLI and creates incidents through the `Microsoft.SecurityInsights/incidents` management API.

The script also creates related bookmarks, mapped entities, MITRE tactics/techniques, incident comments, and incident-to-bookmark relations. Native Sentinel alerts are normally created by analytics rules, so these lab incidents use bookmarks and comments as the explorable timeline evidence.
