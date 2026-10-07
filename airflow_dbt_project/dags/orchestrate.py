from airflow.sdk import dag, task
from airflow.operators.bash import BashOperator

@dag
def orchestrate():
    @task
    def ingest_cdc():
        return 'CDC Data Ingested'
    @task.bash
    def clean_target():
        return "rm -rf /opt/airflow_dbt_project/walmart_project/target && rm -rf /opt/airflow_dbt_project/walmart_project/logs" 
    @task.bash
    def source_freshness():
        #manually set the working directory to the dbt project using the cd command before running the dbt source freshness command
        return "cd /opt/airflow_dbt_project/walmart_project && dbt source freshness"
    silver_technical_test = BashOperator(
            task_id='silver_technical_test',
            cwd='/opt/airflow_dbt_project/walmart_project',
            bash_command='dbt test --select silver_t'
        )
    silver_business_test = BashOperator(
                task_id='silver_business_test',
                cwd='/opt/airflow_dbt_project/walmart_project',
                bash_command='dbt test --select silver_b'
    )
    silver_business = BashOperator(
                    task_id='silver_business',
                    cwd='/opt/airflow_dbt_project/walmart_project',
                    bash_command='dbt run --select silver_b'
        )
    silver_technical = BashOperator(
        task_id='silver_technical',
        cwd='/opt/airflow_dbt_project/walmart_project',
        bash_command='dbt run --select silver_t'
    )
    gold_ephemeral = BashOperator(
            task_id='gold_ephemeral',
            cwd='/opt/airflow_dbt_project/walmart_project',
            bash_command='dbt run --select gold/ephemeral'
        )
    gold_dimnesion = BashOperator(
            task_id='gold_dimnesion',
            cwd='/opt/airflow_dbt_project/walmart_project',
            bash_command='dbt snapshot'
    )
    gold_fact = BashOperator(
            task_id='gold_fact',
            cwd='/opt/airflow_dbt_project/walmart_project',
            bash_command='dbt run --select gold/fact'
    )

    ingest_cdc() >> clean_target() >> source_freshness() >> silver_technical >> silver_technical_test >> silver_business >> silver_business_test >> gold_ephemeral >> gold_dimnesion >> gold_fact

orchestrate_dag = orchestrate()