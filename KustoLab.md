https://dataexplorer.azure.com/clusters/help/databases/Samples


StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
| take 5
| render piechart  

::: secondary
KQL, or Kusto Query Language, is a powerful query language used primarily for analyzing large datasets stored in Azure Data Explorer (ADX) and other services that support KQL, such as Microsoft Azure Monitor, Azure Sentinel, and Microsoft Defender for Cloud. In this lab you will find many example queries that are run against an example data set. This lab content is taken from the SC-200 course, if you have already completed that course and have some familiarty with KQL there is a second option for you at the end of these examples under "Optional objective"
:::

# KQL Labs

::: secondary
KQL, or Kusto Query Language, is a powerful query language used primarily for analyzing large datasets stored in Azure Data Explorer (ADX) and other services that support KQL, such as Microsoft Azure Monitor, Azure Sentinel, and Microsoft Defender for Cloud. In this lab you will find many example queries that are run against an example data set. This lab content is taken from the SC-200 course, if you have already completed that course and have some familiarty with KQL there is a second option for you at the end of these examples under "Optional objective"
:::

# Create queries using Kusto Query Language (KQL)

1. [ ] Go to !!https://dataexplorer.azure.com/clusters/help/databases/Samples!! in your browser. Loin with the Azure Credentials if requested to do do

1. [ ] In the query page, select and expand **help**

1. [ ] expand **Samples**

1. [ ] expand **Tables**

1. [ ] expand **Storm_Events**

1. [ ] Double-click the **StormEvents** table. This will load a StormEvents query into the query pane

1. [ ] Remove the | on line 2

1. [ ] Click **run**

1. [ ] You will now see the output of the entire **StormEvents** table the output section of the DataExplorer

1. [ ] Add the following to the query, after the query is changed, click ***Run*** again to run the query

```
StormEvents
| project State, InjuriesDirect, EventType
```

::: secondary
This will use the Project operator to select columns of data
!!!https://learn.microsoft.com/en-us/kusto/query/project-operator?view=microsoft-fabric!!!
:::

1. [ ] Add the following to the query

```
StormEvents
| project State, InjuriesDirect, EventType
| reduce by State
```

::: secondary
This will use the reduce operator which will attempt to group similar items
!!!https://learn.microsoft.com/en-us/kusto/query/reduce-operator?view=microsoft-fabric!!!
:::

1. [ ] Add the following to change the query

```
StormEvents
| project State, InjuriesDirect, EventType
| summarize InjuriesDirect=count() by EventType
```

::: secondary
Instead of using reduce we now use count() to count the InjuriesDirect over the entire dataset by the EventType !!!https://learn.microsoft.com/en-us/kusto/query/count-aggregation-function?view=microsoft-fabric!!!
:::

1. [ ] Add the following to change the query

```
StormEvents
| project State, InjuriesDirect, EventType
| summarize InjuriesDirect=count() by EventType
```

::: secondary
Instead of using reduce we now use count() to count the InjuriesDirect over the entire dataset by the EventType !!!https://learn.microsoft.com/en-us/kusto/query/count-aggregation-function?view=microsoft-fabric!!!
:::



1. [ ] Add the following to change the query with an additional line on line 3

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
```

::: secondary
We now have added the where operator to filter the information before it is presented to summarize, this will show only the events that have happened in FLORIDA
!!!https://learn.microsoft.com/en-us/kusto/query/where-operator?view=microsoft-fabric!!!
:::


1. [ ] Add the following to change the query with an additional line on line 3

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
```

::: secondary
We now have added the where operator to filter the information before it is presented to summarize, this will show only the events that have happened in FLORIDA
!!!https://learn.microsoft.com/en-us/kusto/query/where-operator?view=microsoft-fabric!!!
:::

1. [ ] Add the following to change the query with an additional line on line 3

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
```

::: secondary
We now have added the where operator to filter the information before it is presented to summarize, this will show only the events that have happened in FLORIDA
!!!https://learn.microsoft.com/en-us/kusto/query/where-operator?view=microsoft-fabric!!!
:::


1. [ ] Add the following to change the query with an additional sort

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
```

::: secondary
This adds a sort operator to sort the InjuriesDirect column decending
!!!https://learn.microsoft.com/en-us/kusto/query/sort-operator?view=microsoft-fabric!!!
:::


1. [ ] Add the following to change the query with an additional sort

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
| take 5
```

::: secondary
We will now add a take operatator as that will select the top 5 items after the sort, if we used the top operator that would take the top 5 items from the original data.
!!!https://learn.microsoft.com/en-us/kusto/query/take-operator?view=microsoft-fabric!!!
:::



1. [ ] Add the following to change the query with an additional sort

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
| take 5
```

::: secondary
We will now add a take operatator as that will select the top 5 items after the sort, if we used the top operator that would take the top 5 items from the original data.
!!!https://learn.microsoft.com/en-us/kusto/query/take-operator?view=microsoft-fabric!!!
:::

1. [ ] Add the following to change the query with an additional sort

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
| take 5
| render barchart  
```

::: secondary
We will now render the output as a barchart
:::

1. [ ] Add the following to change the query with an additional sort

```
StormEvents
| project State, InjuriesDirect, EventType
| where State == "FLORIDA"
| summarize InjuriesDirect=count() by EventType
| sort by InjuriesDirect desc 
| take 5
| render piechart  
```

::: secondary
We will now render the output as a piechart, Unfortunately, Azure Data Explorer (ADX) does not provide built-in functionality to customize the colors of pie charts directly in the interface. The colors are automatically assigned by the system. 
:::

## More examples


This is KQL query to show all the trip taken in the first 6 months of 2014 and a pie chart counting the mount of people in the taxi. You can run this in a new tab using the + button at the top of the page. The data is in the "NYC Taxi" data set and the nyc_taxi table

```
nyc_taxi
| where pickup_datetime >= datetime(2014-01-01) and pickup_datetime < datetime(2014-07-01)
| summarize Count = count() by tostring(passenger_count)
| sort by Count desc
| render piechart
```