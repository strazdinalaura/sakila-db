-- Outer Joins

-- 👇 counts the number of available copies for each film
SELECT 
    f.film_id, f.title, COUNT(*) num_copies
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
GROUP BY f.film_id , f.title;


-- 👇 return all films regardless if they are in the inventory 
SELECT 
    f.film_id, f.title, COUNT(i.inventory_id) num_copies
FROM
    film f
        LEFT OUTER JOIN
    inventory i ON f.film_id = i.film_id
GROUP BY f.film_id , f.title;


-- 👇 return a few rows based on condition
SELECT 
    f.film_id, f.title, i.inventory_id
FROM
    film f
        INNER JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    f.film_id BETWEEN 13 AND 15;
    
    
-- 👇 returns all records from the left table and the matched records from the right table, if record not found in the outer table (inventory) - null value 
-- there's no matching film_id in the inventory table, that record from the film table will still appear in the result, but with a NULL value for the i.inventory_id and any other columns selected from the inventory table.
SELECT 
    f.film_id, f.title, i.inventory_id
FROM
    film f
        LEFT OUTER JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    f.film_id BETWEEN 13 AND 15;
    

-- Left vs Right Outer Joins

-- 👇 right outer join: returning all records from the right table and the matched records from the left table
SELECT 
    f.film_id, f.title, i.inventory_id
FROM
    film f
        RIGHT OUTER JOIN
    inventory i ON f.film_id = i.film_id
WHERE
    f.film_id BETWEEN 13 AND 15;
    

-- 3-Way Outer Joins
SELECT 
    f.film_id, f.title, i.inventory_id, r.rental_date
FROM
    film f
        LEFT OUTER JOIN
    inventory i ON f.film_id = i.film_id
        LEFT OUTER JOIN
    rental r ON i.inventory_id = r.inventory_id
WHERE
    f.film_id BETWEEN 13 AND 15;
    

-- Cross Joins: produces the Cartesian product of two tables, meaning it combines each row from the first table with every row from the second table
SELECT 
    c.name category_name, l.name language_name
FROM
    category c
        CROSS JOIN
    language l;
    
-- 👇 build a three row table that could be joined to other tables
SELECT 'Small Fry' name, 0 low_limit, 74.99 high_limit 
UNION ALL SELECT 'Average Joes' name, 75 low_limit, 149.99 high_limit 
UNION ALL SELECT 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;

-- FABRICATING all the days in 2020
-- generates a row for every day in the year 2020 without a table in db that contains a row for every day
SELECT '2020-01-01' dt
UNION ALL
SELECT '2020-01-02' dt
UNION ALL
SELECT '2020-01-03' dt;
-- ......

-- INSTEAD #1 generate a table with 366 rows with a single column containinga a number between 0 and 366 and then add that number of days to January 1, 2020
SELECT ones.num + tens.num + hundreds.num
FROM (SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 100 num UNION ALL
SELECT 200 num UNION ALL
SELECT 300 num) hundreds;

-- #2 convert the set of numbers to a set of dates
SELECT DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM (SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 100 num UNION ALL
SELECT 200 num UNION ALL
SELECT 300 num) hundreds
WHERE DATE_ADD('2020-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2021-01-01'
ORDER BY 1;

-- #3 generate a report that shows every day in 202 with the number of film rentals on that day
SELECT days.dt, count(r.rental_id) num_rentals
FROM rental r
RIGHT OUTER JOIN (SELECT DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) dt
FROM (SELECT 0 num UNION ALL
SELECT 1 num UNION ALL
SELECT 2 num UNION ALL
SELECT 3 num UNION ALL
SELECT 4 num UNION ALL
SELECT 5 num UNION ALL
SELECT 6 num UNION ALL
SELECT 7 num UNION ALL
SELECT 8 num UNION ALL
SELECT 9 num) ones
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 10 num UNION ALL
SELECT 20 num UNION ALL
SELECT 30 num UNION ALL
SELECT 40 num UNION ALL
SELECT 50 num UNION ALL
SELECT 60 num UNION ALL
SELECT 70 num UNION ALL
SELECT 80 num UNION ALL
SELECT 90 num) tens
CROSS JOIN
(SELECT 0 num UNION ALL
SELECT 100 num UNION ALL
SELECT 200 num UNION ALL
SELECT 300 num) hundreds
WHERE DATE_ADD('2005-01-01', INTERVAL (ones.num + tens.num + hundreds.num) DAY) < '2006-01-01') days
ON days.dt = date(r.rental_date)
GROUP BY days.dt
ORDER BY 1;

-- Natural Joins: returns rows from two tables where the values of all the columns with the same name in both tables match
SELECT c.first_name, c.last_name, date(r.rental_date)
FROM customer c
NATURAL JOIN rental r;

-- restrict columns for at least one of the tables
SELECT 
    cust.first_name, cust.last_name, DATE(r.rental_date)
FROM
    (SELECT 
        customer_id, first_name, last_name
    FROM
        customer) cust
        NATURAL JOIN
    rental r;





