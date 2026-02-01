set search_path to public;

--STEP 1: create a table to store raw data
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


--STEP 2: creating staging view as we iterate on logic and exact datatypes/columns we want
--replace all yes/no columns to binary 1/0 int type. senior_citizen, partner, dependents, phone_service , etc
drop view if exists telco_stg cascade;
create or replace view telco_stg as
select 
	btrim(customer_id) as customer_id,
  	btrim(gender) as gender,
  	senior_citizen,
  	case when partner = 'Yes' then 1 else 0 end as partner,
 	case when dependents = 'Yes' then 1 else 0 end as dependents,
  	tenure,
  	case when phone_service = 'Yes' then 1 else 0 end as phone_service,
  	case when multiple_lines = 'Yes' then 1 else 0 end as multiple_lines,
  	btrim(internet_service) as internet_service,
  	case when online_security = 'Yes' then 1 else 0 end as online_security,
  	case when online_backup = 'Yes' then 1 else 0 end as online_backup,
  	case when device_protection = 'Yes' then 1 else 0 end as device_protection,
  	case when tech_support = 'Yes' then 1 else 0 end as tech_support,
  	case when streaming_tv = 'Yes' then 1 else 0 end as streaming_tv,
  	case when streaming_movies = 'Yes' then 1 else 0 end as streaming_movies,
  	btrim(contract) as contract,
  	case when paperless_billing = 'Yes' then 1 else 0 end as paperless_billing,
  	btrim(payment_method) as payment_method,
  	monthly_charges,
  	nullif(btrim(total_charges), '')::numeric as total_charges,
  	case when churn = 'Yes' then 1 else 0 end as churn
from telco_raw;

--checking the conversion and cleaning
select *
from telco_stg;

