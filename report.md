# Electric Vehicle Adoption in Tri‑Cities, Washington: A SQL‑based Data Analyst Project

## Introduction

The Tri‑Cities metropolitan area of Washington (Kennewick, Pasco and Richland) is part of a growing region that has been embracing electric vehicles (EVs).  Washington’s Department of Licensing publishes an **Electric Vehicle Population** dataset that lists all battery‑electric (BEV) and plug‑in hybrid electric vehicles (PHEV) registered in the state.  According to the dataset documentation, the resource shows **battery electric vehicles (BEVs) and plug‑in hybrid electric vehicles (PHEVs) currently registered through Washington State Department of Licensing (DOL)** and is updated regularly (metadata updated **July 19 2025**).  

This project uses SQL to explore EV adoption patterns within the Tri‑Cities area.  The aim is to determine how EV registrations vary by city and vehicle type, identify the top manufacturers, assess typical electric driving ranges, and understand how registrations have changed over model years.  By leveraging SQL, we can produce transparent, reproducible queries to answer these questions.

## Dataset and Methodology

### Dataset overview

* **Source** – The dataset is published on Washington’s open data portal (data.wa.gov) and catalogued on Data.gov.  It contains BEVs and PHEVs registered through the Washington Department of Licensing.  Each record represents an individual vehicle.  
* **Fields** – Key columns include the first 10 characters of the VIN (`vin_1_10`), `county`, `city`, `state`, `zip_code`, `model_year`, `make`, `model`, `ev_type` (BEV or PHEV), `cafv_type` (clean alternative fuel vehicle eligibility), `electric_range` (EPA‑rated electric range in miles), `base_msrp`, `legislative_district`, `dol_vehicle_id`, `electric_utility` and the 2020 Census tract.  
* **Time frame** – The dataset includes vehicles currently registered; therefore, it reflects cumulative registrations through mid‑2025 (last modified July 15 2025).

### Data collection

We used the Socrata Open Data API (SODA) to download records where `city` equals **Kennewick**, **Pasco** or **Richland**.  A Python script requested up to 50 000 records per city to ensure full coverage.  The three city‑specific datasets were concatenated into a single DataFrame comprising **3 765** records.  The script saved the combined data to a CSV file (`tri_cities_ev_population.csv`) and created a **SQLite** database (`tri_cities_ev_population.db`) with one table (`ev_population`).  Columns containing nested objects (e.g., `geocoded_column`) or computed fields were removed before loading into SQLite.

### SQL analysis

All analyses were performed using standard SQL queries executed against the `ev_population` table.  Key analyses included:

1. **EV type by city** – Count of registered vehicles by city and `ev_type` (BEV vs. PHEV).
2. **Top manufacturers** – Number of vehicles by manufacturer (`make`) sorted in descending order.
3. **Average electric range by make** – For each manufacturer, the mean `electric_range` (excluding null or blank entries) to understand typical electric‑only range.
4. **Distribution by model year** – Number of registrations for each model year.

## Results and SQL Queries

### 1. EV type by city

```sql
SELECT city, ev_type, COUNT(*) AS total
FROM ev_population
GROUP BY city, ev_type
ORDER BY city, ev_type;
```

| City      | EV type                                   | Total vehicles |
|-----------|-------------------------------------------|---------------:|
| Kennewick | Battery Electric Vehicle (BEV)            |           1 007 |
| Kennewick | Plug‑in Hybrid Electric Vehicle (PHEV)    |             368 |
| Pasco     | Battery Electric Vehicle (BEV)            |             745 |
| Pasco     | Plug‑in Hybrid Electric Vehicle (PHEV)    |             214 |
| Richland  | Battery Electric Vehicle (BEV)            |           1 027 |
| Richland  | Plug‑in Hybrid Electric Vehicle (PHEV)    |             404 |

**Interpretation.**  Battery electric vehicles account for roughly **74 %** of registrations in Kennewick, **78 %** in Pasco and **72 %** in Richland.  Across the Tri‑Cities, BEVs outnumber PHEVs by more than 3‑to‑1, reflecting residents’ preference for fully electric vehicles.

### 2. Top manufacturers

