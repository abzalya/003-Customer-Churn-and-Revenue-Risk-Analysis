--STEP 1: create a table to store raw data
set search_path to public;

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

--Load data using the TablePlus import tool

--check data
select *
from telco_raw;