SELECT 
    distinct
    orders_order_id as order_id,
    order_items_order_item_id as order_item_id,
    orders_payment_method as payment_method,
    orders_order_status as status,
    orders_order_timestamp as order_timestamp,
    orders_created_timestamp as created_timestamp,
    orders_updated_timestamp as updated_timestamp,
    orders_is_active as is_active,
    orders_processed_at as processed_at,
    obt_b_processed_at as obt_b_processed_at,
    current_timestamp() as order_gold_processed_at
    from {{ ref('obt_b') }}