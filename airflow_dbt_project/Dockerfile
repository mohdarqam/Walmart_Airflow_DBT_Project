FROM apache/airflow:3.3.2

USER root

RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ python3-venv && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER airflow

COPY requirements.txt .

ENV PATH="/home/airflow/dbt-venv/bin:${PATH}"

RUN python -m venv /home/airflow/dbt-venv && \
    /home/airflow/dbt-venv/bin/pip install --no-cache-dir --upgrade pip && \
    /home/airflow/dbt-venv/bin/pip install --no-cache-dir -r requirements.txt && \
    dbt --version
