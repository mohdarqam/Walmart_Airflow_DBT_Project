{% set configs = [
            {   
                "table_name": "walmart.silver_t.orders_t",
                "columns": """
                                o.order_id                AS orders_order_id,
                                o.customer_id             AS orders_customer_id,
                                o.store_id                AS orders_store_id,
                                o.order_timestamp         AS orders_order_timestamp,
                                o.payment_method          AS orders_payment_method,
                                o.order_status            AS orders_order_status,
                                o.total_amount            AS orders_total_amount,
                                o.created_timestamp       AS orders_created_timestamp,
                                o.updated_timestamp       AS orders_updated_timestamp,
                                o.is_active               AS orders_is_active,
                                o.processed_at            AS orders_processed_at
                                """,
                'alias': 'o'

            },
            {
                'table_name': 'walmart.silver_t.customers_t',
                'columns': """
                            c.customer_id             AS customers_customer_id,
                            c.first_name              AS customers_first_name,
                            c.last_name               AS customers_last_name,
                            c.email                   AS customers_email,
                            c.phone                   AS customers_phone,
                            c.city                    AS customers_city,
                            c.province                AS customers_province,
                            c.country                 AS customers_country,
                            c.created_timestamp       AS customers_created_timestamp,
                            c.updated_timestamp       AS customers_updated_timestamp,
                            c.is_active               AS customers_is_active,
                            c.processed_at            AS customers_processed_at
                                """,
                'alias': 'c',
                'join_condition': 'o.customer_id = c.customer_id'
            },
                        {
                'table_name': 'walmart.silver_t.order_items_t',
                'columns': """
                            oi.order_item_id          AS order_items_order_item_id,
                            oi.order_id               AS order_items_order_id,
                            oi.product_id             AS order_items_product_id,
                            oi.quantity               AS order_items_quantity,
                            oi.unit_price             AS order_items_unit_price,
                            oi.line_amount            AS order_items_line_amount,
                            oi.created_timestamp      AS order_items_created_timestamp,
                            oi.updated_timestamp      AS order_items_updated_timestamp,
                            oi.is_active              AS order_items_is_active,
                            oi.processed_at           AS order_items_processed_at
                                """,
                'alias': 'oi',
                'join_condition': 'o.order_id = oi.order_id'
            },
            {
                'table_name': 'walmart.silver_t.products_t',
                'columns': """
                            p.product_id              AS products_product_id,
                            p.product_name            AS products_product_name,
                            p.category                AS products_category,
                            p.brand                   AS products_brand,
                            p.price                   AS products_price,
                            p.created_timestamp       AS products_created_timestamp,
                            p.updated_timestamp       AS products_updated_timestamp,
                            p.is_active               AS products_is_active,
                            p.processed_at            AS products_processed_at
                                """,
                'alias': 'p',
                'join_condition': 'oi.product_id = p.product_id'
            },
            {
                'table_name': 'walmart.silver_t.stores_t',
                'columns': """
                            s.store_id                AS stores_store_id,
                            s.store_name              AS stores_store_name,
                            s.city                    AS stores_city,
                            s.province                AS stores_province,
                            s.country                 AS stores_country,
                            s.created_timestamp       AS stores_created_timestamp,
                            s.updated_timestamp       AS stores_updated_timestamp,
                            s.is_active               AS stores_is_active,
                            s.processed_at            AS stores_processed_at
                                """,
                'alias': 's',
                'join_condition': 'o.store_id = s.store_id'
            },
            {
                'table_name': 'walmart.silver_t.employees_t',
                'columns': """
                                e.employee_id             AS employees_employee_id,
                                e.store_id                AS employees_store_id,
                                e.first_name              AS employees_first_name,
                                e.last_name               AS employees_last_name,
                                e.email                   AS employees_email,
                                e.job_title               AS employees_job_title,
                                e.salary                  AS employees_salary,
                                e.created_timestamp       AS employees_created_timestamp,
                                e.updated_timestamp       AS employees_updated_timestamp,
                                e.is_active               AS employees_is_active,
                                e.processed_at            AS employees_processed_at,
                                current_timestamp()       AS obt_b_processed_at
                                """,
                'alias': 'e',
                'join_condition': 'o.store_id = e.store_id'
            }



]%}

SELECT 
    {% for config in configs %}
    {{config['columns']}}{% if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {% for cfg in configs %}
    {% if loop.first %}
    {{ cfg['table_name'] }} {{ cfg['alias'] }}
    {% else %}
    LEFT JOIN {{ cfg['table_name'] }} {{ cfg['alias'] }}
        ON {{ cfg['join_condition'] }}
    {% endif %}
    {% endfor %}