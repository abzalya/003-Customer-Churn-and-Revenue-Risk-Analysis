# SQL Phase 2 — Data Cleaning, Validation, and Feature Engineering (Postgres)

 The goal is to create a reproducible pipeline that separates raw data from transformations, validates data quality, and produces a feature view for Python modeling and Tableau visualization.

## What was built

### Raw layer: 'telco_raw'
- Stores the imported CSV exactly as received.
- Text fields remain text to preserve source fidelity (e.g., 'total_charges').

### Staging layer: 'telco_stg' (view)
Transformations applied:
- Trimmed key string fields using 'btrim()' to prevent hidden whitespace issues.
- Encoded Yes/No fields as binary 0/1 integers for modeling readiness.
- Converted 'total_charges' from text to numeric.

Missing value handling:
- Only 'total_charges' had missing values (11 rows), all associated with 'tenure = 0' (new signups).
- Since 'total_charges' is a cumulative billing metric, these were populated as '0' in staging to preserve early-tenure customers.

### Feature layer: 'v_customer_features' (view)
Recreated Excel-derived features:
- 'tenure_bucket'
- 'charges_bucket'
- 'autopay_flag'
- 'bundle_type'
- 'household_type'
- 'service_count'

### KPI layer: 'v_kpis' (view)
Provides quick headline metrics:
- total customers
- churn rate
- average monthly charges
- average total charges

## Data quality checks
The following checks are included to validate transformations:
- Column-level null audit across staging fields
- Duplicate checks on 'customer_id'
- Category distribution checks for key dimensions (internet service, contract, payment method)
- Consistency rule: 'tenure = 0' implies 'total_charges = 0'

## How to run
Run scripts in order:
1. '01_raw_table.sql' (create raw table; then import CSV using TablePlus)
2. '02_staging_view.sql'
3. '03_quality_checks.sql'
4. '04_feature_view.sql'
5. '05_kpi_views.sql'

## Output for downstream phases
- Export dataset for Python and Tableau from 'v_customer_features' (CSV export performed via TablePlus).

Next phase: Python modeling (EDA, baseline model, feature importance, predictive evaluation).