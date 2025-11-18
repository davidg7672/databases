/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-8
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    These are advanced queries using aggregate functions. These
 *           queries also use GROUP BY and HAVING.
 * 
 *======================================================================*/


-- (1)
-- Finds the average and total population of cities within provinces with a large
-- area as well as low inflation.
SELECT ROUND(AVG(population), 2) AS average, SUM(population) AS total_population
FROM country c 
    JOIN province p ON (c.country_code = p.country_code)
    JOIN city ci ON (ci.province_name = p.province_name)
WHERE p.area > 60000 AND c.inflation < 2.0;

-- (2)
-- Finds total area of a country via the province areas
SELECT c.country_code, SUM(p.area) AS total_area
FROM country c JOIN province p USING (country_code)
GROUP BY c.country_code;

-- (3)
-- Gets the gdp, inflation, and total population of countries
SELECT c.country_code, c.country_name, c.gdp, c.inflation, SUM(ci.population) AS total_population
FROM country c JOIN city ci USING (country_code)
GROUP BY c.country_code;

-- (4)
-- Orders countries by size in terms of amount of cities.
SELECT c.country_code, c.country_name, COUNT(*) AS number_of_cities
FROM country c JOIN city ci USING (country_code)
GROUP BY c.country_code
ORDER BY number_of_cities DESC;

-- (5)
-- Queries number of cites that have a certain gdp with an area of a certain size
SELECT c.country_code, c.gdp, SUM(p.area) as area, COUNT(*) AS number_of_cities
FROM country c
    JOIN province p USING (country_code)
    JOIN city ci USING (country_code)
WHERE c.gdp > 15000
GROUP BY c.country_code
HAVING SUM(p.area) >= 400000
ORDER BY number_of_cities DESC;

