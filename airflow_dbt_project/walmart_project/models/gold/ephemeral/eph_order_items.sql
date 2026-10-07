Select 
    distinct
    order_items_order_item_id as order_item_id,
    order_items_order_id as order_id,
    order_items_product_id as product_id,
    order_items_quantity as quantity,
    order_items_unit_price as unit_price,
    order_items_line_amount as line_amount,
    order_items_created_timestamp as created_timestamp,
    order_items_updated_timestamp as updated_timestamp,
    order_items_is_active as is_active,
    order_items_processed_at as processed_at,
    current_timestamp() as order_items_gold_processed_at
    FROM {{ ref('obt_b') }}