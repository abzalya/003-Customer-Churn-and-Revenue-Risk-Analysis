# Excel Phase 1 — Exploratory Analysis & Hypothesis Testing

Using Excel to conduct structured exploratory analysis and quick hypothesis testing on the Telco Customer Churn dataset. The objective of this phase is understanding key churn drivers, validate business intuition, and define priorities for deeper analysis in later stages.

## Workbook Structure

The Excel workbook is organized into four tabs:
- Raw
Contains the original dataset.
- Working
Used for all transformations and feature creation, including data type fixes and new columns.
- Pivots
Contains pivot tables used to quickly test hypotheses and identify high-level patterns in churn behavior.
- Insights
Summarizes hypotheses, key results from pivot analysis, and their business implications.

## Data Preparation & Feature Engineering

Key decisions and transformations include:
- Column standardization
All column names were renamed to lowercase and separated using underscores (e.g., SeniorCitizen → senior_citizen) to ensure consistency across Excel, SQL, Python, and Tableau and to avoid downstream issues.
- Data type fixes
total_charges was converted from text to numeric format.
- Created new columns
	- Derived analytical features
	- churn_flag: binary indicator for churn to enable aggregation and rate calculations
	- tenure_bucket: grouped tenure ranges to improve interpretability
	- charges_bucket: grouped monthly charges to test price sensitivity
	- service_count: count of additional services to assess service dependency
	- bundle_type: combined phone and internet service status into a single variable
	- household_type: combined partner and dependents into a household structure variable
	- autopay_flag: grouped payment methods into automatic vs manual

## Hypothesis Framework

The following hypotheses guided exploratory analysis in this phase:

	**1.	Tenure and Switching Costs**
Longer-tenure customers are less likely to churn due to higher switching costs and habit formation.

	**2.	Contract Lock-in**
Month-to-month contracts exhibit higher churn than fixed-term contracts due to lower contractual commitment.

	**3.	Payment Friction**
Automatic payment methods are associated with lower churn due to reduced repeated cancellation decisions.

	**4.	Price Sensitivity**
Higher monthly charges are associated with different churn behavior, reflecting price sensitivity and customer value differences.

	**5.	Service Dependency**
Customers with more additional services are less likely to churn due to increased dependency and switching effort.

	**6.	Demographic Stability**
Household structure influences churn behavior, potentially reflecting differences in stability and switching difficulty.

	**7.	Product and Internet Type**
Churn rates vary by service bundle and internet type due to differences in pricing, customer profiles, and competitive dynamics.

	**8.	Support and Security Services (deferred)**
The independent impact of services such as Online Security and Tech Support is evaluated in later phases.

	**9.	Customer Friction Indicators (deferred)**
Combined friction signals (manual payments, paper billing, high charges) are examined in later analysis.

## Insights & Interpretation

Quick hypothesis testing was conducted using pivot tables and selective charts for variables showing strong, intuitive patterns. Results and business implications are summarized in the Insights tab. Numerical data remains in pivot tables.

## Transition to Next Phase

Excel phase was limited exploratory analysis and hypothesis validation. Detailed analysis, feature encoding, and predictive modeling were deferred to later stages.

Next phase:
Data cleaning, transformation, and feature construction in SQL, followed by predictive modeling and deeper analysis in Python.