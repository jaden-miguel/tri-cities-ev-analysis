# Tri-Cities EV Analysis Project

This repository contains a data analysis project investigating electric vehicle adoption in the Tri-Cities region (Kennewick, Pasco, Richland) of Washington state. The project uses Washington State’s `Electric Vehicle Population Data` dataset (published by the Department of Licensing) as of July 19, 2025【75374942803867†L94-L99】.

## Project summary

1. **Data retrieval and cleaning** – The dataset was retrieved via the Socrata API, filtered for vehicles registered in the Tri-Cities, and saved as a CSV and as a SQLite database.
2. **Exploratory analysis** – Basic statistics and descriptive analyses were performed to understand the distribution of vehicle makes, models, model years and electric ranges.
3. **SQL analysis** – A series of SQL queries were run against the SQLite database to derive insights about electric vehicle adoption in the region.

The detailed methodology, results and interpretations are provided in the report file [`report.md`](report.md).

## Queries

The SQL commands used in the analysis are stored in [`queries.sql`](queries.sql) and summarized here:

- **count_by_city_and_type** – counts the number of battery electric (BEV) and plug-in hybrid (PHEV) vehicles for each city (Kennewick, Pasco, Richland).
- **top_manufacturers** – lists the top manufacturers by the number of registered EVs in the Tri-Cities.
- **average_range_by_make** – calculates the average electric range (in miles) for each vehicle make.
- **distribution_by_model_year** – counts how many EVs fall within each model year, illustrating adoption over time.

## How to run the queries

1. Open the SQLite database file (created during data cleaning) using a SQL client such as SQLite CLI.
2. Copy the SQL commands from `queries.sql` into your client.
3. Execute each query to reproduce the analysis results reported in `report.md`.

## Dataset source

The EV population dataset is provided by the Washington State Department of Licensing and is available on data.wa.gov【75374942803867†L94-L99】. It lists BEVs and PHEVs registered with the state, including fields such as make, model, model year, electric range, location and more.
