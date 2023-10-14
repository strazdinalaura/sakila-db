
-- Uncorrelated Subqueries:
-- These subqueries are independent of the outer query. They do not reference any columns of the outer query.
-- The inner query executes once, produces a result, and then that result is used by the outer query.
-- It's like preparing a list (from the inner query) and then the outer query uses this list for comparison or other operations.
-- Because the inner query is independent, it's executed first.


-- 👇 single column with multiple rows
-- subquery returns the max value found in customer_id column in customer table, and the containing query returns data about that customer
SELECT 
    customer_id, first_name, last_name
FROM
    customer
WHERE
    customer_id = (SELECT 
            MAX(customer_id)
        FROM
            customer);
    
-- 👇 single column, single row
-- subquery returns single row with a single column
SELECT 
    MAX(customer_id)
FROM
    customer;
    
    
-- 👇 single column, single row
-- in this case, you can take the value the subquery returned and subsitute it into the righthand expression of the filter condition
SELECT 
    customer_id, first_name, last_name
FROM
    customer
WHERE
    customer_id = 599;
    
    
-- Subquery Types
-- Noncorrelated Subqueries
-- 👇 Scalar subquery. Like asking a question where you expect only one answer. 
SELECT 
    city_id, city
FROM
    city
WHERE
    country_id <> (SELECT 
            country_id
        FROM
            country
        WHERE
            country = 'India');


-- Multiple-Row, Single-Column Subqueries
-- 👇 while you can't equate single value to a set of values, you can check is single value can be found in a set of values
SELECT 
    country_id
FROM
    country
WHERE
    country IN ('Canada' , 'Mexico');
    

SELECT 
    country_id
FROM
    country
WHERE
    country = 'Canada' OR country = 'Mexico';
    

-- 👇 query uses in operator with a subquery on the right of the filter condition to return all cities in Canada or Mexico
SELECT 
    city_id, city
FROM
    city
WHERE
    country_id IN (SELECT 
            country_id
        FROM
            country
        WHERE
            country IN ('Canada' , 'Mexico'));


-- 👇 query uses in operator with a subquery on the right of the filter condition to return all cities not in Canada or Mexico
SELECT 
    city_id, city
FROM
    city
WHERE
    country_id NOT IN (SELECT 
            country_id
        FROM
            country
        WHERE
            country IN ('Canada' , 'Mexico'));
            
-- The all operator: used to compare a value to every value in a list or set of values
-- 👇 find all customers who have never gotten a free film rental
-- subquery returns all customers who paid 0 and the main query returns names of customers whose ID is not in the returned subquery
SELECT 
    first_name, last_name
FROM
    customer
WHERE
    customer_id <> ALL (SELECT 
            customer_id
        FROM
            payment
        WHERE
            amount = 0);
            

SELECT 
    first_name, last_name
FROM
    customer
WHERE
    customer_id NOT IN (SELECT 
            customer_id
        FROM
            payment
        WHERE
            amount = 0);
            
            
-- 👇 subquery in HAVING clause
-- the subquery returns the total number of film rentals in all customers in North America, the main query returns all customers whose total nr of film rental exceeds any of North American customers
SELECT 
    customer_id, COUNT(*)
FROM
    rental
GROUP BY customer_id
HAVING COUNT(*) > ALL (SELECT 
        COUNT(*)
    FROM
        rental r
            INNER JOIN
        customer c ON r.customer_id = c.customer_id
            INNER JOIN
        address a ON c.address_id = a.address_id
            INNER JOIN
        city ct ON a.city_id = ct.city_id
            INNER JOIN
        country co ON ct.country_id = co.country_id
    WHERE
        co.country IN ('United States' , 'Mexico', 'Canada')
    GROUP BY r.customer_id);
    

-- the ANY operator
-- 👇 subquery returns total film rental fees for all customers in Bolivia, Paraguay, Chile, and the main query returns all customers who outspent at least one of these countries
SELECT 
    customer_id, sum(amount)
FROM
    payment
GROUP BY customer_id
HAVING sum(amount) > ANY (SELECT 
        sum(p.amount)
    FROM
        payment p
            INNER JOIN
        customer c ON p.customer_id = c.customer_id
            INNER JOIN
        address a ON c.address_id = a.address_id
            INNER JOIN
        city ct ON a.city_id = ct.city_id
            INNER JOIN
        country co ON ct.country_id = co.country_id
    WHERE
        co.country IN ('Bolivia' , 'Paraguay', 'Chile')
    GROUP BY co.country);
    
