# Walmart dbt orchestration with Airflow

This directory contains the Airflow deployment for the Walmart dbt project:

- `dags/orchestrate.py` defines the workflow.
- `walmart_project/` contains the dbt project and Databricks profile location.
- `Dockerfile` builds an Airflow image with the dbt Databricks adapter.
- `requirements.txt` installs `dbt-core` and `dbt-databricks`.
- `docker-compose.yaml` starts Airflow, its worker, PostgreSQL, and Redis.

## Workflow

The `orchestrate` DAG currently runs these tasks in sequence:

1. `ingest_cdc` is a Python TaskFlow task placeholder. It returns a status
   string; it does not currently ingest data.
2. `clean_target` removes dbt's generated `target` and `logs` directories.
3. `source_freshness` runs `dbt source freshness`.
4. `silver_technical` builds the `silver_t` models, followed by
   `silver_technical_test`.
5. `silver_business` builds the `silver_b` models, followed by
   `silver_business_test`.
6. `gold_ephemeral` builds the ephemeral Gold models.
7. `gold_dimnesion` runs dbt snapshots.
8. `gold_fact` builds the Gold fact model.

The dbt commands run in `/opt/airflow/walmart_project`, which is mounted from
this directory's `walmart_project/` folder. The BashOperators set that working
directory with `cwd`; the source-freshness task changes into it in its command.

No schedule is declared on the DAG at present. It therefore needs to be
triggered manually in Airflow; it will not run periodically until a schedule is
configured in `dags/orchestrate.py`.

## Databricks integration

The `dbt-databricks` adapter connects dbt to Databricks using the profile in
`walmart_project/profiles.yml`. The adapter brings in `databricks-sdk` as a
Python dependency, but this DAG does not directly instantiate a
`databricks.sdk.WorkspaceClient` or call the Databricks Jobs API. Airflow
launches dbt's command-line interface, and dbt uses the adapter for its
Databricks connection.

The current Python integration is Airflow's TaskFlow API in the DAG. The
`ingest_cdc` task is only a placeholder; the transformation, freshness, test,
snapshot, and build work is launched as dbt CLI commands.

## Credentials and Git

Keep Databricks credentials in the local `walmart_project/profiles.yml` or,
preferably, an Airflow Connection or external secrets backend. Do not commit
profiles, `.env` files, Airflow configuration, tokens, or private keys. The
repository `.gitignore` excludes these local files. If credentials have ever
been committed or shared, rotate them; adding a file to `.gitignore` does not
remove it from Git history.

The Compose file also loads a local `.env` file. Supply the required local
Airflow environment values before starting the stack; never put real
credentials in a tracked example or README.

## Run Airflow locally

After renaming this directory to `airflow_dbt_project`, open PowerShell in
that directory and initialize and start the stack:

```powershell
docker compose up airflow-init
docker compose up -d
```

Open [http://localhost:8080](http://localhost:8080), enable the `orchestrate`
DAG if it is paused, and trigger it manually.

To rebuild the custom image after changing dependencies or the Dockerfile:

```powershell
docker compose build
docker compose up -d
```

To stop the stack without removing its named data volumes:

```powershell
docker compose down
```

## Run dbt without Airflow

From the repository root, the root Python project can run the dbt CLI against
the Airflow-contained project and profile:

```powershell
uv run --project . dbt parse --project-dir airflow_dbt_project/walmart_project --profiles-dir airflow_dbt_project/walmart_project
uv run --project . dbt source freshness --project-dir airflow_dbt_project/walmart_project --profiles-dir airflow_dbt_project/walmart_project
uv run --project . dbt run --project-dir airflow_dbt_project/walmart_project --profiles-dir airflow_dbt_project/walmart_project
uv run --project . dbt test --project-dir airflow_dbt_project/walmart_project --profiles-dir airflow_dbt_project/walmart_project
```
