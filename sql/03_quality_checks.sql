--STEP 3: checking for missing/null values (total number of null values
--NOTE: final version of the code for craeting of the view was also added to 02_staging_view therefore if it was ran previously, you may not observe the same behaviour I have. 

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

--only null values are total_charges, specifically 11 of them 
--why ?

select * 
from telco_stg
where total_charges is null;

--all 11 null values are associated with customers with tenure = 0, i.e. new customers who have not been billed yet. 
--as the total_charges is a cumilative billing metric, their true value is 0
--populate the null values with 0 

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

--check // can additionally re-run top query to see that all columns are populated fully
select total_charges
from telco_stg
where tenure = 0;

--checking for duplicates on customer_id
select customer_id, count(*) as n
from telco_stg
group by 1
having count(*) > 1;

-- Category distributions (spot unexpected values)
select internet_service, count(*) from telco_stg group by 1 order by 2 desc;
select contract, count(*) from telco_stg group by 1 order by 2 desc;
select payment_method, count(*) from telco_stg group by 1 order by 2 desc;