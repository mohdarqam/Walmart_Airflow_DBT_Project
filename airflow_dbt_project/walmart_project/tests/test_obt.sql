{{
    config(severity='warn')
}}

select
    obt.orders_order_id,
    obt.order_items_order_item_id,
    obt.order_items_product_id,
    obt.orders_store_id,
    obt.orders_customer_id,
    obt.employees_employee_id
from {{ ref('obt_b') }} as obt
where
    obt.orders_order_id is null
    or obt.order_items_order_item_id is null
    or obt.order_items_product_id is null
    or obt.orders_store_id is null
    or obt.orders_customer_id is null
    or obt.employees_employee_id is null