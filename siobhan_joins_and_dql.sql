--Customer table
CREATE TABLE customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(30),
	state VARCHAR(2),
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



-- Add data to each table
INSERT INTO customer(first_name, last_name, email, address, city, state, zipcode)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA', '87522'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA', '43592'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA', '34532'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA', '43538'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL', '60623');


--did separate adds so that timestamps are different
INSERT INTO order_(amount, customer_id)
VALUES(22.44, 1);

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

SELECT * 
FROM order_;


--Let's say we want to get information on customers who ordered on a certain date
--use join to get info from linked data tables 


-- INNER JOIN
--like intersect - will return matching data from BOTH tables

SELECT first_name, last_name, email, amount
FROM customer
JOIN order_
ON customer.customer_id = order_.customer_id;

SELECT *
FROM order_
INNER JOIN customer
ON order_.customer_id = customer.customer_id;



--Full Join is like combination:
--returns full set of data from both sets
--NULL values for info that didn't match similar 

SELECT *
FROM order_
FULL JOIN customer
ON order_.customer_id = customer.customer_id;


--Left Join: everything from LEFT table, matches from RIGHT
--Left Table = first one mentioned (from)
-- Right Table = other one

SELECT *
FROM order_
LEFT JOIN customer
ON customer.customer_id = order_.customer_id;

SELECT *
FROM order_
LEFT JOIN customer
ON order_.customer_id = customer.customer_id;



-- RIGHT JOIN 
SELECT *
FROM customer -- LEFT TABLE because it IS FIRST one mentioned
RIGHT JOIN order_ -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;


SELECT *
FROM order_ -- LEFT TABLE because it IS FIRST one mentioned
RIGHT JOIN customer -- RIGHT TABLE 
ON customer.customer_id = order_.customer_id;

-- ******SEE PNG of SQL Joins Venn Diagrams in Week5 Day3 Folder******

-- Using JOINS with DQL statements
SELECT *
FROM customer 
JOIN order_
ON customer.customer_id = order_.customer_id
WHERE customer_state = 'VA';




--Specifying columns that show up in both tables
--****EXAMPLE
-- if same column data in each table, must specify which table it's coming from 
--SELECT first_name, student.last_name, teacher.last_name
--FROM student
--JOIN teacher
--ON student.teacher_id = teacher.teacher_id;

SELECT customer.customer_id, first_name, last_name, email, amount, order_date
FROM customer 
JOIN order_ 
ON customer.customer_id = order_.customer_id;


--Alias table names to help w ambiguity when tables have same column names
SELECT c.customer_id, c.first_name, c.last_name, c.email, o.amount, o.order_date
FROM customer c
JOIN order_ o 
ON c.customer_id = o.customer_id;


--Using Joins whith Group Bys, Having, Order By, etc
SELECT c.customer_id, c.first_name, c.last_name, sum(o.amount) AS total_spent
FROM customer c
JOIN order_ o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id;


SELECT c.customer_id, c.first_name, c.last_name, sum(o.amount) AS total_spent
FROM customer c
JOIN order_ o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent desc;


SELECT c.customer_id, c.first_name, c.last_name, sum(o.amount) AS total_spent
FROM customer c
JOIN order_ o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING sum(o.amount) > 50
ORDER BY total_spent desc;




