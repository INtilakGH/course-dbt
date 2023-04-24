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
![Screenshot 2023-04-23 at 6 15 25 PM](https://user-images.githubusercontent.com/124845082/233879757-82b8ee7a-da9f-4be6-9884-da334e162d6b.png)

I enriched stg_users table with addresses information and placed into marts/core directory. Core because I thought it's something that can be analyzed by stakeholders stand alone as well as be joined with orders or products. It's a table that describes customers so it's a dimentional table. When deciding on the directory, I was in a doubt between "marts/product/intermediate" and "marts/core". Then based on what I mentioned above I decided to place it in "core"
For something specific like events I created a table in marts/product. It's a "fact" table. This can be surfaced to stakeholders through BI tools, and sliced and diced in different ways to answer their questions. 

The diagram below shows all the sources for my fact_page_views. I was thinking that having some user information like zipcode would be helpful to analyse and plan inventory in different locations.

![Screenshot 2023-04-23 at 3 40 45 PM](https://user-images.githubusercontent.com/124845082/233881090-3d8a9bd8-8d9e-4a45-a907-54e77658de95.png)



## Part 2
I made a few assumptions about our data such as unique values in primary key columns (user_id in user table, product_id in product table, etc), and positive values for inventory in product table. I have used dbt tests like not_null and unique, and created a positive_value test in macros (as generic test that can be reused). All tests completed successfully.

## Part 3
I ran dbt snapshot and then queried my inventory_snapshot table. I could see changes in some items (see the screenshot)

![Screenshot 2023-04-23 at 6 18 12 PM](https://user-images.githubusercontent.com/124845082/233879708-a1798f38-ae4c-4e6e-8154-4dfd3004fb02.png)
