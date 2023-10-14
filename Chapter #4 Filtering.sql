-- Equality Conditions 
SELECT 
    c.email
FROM
    customer AS c
        INNER JOIN
    rental AS r ON c.customer_id = r.customer_id -- 1st equality condition
WHERE
    DATE(r.rental_date) = '2005-06-14'; -- 2nd equality condition
    

-- Inequality Conditions 
SELECT 
    c.email
FROM
    customer AS c
        INNER JOIN
    rental AS r ON c.customer_id = r.customer_id -- 1st inequality condition
WHERE
    DATE(r.rental_date) <> '2005-06-14'; -- 2nd inequality condition
    
    
DELETE FROM rental 
WHERE
    YEAR(r.rental_date) = '2004'; 


-- Range Conditions
SELECT 
    customer_id, rental_date
FROM
    rental
WHERE
    rental_date < '2005-05-25';


SELECT 
    customer_id, rental_date
FROM
    rental
WHERE
    rental_date <= '2005-06-16'
    AND rental_date >= '2005-06-14';
    
    
SELECT 
    customer_id, rental_date
FROM
    rental
WHERE
    rental_date BETWEEN '2005-06-14' AND '2005-06-16'; -- specify the lower limit of the range first (after BETWEEN), ranges are inclusive
    
    
SELECT 
    customer_id, payment_date, amount
FROM
    payment
WHERE
    amount BETWEEN 10.0 AND 11.99;
 
 
SELECT 
    first_name, last_name
FROM
    customer
WHERE
    last_name BETWEEN 'FA' AND 'FRB';
    
  
  
SELECT 
    title, rating
FROM
    film
WHERE
    rating = 'G' OR rating = 'PG';
  
  
SELECT 
    title, rating
FROM
    film
WHERE
    rating IN ('G' , 'PG');
    
    
-- using Subqueries
SELECT 
    title, rating
FROM
    film
WHERE rating IN (SELECT rating FROM film WHERE title LIKE '%PET%');


SELECT 
    title, rating
FROM
    film
WHERE
    rating NOT IN ('PG-13' , 'R', 'NC-17');
    
    
SELECT 
    last_name, first_name
FROM
    customer
WHERE
    LEFT(last_name, 1) = 'Q'; -- strip off the first letter of last_name with left()
    
    
-- Using Wildcards
SELECT 
    last_name, first_name
FROM
    customer
WHERE
    last_name LIKE '_A_T%S';


SELECT 
    last_name, first_name
FROM
    customer
WHERE
    last_name LIKE 'Q%'
        OR last_name LIKE 'Y%';
        
SELECT last_name, first_name
FROM customer
WHERE last_name REGEXP '^[QY]'; -- find all customers whose last name starts with Q and Y


-- NULL Values
SELECT 
    rental_id, customer_id
FROM
    rental
WHERE
    return_date IS NULL; -- An expression can be NULL
  
  
SELECT 
    rental_id, customer_id
FROM
    rental
WHERE
    return_date = NULL; -- An expression can not equal NULL
   
   
SELECT 
    rental_id, customer_id
FROM
    rental
WHERE
    return_date IS NOT NULL;
    
    
SELECT 
    rental_id, customer_id, return_date
FROM
    rental
WHERE
    return_date NOT BETWEEN '2005-05-01' AND '2005-09-01'; -- if there's no return date, those NULL values won't be returned
    
    
SELECT 
    rental_id, customer_id, return_date
FROM
    rental
WHERE
    return_date IS NULL
        OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';
    









    
    


    
    

    
    


