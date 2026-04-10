create database sales_db;
use sales_db;
show databases;

show tables;
select * from sales;


ALTER TABLE sales 
CHANGE `Revenue` revenue VARCHAR(50),
CHANGE `cost` cost VARCHAR(50);

set sql_safe_updates=0;

UPDATE sales
SET revenue = REPLACE(revenue, ',', ''),
    cost = REPLACE(cost, ',', ''),
    profit = REPLACE(profit, ',', '');
    
alter table sales 
modify revenue int,
modify cost int,
modify profit int;

SHOW FULL TABLES WHERE TABLE_TYPE = 'VIEW';

create view total_cost as
select sum(cost) as total_cost from sales;

create view total_revenue as 
select sum(revenue) as total_revenue from sales;

create view total_profit as 
select sum(revenue)-sum(cost) as total_profit from sales;

create view total_orders as 
select count(order_id) as total_orders from sales;

create view aov as 
select (select sum(revenue) from sales)/(select count(order_id) from sales) as AOV from sales limit 1;

create view first_prob as 
select customer_name,sum(revenue) as total_revenue from sales 
group by customer_name
having total_revenue>(select avg(revenue) from sales)
order by total_revenue desc limit 5;

create view second_prob as
select country, sum(profit) as total_profit
from sales 
group by country
having total_profit=(select max(country_profit) from
(select sum(profit) as country_profit from sales group by country) as temp );

create view third_prob as
select sales_rep,sum(revenue) as rep_revenue from sales 
group by sales_rep 
having rep_revenue>(select avg(manager_revenue) from
(select sales_manager,sum(revenue) as manager_revenue
from sales group by sales_manager)as mgr) 
order by rep_revenue desc;

select avg(manager_revenue) from(select sales_manager,sum(revenue) as manager_revenue from sales 
group by sales_manager) as mgr;

select max(rep_revenue) from(select sales_rep,sum(revenue) as rep_revenue from sales 
group by sales_rep) as rpr;

create view four_prob as
select category,sum(profit) as total_profit from sales 
group by category
order by total_profit desc limit 3;

create view five_prob as
select order_id,profit from sales 
where profit >(select avg(profit) from sales)
order by profit desc limit 5;


create view country_perf as 
select country,sum(cost) as total_cost, sum(revenue) as total_revenue, sum(profit) as total_profit from sales 
group by country
order by total_profit desc limit 5;

create view category_perf as
select category,sum(cost) as total_cost, sum(revenue) as total_revenue, sum(profit) as total_profit from sales 
group by category
order by total_profit desc limit 5;

create view manager_perf as
select sales_manager,sum(cost) as total_cost, sum(revenue) as total_revenue, sum(profit) as total_profit from sales 
group by sales_manager
order by total_profit desc limit 5;

create view rep_perf as
select sales_rep,sum(cost) as total_cost, sum(revenue) as total_revenue, sum(profit) as total_profit from sales 
group by sales_rep
order by total_profit desc limit 5;

create view device_perf as
select device_type,sum(cost) as total_cost, sum(revenue) as total_revenue, sum(profit) as total_profit from sales 
group by device_type
order by total_profit desc;

create view sales_trend as
select year(date) as year,quarter(date) as quarter, sum(revenue) as total_revenue from sales
group by  year(date),quarter(date) 
order by year,quarter;


describe sales;

alter table sales
add column new_date date;

update sales
set new_date=str_to_date(date,'%d-%m-%Y');

alter table sales
drop column date;

alter table sales 
change new_date date date;

select * from sales_trend;