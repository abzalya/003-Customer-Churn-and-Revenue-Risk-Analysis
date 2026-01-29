# Layoffs Analysis: SQL → Excel → Power BI

## Overview
This project analyzes global company layoffs data to identify trends across time, industries, and regions. 
The objective is to understand which sectors were most affected, how layoffs evolved over time, and what patterns emerge by company size and geography.

## Tools Used
- SQL: PostgreSQL
- Excel: Microsoft Excel 365
- Power BI: Power BI Desktop

## Data Source
Dataset: Global Tech Layoffs Dataset  
Source: Public Kaggle dataset  
Time period: 2020–2024  

Raw data is stored in data/raw/ and is not modified.

## Project Structure
- data/ → raw and processed datasets
- sql/ → data cleaning and analysis scripts
- excel/ → exploratory analysis workbook
- powerbi/ → dashboard file
- docs/ → documentation and methodology

## How to Reproduce

1. Load raw CSV files into SQL staging tables.
2. Run SQL scripts in order:
   - 00_create_tables.sql
   - 01_cleaning.sql
   - 02_analysis_views.sql
3. Open excel/analysis.xlsx and refresh connections.
4. Open powerbi/dashboard.pbix and refresh data.

## Key Outputs
- Cleaned SQL tables
- Reusable analysis views
- Excel pivot summaries
- Interactive Power BI dashboard

## Key Insights
- Layoffs peaked during specific economic periods.
- Technology and finance sectors were most affected.
- Certain regions showed higher volatility than others.

## Limitations
- Dataset relies on public reporting.
- Smaller companies may be underrepresented.
- Some records contain incomplete location data.

## Author
Bekzat Amirbay  
2026