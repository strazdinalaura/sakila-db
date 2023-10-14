-- exercise 3-1
SELECT 
    actor_id, first_name, last_name
FROM
    actor
ORDER BY last_name , first_name;

-- exercise 3-2
SELECT 
    actor_id, first_name, last_name
FROM
    actor
WHERE
    last_name = 'WILLIAMS'
        OR last_name = 'DAVIS';

-- excercise 3-3
SELECT DISTINCT
    customer_id
FROM
    rental
WHERE
    DATE(rental_date) = '2005-07-05';

-- excercise 3-4
SELECT 
    c.email, r.return_date
FROM
    customer AS c
        INNER JOIN
    rental AS r ON c.customer_id = r.customer_id
WHERE
    DATE(r.rental_date) = '2005-06-14'
ORDER BY DATE(r.return_date) DESC;