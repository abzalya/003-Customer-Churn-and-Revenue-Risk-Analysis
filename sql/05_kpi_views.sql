--STEP 5: Create a view of KPIs

drop view if exists v_kpis;

create or replace view v_kpis as
select
  	count(*) as customers,
  	round(avg(churn) * 100, 2) as churn_rate,
  	round(avg(monthly_charges), 2) as avg_monthly_charges,
  	round(avg(total_charges), 2) as avg_total_charges
from telco_stg;