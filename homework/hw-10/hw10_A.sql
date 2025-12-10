/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-10, Part A
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Advanced SQL Queries
 * 
 *======================================================================*/

-- (1)
-- Find actors that haven't acted in a PG-rated film using outer join
SELECT DISTINCT
    a.actor_id,
    a.first_name,
    a.last_name
FROM actor a
    LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
    LEFT JOIN film f ON fa.film_id = f.film_id AND f.rating = 'PG'
WHERE f.film_id IS NULL;

-- (2)
-- Finds films and determines if they're short, feature, or featurette
SELECT
    f.film_id,
    f.title,
    f.rating,
    f.length,
    CASE
        WHEN f.length >= 80 THEN 'feature'
        WHEN f.length <= 50 THEN 'short'
        ELSE 'featurette'
    END AS type
FROM film f;

-- (3)
-- Ranks films by rating and by length. Orders from lowest rating then length
SELECT
    f.film_id,
    f.title,
    f.rating,
    f.length,
    ROW_NUMBER() OVER (PARTITION BY f.rating ORDER BY f.length) AS rank
FROM film f;

-- (4)
-- CTE to find all actor, category, and inventory updates for Action films
WITH film_update AS (
    -- finding unique values for update, using union
    SELECT DISTINCT
        film_id,
        'actor' AS update_type,
        last_update AS update_date
    FROM film_actor
    UNION
    SELECT DISTINCT
        film_id,
        'category' AS update_type,
        last_update AS update_date
    FROM film_category
    UNION
    SELECT DISTINCT
        film_id,
        'inventory' AS update_type,
        last_update AS update_date
    FROM inventory
)
-- selecting the unique updates
SELECT DISTINCT
    f.title,
    fu.film_id,
    fu.update_type,
    fu.update_date
FROM film_update fu
    JOIN film f USING (film_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
WHERE c.name = 'Action'
ORDER BY f.title, fu.update_date;
