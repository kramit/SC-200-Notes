# Logs need to be sent directly into the log analytics workspace in a JSON format

# Replace these variables with your actual values
$workspaceId = "YOUR_WORKSPACE_ID"
$sharedKey = "YOUR_SHARED_KEY"
$logType = "YourLogType" # Name the type of log you're sending

# Function to create the authorization header
function CreateAuthorizationHeader {
    param (
        [string]$workspaceId,
        [string]$sharedKey,
        [string]$date,
        [string]$contentLength
    )
    
    $stringToHash = "POST`n$contentLength`napplication/json`n`n$x-ms-date:$date`n/api/logs"
    $bytesToHash = [System.Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [System.Convert]::FromBase64String($sharedKey)
    
    $sha256 = New-Object System.Security.Cryptography.HMACSHA256
    $sha256.Key = $keyBytes
    $hashBytes = $sha256.ComputeHash($bytesToHash)
    $signature = [Convert]::ToBase64String($hashBytes)
    
    return "SharedKey $workspaceId:$signature"
}

# Function to send data to the Log Analytics workspace
function SendData {
    param (
        [string]$jsonData
    )
    
    $date = [DateTime]::UtcNow.ToString("R")
    $contentLength = $jsonData.Length.ToString()
    $authorizationHeader = CreateAuthorizationHeader $workspaceId $sharedKey $date $contentLength
    
    $headers = @{
        "Content-Type" = "application/json"
        "Log-Type" = $logType
        "x-ms-date" = $date
        "Authorization" = $authorizationHeader
    }
    
    $url = "https://$workspaceId.ods.opinsights.azure.com/api/logs?api-version=2016-04-01"
    
    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $jsonData
}

# Reading the CSV file and converting it to JSON
$csvData = Import-Csv -Path "path/to/your/file.csv" | ConvertTo-Json

# Sending the JSON data to the Log Analytics workspace
SendData $csvData
