SELECT 
    DiSTINCT
    stores_store_id AS store_id,
    stores_store_name AS store_name,
    stores_city AS city,
    stores_province AS province,
    stores_country AS country,
    stores_created_timestamp AS created_timestamp,
    stores_updated_timestamp AS updated_timestamp,
    stores_is_active AS is_active,
    stores_processed_at AS processed_at,
    current_timestamp() AS store_gold_processed_at
    from {{ ref('obt_b') }}