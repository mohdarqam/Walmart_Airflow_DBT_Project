SELECT 
    DISTINCT
    products_product_id AS product_id,
    products_product_name AS product_name,
    products_category AS category,
    products_brand AS brand,
    products_price AS price,
    products_created_timestamp AS created_timestamp,
    products_updated_timestamp AS updated_timestamp,
    products_is_active AS is_active,
    products_processed_at AS processed_at,
    current_timestamp() AS product_gold_processed_at
    from {{ ref('obt_b') }}
