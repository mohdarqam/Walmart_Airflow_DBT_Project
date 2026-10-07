{{


    config(
        materialized='incremental',
        unique_key='store_id'
    )
}}
select *,
    current_timestamp() as processed_at
from {{ source('walmart_databricks', 'stores') }}
where
{% if is_incremental() %}
updated_timestamp > (select coalesce(max(updated_timestamp), '1900-01-01') from {{ this }})
{% endif %}