-- Lab 3.07
use sakila;
-- 1
select count(customer_id) as Customers, substr(last_update,6,2) as Month from customer
where active=1
group by Month;

select distinct substr(return_date,6,2) as Month from rental;

-- 2
create or replace view user_activity as
select customer_id,
substr(return_date,6,2) as Activity_Month, active
from rental as Rental
join customer as Customer using(customer_id);

select* from user_activity;

-- 3
create or replace view monthly_active_users as
select Activity_Month, count(customer_id) as Active_users
from user_activity
group by Activity_Month
order by Activity_Month asc;

select * from monthly_active_users;

with cte_activity as (
  select Active_users, lag(Active_users,1) over () as last_month, Activity_month
  from monthly_active_users
)
select (Active_users-last_month)/Active_users*100 as variation , Active_users, last_month, Activity_month from cte_activity
where last_month is not null;

-- 4

create or replace view user_activity as
select customer_id, substr(Rental.return_date,6,2) as Activity_Month
from rental as Rental
join customer as Customer using(customer_id);

select* from user_activity;
 
create or replace view distinct_users as
select count(
	distinct customer_id) as Active_id, Activity_Month
from user_activity
group by Activity_Month;

select * from distinct_users;


with cte as(
	select *, 
    lag(Active_id) over () as Previous_month
    from distinct_users
    order by Activity_Month
)
select *, Active_id - Previous_month as News
from cte
order by Activity_Month;