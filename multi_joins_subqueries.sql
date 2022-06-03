SELECT *
FROM actor;

SELECT *
FROM film;


SELECT *
FROM film_actor;


-- Join actor to film actor table
SELECT *
FROM actor 
JOIN film_actor 
ON actor.actor_id = film_actor.actor_id;


-- Join film to film actor table 
SELECT *
FROM film 
JOIN film_actor 
ON film.film_id = film_actor.film_id;


-- Join all together
SELECT *
FROM actor a 
JOIN film_actor fa 
ON a.actor_id = fa.actor_id 
JOIN film f 
ON f.film_id = fa.film_id
ORDER BY f.film_id;



SELECT a.actor_id, a.first_name, a.last_name, f.title 
FROM actor a 
JOIN film_actor fa 
ON a.actor_id = fa.actor_id 
JOIN film f 
ON f.film_id = fa.film_id
WHERE f.rental_duration > 4
ORDER BY f.film_id DESC;



--SELECT 
--FROM 
--JOIN 
--ON 
--WHERE 
--GROUP BY 
--HAVING 
--ORDER BY 
--LIMIT
--OFFSET



-- SUBQUERIES
-- Which film has the most actors in it

-- Step 1. Get the film id of the film with the most actors
SELECT film_id
FROM film_actor
GROUP BY film_id
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Step 2. Get the film from the film_id in step 1
SELECT title 
FROM film 
WHERE film_id = 508;


-- Combine the two queries into a subquery. The query you want to run first is the subquery 
-- *Subquery must return only one column*
SELECT film_id, title 
FROM film 
WHERE film_id = (
	SELECT film_id
	FROM film_actor
	GROUP BY film_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);



--Have subquery RETURN COLUMN WITH multiple rows
SELECT category_id
FROM film_category
GROUP BY category_id 
HAVING COUNT(*) > 60
ORDER BY COUNT(*) DESC;

--15
--9
--8
--6
--2
--1
--13
--7
--14
--10


SELECT *
FROM category c 
WHERE c.category_id IN (
15,
9,
8,
6,
2,
1,
13,
7,
14,
10
)

SELECT *
FROM category c 
WHERE c.category_id IN (
	SELECT category_id
	FROM film_category
	GROUP BY category_id 
	HAVING COUNT(*) > 60
	ORDER BY COUNT(*) DESC
);



-- Use subquery for calculation

-- List all of the payments who have made payments more than the average customer pays
SELECT AVG(amount) FROM payment p 


SELECT *
FROM payment p 
WHERE p.amount > (
	SELECT AVG(amount)
	FROM payment p
);


-- List customers who have more rentals than the average customer 

SELECT AVG(num_rentals)
FROM (
	SELECT r.customer_id, COUNT(*) AS num_rentals
	FROM rental r 
	GROUP BY r.customer_id 
) AS average;

--SELECT r.customer_id, COUNT(*) AS num_rentals
--FROM rental r 
--GROUP BY r.customer_id;
SELECT r.customer_id
FROM rental r 
GROUP BY r.customer_id 
HAVING COUNT(*) > (
	SELECT AVG(num_rentals)
	FROM (
		SELECT r.customer_id, COUNT(*) AS num_rentals
		FROM rental r 
		GROUP BY r.customer_id 
	) AS average
);

SELECT *
FROM customer c 
WHERE c.customer_id IN (
	SELECT r.customer_id
	FROM rental r 
	GROUP BY r.customer_id 
	HAVING COUNT(*) > (
		SELECT AVG(num_rentals)
		FROM (
			SELECT r.customer_id, COUNT(*) AS num_rentals
			FROM rental r 
			GROUP BY r.customer_id 
		) AS average
	)
);



-- Using Subqueries in DML statements

ALTER TABLE customer 
ADD COLUMN loyalty_member BOOLEAN DEFAULT FALSE;

SELECT *
FROM customer;


-- SET all customers who have 25 or more rentals to a loyalty MEMBER 

UPDATE customer
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM rental 
	GROUP BY customer_id
	HAVING COUNT(*) >= 25
);

SELECT *
FROM customer;


SELECT * FROM customer WHERE loyalty_member = TRUE;



SELECT *
FROM customer c 
JOIN rental r 
ON c.customer_id = r.customer_id 
WHERE c.customer_id IN (
	SELECT customer_id
	FROM rental 
	GROUP BY customer_id
	HAVING COUNT(*) >= 25
) 
ORDER BY last_name ;


