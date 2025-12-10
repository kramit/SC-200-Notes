#!/bin/bash
set -x

echo "=== Starting Data Connector Export ==="
echo "Current directory: $(pwd)"
echo "Python version:"
python3 --version

echo ""
echo "=== Installing requirements ==="
python3 -m pip install -r /Users/mike/Library/CloudStorage/OneDrive-Personal/Documents/GitHub/SC-200-Notes/APIapp/requirements.txt

echo ""
echo "=== Setting environment variables ==="
export AZ_TENANT_ID=2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce
export AZ_CLIENT_ID=6a92a1ec-1ab0-4b03-85c1-74119fcf1771
export AZ_CLIENT_SECRET=${AZ_CLIENT_SECRET}
export AZ_SUBSCRIPTION_ID=2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce
export AZ_RESOURCE_GROUP=loganalytics
export AZ_WORKSPACE_NAME=KramitSentinal

echo "Tenant ID: $AZ_TENANT_ID"
echo "Client ID: $AZ_CLIENT_ID"
echo "Subscription ID: $AZ_SUBSCRIPTION_ID"
echo "Resource Group: $AZ_RESOURCE_GROUP"
echo "Workspace Name: $AZ_WORKSPACE_NAME"

echo ""
echo "=== Running fetch_connectors.py ==="
python3 /Users/mike/Library/CloudStorage/OneDrive-Personal/Documents/GitHub/SC-200-Notes/APIapp/fetch_connectors.py

echo ""
echo "=== Checking for output CSV ==="
ls -la /Users/mike/Library/CloudStorage/OneDrive-Personal/Documents/GitHub/SC-200-Notes/APIapp/data_connectors.csv

echo "=== Done ==="
