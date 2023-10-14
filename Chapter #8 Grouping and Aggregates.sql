-- Grouping Concepts
SELECT 
    customer_id
FROM
    rental;


SELECT 
    customer_id
FROM
    rental
GROUP BY customer_id;


SELECT 
    customer_id, count(*)
FROM
    rental
GROUP BY customer_id;


-- 👇 customer who reented the most films
SELECT 
    customer_id, count(*)
FROM
    rental
GROUP BY customer_id
ORDER BY 2 desc;


-- 👇 filter out any customers who have rented fewer than 40 films
SELECT 
    customer_id, count(*)
FROM
    rental
WHERE count(*) >= 40
GROUP BY customer_id;
-- ‼️ GROUP BY runs after WHERE clause, can't refer to aggregate function in WHERE clause  because groups have not been generated yet 


SELECT 
    customer_id, count(*)
FROM
    rental
GROUP BY customer_id
HAVING count(*) >= 40;


-- Aggregate Functions
-- Common functions
SELECT 
    MAX(amount) max_amt,
    MIN(amount) min_amt,
    AVG(amount) avg_amt,
    SUM(amount) tot_amt,
    COUNT(*) num_paymnets
FROM
    payment;
    
-- Implicit vs. Explicit Groups
-- 👇 to expand previous query and retrieve additional columns along with columns generated with aggregate functions

SELECT customer_id,
MAX(amount) max_amt,
    MIN(amount) min_amt,
    AVG(amount) avg_amt,
    SUM(amount) tot_amt,
    COUNT(*) num_paymnets
FROM
    payment;


-- 💡 Modify query by using the "GROUP BY" clause, you clearly define how the data should be grouped. The server knows to group together rows having the same value in the customer_id column
SELECT customer_id,
MAX(amount) max_amt,
    MIN(amount) min_amt,
    AVG(amount) avg_amt,
    SUM(amount) tot_amt,
    COUNT(*) num_paymnets
FROM
    payment
GROUP BY customer_id;


-- Counting Distinct Values
SELECT 
    COUNT(customer_id) num_rows,
    COUNT(DISTINCT customer_id) num_customer
FROM
    payment;


-- Using Expressions
-- return max number of days between when a film rented and returned
SELECT 
    MAX(DATEDIFF(return_date, rental_date))
FROM
    rental;
    
    
-- How Nulls Are Handled
CREATE TABLE number_tbl (
    val SMALLINT
);


INSERT INTO number_tbl VALUES (1);

INSERT INTO number_tbl VALUES (3);

INSERT INTO number_tbl VALUES (5);


SELECT 
    COUNT(*) num_rows,
    COUNT(val) num_vals,
    SUM(val) total,
    MAX(val) max_val,
    AVG(val) avg_val
FROM
    number_tbl;

INSERT INTO number_tbl VALUES(NULL);


SELECT 
    COUNT(*) num_rows,
    COUNT(val) num_vals,
    SUM(val) total,
    MAX(val) max_val,
    AVG(val) avg_val
FROM
    number_tbl;
    
-- Generating Groups
-- Single column grouping
SELECT 
    actor_id, COUNT(*)
FROM
    film_actor
GROUP BY actor_id;


-- Multicolumn grouping
-- 👇 generates groups for each combination of actor and rating
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
GROUP BY fa.actor_id , f.rating
ORDER BY 1 , 2;


-- Grouping via expressions
SELECT 
    EXTRACT(YEAR FROM rental_date) year, COUNT(*) how_many
FROM
    rental
GROUP BY EXTRACT(YEAR FROM rental_date);


-- Generating Rollups
-- the WITH ROLLUP function in this query provides a multi-level aggregation of films, first by actor, then by rating, and finally a grand total, all in one result set.
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
GROUP BY fa.actor_id , f.rating with rollup
ORDER BY 1 , 2;


-- Group Filter Conditions
SELECT 
    fa.actor_id, f.rating, COUNT(*)
FROM
    film_actor fa
        INNER JOIN
    film f ON fa.film_id = f.film_id
WHERE f.rating IN ('G', 'PG') -- filters the rows before they are grouped
GROUP BY fa.actor_id , f.rating with rollup -- groups the results by actor_id and rating
HAVING count(*) > 9; -- filters the groups after they have been formed









