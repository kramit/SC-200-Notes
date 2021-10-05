workbook 101
https://techcommunity.microsoft.com/t5/azure-sentinel/azure-sentinel-workbooks-101-with-sample-workbook/ba-p/1409216#:~:text=In%20Azure%20Sentinel%2C%20Workbooks%20contain%20a%20large%20pool,based%20on%20the%20user%E2%80%99s%20vision%20and%20use%20case.

------

sample alerts:

Azure Security centre connecter is now defender connector, turn this on with bi-directional enabled

in security centre go to alerts and generate sample alerts

they will appear as incidents in Sentinel

-----

KQL log query

SecurityAlert
| were productname == "Azure Security Centre"