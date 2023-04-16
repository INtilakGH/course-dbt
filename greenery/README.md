Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

### Answer questions / queries

select count(distinct(user_id))
from stg_users;
##### 130 users

with orderlist as (
select count(order_id) as order_count
from stg_orders
group by hour(created_at)
)
--select sum(order_count)/count(order_count) from orderlist
select avg(order_count) from orderlist;
##### 15.041667 orders per hour

select avg(datediff(day, created_at, delivered_at))
from stg_orders
where status='delivered';
##### 3.891803 days from placed to delivered

--select * from stg_orders
--where status='delivered'  limit 10;

with order_per_user as (

select count(order_id) as order_c
from stg_orders
group by user_id
)
select count(order_c)
from order_per_user
where order_c >=3;
##### only 1 purchase - 25 users
##### only 2 purchases - 28 users
##### 3 and more - 71 users

with session_list as (

select count(distinct(session_id)) as session_count
from stg_events
group by hour(created_at)
)
select avg(session_count) from session_list;
##### 39.458333 unique sessions per hour