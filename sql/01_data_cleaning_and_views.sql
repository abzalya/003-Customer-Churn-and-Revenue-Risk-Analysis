set search_path to public;

--create a table to store raw data
drop table if exists telco_raw;
create table telco_raw (
  customer_id text,
  gender text,
  senior_citizen int,
  partner text,
  dependents text,
  tenure int,
  phone_service text,
  multiple_lines text,
  internet_service text,
  online_security text,
  online_backup text,
  device_protection text,
  tech_support text,
  streaming_tv text,
  streaming_movies text,
  contract text,
  paperless_billing text,
  payment_method text,
  monthly_charges numeric,
  total_charges text,
  churn text
);
--using the TablePlus import tool

--check data
select *
from telco_raw;


--creating staging view as we iterate on logic and exact datatypes/columns we want
--replace all yes/no columns to binary as a bool type. senior_citizen, partner, dependents, phone_service , etc
create or replace view telco_stg as
select 
  customer_id,
  gender,
  senior_citizen,
  partner,
  dependents,
  tenure,
  phone_service,
  multiple_lines,
  internet_service,
  online_security,
  online_backup,
  device_protection,
  tech_support,
  streaming_tv,
  streaming_movies,
  contract,
  paperless_billing,
  payment_method,
  monthly_charges,
  nullif(btrim(total_charges), '')::numeric as total_charges_num,
  churn
from telco_raw;

--recreating excel features
create or replace view v_customer_features as
select
  *,
  case when churn = 'Yes' then 1 else 0 end as churn_flag,

  case
    when tenure <= 6 then '0-6'
    when tenure <= 12 then '7-12'
    when tenure <= 24 then '13-24'
    when tenure <= 48 then '25-48'
    else '49+'
  end as tenure_bucket,

  case
    when monthly_charges < 35 then 'low'
    when monthly_charges <= 70 then 'mid'
    else 'high'
  end as charges_bucket,

  case
    when payment_method in ('Bank transfer (automatic)', 'Credit card (automatic)') then 1
    else 0
  end as autopay_flag,

  case
    when phone_service = 'Yes' and internet_service <> 'No' then 'phone+internet'
    when phone_service = 'Yes' and internet_service = 'No' then 'phone_only'
    when phone_service = 'No' and internet_service <> 'No' then 'internet_only'
    else 'other'
  end as bundle_type,

  case
    when partner = 'Yes' and dependents = 'Yes' then 'partner+dependents'
    when partner = 'Yes' and dependents = 'No'  then 'partner_only'
    when partner = 'No'  and dependents = 'Yes' then 'dependents_only'
    else 'neither'
  end as household_type,

  (
    (case when online_security   = 'Yes' then 1 else 0 end) +
    (case when online_backup     = 'Yes' then 1 else 0 end) +
    (case when device_protection = 'Yes' then 1 else 0 end) +
    (case when tech_support      = 'Yes' then 1 else 0 end) +
    (case when streaming_tv      = 'Yes' then 1 else 0 end) +
    (case when streaming_movies  = 'Yes' then 1 else 0 end)
  ) as service_count

from telco_stg;