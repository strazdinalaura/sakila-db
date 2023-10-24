-- customer table view
CREATE VIEW customer_vw (customer_id , first_name , last_name , email) AS
    SELECT 
        customer_id,
        first_name,
        last_name,
        CONCAT(SUBSTR(email, 1, 2),
                '*****',
                SUBSTR(email, - 4)) email
    FROM
        customer;
  
  
SELECT 
    first_name, last_name, email
FROM
    customer_vw;
    
SELECT 
    first_name, COUNT(*), MIN(last_name), MAX(last_name)
FROM
    customer_vw
WHERE
    first_name LIKE 'J%'
GROUP BY first_name
HAVING COUNT(*) > 1
ORDER BY 1;


-- joining views
SELECT 
    cv.first_name, cv.last_name, p.amount
FROM
    customer_vw cv
        INNER JOIN
    payment p ON cv.customer_id = p.customer_id
WHERE
    p.amount >= 11;
    
-- constraining which rows a set of users may access by adding a where clause to view definition
-- 👇 view excludes inactive users
CREATE VIEW active_customer_vw (customer_id , first_name , last_name , email) AS
    SELECT 
        customer_id,
        first_name,
        last_name,
        CONCAT(SUBSTR(email, 1, 2),
                '*****',
                SUBSTR(email, - 4)) email
    FROM
        customer
    WHERE
        active = 1;
        
        
-- Data Aggregation
-- 👇 report view: total sales for each film category
CREATE VIEW sales_by_film_category AS
    SELECT 
        c.name AS category, SUM(p.amount) AS total_sales
    FROM
        payment AS p
            INNER JOIN
        rental AS r ON p.rental_id = r.rental_id
            INNER JOIN
        inventory AS i ON r.inventory_id = i.inventory_id
            INNER JOIN
        film AS f ON i.film_id = f.film_id
            INNER JOIN
        film_category AS fc ON f.film_id = fc.film_id
            INNER JOIN
        category AS c ON fc.category_id = c.category_id
    GROUP BY c.name
    ORDER BY total_sales DESC;
    
    
SELECT * FROM sales_by_film_category;


-- reporting view that show all film, category, number of actors, total inventory, nr of rentals
-- 👇 even though data from 6 different tables can be retrieved through the view, the from clause of the query has only one table. Data from the other tables is generated using scalar subquries

CREATE VIEW film_stats AS
    SELECT 
        f.film_id,
        f.title,
        f.description,
        f.rating,
        (SELECT 
                c.name
            FROM
                category c
                    INNER JOIN
                film_category fc ON c.category_id = fc.category_id
            WHERE
                fc.film_id = f.film_id) category_name,
        (SELECT 
                COUNT(*)
            FROM
                film_actor fa
            WHERE
                fa.film_id = f.film_id) num_actors,
        (SELECT 
                COUNT(*)
            FROM
                inventory i
            WHERE
                i.film_id = f.film_id) inventory_cnt,
        (SELECT 
                COUNT(*)
            FROM
                inventory i
                    INNER JOIN
                rental r ON r.inventory_id = i.inventory_id
            WHERE
                i.film_id = f.film_id) num_rentals
    FROM
        film f;
        
SELECT * FROM film_stats;
        
        

-- Joining partitioned data
-- 👇 case when combining two tables to create a single view
CREATE VIEW payment_all (payment_id , customer_id , staff_id , rental_id , amount , payment_date , last_update) AS
    SELECT 
        payment_id,
        customer_id,
        staff_id,
        rental_id,
        amount,
        payment_date,
        last_update
    FROM
        payment_historic 
    UNION ALL SELECT 
        payment_id,
        customer_id,
        staff_if,
        rental_id,
        amount,
        payment_date,
        last_update
    FROM
        payment_current;
        
-- Updatable Views: modifying data through views with certain rescrictions
-- 👇 updating simple views
CREATE VIEW customer_vw (customer_id , first_name , last_name , email) AS
    SELECT 
        customer_id,
        first_name,
        last_name,
        CONCAT(SUBSTR(email, 1, 2),
                '*****',
                SUBSTR(email, - 4)) email
    FROM
        customer;

-- update last name
UPDATE customer_vw 
SET 
    last_name = 'SMITH-ALLEN'
WHERE
    customer_id = 1;
    
    
-- Updating Complex Views
CREATE VIEW customer_details AS
    SELECT 
        c.customer_id,
        c.store_id,
        c.first_name,
        c.last_name,
        c.address_id,
        c.active,
        c.create_date,
        a.address,
        ct.city,
        cn.country,
        a.postal_code
    FROM
        customer c
            INNER JOIN
        address a ON c.address_id = a.address_id
            INNER JOIN
        city ct ON a.city_id = ct.city_id
            INNER JOIN
        country cn ON ct.country_id = cn.country_id;
        

UPDATE customer_details 
SET 
    last_name = 'SMITH-ALLEN',
    active = 0
WHERE
    customer_id = 1;


UPDATE customer_details 
SET 
    address = '99 Monckinbird Lane'
WHERE
    customer_id = 1;
    

INSERT INTO customer_details (customer_id, store_id, first_name, last_name, address_id, active, create_date)
VALUES (9998, 1, 'BRIAN', 'SALAZAR', 5, 1, now());

-- 💡 Can not modify more than one base table thourgh join view
INSERT INTO customer_details (customer_id, store_id, first_name, last_name, address_id, active, create_date, address)
VALUES (9998, 1, 'BRIAN', 'SALAZAR', 5, 1, now(), '99 Monckinbird Lane');


-- Exercises
-- 14-1
SELECT title, category_name, first_name, last_name
FROM flm_ctgr_actor
WHERE last_name = 'FAWCETT';

CREATE VIEW flm_ctgr_actor AS
    SELECT 
        f.title title, c.name category_name, a.first_name, a.last_name
    FROM
        actor a
            INNER JOIN
        film_actor fa ON a.actor_id = fa.actor_id
            INNER JOIN
        film f ON fa.film_id = f.film_id
            INNER JOIN
        film_category fc ON f.film_id = fc.film_id
            INNER JOIN
        category c ON fc.category_id = c.category_id
    WHERE
        a.last_name = 'FAWCETT';
        
SELECT * FROM flm_ctgr_actor;


-- 14-2
-- report that includes the name of every country, along with total payments for all customers who live in each country. 
-- Generate a view definition that queries the country table and uses a scalar subquery to calculated a value for a column name tot_payments
CREATE VIEW country_payments_2 AS
    SELECT 
        cn.country,
            (SELECT 
                SUM(p.amount)
            FROM
                payment p
                    INNER JOIN
                customer c ON p.customer_id = c.customer_id
                    INNER JOIN
                address a ON c.address_id = a.address_id
                    INNER JOIN
                city ct ON a.city_id = ct.city_id
            WHERE
                ct.country_id = cn.country_id) tot_payments
    FROM
        country cn;
    
    SELECT * from country_payments_2;






















