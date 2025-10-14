/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-4, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Queries using Views, as well as other methods
 * 
 *======================================================================*/


-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement each query as per the homework instructions.
--   * Provide comments for each query as described in the homework instructions.

-- dropping views
DROP VIEW IF EXISTS country_city;
DROP VIEW IF EXISTS border_full;

-- Query 1
-- Creating a view that returns every city along with their country and country code
CREATE VIEW country_city AS
    SELECT c.country_code, c.country_name, ci.city_name, population
    FROM country c JOIN city ci USING (country_code);

-- Query 2
-- 
SELECT DISTINCT c.country_code, c.country_name, c.gdp, c.inflation
FROM country_city cc1 
    JOIN country_city cc2 USING (country_code)
    JOIN country c USING (country_code)
WHERE cc1.city_name <> cc2.city_name AND
    cc1.population > 1500000 AND
    cc2.population > 1500000
ORDER BY c.gdp DESC, c.inflation ASC;

-- Query 3
CREATE VIEW border_full AS
    SELECT country_code_1, country_code_2, border_length FROM border
    UNION
    SELECT country_code_2, country_code_1, border_length FROM border;

-- Query 4
SELECT DISTINCT c1.country_code, c1.country_name
FROM country c1
    JOIN border_full b ON (c1.country_code = b.country_code_1)
    JOIN country c2 ON (c2.country_code = b.country_code_2)
WHERE (c1.gdp > 15000 AND c1.inflation < 2.5) AND
    (c2.gdp <= 15000 AND c2.inflation >=2.5);

-- Query 5
-- Find countries with the highest inflation using the negation pattern.
-- The hint: countries with highest inflation are countries that don't have non-highest inflation.
-- Strategy: Start with all countries, then EXCEPT (remove) countries that have some other
-- country with higher inflation. What remains are the countries with maximum inflation.
SELECT c.country_code, c.country_name, c.inflation -- attributes
FROM country c -- from country
EXCEPT -- disqualifying countries
SELECT c2.country_code, c2.country_name, c2.inflation -- this query returns the lowest economies
FROM country c2, country c3 
WHERE c3.inflation > c2.inflation;
