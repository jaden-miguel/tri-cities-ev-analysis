-- SQL queries used in the Tri-Cities EV analysis project

-- 1. EV type by city: count of registered vehicles by city and vehicle type (BEV vs PHEV)
SELECT city, ev_type, COUNT(*) AS total
FROM ev_population
GROUP BY city, ev_type
ORDER BY city, ev_type;

-- 2. Top manufacturers: count of vehicles by make, in descending order
SELECT make, COUNT(*) AS vehicle_count
FROM ev_population
GROUP BY make
ORDER BY vehicle_count DESC
LIMIT 10;

-- 3. Average electric range by manufacturer: mean electric_range for each make, excluding blank values
SELECT make,
       AVG(CASE WHEN electric_range = '' OR electric_range IS NULL
                 THEN NULL ELSE CAST(electric_range AS INTEGER) END) AS avg_range
FROM ev_population
WHERE electric_range != ''
GROUP BY make
ORDER BY avg_range DESC
LIMIT 10;

-- 4. Distribution by model year: count of registrations for each model year
SELECT model_year, COUNT(*) AS total
FROM ev_population
GROUP BY model_year
ORDER BY model_year;
