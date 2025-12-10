/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-9
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    SQL queries demonstrating subqueries and advanced filtering
 * 
 *======================================================================*/

-- (1)
-- Find films that are the longest in length with above average replacement cost
SELECT 
    film_id,
    title,
    length,
    replacement_cost
FROM film
WHERE length = (SELECT MAX(length) FROM film) AND 
    replacement_cost > (SELECT AVG(replacement_cost) FROM film);

-- (2)
-- Find the longest PG-13 rated film
SELECT
    film_id,
    title,
    length
FROM film
WHERE rating = 'PG-13' AND
    length = (SELECT MAX(length) FROM film WHERE rating = 'PG-13');

-- (3)
-- Find G-rated action films that have been rented at least 15 times
SELECT
    f.film_id,
    f.title,
    COUNT(*) AS num_rentals
FROM film_category fc
    JOIN film f USING (film_id)
    JOIN category c USING (category_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE f.rating = 'G' AND
    c.name = 'Action'
GROUP BY f.film_id, f.title
HAVING COUNT(*) >= 15
ORDER BY num_rentals DESC, f.title ASC;

-- (4)
-- Find actors that are in at least 4 horror films.
SELECT
    COUNT(*) AS num_appearance,
    a.actor_id,
    a.last_name,
    a.first_name
FROM film_actor fa
    JOIN film f USING (film_id)
    JOIN actor a USING (actor_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
WHERE c.name = 'Horror'
GROUP BY a.actor_id, a.last_name, a.first_name
HAVING COUNT(*) >= 4
ORDER BY num_appearance DESC;

-- (5)
-- Find the category (or categories) with the most PG-rated films
SELECT c.name, COUNT(*) AS num_pg_films
FROM category c
    JOIN film_category fc USING (category_id)
    JOIN film f USING (film_id)
WHERE f.rating = 'PG'
GROUP BY c.name
HAVING COUNT(*) = (
    SELECT MAX(pg_count)
    FROM (
        SELECT COUNT(*) AS pg_count
        FROM category c2
            JOIN film_category fc2 USING (category_id)
            JOIN film f2 USING (film_id)
        WHERE f2.rating = 'PG'
        GROUP BY c2.category_id
    ) AS counts
);

-- (6)
-- Find PG-rated films rented more than the average for PG films
SELECT f.title, COUNT(*) AS num_rentals
FROM film f
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE f.rating = 'PG'
GROUP BY f.title
HAVING COUNT(*) > (
    SELECT AVG(rental_count)
    FROM (
        SELECT COUNT(*) AS rental_count
        FROM film f2
            JOIN inventory i2 ON f2.film_id = i2.film_id
            JOIN rental r2 ON i2.inventory_id = r2.inventory_id
        WHERE f2.rating = 'PG'
        GROUP BY f2.film_id
    ) AS pg_rentals
)
ORDER BY num_rentals DESC;

-- (7)
-- Find actors that have NOT acted in a PG-rated film
SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
WHERE NOT EXISTS (
    SELECT 1
    FROM film_actor fa
        JOIN film f USING (film_id)
    WHERE fa.actor_id = a.actor_id
      AND f.rating = 'PG'
);

-- (8)
-- Find films that are in ALL stores' inventories
SELECT f.film_id, f.title
FROM film f
    JOIN inventory i USING (film_id)
GROUP BY f.film_id, f.title
HAVING COUNT(DISTINCT i.store_id) = (SELECT COUNT(*) FROM store);