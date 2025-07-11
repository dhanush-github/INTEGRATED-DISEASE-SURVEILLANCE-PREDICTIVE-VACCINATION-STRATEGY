-- 1. Total cases by district & disease
SELECT dm.district_name, c.disease, SUM(c.cases_reported) AS total_cases
FROM cases_table c
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name, c.disease
ORDER BY total_cases DESC;

-- 2. Incidence rate (cases per 1,000 population)
SELECT dm.district_name,
       SUM(c.cases_reported) AS total_cases,
       p.population,
       ROUND(SUM(c.cases_reported)::NUMERIC / p.population * 1000, 2) AS incidence_rate_per_1k
FROM cases_table c
JOIN district_mapping dm ON c.district_code = dm.district_code
JOIN population_table p ON c.district_code = p.district_code
GROUP BY dm.district_name, p.population
ORDER BY incidence_rate_per_1k DESC;

-- 3. High-risk districts: Low vaccination & high cases
SELECT dm.district_name,
       SUM(c.cases_reported) AS total_cases,
       v.vaccination_coverage
FROM cases_table c
JOIN vaccination_table v ON c.district_code = v.district_code
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name, v.vaccination_coverage
HAVING v.vaccination_coverage < 70 AND SUM(c.cases_reported) > 500
ORDER BY total_cases DESC;

-- 4. Rolling 4-week average cases (example district)
SELECT week,
       AVG(cases_reported) OVER (
         PARTITION BY district_code ORDER BY week ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
       ) AS rolling_avg_cases
FROM cases_table
WHERE district_code = 'D0001'
ORDER BY week;

-- 5. Rainfall correlation with cases
SELECT dm.district_name,
       w.week,
       AVG(w.rainfall_mm) AS avg_rainfall,
       SUM(c.cases_reported) AS total_cases
FROM cases_table c
JOIN weather_table w ON c.district_code = w.district_code AND c.week = w.week
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name, w.week
ORDER BY dm.district_name, w.week;

-- 6. Humidity vs total cases
SELECT dm.district_name,
       AVG(w.humidity) AS avg_humidity,
       SUM(c.cases_reported) AS total_cases
FROM cases_table c
JOIN weather_table w ON c.district_code = w.district_code AND c.week = w.week
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name
ORDER BY avg_humidity DESC;

-- 7. Districts with weekly increase in cases
SELECT district_code,
       week,
       cases_reported,
       cases_reported - LAG(cases_reported) OVER (
         PARTITION BY district_code ORDER BY week
       ) AS weekly_change
FROM cases_table
ORDER BY district_code, week;

-- 8. Total annual cases (if multiple years)
SELECT year,
       SUM(cases_reported) AS total_cases
FROM cases_table
GROUP BY year
ORDER BY year;

-- 9. Rank districts by total cases
SELECT dm.district_name,
       SUM(c.cases_reported) AS total_cases,
       RANK() OVER (ORDER BY SUM(c.cases_reported) DESC) AS severity_rank
FROM cases_table c
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name
ORDER BY severity_rank;

-- 10. Top 5 districts with highest rainfall & high cases
SELECT dm.district_name,
       AVG(w.rainfall_mm) AS avg_rainfall,
       SUM(c.cases_reported) AS total_cases
FROM cases_table c
JOIN weather_table w ON c.district_code = w.district_code AND c.week = w.week
JOIN district_mapping dm ON c.district_code = dm.district_code
GROUP BY dm.district_name
ORDER BY avg_rainfall DESC, total_cases DESC
LIMIT 5;
