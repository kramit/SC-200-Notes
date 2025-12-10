# Sentinel Data Connector Exporter

This small utility fetches the list of active data connectors from a Microsoft Sentinel (SecurityInsights) workspace
and exports them as a CSV file in the `APIapp` folder.

Prerequisites
- Python 3.8+
- `requests` package

Setup
1. Copy `.env.example` to `.env` or export equivalent environment variables:

```
AZ_TENANT_ID=2bf0f2d8-74f9-4288-b5d9-266cd13cc4ce
AZ_CLIENT_ID=6a92a1ec-1ab0-4b03-85c1-74119fcf1771
AZ_CLIENT_SECRET=<your service principal secret>
AZ_SUBSCRIPTION_ID=<subscription id containing the workspace>
AZ_RESOURCE_GROUP=<resource group of the workspace>
AZ_WORKSPACE_NAME=KramitSentinal
```

2. Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Run

```bash
python fetch_connectors.py
```

Output
- `data_connectors.csv` will be written into the `APIapp` folder. The CSV includes top-level `id`, `name`, `type`, `kind`
  and a `properties_json` column containing the raw `properties` object.

Notes & troubleshooting
- You must provide a valid client secret for the service principal. If you don't want to store secrets in files, export
  them as environment variables in your shell session.
- If you don't know the subscription id or resource group, you can find the Log Analytics workspace resource in the
  Azure Portal -> Log Analytics workspaces and view the resource's `Subscription` and `Resource group` values.
- API versions can change; if the script errors with a 404 on the REST path, try updating the `api-version` parameter
  in `fetch_connectors.py` to a newer Microsoft.SecurityInsights API version.
