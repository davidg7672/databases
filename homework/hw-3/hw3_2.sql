/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-3, Part 2
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Queries from part 1. Creating queries from the first part of
 *           the assignment
 * 
 *======================================================================*/

-- Query 1

SELECT country_code, country_name, inflation, province_name, area
FROM country, province
WHERE country.country_code = province.country_code  -- make sure same country
    AND province.area <= 50000                      -- checking province area
    AND country.inflation >= 2.0                    -- checking inflation
ORDER BY country.inflation DESC, country.country_code ASC, province.area ASC; -- sorting by condition

-- Query 2
SELECT country_code, country_name, inflation, province_name, area
FROM country CROSS JOIN province
WHERE country.country_code = province.country_code  -- make sure same country
    AND province.area <= 50000                      -- checking province area
    AND country.inflation >= 2.0                    -- checking inflation
ORDER BY country.inflation DESC, country.country_code ASC, province.area ASC; -- sorting by condition

-- Query 3
SELECT DISTINCT country.country_code, country.country_name, province.province_name, province.area
FROM country, province, city
WHERE country.country_code = province.country_code
    AND province.province_name = city.province_name
    AND province.country_code = city.country_code
    AND city.population > 500000

-- Query 4
SELECT DISTINCT country.country_code, country.country_name, province.province_name, province.area
FROM country CROSS JOIN province CROSS JOIN city
WHERE country.country_code = province.country_code
    AND province.province_name = city.province_name
    AND province.country_code = city.country_code
    AND city.population > 500000

-- Query 5

-- 