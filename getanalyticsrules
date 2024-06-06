# PowerShell Script to List Analytics Rules in Microsoft Sentinel

This script lists all analytics rules in a specified Microsoft Sentinel workspace using Azure PowerShell.

## Prerequisites

- Azure PowerShell module installed (`Az`)
- Access to the Azure subscription and resource group containing the Sentinel workspace

## Script

```powershell
# Install the required Azure PowerShell module
Install-Module -Name Az -AllowClobber -Scope CurrentUser

# Connect to your Azure account
Connect-AzAccount

# Define the variables
$resourceGroupName = "YourResourceGroupName"
$workspaceName = "yourLAWworkspacename"

# Get the workspace
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName

# Get all analytics rules in the workspace
$analyticsRules = Get-AzSentinelAlertRule -ResourceGroupName $resourceGroupName -WorkspaceName $workspaceName

# Display the rules
$analyticsRules | Select-Object DisplayName, Severity, Enabled, Query, QueryFrequency, QueryPeriod
