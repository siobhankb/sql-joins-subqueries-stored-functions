--multi joins
--many to many relationship

select * 
from actor;

select *
from film;

--a film can have many actors
--an actor can be in many films
--film_actor is that intermediary table for many-to-many relationships
select * 
from film_actor;

--Use mulit-join to get info from 2 tables with many-to-many link
--join actor table to film_actor table
SELECT *
FROM actor a
JOIN film_actor fa 
ON a.actor_id = fa.actor_id;
--join film table to film_actor table
SELECT *
FROM film_actor
JOIN film
ON film.film_id = film_actor.film_id
ORDER BY film.film_id;

--join the film table to the film_actor table adn then join that to the actor table
SELECT f.film_id, a.actor_id, f.title, f.description, a.actor_id, a.first_name, a.last_name
FROM film f
JOIN film_actor fa 
ON f.film_id = fa.film_id
JOIN actor a 
ON a.actor_id = fa.actor_id
ORDER BY f.film_id;


--add filter with WHERE
SELECT f.film_id, a.actor_id, f.title, f.description, a.actor_id, a.first_name, a.last_name
FROM film f
JOIN film_actor fa 
ON f.film_id = fa.film_id
JOIN actor a 
ON a.actor_id = fa.actor_id
WHERE f.rental_duration > 4
ORDER BY f.film_id;



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


Have subquery RETURN COLUMN WITH multiple rows
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
);





--Turn above into subquery
SELECT *
FROM category
WHERE category_id in(
	SELECT category_id FROM film_category
	GROUP BY category_id
	HAVING count(*) > 60
	ORDER BY count(*) DESC 
);


--use subquery for calculation

--list all of the payments that are more than the avg customer pay
SELECT avg(amount)
FROM payment;

SELECT *
FROM payment
WHERE amount > (
	SELECT avg(amount)
	FROM payment
);
--Nice to have this as a subquery because average will change as new payments come in
-- real life example - maybe want to send coupons to customers who spend above the average
--eventually we'll learn how to save this query/calc to reference it later...


--Subqueries with FROM clause

--List customers who have more rentals than the average customer
--figure out avg # rentals

--get customer rental counts:
SELECT customer_id, count(*) AS num_rentals
FROM rental
GROUP BY customer_id;
--put ^^^ into subquery to get the average of all those

--find the average from the customer rental counts
--subquery in FROM *MUST* have an alias
SELECT avg(num_rentals)
FROM (
	SELECT customer_id, count(*) AS num_rentals
	FROM rental
	GROUP BY customer_id 
) AS customer_rental_counts;

--find the customers by ID who have more rentals than the avg
SELECT customer_id, count(*) AS num_rentals
FROM rental
GROUP BY customer_id
HAVING count(*) > (
	SELECT avg(num_rentals)
	FROM (
		SELECT customer_id, count(*) AS num_rentals
		FROM rental
		GROUP BY customer_id
	) AS customer_rental_counts
);

--list the customer names who have more rentals than average using teh customer ids from prev query
SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id in(
	SELECT customer_id --gotta GET rid OF 2nd COLUMN OR ELSE error
	FROM rental
	GROUP BY customer_id
	HAVING count(*) > (
		SELECT avg(num_rentals)
		FROM (
			SELECT customer_id, count(*) AS num_rentals
			FROM rental
			GROUP BY customer_id
		) AS customer_rental_counts
	)
)
ORDER BY customer_id;



--Use subqueries in DML 
SELECT *
FROM customer;

ALTER TABLE customer 
ADD COLUMN loyalty_member BOOLEAN DEFAULT FALSE;
--**this column was already here...**--

UPDATE customer SET loyalty_member = FALSE;

SELECT *
FROM customer;

--set all customers who have made 25 or more rentals a loyalty MEMBER 

--step1: Find all customers who have made more than 25 rentals
SELECT customer_id, count(*) AS number_of_rentals
FROM rental
GROUP BY customer_id 
HAVING count(*) > 25;

--step2: update the customer table and set loyalty_member = True 
--         if the customer is in the list of customers over 25 rentals

UPDATE customer
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id -- GET rid OF count COLUMN bc FROM subquery can ONLY have 1 column
	FROM rental
	GROUP BY customer_id 
	HAVING count(*) > 25
);

SELECT first_name, last_name, loyalty_member
FROM customer
ORDER BY customer_id;


--combine JOIN with subquery
-- get all the info on customers who have rented more than 25

SELECT c.customer_id, first_name, last_name, rental_id, rental_date
FROM customer c
JOIN rental r 
ON c.customer_id = r.customer_id
ORDER BY c.customer_id;

--only get the ones w more than 25 rentals
SELECT c.customer_id, first_name, last_name, rental_id, rental_date
FROM customer c
JOIN rental r 
ON c.customer_id = r.customer_id
WHERE c.customer_id IN (
	SELECT customer_id -- GET rid OF count COLUMN bc FROM subquery can ONLY have 1 column
	FROM rental
	GROUP BY customer_id 
	HAVING count(*) > 25
)
ORDER BY c.customer_id;


-- and if you just wanted a list of names with their rental counts
--    for customers who have more than 25 rentals?

--*v*v*v*WRONG*v*v*v*--

--fix later?--
SELECT first_name, last_name, customer_id, count(*)
FROM customer c
GROUP BY customer_id
WHERE c.customer_id IN (
	SELECT c.customer_id, first_name, last_name, rental_id, rental_date
	FROM customer c
	JOIN rental r 
	ON c.customer_id = r.customer_id
	WHERE c.customer_id IN (
		SELECT customer_id -- GET rid OF count COLUMN bc FROM subquery can ONLY have 1 column
		FROM rental
		GROUP BY customer_id 
		HAVING count(*) > 25
	)
)
ORDER BY c.customer_id;
--*^*^*^WRONG^*^*^*--




