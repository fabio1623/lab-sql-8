use sakila;

-- 1. Write a query to display for each store its store ID, city, and country.
SELECT 
    store.store_id, city.city, country.country
FROM
    store
        JOIN
    address USING (address_id)
        JOIN
    city USING (city_id)
        JOIN
    country USING (country_id)
GROUP BY store.store_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
SELECT 
    store.store_id,
    city.city,
    country.country,
    SUM(payment.amount) AS sales
FROM
    store
        JOIN
    address USING (address_id)
        JOIN
    city USING (city_id)
        JOIN
    country USING (country_id)
        JOIN
    staff USING (store_id)
        JOIN
    payment USING (staff_id)
GROUP BY store.store_id;

-- 3. Which film categories are longest?
SELECT 
    category.name, AVG(film.length) AS avg_length
FROM
    category
        JOIN
    film_category USING (category_id)
        JOIN
    film USING (film_id)
GROUP BY category.category_id
ORDER BY avg_length DESC
LIMIT 1;


-- 4. Display the most frequently rented movies in descending order.
SELECT 
    film.title, COUNT(*) AS nb_rentals
FROM
    film
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
GROUP BY film.film_id
ORDER BY nb_rentals DESC;

-- 5. List the top five genres in gross revenue in descending order.
SELECT 
    category.name, SUM(payment.amount) AS gross_revenue
FROM
    category
        JOIN
    film_category USING (category_id)
        JOIN
    inventory USING (film_id)
        JOIN
    rental USING (inventory_id)
        JOIN
    payment USING (rental_id)
GROUP BY category.category_id
ORDER BY gross_revenue DESC
LIMIT 5;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
SELECT 
    film.title, store.store_id, COUNT(*) AS nb_copies
FROM
    film
        JOIN
    inventory USING (film_id)
        JOIN
    store USING (store_id)
WHERE
    film.title = 'Academy Dinosaur'
        AND store.store_id = 1
GROUP BY store.store_id;

-- 7. Get all pairs of actors that worked together.
SELECT 
    CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1,
    CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2,
    film.title
FROM
    film_actor AS fa1
        JOIN
    film_actor AS fa2 ON (fa1.film_id = fa2.film_id)
        AND (fa1.actor_id > fa2.actor_id)
        JOIN
    actor a1 ON (fa1.actor_id = a1.actor_id)
        JOIN
    actor a2 ON (fa2.actor_id = a2.actor_id)
        JOIN
    film ON (fa1.film_id = film.film_id)
ORDER BY fa1.film_id ASC;


-- SELECT 
--     CONCAT(a1.first_name, ' ', a1.last_name) AS actor_1,
--     CONCAT(a2.first_name, ' ', a2.last_name) AS actor_2
-- FROM
--     actor a1
--         JOIN
--     actor a2 ON (a1.actor_id < a2.actor_id)
--         JOIN
--     film_actor ON a1.actor_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.
-- 9. For each film, list actor that has acted in more films.
SELECT 
    film.title,
    CONCAT(actor.first_name, ' ', actor.last_name) AS actor
FROM
    film
        JOIN
    film_actor USING (film_id)
        JOIN
    actor USING (actor_id)
WHERE
    CONCAT(actor.first_name, ' ', actor.last_name) IN (SELECT 
            CONCAT(actor.first_name, ' ', actor.last_name)
        FROM
            actor
                JOIN
            film_actor USING (actor_id)
        GROUP BY actor.actor_id
        HAVING COUNT(*) > 1)
ORDER BY film.title;