-- Multicolumn Subqueries
-- 👇 returns two subqueries to idetify all actors with the last name Monroe and all films rated PG, and the main query then uses this information to retrieve all cases where an actor named Monroe appeared
SELECT 
    fa.actor_id, fa.film_id
FROM
    film_actor fa
WHERE
    fa.actor_id IN (SELECT 
            actor_id
        FROM
            actor
        WHERE
            last_name = 'MONROE')
        AND fa.film_id IN (SELECT 
            film_id
        FROM
            film
        WHERE
            rating = 'PG');
   
   
-- 👇 merging two single-column subqueries into one multicolumn subquery
SELECT -- The main query then looks at the film_actor table (your big box of DVDs) and selects all rows (DVDs) where the actor_id and film_id match any combination on the "Monroe-PG list".
    actor_id, film_id
FROM
    film_actor
WHERE -- The "Monroe-PG list" is created by the subquery. It lists all combinations of actor_id and film_id where the actor's last name is 'Monroe' and the film's rating is 'PG'.
    (actor_id , film_id) IN (SELECT 
            a.actor_id, f.film_id
        FROM
            actor a
                CROSS JOIN
            film f
        WHERE
            a.last_name = 'MONROE'
                AND f.rating = 'PG');


-- Correlated Subqueries:
-- These subqueries reference columns from the outer query. The result of the inner query can be different for each row of the outer query because it's dependent on data from the outer query.
-- For each row processed by the outer query, the correlated subquery executes, using the data from the current row of the outer query.
-- It's like, for each item in the outer list, you're checking a condition that might change based on that specific item.
-- The inner (correlated) subquery is intertwined with the outer query's row-by-row processing.

-- 👇 count the number of film rentals for each customer, and retrieve those customers who have exaclty 20 films
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    20 = (SELECT 
            COUNT(*)
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id); -- reference makes the query correlated
 

-- The exist operator: a way to check if something is there, without needing details about it. 
-- Using exist, subquery return zero, one or more rows, and the condition checks if subquery returned one or more rows
-- 👇 find all the customers who rented at least one film prior to May 25 without regard for how many films were rented
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    EXISTS( SELECT 
            1
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id
                AND DATE(r.rental_date) < '2005-05-25');

			
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    EXISTS( SELECT 
            r.rental_date, r.customer_id, 'ABCD' str, 2 * 6 / 7 nmbr
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id
                AND DATE(r.rental_date) < '2005-05-25');
                

-- 👇 query finds all actors who have never appeared in an R-rated film
SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    NOT EXISTS( SELECT 
            1
        FROM
            film_actor fa
                INNER JOIN
            film f ON f.film_id = fa.film_id
        WHERE
            fa.actor_id = a.actor_id
                AND f.rating = 'R');
                
                
-- Data Manipulatin Using Correlated Subqueries
UPDATE customer c 
SET 
    c.last_update = (SELECT 
            MAX(r.rental_date)
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id);
            
-- 👇 subquery in SET clause executes only if the condition in the UPDATE stetement's WHERE clause evaluates to true
UPDATE customer c 
SET 
    c.last_update = (SELECT 
            MAX(r.rental_date)
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id)
WHERE
    EXISTS( SELECT 
            1
        FROM
            rental r
        WHERE
            r.customer_id = c.customer_id);
            

-- 👇 remove rows from the customer table where there have been no film rentals in the past year
DELETE FROM customer c
WHERE 365 < ALL
(SELECT datediff(now(), r.rental_date) days_since_last_rental 
FROM rental r 
WHERE r.customer_id = c.customer_id);


-- When to use Subqueries
-- Subqueries as Data Sources: It's like creating a temporary summarized list that you can then use in your main query. 

-- 👇 The subquery is given name "pymnt" and is joined to the customer table via the customer_id. The main query retrieves customer name from customer table, along with a summary columns from the pymnt subquery
SELECT 
    c.first_name,
    c.last_name,
    pymnt.num_rentals,
    pymnt.tot_payments
