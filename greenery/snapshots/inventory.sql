{% snapshot inventory_snapshot %}

  {{
    config(
      target_schema='dbt_irinasigmacomputingcom',
      target_database='dev_db',
      unique_key='product_id',

      strategy='check',
      check_cols=['inventory']
    )
  }}

  SELECT * FROM {{ source('postgres', 'products') }}

{% endsnapshot %}