/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-3, Part 2
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Queries from part 1. Creating queries from the first part of
 *           the assignment.
 * 
 *======================================================================*/

-- Query 1: Find provinces with small areas in countries with high inflation
-- Using comma joins to find provinces with area <= 50000 in countries with inflation >= 1.8%
-- Results sorted by inflation (highest first), then country code, then area (smallest first)
SELECT country.country_code, country.country_name, country.inflation, province.province_name, province.area
FROM country, province
WHERE country.country_code = province.country_code AND -- make sure same country
    province.area <= 50000 AND                      -- checking province area
    country.inflation >= 1.8                 -- checking inflation
ORDER BY country.inflation DESC, country.country_code ASC, province.area ASC; -- sorting by condition

-- Query 2: Same as Query 1 but using JOIN syntax instead of comma joins
-- Find provinces with small areas in countries with high inflation using explicit JOIN
SELECT c.country_code, c.country_name, c.inflation, p.province_name, p.area
FROM country c JOIN province p USING (country_code)
WHERE p.area <= 50000 AND
    c.inflation >= 1.0
ORDER BY c.inflation DESC, c.country_code ASC, p.area ASC;

-- Query 3: Find unique provinces that have at least one city with population > 500000
-- Using comma joins to connect country, province, and city tables
-- Returns one row per matching province using DISTINCT
SELECT DISTINCT country.country_code, country.country_name, province.province_name, province.area
FROM country, province, city
WHERE country.country_code = province.country_code AND
    province.province_name = city.province_name AND
    province.country_code = city.country_code AND
    city.population > 500000;

-- Query 4: Same as Query 3 but using JOIN syntax instead of comma joins
-- Find unique provinces that have at least one city with population > 500000 using explicit JOINs
SELECT DISTINCT c.country_code, c.country_name, p.province_name, p.area
FROM country c
    JOIN province p ON (c.country_code = p.country_code)
    JOIN city ci ON (p.province_name = ci.province_name AND p.country_code = ci.country_code)
WHERE ci.population > 500000;

-- Query 5: Find provinces with at least two cities having population > 500000
-- Using comma joins with self-join to find provinces with 2+ large cities
SELECT DISTINCT c.country_code, c.country_name, p.province_name, p.area
FROM country c, province p, city ci1, city ci2
WHERE c.country_code = p.country_code AND
    p.province_name = ci1.province_name AND
    p.province_name = ci2.province_name AND
    ci1.city_name <> ci2.city_name AND
    ci1.population > 500000 AND
    ci2.population > 500000;

-- Query 6: Same as Query 5 but using JOIN syntax
-- Find provinces with at least two cities having population > 500000
SELECT DISTINCT c.country_code, c.country_name, p.province_name, p.area
FROM country c
    JOIN province p ON (c.country_code = p.country_code)
    JOIN city ci1 ON (p.province_name = ci1.province_name AND p.country_code = ci1.country_code)
    JOIN city ci2 ON (p.province_name = ci2.province_name AND p.country_code = ci2.country_code)
WHERE ci1.city_name <> ci2.city_name AND
    ci1.population > 500000 AND
    ci2.population > 500000;

-- Query 7: Find unique pairs of different cities with the same population
-- Using JOIN syntax to find cities with same population but different names/provinces/countries
-- Returns 7 attributes: city1_name, city1_province, city1_country, city2_name, city2_province, city2_country, population
SELECT ci1.city_name, ci1.province_name, ci1.country_code,
       ci2.city_name, ci2.province_name, ci2.country_code, ci1.population
FROM city ci1 JOIN city ci2 ON (ci1.population = ci2.population) -- same population
WHERE (ci1.province_name <> ci2.province_name OR
       ci1.city_name <> ci2.city_name OR
       ci1.country_code <> ci2.country_code) AND -- different cities
        (ci1.city_name < ci2.city_name OR -- city name is different
         (ci1.city_name = ci2.city_name AND ci1.province_name < ci2.province_name) OR -- same city name, different province (Portland, ME & Portland, OR)
         (ci1.city_name = ci2.city_name AND ci1.province_name = ci2.province_name AND ci1.country_code < ci2.country_code)) -- Paris, Canada & Paris, France
ORDER BY ci1.population, ci1.city_name, ci2.city_name;

-- Query 8: Find countries with high GDP and low inflation that border countries with low GDP and high inflation
-- Using comma joins to find bordering countries with opposite economic conditions
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1, country c2, border b
WHERE (c1.country_code = b.country_code_1 AND
    c2.country_code = b.country_code_2) AND
    (c1.gdp > 15000 AND c1.inflation < 2.5) AND
    (c2.gdp <= 15000 AND c2.inflation >= 2.5);

-- Query 9: Same as Query 8 but using JOIN syntax
-- Find countries with high GDP and low inflation that border countries with low GDP and high inflation
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1
    JOIN border b ON (c1.country_code = b.country_code_1)
    JOIN country c2 ON (c2.country_code = b.country_code_2)
WHERE (c1.gdp > 15000 AND c1.inflation <= 2.0) AND
    (c2.gdp <= 15000 AND c2.inflation > 2.0);

-- Query 10: Find cities in small provinces of wealthy countries that have high populations.
-- This query identifies major cities in small provinces of high-GDP countries.
SELECT DISTINCT c.country_name, p.province_name, ci.city_name, ci.population, p.area, c.gdp
FROM country c
    JOIN province p ON (c.country_code = p.country_code)
    JOIN city ci ON (p.province_name = ci.province_name AND p.country_code = ci.country_code)
WHERE p.area <= 50000  -- small province area
    AND c.gdp >= 5000  -- high GDP country (lowered to include Thailand)
    AND ci.population >= 1000000  -- high population city
ORDER BY c.gdp DESC, ci.population DESC, p.area ASC;