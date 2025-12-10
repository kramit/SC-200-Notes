#!/usr/bin/env python3
"""
Fetch Microsoft Sentinel (SecurityInsights) data connectors for a workspace
and export them as CSV into the `APIapp` folder.

Usage:
  - Set environment variables (see `.env.example`) or pass as args.
  - Run: `python fetch_connectors.py`

This script uses the Service Principal (client credentials) flow to obtain
an Azure management token and calls the ARM REST API to list data connectors.

Note: you must supply `AZ_CLIENT_SECRET`, `AZ_SUBSCRIPTION_ID`, and
`AZ_RESOURCE_GROUP` for the call to succeed.
"""
import os
import sys
import requests
import csv
import json
from urllib.parse import urljoin


def get_env(name, required=True):
    v = os.getenv(name)
    if required and not v:
        print(f"Missing environment variable: {name}")
        sys.exit(2)
    return v


def get_token(tenant_id, client_id, client_secret):
    token_url = f"https://login.microsoftonline.com/{tenant_id}/oauth2/v2.0/token"
    data = {
        "grant_type": "client_credentials",
        "client_id": client_id,
        "client_secret": client_secret,
        "scope": "https://management.azure.com/.default",
    }
    r = requests.post(token_url, data=data)
    r.raise_for_status()
    return r.json()["access_token"]


def list_data_connectors(token, subscription_id, resource_group, workspace_name):
    base = "https://management.azure.com/"
    path = (
        f"subscriptions/{subscription_id}/resourceGroups/{resource_group}/"
        f"providers/Microsoft.OperationalInsights/workspaces/{workspace_name}/"
        "providers/Microsoft.SecurityInsights/dataConnectors"
    )
    url = urljoin(base, path)
    params = {"api-version": "2021-10-01"}
    headers = {"Authorization": f"Bearer {token}", "Content-Type": "application/json"}

    print(f"API URL: {url}")
    print(f"API Version: {params['api-version']}")
    items = []
    while url:
        r = requests.get(url, headers=headers, params=params)
        print(f"HTTP Status: {r.status_code}")
        if r.status_code == 404:
            print(f"ERROR 404: Workspace or SecurityInsights provider not found.")
            print(f"  Subscription: {subscription_id}")
            print(f"  Resource Group: {resource_group}")
            print(f"  Workspace Name: {workspace_name}")
            print(f"  Response: {r.text}")
            print("Troubleshooting:")
            print("  1. Verify workspace name and resource group in Azure Portal")
            print("  2. Ensure the Log Analytics workspace has Microsoft Sentinel enabled")
            print("  3. Check that the subscription/resource group are correct")
            sys.exit(2)
        if r.status_code != 200:
            print(f"ERROR {r.status_code}: {r.text}")
        r.raise_for_status()
        data = r.json()
        items.extend(data.get("value", []))
        # pagination
        url = data.get("nextLink")
        # after first page, don't send params again to nextLink
        params = {}

    return items


def save_as_csv(items, outpath):
    # We'll include a few common fields and dump properties as JSON string.
    fieldnames = [
        "id",
        "name",
        "type",
        "kind",
        "properties_json",
    ]
    with open(outpath, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        for it in items:
            row = {
                "id": it.get("id"),
                "name": it.get("name"),
                "type": it.get("type"),
                "kind": it.get("kind"),
                "properties_json": json.dumps(it.get("properties", {}), ensure_ascii=False),
            }
            writer.writerow(row)


def main():
    tenant_id = get_env("AZ_TENANT_ID")
    client_id = get_env("AZ_CLIENT_ID")
    client_secret = get_env("AZ_CLIENT_SECRET")
    subscription_id = get_env("AZ_SUBSCRIPTION_ID")
    resource_group = get_env("AZ_RESOURCE_GROUP")
    workspace_name = get_env("AZ_WORKSPACE_NAME")

    print("Acquiring token...")
    token = get_token(tenant_id, client_id, client_secret)
    print("Listing data connectors for workspace:", workspace_name)
    items = list_data_connectors(token, subscription_id, resource_group, workspace_name)
    print(f"Found {len(items)} data connector(s)")

    outpath = os.path.join(os.path.dirname(__file__), "data_connectors.csv")
    save_as_csv(items, outpath)
    print("Exported CSV to:", outpath)


if __name__ == "__main__":
    main()
