# SC-200 KQL Training Data

Use this script to import the CSV training data from this repository into an existing Log Analytics workspace.

## Azure Cloud Shell

Run this one-liner in PowerShell Cloud Shell for the standard lab workspace:

```powershell
iwr https://raw.githubusercontent.com/kramit/SC-200-Notes/main/KQLData/Import-SentinelTrainingLabData.ps1 -OutFile ./Import-SentinelTrainingLabData.ps1; ./Import-SentinelTrainingLabData.ps1 -ResourceGroupName defender-RG -WorkspaceName defenderWorkspace
```

## Local Usage

From the repository root:

```powershell
.\KQLData\Import-SentinelTrainingLabData.ps1 -ResourceGroupName <resource-group-name> -WorkspaceName <workspace-name>
```

The script uses Azure CLI to resolve the workspace ID and shared key, downloads the CSV files from `KQLData/Artifacts`, and imports them into custom Log Analytics tables such as `SecurityEvent_CL`, `SigninLogs_CL`, and `OfficeActivity_CL`.
