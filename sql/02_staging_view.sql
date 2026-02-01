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

--including the final version of the view that was created after the quality checks

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

--checking the conversion and cleaning
select *
from telco_stg;