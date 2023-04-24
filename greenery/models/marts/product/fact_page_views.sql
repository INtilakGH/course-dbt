{{
    config(
        materialized='table'
    )
}}

with events as (
    select *
    from {{ref('stg_events')}}
)
, users as (
    select 
    user_id as join_user_id
    , zipcode
    from {{ ref('dim_users') }}
)
, products as (
    select
    product_id as join_product_id
    , name as product_name
    , price
    from {{ref('stg_products')}}

)

select * from events

left join users
on events.user_id = users.join_user_id

left join products
on events.product_id = products.join_product_id