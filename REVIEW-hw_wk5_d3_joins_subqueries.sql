--1. List all customers who live in Texas (use JOINs)
SELECT c.customer_id, c.address_id, c.first_name, c.last_name, a.address, a.district
FROM customer c
JOIN address a
ON c.address_id = a.address_id
WHERE district = 'Texas'
ORDER BY c.customer_id;


--2. Get all payments above $6.99 with the Customer’s full name
SELECT c.last_name, c.first_name, p.amount
FROM payment p
JOIN customer c 
ON p.customer_id = c.customer_id 
WHERE p.amount > 6.99
ORDER BY c.last_name;


--3. Show all customer names who have made payments over $175 (use subqueries)
--In Class -- Brian used SUM, as in people who've spent an aggregated amount > 175
SELECT *
FROM customer 
WHERE customer_id IN (
	SELECT customer_id 
	FROM payment
	GROUP BY customer_id 
	HAVING sum(amount) > 175
);


	--this gets all the rows where amount > 175
SELECT c.customer_id, c.last_name, c.first_name, p.payment_id, p.amount
FROM customer c 
JOIN payment p 
ON c.customer_id = p.customer_id
WHERE p.amount > 175
ORDER BY p.payment_id DESC;

	--this shows the 3 names of people who made payments over $175
SELECT c.last_name, c.first_name
FROM customer c 
WHERE c.customer_id in (
	SELECT p.customer_id
	FROM payment p 
	WHERE amount > 175
	ORDER BY amount
);


--4. List all customers that live in Argentina (use the city table)
--customer TABLE -> address_id -> address TABLE
	--address TABLE -> city_id -> city TABLE
		-- city TABLE -> country_id -> country TABLE
			-- country = 'Argentina'

SELECT customer_id, last_name, first_name
FROM customer
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE country_id IN (
			SELECT country_id
			FROM country
			WHERE country = 'Argentina'
		)
	)
);


--Brian's solution, using JOIN
SELECT * 
FROM customer c
JOIN address a 
ON c.address_id= a.address_id 
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id
WHERE country = 'Argentina';


--5. Which film category has the most movies in it?
--Answer: SPORTS
SELECT name
FROM category
WHERE category_id = (
	SELECT category_id
	FROM film_category fc
	GROUP BY fc.category_id
	ORDER BY count(*) DESC
	LIMIT 1
);

--to also show count, use join:
--There are 74 SPORTS movies
SELECT c.name, count(*)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
WHERE fc.category_id = (
	SELECT category_id
	FROM film_category fc
	GROUP BY fc.category_id
	ORDER BY count(*) DESC
	LIMIT 1
)
GROUP BY c.name;


--6. What film had the most actors in it?
--Answer: Lambs Cincinatti had 16 actors in it
SELECT film.film_id, film.title, count(*)
FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id 
WHERE film.film_id IN (
	SELECT film_id
	FROM film_actor fa
	GROUP BY film_id
	ORDER BY count(*) DESC
	LIMIT 1	
	)
GROUP BY film.film_id;

--Brian's solution:
SELECT f.film_id, f.title, count(*)
FROM film_actor fa
JOIN film f
ON f.film_id = fa.film_id 
GROUP BY f.film_id
ORDER BY count(*) DESC
LIMIT 1;

--7a. Which actor has been in the least movies?
--Answer: Emily Dee has been in 14 movies
SELECT a.first_name, a.last_name, count(*)
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE a.actor_id IN (
	SELECT fa.actor_id
	FROM film_actor fa
	GROUP BY fa.actor_id
	ORDER BY count(*)
	LIMIT 1
)
GROUP BY a.actor_id;

--7b. Which actor has been in the most movies?
--Answer: Gina Degeneres was in 42 movies
SELECT a.first_name, a.last_name, count(*)
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE a.actor_id IN (
	SELECT fa.actor_id
	FROM film_actor fa
	GROUP BY fa.actor_id
	ORDER BY count(*) DESC
	LIMIT 1
)
GROUP BY a.actor_id;


--8. Which country has the most cities?
--Answer: India has the most cities - 60
SELECT c.country, count(*)
FROM country c
JOIN city cy
ON c.country_id = cy.country_id
WHERE c.country_id IN (
	SELECT cy.country_id
	FROM city cy
	GROUP BY cy.country_id
	ORDER BY count(*) DESC
	LIMIT 1
	)
GROUP BY c.country;

--Brian's solution:
SELECT c.country, count(*)
FROM country c
JOIN city cy
ON c.country_id = cy.country_id
GROUP BY cy.country_id, c.country_id
ORDER BY count(*) DESC;


--9. List the actors who have been in more than 3 films but less than 6.
--Answer: 0 actors have been in fewer than 14 movies

SELECT actor_id, count(*) AS actor_num
FROM film_actor
GROUP BY actor_id
HAVING count(*) > 3
ORDER BY actor_num;
--returns actor_id 148 (Emily Dee) has been in 14 movies, the least number of movies from all actors in table
--(see answer to question 7a)

--MODIFIED-9. List the actors who have been in more than 20 films but less than 30.
SELECT a.first_name, a.last_name, count(*)
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id
WHERE a. actor_id IN (
	SELECT fa.actor_id
	FROM film_actor fa
	GROUP BY fa.actor_id
	HAVING count(*) > 20 AND count(*) < 30
)
GROUP BY a.actor_id
ORDER BY count(*);


--Brian's solution:
SELECT *
FROM actor a
WHERE a. actor_id IN (
	SELECT fa.actor_id
	FROM film_actor fa
	GROUP BY fa.actor_id
	HAVING count(*) > 20 AND count(*) < 30
);
