SELECT
    orders_order_id AS order_id,
    order_items_order_item_id AS order_item_id,
    products_product_id AS product_id,
    stores_store_id AS store_id,
    employees_employee_id AS employee_id,
    customers_customer_id AS customer_id,
    orders_total_amount AS total_amount,
    order_items_quantity AS quantity,
    order_items_unit_price AS unit_price,
    order_items_line_amount AS line_amount
    FROM {{ ref('obt_b') }}