--STEP 3: checking for missing/null values (total number of null values
select
  	sum(case when customer_id is null then 1 else 0 end) as customer_id_nulls,
  	sum(case when gender is null then 1 else 0 end) as gender_nulls,
  	sum(case when senior_citizen is null then 1 else 0 end) as senior_citizen_nulls,
  	sum(case when partner is null then 1 else 0 end) as partner_nulls,
  	sum(case when dependents is null then 1 else 0 end) as dependents_nulls,
	sum(case when tenure is null then 1 else 0 end) as tenure_nulls,
  	sum(case when phone_service is null then 1 else 0 end) as phone_service_nulls,
  	sum(case when multiple_lines is null then 1 else 0 end) as multiple_lines_nulls,
  	sum(case when internet_service is null then 1 else 0 end) as internet_service_nulls,
  	sum(case when online_security is null then 1 else 0 end) as online_security_nulls,
  	sum(case when online_backup is null then 1 else 0 end) as online_backup_nulls,
  	sum(case when device_protection is null then 1 else 0 end) as device_protection_nulls,
  	sum(case when tech_support is null then 1 else 0 end) as tech_support_nulls,
  	sum(case when streaming_tv is null then 1 else 0 end) as streaming_tv_nulls,
  	sum(case when streaming_movies is null then 1 else 0 end) as streaming_movies_nulls,
  	sum(case when contract is null then 1 else 0 end) as contract_nulls,
  	sum(case when paperless_billing is null then 1 else 0 end) as paperless_billing_nulls,
  	sum(case when payment_method is null then 1 else 0 end) as payment_method_nulls,
  	sum(case when monthly_charges is null then 1 else 0 end) as monthly_charges_nulls,
  	sum(case when total_charges is null then 1 else 0 end) as total_charges_nulls,
  	sum(case when churn is null then 1 else 0 end) as churn_nulls
from telco_stg;

--As part of SQL Phase 2, a column-level null audit was performed on the staging view to validate data integrity following type coercion and feature construction. Null values were explicitly counted for all attributes, confirming that missingness is limited and consistent with source-data characteristics rather than transformation errors.

--only null values are total_charges, specifically 11 of them 
--why ?

select * 
from telco_stg
where total_charges is null;

--all 11 null values are associated with customers with tenure = 0, i.e. new customers who have not been billed yet. 
--as the total_charges is a cumilative billing metric, their true value is 0
--populate the null values with 0 

--All missing values in total_charges were observed exclusively among customers with zero tenure, corresponding to new signups who had not yet been billed. These values were populated as 0, reflecting the true cumulative charges at the time of observation. This approach preserves early-tenure customers in the dataset while maintaining logical consistency.

--STEP 4: Populate nulls with 0 
drop view if exists telco_stg cascade;
create or replace view telco_stg as
select 
	btrim(customer_id) as customer_id,
  	btrim(gender) as gender,
  	senior_citizen,
  	case when partner = 'Yes' then 1 else 0 end as partner,
 	case when dependents = 'Yes' then 1 else 0 end as dependents,
  	tenure,
  	case when phone_service = 'Yes' then 1 else 0 end as phone_service,
  	case when multiple_lines = 'Yes' then 1 else 0 end as multiple_lines,
  	btrim(internet_service) as internet_service,
  	case when online_security = 'Yes' then 1 else 0 end as online_security,
  	case when online_backup = 'Yes' then 1 else 0 end as online_backup,
  	case when device_protection = 'Yes' then 1 else 0 end as device_protection,
  	case when tech_support = 'Yes' then 1 else 0 end as tech_support,
  	case when streaming_tv = 'Yes' then 1 else 0 end as streaming_tv,
  	case when streaming_movies = 'Yes' then 1 else 0 end as streaming_movies,
  	btrim(contract) as contract,
  	case when paperless_billing = 'Yes' then 1 else 0 end as paperless_billing,
  	btrim(payment_method) as payment_method,
  	monthly_charges,
  	case when tenure = 0 then 0
  		else nullif(btrim(total_charges), '')::numeric end as total_charges, -- edited version to populate with 0 for customers with 0 tenure 
  	case when churn = 'Yes' then 1 else 0 end as churn
from telco_raw;

--check // can additionally re-run STEP 3 query to see that all columns are populated fully
select total_charges
from telco_stg
where tenure = 0;

--STEP 5: Extra quality checks
--checking for duplicates
select customer_id, count(*) as n
from telco_stg
group by 1
having count(*) > 1;

--consistency on text
select internet_service, count(*) from telco_stg group by 1 order by 2 desc;
select contract, count(*) from telco_stg group by 1 order by 2 desc;
select payment_method, count(*) from telco_stg group by 1 order by 2 desc;


--STEP 5: recreating excel features
drop view if exists v_customer_features;
create or replace view v_customer_features as
select *,
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
    	when phone_service = 1 and not internet_service = 'No' then 'phone+internet'
    	when phone_service = 1 and internet_service = 'No' then 'phone_only'
    	when phone_service = 0 and not internet_service = 'No' then 'internet_only'
    	else 'other'
  	end as bundle_type,
  	case
    	when partner = 1 and dependents = 1 then 'partner+dependents'
    	when partner = 1 and dependents = 0 then 'partner_only'
    	when partner = 0 and dependents = 1 then 'dependents_only'
    	else 'neither'
  	end as household_type,
  	(
    	(case when online_security   = 1 then 1 else 0 end) +
    	(case when online_backup     = 1 then 1 else 0 end) +
    	(case when device_protection = 1 then 1 else 0 end) +
    	(case when tech_support      = 1 then 1 else 0 end) +
    	(case when streaming_tv      = 1 then 1 else 0 end) +
    	(case when streaming_movies  = 1 then 1 else 0 end)
  	) as service_count
from telco_stg;

--STEP 6: VIEWS
drop view if exists v_kpis;
create or replace view v_kpis as
select
  	count(*) as customers,
  	round(avg(churn) * 100, 2) as churn_rate,
  	round(avg(monthly_charges), 2) as avg_monthly_charges,
  	round(avg(total_charges), 2) as avg_total_charges
from telco_stg;

--recreate an excel pivot to check the consistency
select 
	tenure_bucket,
	count(*) as customers,
	round(avg(churn) * 100, 2) as churn_rate
from v_customer_features
group by tenure_bucket
order by churn_rate DESC;	

--STEP 7: Export to csv for Python Phase 3
--using TablePlus export feature