-- The Case expression
-- 👇 Searched CASE expression - generates a value for teh activity_type column which returns ACTIVE or INACTIVE based on customer table column 'active'
SELECT 
    first_name,
    last_name,
    CASE
        WHEN active = 1 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END activity_type
FROM
    customer;
    
-- 👇 query uses a correlated subquery to return the number of rentals, but only for active users
SELECT 
    c.first_name,
    c.last_name,
    CASE
        WHEN active = 0 THEN 0
        ELSE (SELECT 
                COUNT(*)
            FROM
                rental r
            WHERE
                r.customer_id = c.customer_id)
    END num_rentals
FROM
    customer c;
    
    
-- Result Set Transformations
-- 👇 show the number of film rentals for May, June, and July
SELECT 
    MONTHNAME(rental_date) rental_month, COUNT(*) num_rentlals
FROM
    rental
WHERE
    rental_date BETWEEN '2005-05-01' AND '2005-08-01'
GROUP BY MONTHNAME(rental_date);

-- 👇 to transform the result set into a single row, create three columns, and within each column, sum only those rows that relate to the month in question
SELECT 
SUM(CASE WHEN MONTHNAME(rental_date) = 'May' THEN 1 ELSE 0 END) May_rentals,
SUM(CASE WHEN MONTHNAME(rental_date) = 'June' THEN 1 ELSE 0 END) June_rentals,
SUM(CASE WHEN MONTHNAME(rental_date) = 'July' THEN 1 ELSE 0 END) July_rentals
FROM rental
WHERE rental_date BETWEEN '2005-05-01' AND '2005-08-01';


-- Checking for Existance
-- 👇 generate three output columns , one to show if the actor appeared in G-rate, PG-rated or NC-17 rated films
SELECT 
    a.first_name,
    a.last_name,
    CASE
        WHEN
            EXISTS( SELECT 
                    1
                FROM
                    film_actor fa
                        INNER JOIN
                    film f ON fa.film_id = f.film_id
                WHERE
                    fa.actor_id = a.actor_id
                        AND f.rating = 'G')
        THEN
            'Y'
        ELSE 'N'
    END g_actor,
    CASE
        WHEN
            EXISTS( SELECT 
                    1
                FROM
                    film_actor fa
                        INNER JOIN
                    film f ON fa.film_id = f.film_id
                WHERE
                    fa.actor_id = a.actor_id
                        AND f.rating = 'PG')
        THEN
            'Y'
        ELSE 'N'
    END pg_actor,
    CASE
        WHEN
            EXISTS( SELECT 
                    1
                FROM
                    film_actor fa
                        INNER JOIN
                    film f ON fa.film_id = f.film_id
                WHERE
                    fa.actor_id = a.actor_id
                        AND f.rating = 'NC-17')
        THEN
            'Y'
        ELSE 'N'
    END nc17_actor
FROM
    actor a
WHERE
    a.last_name LIKE 'S%'
        OR a.first_name LIKE 'S%';

-- Correlation: The subquery is correlated with the outer query by the condition fa.actor_id = a.actor_id. This means for each actor in the outer query, the subquery checks the film_actor and film tables to see if there's a match for that specific actor with a 'G' 'PG' 'NC17' rated film.
-- EXISTS: The EXISTS keyword checks if the subquery returns any rows. If it does, it means the actor has appeared in at least one 'G' 'PG' 'NC17' rated film. If not, they haven't.
-- Output: If the actor has appeared in a 'G' rated film, the CASE expression outputs 'Y'. If not, it outputs 'N' 'PG' 'NC17'.


-- how many rows are encountered, but only up to a point
-- 👇 case expressions counts the number of copies in inventory for each film and then returns either 'Out of Stock', 'Scarce', 'Available', or 'Common'
SELECT 
    f.title,
    CASE (SELECT 
            COUNT(*)
        FROM
            inventory i
        WHERE
            i.film_id = f.film_id)
        WHEN 0 THEN 'Out of Stock'
        WHEN 1 THEN 'Scarce'
        WHEN 2 THEN 'Scarce'
        WHEN 3 THEN 'Available'
        WHEN 4 THEN 'Available'
        ELSE 'Common'
    END film_availability
FROM
    film f;
    
-- Division-by-Zero Errors
-- 👇 to safeguard calculations from errors, or set to null, wrap denominators in conditional logic
SELECT 
    c.first_name,
    c.last_name,
    SUM(p.amount) tot_payment_amt,
    COUNT(p.amount) num_payments,
    SUM(p.amount) / CASE
        WHEN COUNT(p.amount) = 0 THEN 1
        ELSE COUNT(p.amount)
    END average_payment
FROM
    customer c
        LEFT OUTER JOIN
    payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name , c.last_name;


-- Conditional Updates
-- 👇 set customer.active column to 0 for any customers who haven't rented a film in the last 90 days
UPDATE customer 
SET 
    active = CASE
        WHEN
            90 <= (SELECT 
                    DATEDIFF(NOW(), MAX(rental_date))
                FROM
                    rental r
                WHERE
                    r.customer_id = customer.customer_id)
        THEN
            0
        ELSE 1
    END
WHERE
    active = 1;


-- Handling Null Values
-- 👇 when retrieving data, you can use case expression to substitute the string if the value is null
SELECT 
    c.first_name,
    c.last_name,
    CASE
        WHEN a.address IS NULL THEN 'Unknown'
        ELSE a.address
    END address,
    CASE
        WHEN ct.city IS NULL THEN 'Unknown'
        ELSE ct.city
    END city,
    CASE
        WHEN cn.country IS NULL THEN 'Unknown'
        ELSE cn.country
    END country
FROM
    customer c
        LEFT OUTER JOIN
    address a ON c.address_id = a.address_id
        LEFT OUTER JOIN
    city ct ON a.city_id = ct.city_id
        LEFT OUTER JOIN
    country cn ON ct.country_id = cn.country_id;

-- Using LEFT OUTER JOIN ensures that all customers are included in the result, regardless of whether they have associated address, city, or country data. Switching to INNER JOIN would exclude customers without complete address, city, or country data from the result set.



