FROM
    customer c
        INNER JOIN
    (SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt ON c.customer_id = pymnt.customer_id;



SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id;

-- 💡 subqueries in from clause must be non-correlated


-- Data Fabrication: using subqueries to generate data that doesn't exist in your db
-- 👇 group customers by the amount of money spent on film rentals, but you want to use group definitions that are not stored in your db

-- #1 query that generates the group definitions
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit
UNION ALL
SELECT 'Avergae Joes' name, 75 low_limit, 149.99 high_limit
UNION ALL
SELECT 'Heavy Hitters' name, 150 low_limit, 999999999.99 high_limit;


-- #2 query that generate the desired groups and places them into from clause of another query to generate customer groups
SELECT 
    pymnt_grps.name, COUNT(*) num_customers
FROM
    (SELECT 
        customer_id, COUNT(*) num_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt
        INNER JOIN
    (SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit UNION ALL SELECT 'Avergae Joes' name, 75 low_limit, 149.99 high_limit UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 999999999.99 high_limit) pymnt_grps ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
GROUP BY pymnt_grps.name;


-- Task oriented subqueries 
-- 👇 #1 joining 3 tables to generate a report showing each customer's name, along with their city with total rentals and payment
SELECT 
    c.first_name,
    c.last_name,
    ct.city,
    SUM(p.amount) tot_payments,
    COUNT(*) tot_rentals
FROM
    payment p
        INNER JOIN
    customer c ON c.customer_id = p.customer_id
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    city ct ON a.city_id = ct.city_id
GROUP BY c.first_name , c.last_name , ct.city;

-- 👇 #2 grouping subquery
SELECT customer_id, count(*), sum(amount) tot_payments
FROM payment
GROUP BY customer_id;


-- v2 of the #1 query
SELECT 
    c.first_name,
    c.last_name,
    ct.city,
    pymnt.tot_payments,
    pymnt.tot_rentals
FROM
    (SELECT 
        customer_id, COUNT(*) tot_rentals, SUM(amount) tot_payments
    FROM
        payment
    GROUP BY customer_id) pymnt
        INNER JOIN
    customer c ON pymnt.customer_id = c.customer_id
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    city ct ON a.city_id = ct.city_id;
    

-- Common table expressions
-- 👇 this query calculates the total revenue generated from PG-rated film rentals where the cast includes an actor whose last name starts with S
WITH actors_s AS -- #1 finds all actors whose name starts with S
(SELECT actor_id, first_name, last_name 
FROM actor 
WHERE last_name LIKE 'S%'),

actors_s_pg AS -- #2 joins #1 data set to the film table and filters on fims having a PG rating
(SELECT s.actor_id, s.first_name, s.last_name, f.film_id, f.title 
FROM actors_s s
INNER JOIN film_actor fa
ON s.actor_id = fa.actor_id
INNER JOIN film f
ON f.film_id = fa.film_id
WHERE f.rating = 'PG'),

actors_s_pg_revenue AS -- #3 joins #2 data set to the payent table to retrieve the amounts paid to rent any of these films
(SELECT spg.first_name, spg.last_name, p.amount
FROM actors_s_pg spg
INNER JOIN inventory i
ON i.film_id = spg.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
INNER JOIN payment p
ON r.rental_id = p.rental_id) -- end of WITH clause

SELECT spg_rev.first_name, spg_rev.last_name, sum(spg_rev.amount) tot_revenue
FROM actors_s_pg_revenue spg_rev
GROUP BY spg_rev.first_name, spg_rev.last_name
ORDER BY 3 desc;


-- Subqueries as Expression Generators
-- 👇 uses individual look-ups (subqueries) for each piece of information (first name, last name, city) for each payment.
SELECT 
    (SELECT 
            c.first_name
        FROM
            customer c
        WHERE
            c.customer_id = p.customer_id) first_name,
    (SELECT 
            c.last_name
        FROM
            customer c
        WHERE
            c.customer_id = p.customer_id) last_name,
    (SELECT 
            ct.city
        FROM
            customer c
                INNER JOIN
            address a ON c.address_id = a.address_id
                INNER JOIN
            city ct ON a.city_id = ct.city_id
        WHERE
            c.customer_id = p.customer_id) city,
    SUM(p.amount) tot_payments,
    COUNT(*) tot_rentals
FROM
    payment p
GROUP BY p.customer_id;

-- 👇 subqueries can appear in ORDER BY clause
SELECT 
    a.actor_id, a.first_name, a.last_name
FROM
    actor a
ORDER BY (SELECT 
        COUNT(*)
    FROM
        film_actor fa
    WHERE
        fa.actor_id = a.actor_id) DESC;
        
        
-- using non-correlated subqueries in SELECT statement
INSERT INTO film_actor (actor_id, film_id, last_update)
VALUES ((SELECT actor_id FROM actor
WHERE first_name = 'JENNIFER' AND last_name = 'DAVIS'),
(SELECT film_id FROM film
WHERE title = 'ACE GOLDFINGER'), now());
