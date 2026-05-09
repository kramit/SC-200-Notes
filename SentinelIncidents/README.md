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

## Student Lab: Explore Microsoft Sentinel Incidents

1. [ ] Navigate to the Azure portal.

1. [ ] In the search bar at the top of the Azure portal, search for **Microsoft Sentinel**.

1. [ ] Select **Microsoft Sentinel**.

1. [ ] Select the Sentinel workspace used for this lab.

1. [ ] In the left menu, under **Threat management**, select **Incidents**.

1. [ ] Review the list of incidents.

   ::: warning
   **Note:** Some lab environments may also have analytics rules generating alerts and incidents from the same specific log entries. This is expected if the lab has been configured to repeatedly generate incident data for investigation practice.
   :::

1. [ ] Find the incidents with the **SC-200 Lab** tag.

1. [ ] Review the following sample incidents:

   - **Suspicious phishing email opened by finance user**
   - **Impossible travel sign-in for student account**
   - **Malware detected on Windows 11 lab VM**
   - **Unusual download volume from SharePoint**
   - **Multiple failed RDP logons followed by success**

1. [ ] Select **Impossible travel sign-in for student account**.

1. [ ] Review the incident summary pane.

   Check the following fields:

   - **Status**
   - **Severity**
   - **Owner**
   - **Description**
   - **Tags**
   - **Entities**
   - **Last update time**
   - **Creation time**

1. [ ] Select the **Timeline** tab.

1. [ ] Review the timeline evidence.

   ::: tip
   **Tip:** These lab incidents use related bookmarks as timeline evidence. If the timeline does not populate immediately, wait a minute, refresh the incident, and check the **Bookmarks** tab.
   :::

1. [ ] Select the **Bookmarks** tab.

1. [ ] Open the bookmark associated with the incident.

1. [ ] Review the bookmark details.

   Look for:

   - The bookmark title
   - The investigation notes
   - The related query
   - The query result
   - MITRE tactics and techniques
   - Related account, host, IP address, or URL entities

1. [ ] Select the **Entities** tab.

1. [ ] Review each entity connected to the incident.

   Depending on the incident, you may see entities such as:

   - Account
   - Host
   - IP address
   - URL

1. [ ] Open each entity and review the information available.

1. [ ] Use the entity details to answer the following questions:

   - Which user or account is involved?
   - Which device or host is involved?
   - Is there a suspicious IP address?
   - Is there a suspicious URL?
   - Does the activity look malicious, suspicious, or expected?

1. [ ] Select the **Comments** tab.

1. [ ] Review the investigation comment added to the incident.

1. [ ] Use the comment as a guide for what to investigate next.

1. [ ] Select the **Overview** or **Timeline** tab again.

1. [ ] Decide what action you would take as an analyst.

   Consider the following options:

   - Assign the incident to yourself
   - Leave the incident as **New**
   - Change the incident to **Active**
   - Add an investigation comment
   - Close the incident as a false positive
   - Close the incident as a true positive

1. [ ] Add a comment to the incident explaining your decision.

   Example:

   ```text
   Reviewed the related bookmark, account entity, and source IP address. Activity appears suspicious and should be escalated for further investigation.
   ```

1. [ ] Repeat the same process for each of the remaining **SC-200 Lab** incidents.

1. [ ] For each incident, complete the following mini investigation checklist:

   - Identify the likely affected user.
   - Identify the likely affected host, IP address, or URL.
   - Review the related bookmark evidence.
   - Review the MITRE tactic or technique.
   - Add an analyst comment.
   - Decide whether the incident should remain open or be closed.

1. [ ] Compare the incidents.

   Answer the following questions:

   - Which incident has the highest severity?
   - Which incident would you investigate first?
   - Which incident appears most likely to be a true positive?
   - Which incident might be expected or benign activity?
   - What additional data would help you make a better decision?

1. [ ] Return to the **Incidents** list.

1. [ ] Use filters to find only the lab incidents.

   Suggested filters:

   - **Tag:** SC-200 Lab
   - **Severity:** High
   - **Status:** New

1. [ ] Clear the filters when you are finished.

1. [ ] Confirm that you can explain the purpose of each incident tab:

   - **Timeline** shows the sequence of investigation evidence.
   - **Alerts** shows analytics or product alerts when present.
   - **Bookmarks** shows saved investigation evidence.
   - **Entities** shows users, hosts, IP addresses, URLs, and other related objects.
   - **Comments** shows analyst notes and investigation decisions.

1. [ ] Close the incident page when the investigation is complete.
