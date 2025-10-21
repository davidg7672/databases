/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-4, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    SQL queries demonstrating views, UNION, EXCEPT, and set operations.
 *           Creates views for country-city relationships and symmetric border 
 *           closure, then implements queries to find countries meeting various
 *           criteria using these views.
 * 
 *======================================================================*/

-- dropping views if they exist
DROP VIEW IF EXISTS country_city;
DROP VIEW IF EXISTS border_full;

-- practice
-- 1
CREATE VIEW country_city AS
    SELECT c.country_code, c.country_name, ci.city_name, ci.population
    FROM country c JOIN city ci USING (country_code);

-- 2
SELECT DISTINCT c.country_code, c.country_name, c.gdp, c.inflation
FROM country c
    JOIN country_city cc1 USING (country_code)
    JOIN country_city cc2 USING (country_code)
WHERE cc1 <> cc2 AND
    cc1.population > 1500000 AND
    cc2.population > 1500000
ORDER BY c.gdp DESC, c.inflation ASC;

-- 3
CREATE VIEW border_full AS
    SELECT b.country_code_1, b.country_code_2, border_length FROM border b
    UNION
    SELECT b.country_code_2, b.country_code_1, border_length FROM border b;

-- 4
SELECT c1.country_code, c1.country_name
FROM border_full b
    JOIN country c1 ON (b.country_code_1 = c1.country_code)
    JOIN country c2 ON (b.country_code_2 = c2.country_code)
WHERE (c1.gdp > 0.2 AND c1.inflation < 2.0) AND --low inflation & high gdp
    (c2.inflation > 2.0 AND c2.gdp < 0.2); -- high inflation & low gdp

-- 5
SELECT c.country_code, c.country_name, c.inflation 
FROM country c
EXCEPT
SELECT c2.country_code, c2.country_name, c2.inflation
FROM country c2, country c3
WHERE c3.inflation > c2.inflation;

















-- -- View 1
-- -- Purpose: Create a view that joins the country and city tables to return every city 
-- -- along with its country code, country name, city name, and population.
-- CREATE VIEW country_city AS
--     SELECT c.country_code, c.country_name, ci.city_name, population
--     FROM country c JOIN city ci USING (country_code);

-- -- Query 2
-- -- Purpose: Find all countries containing at least two cities with population over 1,500,000.
-- -- Uses self-join on country_city view to pair different cities in the same country.
-- SELECT DISTINCT c.country_code, c.country_name, c.gdp, c.inflation
-- FROM country_city cc1 
--     JOIN country_city cc2 USING (country_code)
--     JOIN country c USING (country_code)
-- WHERE cc1.city_name <> cc2.city_name AND
--     cc1.population > 1500000 AND
--     cc2.population > 1500000
-- ORDER BY c.gdp DESC, c.inflation ASC;

-- -- Query 3
-- -- Purpose: Create a view computing the symmetric closure of the border table.
-- CREATE VIEW border_full AS
--     SELECT country_code_1, country_code_2, border_length FROM border
--     UNION
--     SELECT country_code_2, country_code_1, border_length FROM border;

-- -- Query 4
-- -- Purpose: Find countries with high GDP (>15000) and low inflation (<2.5) that border 
-- -- a country with low GDP (<=15000) and high inflation (>=2.5).
-- SELECT DISTINCT c1.country_code, c1.country_name
-- FROM country c1
--     JOIN border_full b ON (c1.country_code = b.country_code_1)
--     JOIN country c2 ON (c2.country_code = b.country_code_2)
-- WHERE (c1.gdp > 15000 AND c1.inflation < 2.5) AND
--     (c2.gdp <= 15000 AND c2.inflation >=2.5);

-- -- Query 5
-- -- Purpose: Find all countries with the highest inflation value.
-- -- Uses negation pattern: highest inflation countries = countries that don't have non-highest inflation.
-- SELECT c.country_code, c.country_name, c.inflation
-- FROM country c
-- EXCEPT
-- SELECT c2.country_code, c2.country_name, c2.inflation
-- FROM country c2, country c3 
-- WHERE c3.inflation > c2.inflation;
