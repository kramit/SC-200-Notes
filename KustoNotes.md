https://dataexplorer.azure.com/clusters/help/databases/Samples

https://docs.microsoft.com/en-us/azure/data-explorer/query-monitor-dat

https://docs.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-explorer

StormEvents
| project State, InjuriesDirect
| reduce by State


StormEvents 
| where StartTime >= datetime(2007-11-01) and StartTime < datetime(2007-12-01)
| where State == "FLORIDA"  
| count 

Covid19_flat() 
| project Country, Deaths
|summarize Death=count() by Country

