--STEP 4: recreating excel features
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

--recreate an excel pivot to check the consistency
select 
	tenure_bucket,
	count(*) as customers,
	round(avg(churn) * 100, 2) as churn_rate
from v_customer_features
group by tenure_bucket
order by churn_rate DESC;

--STEP 5: Export to csv for Python Phase 3
--using TablePlus export feature