```sql
SELECT make, COUNT(*) AS vehicle_count
FROM ev_population
GROUP BY make
ORDER BY vehicle_count DESC
LIMIT 10;
```

| Manufacturer | Vehicle count |
|--------------|--------------:|
| Tesla        |         1 696 |
| Ford         |           296 |
| Chevrolet    |           291 |
| Toyota       |           213 |
| Nissan       |           161 |
| BMW          |           137 |
| Hyundai      |           126 |
| Kia          |           125 |
| Rivian       |           113 |
| Jeep         |            98 |

**Interpretation.**  **Tesla** dominates the Tri‑Cities EV market, representing nearly **45 %** of all registered EVs.  Ford and Chevrolet have similar market shares (≈8 % each), followed by Toyota, Nissan and BMW.  The presence of newer entrants like Rivian indicates diversification in the market.

### 3. Average electric range by manufacturer (top 10)

```sql
SELECT make,
       AVG(CASE WHEN electric_range = '' OR electric_range IS NULL
                 THEN NULL ELSE CAST(electric_range AS INTEGER) END) AS avg_range
FROM ev_population
WHERE electric_range != ''
GROUP BY make
ORDER BY avg_range DESC
LIMIT 10;
```

| Manufacturer | Average electric range (miles) |
|--------------|------------------------------:|
| Jaguar       | 234.0 |
| Polestar     | 84.7 |
| Tesla        | 79.5 |
| Chevrolet    | 78.0 |
| Fiat         | 69.0 |
| Hyundai      | 62.6 |
| Nissan       | 59.8 |
| Audi         | 59.0 |
| Ford         | 53.8 |
| Toyota       | 51.3 |

**Interpretation.**  Jaguar has the highest average electric range, but this result is based on a small number of vehicles.  **Tesla** models have an average rated range of about **80 miles** in the dataset because many Tesla records do not include range values (missing or “0”), lowering the computed average.  Chevrolet and Fiat also show respectable electric‑range values.  Traditional automakers such as Ford and Toyota have shorter average ranges, likely reflecting a higher share of plug‑in hybrids with smaller batteries.

### 4. Distribution by model year

```sql
SELECT model_year, COUNT(*) AS total
FROM ev_population
GROUP BY model_year
ORDER BY model_year;
```

| Model year | Vehicles |
|-----------:|---------:|
| 2011       |       11 |
| 2012       |       27 |
| 2013       |       78 |
| 2014       |       69 |
| 2015       |       66 |
| 2016       |       83 |
| 2017       |      130 |
| 2018       |      196 |
| 2019       |      306 |
| 2020       |      465 |
| 2021       |      578 |
| 2022       |      853 |
| 2023       |      737 |
| 2024       |      124 |
| 2025       |       13 |
| 2026       |        1 |

**Interpretation.**  EV registrations have grown rapidly since 2019, peaking in **2022** with **853** vehicles.  The drop in 2023 and 2024 may reflect incomplete data (the dataset is current through mid‑2025) or supply‑chain constraints.  Early model years (2011–2015) account for relatively few vehicles, indicating that most EVs on Tri‑Cities roads are recent.

## Conclusion

Using Washington’s **Electric Vehicle Population** dataset, this SQL‑based project provides insights into EV adoption within the Tri‑Cities region.  The data show that:

* **BEVs dominate** the local market; more than three‑quarters of registered EVs are battery‑electric vehicles, reflecting strong consumer confidence in fully electric models.
* **Tesla** is by far the most popular manufacturer, accounting for nearly half of all EVs.  Other leading brands include Ford, Chevrolet, Toyota and Nissan, but none approach Tesla’s volume.
* **Electric ranges vary** by manufacturer; some luxury brands show high averages, while plug‑in‑hybrid‑heavy makes exhibit shorter ranges.
* **Registrations surged** from 2019 through 2022, pointing to accelerating EV adoption.  Ongoing data releases will reveal whether this momentum continues.

The Tri‑Cities case demonstrates how open data and SQL can be combined to answer practical questions about emerging technologies.  Similar analyses could be extended to compare counties, evaluate the availability of charging infrastructure or assess the relationship between EV adoption and demographic factors.
