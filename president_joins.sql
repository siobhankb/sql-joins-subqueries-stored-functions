-- Customer Table
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	address VARCHAR(100),
	city VARCHAR(20),
	customer_state VARCHAR(2),
	zipcode VARCHAR(5)
);

SELECT *
FROM customer;


-- Order Table 
CREATE TABLE order_(
	order_id SERIAL PRIMARY KEY,
	order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	amount NUMERIC(5,2),
	customer_id INTEGER,
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);


SELECT *
FROM order_;


-- Add data to each table
INSERT INTO customer(first_name, last_name, email, address, city, customer_state, zipcode)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA', '87522'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA', '43592'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA', '34532'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA', '43538'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL', '60623');

SELECT *
FROM customer;


INSERT INTO order_(amount, customer_id)
VALUES(22.55, 1);

INSERT INTO order_(amount, customer_id)
VALUES(99.88, 1);

INSERT INTO order_(amount, customer_id)
VALUES(88.22, 3);

INSERT INTO order_(amount, customer_id)
VALUES(11.99, 2);

INSERT INTO order_(amount, customer_id)
VALUES(10.99, null);

INSERT INTO order_(amount, customer_id)
VALUES(11.02, null);


SELECT * FROM order_;




-- INNER JOIN

SELECT *
FROM customer
JOIN order_
ON customer.customer_id = order_.customer_id;



-- FULL JOIN
SELECT *
FROM customer
FULL JOIN order_
ON customer.customer_id = order_.customer_id;


-- LEFT JOIN
SELECT *
FROM customer -- LEFT TABLE because it IS FIRST one mentioned
LEFT JOIN order_ -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;


SELECT *
FROM order_ -- LEFT TABLE because it IS FIRST one mentioned
LEFT JOIN customer -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;


-- RIGHT JOIN 
SELECT *
FROM customer -- LEFT TABLE because it IS FIRST one mentioned
RIGHT JOIN order_ -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;


SELECT *
FROM order_ -- LEFT TABLE because it IS FIRST one mentioned
RIGHT JOIN customer -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;




-- ADD JOINS TO YOUR ALREADY CREATED DQL STATEMENTS
SELECT *
FROM customer 
JOIN order_
ON customer.customer_id = order_.customer_id
WHERE customer_state = 'VA';


SELECT * FROM order_;


SELECT order_.customer_id, first_name, last_name, amount, order_date 
FROM customer
JOIN order_ 
ON customer.customer_id = order_.customer_id;


--SELECT student.first_name, student.last_name, teacher.first_name
--FROM student
--JOIN teacher
--ON student.teacher_id = teacher.teacher_id;

-- Alias table names 

SELECT c.first_name, c.last_name, o.order_date, o.amount
FROM customer c 
JOIN order_ o 
ON c.customer_id = o.customer_id;



-- USING JOINS WITH GROUP BYS
SELECT c.customer_id, c.first_name, c.last_name, SUM(o.amount) AS total_spent
FROM customer c
JOIN order_ o 
ON c.customer_id = o.customer_id 
GROUP BY c.customer_id
HAVING SUM(o.amount) > 50
ORDER BY total_spent DESC;




