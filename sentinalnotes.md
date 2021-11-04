workbook 101
https://techcommunity.microsoft.com/t5/azure-sentinel/azure-sentinel-workbooks-101-with-sample-workbook/ba-p/1409216#:~:text=In%20Azure%20Sentinel%2C%20Workbooks%20contain%20a%20large%20pool,based%20on%20the%20user%E2%80%99s%20vision%20and%20use%20case.

Workbooks Deep Dive from Microsoft
https://www.youtube.com/watch?v=7eYNaYSsk1A

------

Sentinal Ninja Training Level 400
https://techcommunity.microsoft.com/t5/azure-sentinel/become-an-azure-sentinel-ninja-the-complete-level-400-training/ba-p/1246310

MS Security Community
https://techcommunity.microsoft.com/t5/security-compliance-and-identity/join-our-security-community/ba-p/927847


Sentinal Parsers for ASIM  Azure Sentinel Information Model 
https://github.com/Azure/Azure-Sentinel/tree/master/Parsers

------
Long term logs over 90 days
https://techcommunity.microsoft.com/t5/microsoft-sentinel-blog/move-your-microsoft-sentinel-logs-to-long-term-storage-with-ease/ba-p/1407153#:~:text=Out%20of%20the%20box%2C%20Azure%20Sentinel%20provides%2090,retention%20for%20Log%20Analytics%20workspaces%20is%202%20years.

------

sample alerts:

Azure Security centre connecter is now defender connector, turn this on with bi-directional enabled

in security centre go to alerts and generate sample alerts

they will appear as incidents in Sentinel

-----

KQL log query

SecurityAlert
| were productname == "Azure Security Centre"


------
custom analytics rule

AzureActivity
| where OperationName == "Create or Update Virtual Machine"or OperationName
=="Create Deployment"
| where ActivityStatus == "Succeeded"
| make-series dcount(ResourceId) 
default=0 on EventSubmissionTimestamp
in range(ago(7d), now(), 1d) by Caller


------

Improve SecOps with Azure Sentinel your Cloud-Native SIEM | DB161 
https://www.youtube.com/watch?v=Jeu0lRjoVs4

Azure Sentinel webinar: Unleash the automation Jedi tricks & build Logic Apps Playbooks like a Boss
https://www.youtube.com/watch?v=G6TIzJK8XBA

nov 2nd 2021 ignite sentinal talk
https://myignite.microsoft.com/sessions/c0a74937-5c04-499d-a473-f72b107f824e?source=sessions

upcoming webinars from nov 2nd
https://techcommunity.microsoft.com/t5/security-compliance-and-identity/security-community-webinars/ba-p/927888


-------

https://github.com/Azure/Azure-Sentinel/tree/master/Solutions/Training/Azure-Sentinel-Training-Lab
