desc customer;

-- Cartesian Product
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c
        JOIN
    address a; -- returns customer x address permutation, rarely used 
    

SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c
        JOIN
    address a ON c.address_id = a.address_id; -- returns single address row for each customer
    
    
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c
       INNER JOIN
    address a ON c.address_id = a.address_id; -- returns single address row for each customer
    
    
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c
        INNER JOIN
    address a USING (address_id);

-- ANSI Join Syntax
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c,
    address a
WHERE
    c.address_id = a.address_id;
    
    
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c,
    address a
WHERE
    c.address_id = a.address_id
    AND a.postal_code =52137;
   
-- same query using ANSI syntax
SELECT 
    c.first_name, c.last_name, a.address
FROM
    customer c INNER JOIN
    address a
WHERE
    c.address_id = a.address_id
    AND a.postal_code =52137;
    
-- Joining Three or More Tables
SELECT 
    c.first_name, c.last_name, ct.city
FROM
    customer c
        INNER JOIN
    address a ON a.address_id = c.address_id
        INNER JOIN
    city ct ON a.city_id = ct.city_id;
    
-- Using Subqueries as Tables
SELECT 
    c.first_name, c.last_name, addr.address, addr.city
FROM
    customer c
        INNER JOIN
    (SELECT 
        a.address_id, a.address, ct.city
    FROM
        address a
    INNER JOIN city ct ON a.city_id = ct.city_id
    WHERE
        a.district = 'California') addr -- finds all addresses in California
        ON c.address_id = addr.address_id;
        
        
SELECT 
        a.address_id, a.address, ct.city
    FROM
        address a
    INNER JOIN city ct ON a.city_id = ct.city_id
    WHERE
        a.district = 'California';


-- Using the same Table twice 
-- query return all movies in which either CATE MCQUEEN or CUBA BIRCH appeared
SELECT 
    f.title
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    ((a.first_name = 'CATE'
        AND a.last_name = 'MCQUEEN')
        OR (a.first_name = 'CUBA'
        AND a.last_name = 'BIRCH'));
     
     
-- query returns all movies in which both CATE MCQUEEN and CUBA BIRCH appeared
SELECT 
    f.title
FROM
    film f
        INNER JOIN
    film_actor AS fa1 ON f.film_id = fa1.film_id
        INNER JOIN
    actor a1 ON fa1.actor_id = a1.actor_id
        INNER JOIN
    film_actor fa2 ON f.film_id = fa2.film_id
        INNER JOIN
    actor a2 ON fa2.actor_id = a2.actor_id
WHERE
    (a1.first_name = 'CATE'
        AND a1.last_name = 'MCQUEEN')
        AND (a2.first_name = 'CUBA'
        AND a2.last_name = 'BIRCH');
        
    

    
    


