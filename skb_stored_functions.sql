SELECT * FROM actor;

--get all the actors with last name starts w B
SELECT count(*)
FROM actor
WHERE last_name LIKE 'B%';

SELECT count(*)
FROM actor
WHERE last_name LIKE 'H%';

--OR we can store this function to return last names beginning with letter, X
CREATE [ OR REPLACE ] FUNCTION
    name ( [ [ argmode ] [ argname ] argtype [ { DEFAULT | = } default_expr ] [, ...] ] )
    [ RETURNS rettype
      | RETURNS TABLE ( column_name column_type [, ...] ) ]
  { LANGUAGE lang_name
--    | TRANSFORM { FOR TYPE type_name } [, ... ]
--    | WINDOW
--    | { IMMUTABLE | STABLE | VOLATILE }
--    | [ NOT ] LEAKPROOF
--    | { CALLED ON NULL INPUT | RETURNS NULL ON NULL INPUT | STRICT }
--    | { [ EXTERNAL ] SECURITY INVOKER | [ EXTERNAL ] SECURITY DEFINER }
--    | PARALLEL { UNSAFE | RESTRICTED | SAFE }
--    | COST execution_cost
--    | ROWS result_rows
--    | SUPPORT support_function
--    | SET configuration_parameter { TO value | = value | FROM CURRENT }
    | AS 'definition' <- this IS the FUNCTION - put it IN quotations AS a string
    | AS 'obj_file', 'link_symbol'
    | sql_body
  } ...
  
  
  
  --create a stored function to give us the count of actors whose last name starts with *letter*
CREATE FUNCTION last_letter_count (letter VARCHAR(1))
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
	DECLARE actor_count INTEGER;
BEGIN 
	SELECT count(*) INTO actor_count -- this IS how we RETURN the value(we declared this variable as the result of this action)
FROM actor
WHERE last_name LIKE concat(letter, '%');

RETURN actor_count;
END;
$$

--Execute function
SELECT last_letter_count('F');


--create a function that will return the employee with the most transactions
--  (we'll use the payment table; confusion abt info from payment or rental table)

--from the other day:
SELECT staff_id, count(*)
FROM payment p
GROUP BY staff_id
ORDER BY count(*) DESC 
LIMIT 1; -- this limits TO the TOP only



SELECT concat(first_name, ' ', last_name) AS employee
FROM staff
WHERE staff_id = (
	SELECT staff_id 
	FROM payment p
	GROUP BY staff_id 
	ORDER BY count(*) DESC 
	LIMIT 1
);

--Now turn this into a function

CREATE FUNCTION employee_with_most_transations()
RETURNS VARCHAR(100)
LANGUAGE plpgsql
AS $$
	DECLARE employee VARCHAR (100);
BEGIN
	SELECT concat(first_name, ' ', last_name) INTO employee --CHANGE INTO so that the RESULT gets saved AS the variable we want TO return
	FROM staff
	WHERE staff_id = (
		SELECT staff_id 
		FROM payment p
		GROUP BY staff_id 
		ORDER BY count(*) DESC 
		LIMIT 1
	);
END 
$$

--run function
SELECT employee_with_most_transactions();


--Functions can return TABLES

--create a function that will return a table 
--	with customers and their 
--	full address (address, city, district, country) by country

CREATE OR REPLACE FUNCTION who_in_that_country(country_name VARCHAR(50))
RETURNS TABLE (
	first_name VARCHAR,
	last_name VARCHAR,
	address VARCHAR,
	city VARCHAR,
	district VARCHAR,
	country VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
	RETURN QUERY
	SELECT c.first_name, c.last_name, a.address, ci.city, a.district, co.country
	FROM customer c
	JOIN address a
	ON c.address_id = a.address_id
	JOIN city ci 
	ON a.city_id = ci.city_id 
	JOIN country co 
	ON ci.country_id = co.country_id
	WHERE co.country = country_name;
END; 
$$


SELECT *
FROM who_in_that_country('China');

SELECT *
FROM who_in_that_country('United States')
WHERE district = 'California';

--to delete a function
--use DROP <FUNCTION> <function_name>
DROP FUNCTION last_letter_count;

--now that it's gone, you'll get an error, so
DROP FUNCTION IF EXISTS last_letter_count;



