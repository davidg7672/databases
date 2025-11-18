/*======================================================================
 * 
 *  NAME:    David Sosa
 *  ASSIGN:  HW-8 Part 2
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    SQL queries with more advanced features. These queries use
 *           aggregate functions, GROUP BY, and HAVING.
 * 
 *======================================================================*/

-- (1)
-- Finds total number of films as well as aggregate functions. Min, max, avg, and count is used here.
SELECT COUNT(*) AS num_films, 
    MIN(f.length) AS min_length, 
    MAX(f.length) AS max_length, 
    ROUND(AVG(f.length), 2) AS avg_length, 
    COUNT(DISTINCT special_features) AS special_features
FROM film f;

-- (2)
-- Finds number of films of each rating along with average length time
SELECT f.rating, COUNT(*) as num_films, ROUND(AVG(f.length), 2) as avg_length
FROM film f
GROUP BY f.rating
ORDER BY avg_length DESC;

-- (3)
-- Finds the total number of films in each category. As well as other statistics, such as min, max, avg.
SELECT c.name, SUM(fc.category_id) AS num_films, MIN(f.rental_rate) AS min_rate, MAX(f.rental_rate) AS max_rate, ROUND(AVG(f.rental_rate), 2) AS avg_rate, MIN(f.replacement_cost) AS min_cost, MAX(f.replacement_cost) AS max_cost, ROUND(AVG(f.replacement_cost), 2) AS avg_cost
FROM film_category fc
    JOIN category c USING (category_id)
    JOIN film f USING (film_id)
GROUP BY c.name
ORDER BY c.name ASC;

-- (4)
-- Finds total rentals of class films for each rating. So the classics of each rating (G - R)
SELECT f.rating, COUNT(*) as num_rentals
FROM film f
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE c.name = 'Classics' AND i.store_id = 1
GROUP BY f.rating
ORDER BY num_rentals DESC;

-- (5)
-- Finds PG-rated horror films that have been rented at least 10 times.
SELECT f.title, COUNT(*) AS num_rentals
FROM film f
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE f.rating = 'PG' AND c.name = 'Horror'
GROUP BY f.title
HAVING COUNT(*) >= 10
ORDER BY num_rentals DESC;

-- (6)
-- Finds actors that have been in least 5 sports films. 
SELECT a.first_name, a.last_name, COUNT(*) AS num_sports_films
FROM actor a
    JOIN film_actor fa USING (actor_id)
    JOIN film f USING (film_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
WHERE c.name = 'Sports'
GROUP BY a.first_name, a.last_name
HAVING COUNT(*) >= 5
ORDER BY num_sports_films DESC, a.last_name, a.first_name;