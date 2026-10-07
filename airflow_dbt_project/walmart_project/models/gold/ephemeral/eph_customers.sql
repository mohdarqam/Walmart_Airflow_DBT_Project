Select 
    distinct
    customers_customer_id as customer_id,
    customers_first_name as first_name,
    customers_last_name as last_name,
    customers_email as email,
    customers_phone as phone,
    customers_city as city,
    customers_province as province,
    customers_country as country,
    customers_created_timestamp as created_timestamp,
    customers_updated_timestamp as updated_timestamp,
    customers_is_active as is_active,
    customers_processed_at as processed_at,
    current_timestamp() as customer_gold_processed_at

from {{ ref('obt_b') }}
    
