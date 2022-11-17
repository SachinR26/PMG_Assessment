# PMG_Assessment 
## By Srivats Srinivasan Ramanujam, Information Technology and Management, the University of Texas at Dallas
### https://www.linkedin.com/in/srivatsramanujam/

## Solutions for the PMG SQL Assessment - Solved using MS SQL Server


### Question #1 Generate a query to get the sum of the clicks of the marketing data

<b>Query:</b><br>
Select sum(clicks) as Total_Clicks from marketing_data;



### Question #2 Generate a query to gather the sum of revenue by store_location from the store_revenue table

<b>Query:</b><br>
Select store_location, sum(revenue) as Total_Store_Revenue from store_revenue
group by store_location;



### Question #3 Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo. Please ensure all records from each table are accounted for.

<b>Query:</b><br> 
select ISNULL(m.date,s.date) as Date, ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, m.impressions as Impressions, m.clicks as Clicks, sum(s.revenue) as Total_Revenue 
from marketing_data m full outer join store_revenue s on m.date=s.date and 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location))
group by ISNULL(m.geo,RIGHT(s.store_location,2)),ISNULL(m.date,s.date), m.impressions, m.clicks;

<b>Explanation:</b><br>
USING RIGHT function in the outer join clause is faster that the SUBSTRING function. The reason I used SUBSTRING was, 
if the length of state changed from TX to Texas, it will still be able to accomodate that change. We can use Right(s.store_location,2) 
which will still fetch the same answer <br>
select ISNULL(m.date,s.date) as Date, ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, m.impressions as Impressions, m.clicks as Clicks, sum(s.revenue) as Total_Revenue 
from marketing_data m full outer join store_revenue s on m.date=s.date and 
m.geo = <br>RIGHT(s.store_location,2)</br>
group by ISNULL(m.geo,RIGHT(s.store_location,2)),ISNULL(m.date,s.date), m.impressions, m.clicks;


### Question #4 In your opinion, what is the most efficient store and why?

<b>Query:</b><br> 
Select ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, sum(m.impressions) as Total_Impressions, sum(m.clicks) as Total_Clicks, sum(s.revenue) as Total_Revenue,
round((sum(s.revenue)/sum(m.clicks)),2) as Revenue_per_Click, round(((sum(m.clicks)*100)/sum(m.impressions)),2) as Click_Through_Rate, 
round((sum(s.revenue)/sum(m.impressions)),2) as Revenue_per_Impression
from marketing_data m full outer join store_revenue s on 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location)) and m.date=s.date
group by ISNULL(m.geo,RIGHT(s.store_location,2));

<b>Explanation and my opinion:</b><br>
The Revenue per click and Revenue per Impression is higher for the stores in California, which makes it the most efficient store state. 
But if we consider the click through rate, then Minnesota has a higher value when compared to the other states. Hence, efficiency depends on various factors.
In my opinion, California is the most efficient state with the data that we have.


### Question #5 (Challenge) Generate a query to rank in order the top 10 revenue producing states

<b>Query:</b><br> 
select TOP 10 ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, sum(revenue) as Total_Revenue
from store_revenue s full outer join marketing_data m on 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location)) and m.date=s.date
group by ISNULL(m.geo,RIGHT(s.store_location,2))
order by total_revenue desc

<b>Explanation:</b><br>
In the dataset, we only have 4 states which are California, Minnesota, New York and Texas. The question asks top 10 states and we can see
California has the highest revenue in sales. But if the data is larger with more than 10 states, this query will still work and give you the Top 10 revenue producing states
