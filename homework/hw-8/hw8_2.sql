-- (1)
SELECT
    COUNT(*) AS num_films,
    MIN(f.length) AS min_length,
    MAX(f.length) AS max_length,
    ROUND(AVG(f.length), 2) AS avg_length,
    COUNT(DISTINCT special_features) AS special_features
FROM film f;

-- (2)
SELECT 
    f.rating,
    COUNT(*) AS num_films,
    ROUND(AVG(f.length), 2) AS avg_length
FROM film f
GROUP BY f.rating
ORDER BY avg_length DESC;

-- (3)
-- SELECT 
--     c.name,
--     COUNT(*) AS num_films,
--     MIN(f.rental_rate) AS min_rate,
--     MAX(f.rental_rate) AS max_rate,
--     AVG(f.rental_rate) AS avg_rate,
--     MIN(f.replacement_cost) AS min_cost,
--     MAX(f.replacement_cost) AS max_cost,
--     AVG(f.replacement_cost) AS avg_cost
-- FROM film_category fc
--     JOIN category c USING (category_id)
--     JOIN film f USING (film_id)
-- GROUP BY c.name
-- ORDER BY c.name ASC;

-- (4)
SELECT
    f.rating,
    COUNT(*) as num_rentals
FROM film_category fc
    JOIN film f USING (film_id)
    JOIN category c USING (category_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE i.store_id = 1 AND c.name = 'Classics'
GROUP BY f.rating
ORDER BY num_rentals DESC;

-- (5)
SELECT
    f.title,
    COUNT(*) AS num_rentals
FROM film_category fc
    JOIN film f USING (film_id)
    JOIN category c USING (category_id)
    JOIN inventory i USING (film_id)
    JOIN rental r USING (inventory_id)
WHERE c.name = 'Horror' AND f.rating = 'PG'
GROUP BY f.title
HAVING COUNT(*) >= 10
ORDER BY num_rentals DESC;

-- (6)
SELECT
    a.first_name,
    a.last_name,
    COUNT(*) AS num_sports_films
FROM film_actor fa
    JOIN film f USING (film_id)
    JOIN actor a USING (actor_id)
    JOIN film_category fc USING (film_id)
    JOIN category c USING (category_id)
WHERE c.name = 'Sports'
GROUP BY a.first_name, a.last_name
HAVING COUNT(*) >= 5
ORDER BY num_sports_films DESC;