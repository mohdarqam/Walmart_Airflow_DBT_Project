SELECT 
    DISTINCT
    employees_employee_id AS employee_id,
    employees_store_id AS store_id,
    employees_first_name AS first_name,
    employees_last_name AS last_name,
    employees_email AS email,
    employees_job_title AS job_title,
    employees_salary AS salary,
    employees_created_timestamp AS created_timestamp,
    employees_updated_timestamp AS updated_timestamp,
    employees_is_active AS is_active,
    employees_processed_at AS processed_at,
    current_timestamp() AS employee_gold_processed_at
    from {{ ref('obt_b') }}