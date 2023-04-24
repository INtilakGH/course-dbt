{{
    config(
        materialized='view'
    )
}}

with users as (
    select 
    user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at
    , updated_at
    , address_id as user_address_id
    from {{ ref('stg_users')}}
)
, addresses as (
    select *
    from {{ ref('stg_addresses') }}

)

select *
from users
left join addresses
on users.user_address_id = addresses.address_id