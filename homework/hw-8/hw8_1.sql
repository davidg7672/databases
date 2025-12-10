/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-8
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    These are advanced queries using aggregate functions. These
 *           queries also use GROUP BY and HAVING.
 * 
 *======================================================================*/

-- 1
SELECT ROUND(AVG(population),2) as average_population, SUM(population) as total_population
FROM country c
    JOIN province p ON (c.country_code = p.country_code)
    JOIN city ci ON (ci.province_name = p.province_name)
WHERE c.inflation <= 1.8 AND p.area > 60000

-- 2
SELECT c.country_code, SUM(p.area) as total_area
FROM country c JOIN province p USING (country_code)
GROUP BY c.country_code;

-- 3 
SELECT c.country_code, c.country_name, c.gdp, c.inflation, SUM(ci.population) as total_population
FROM country c JOIN city ci USING (country_code)
GROUP BY c.country_code, c.country_name, c.gdp, c.inflation;

-- 4
SELECT c.country_code, c.country_name, COUNT(*) as num_cities
FROM country c JOIN city ci USING (country_code)
GROUP BY c.country_code, c.country_name
ORDER BY num_cities DESC;

-- 5
SELECT c.country_code, c.gdp, SUM(p.area) as area, COUNT(*) as num_cities
FROM country c
    JOIN province p USING (country_code)
    JOIN city ci USING (country_code)
WHERE c.gdp > 15000
GROUP BY c.country code, c.gdp
HAVING SUM(p.area) >= 400000
ORDER BY num_cities DESC;