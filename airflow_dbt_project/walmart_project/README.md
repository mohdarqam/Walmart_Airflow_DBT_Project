# Walmart dbt project

This folder contains the complete dbt project: project configuration, models,
macros, tests, snapshots, analyses, and seeds.

Run commands from this folder:

```powershell
uv run --project .. dbt parse --project-dir . --profiles-dir .
uv run --project .. dbt run --project-dir . --profiles-dir .
uv run --project .. dbt test --project-dir . --profiles-dir .
uv run --project .. dbt snapshot --project-dir . --profiles-dir .
```

The local `profiles.yml` contains connection settings and is ignored by Git.
Keep credentials out of version control.
