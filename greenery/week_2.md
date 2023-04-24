## Part 1

##### What is our user repeat rate?

Repeat Rate = Users who purchased 2 or more times / users who purchased

```ruby
select
count(distinct(user_id))
from stg_orders;


with order_per_user as (

select count(order_id) as order_c
from stg_orders
group by user_id
)
select 
count_if(order_c>=2) as two_and_more
, order_c
from order_per_user;
```
99/124 = 0.8

#### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
We can analyze the time between purchases and number of purchases to make our assumptions on whether customer will buy again. 
Having demographic data and customer reviews would help for analysis.

#### Create a marts folder, so we can organize our models, with the following subfolders for business units.
#### What are daily page views by product? Daily orders by product? What’s getting a lot of traffic, but maybe not converting into purchases?

```ruby
select 
product_name
, price
, count_if(event_type='page_view') as product_viewed
, count_if(event_type='add_to_cart') as product_bought
, count(date_trunc('day',created_at)) as days
, round(div0(product_bought , product_viewed),2) as bought_vs_viewed
, round(div0(product_viewed, days),2) as views_per_day

from fact_page_views
group by product_name, price
order by 4 desc;
```

## Part 2

