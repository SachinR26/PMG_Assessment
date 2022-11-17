/* Creating a Databse called pmg */
create database pmg;

/* We are going to use the created database pmg */
use pmg;

/* We are creating two tables, marketing_data and store_revenue with auto_increment IDs. (Identity is the AutoIncrement in MS SQL Server) */
create table marketing_data ( id int not null primary key Identity(1,1), date datetime, geo varchar(2), impressions float, clicks float );

create table store_revenue ( id int not null primary key Identity(1,1), date datetime, brand_id int, store_location varchar(250), revenue float);

/* Once created, we use the sql import/export wizard to import the data from the csv files */
select * from marketing_data;

select * from store_revenue;

/* Ensuring that the datatypes are correct for both the tables */
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'store_revenue';

SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'marketing_data';

/*Question #1 Generate a query to get the sum of the clicks of the marketing data​*/
Select sum(clicks) as Total_Clicks from marketing_data; /* With this we get the total clicks in the marketing data */
Select geo, sum(clicks) as Total_Clicks from marketing_data group by geo; /* We get the total clicks for each geographic location in marketing data */ 

/* Question #2 Generate a query to gather the sum of revenue by store_location from the store_revenue table​ */
Select store_location, sum(revenue) as Total_Store_Revenue from store_revenue
group by store_location;

/* Question #3 Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo. Please ensure all records from each table are accounted for. */
select ISNULL(m.date,s.date) as Date, ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, m.impressions as Impressions, m.clicks as Clicks, sum(s.revenue) as Total_Revenue 
from marketing_data m full outer join store_revenue s on m.date=s.date and 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location))
group by ISNULL(m.geo,RIGHT(s.store_location,2)),ISNULL(m.date,s.date), m.impressions, m.clicks;
/* USING RIGHT function in the outer join clause is faster that the SUBSTRING function. The reason I used SUBSTRING was, 
if the length of state changed from TX to Texas, it will still be able to accomodate that change. We can use Right(s.store_location,2) 
which will still fetch the same answer */


/* Question #4 In your opinion, what is the most efficient store and why?​ */
Select ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, sum(m.impressions) as Total_Impressions, sum(m.clicks) as Total_Clicks, sum(s.revenue) as Total_Revenue,
round((sum(s.revenue)/sum(m.clicks)),2) as Revenue_per_Click, round(((sum(m.clicks)*100)/sum(m.impressions)),2) as Click_Through_Rate, 
round((sum(s.revenue)/sum(m.impressions)),2) as Revenue_per_Impression
from marketing_data m full outer join store_revenue s on 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location)) and m.date=s.date
group by ISNULL(m.geo,RIGHT(s.store_location,2));

/* USING RIGHT function in the outer join clause is faster that the SUBSTRING function. The reason I used SUBSTRING was, 
if the length of state changed from TX to Texas, it will still be able to accomodate that change. We can use Right(s.store_location,2) 
which will still fetch the same answer */
/* The Revenue per click and Revenue per Impression is higher for the stores in California, which makes it the most efficient store. 
But if we consider the click through rate, then Minnesota has a higher value when compared to the other states. Hence, efficiency depends on various factors. */



/* Question #5 (Challenge) Generate a query to rank in order the top 10 revenue producing states​ */
select TOP 10 ISNULL(m.geo,RIGHT(s.store_location,2)) as Geo, sum(revenue) as Total_Revenue
from store_revenue s full outer join marketing_data m on 
m.geo = SUBSTRING(s.store_location,CHARINDEX('-',s.store_location)+1,len(s.store_location)-CHARINDEX('-',s.store_location)) and m.date=s.date
group by ISNULL(m.geo,RIGHT(s.store_location,2))
order by total_revenue desc
/* In the dataset, we only have 4 states which are California, Minnesota, New York and Texas. The question asks top 10 states and we can see
California has the highest revenue in sales. But if the data is larger with more than 10 states, this query will still work and give you the Top 10 revenue producing states */




