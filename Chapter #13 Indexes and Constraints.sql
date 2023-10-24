-- Indexes: They help the database find and retrieve data more quickly. An index is created on columns in a table and helps speed up the process of querying.
-- Index Creation
ALTER TABLE customer
ADD INDEX idx_email (email);


SHOW INDEX FROM customer;


ALTER TABLE customer
DROP INDEX idx_email;

-- Unique Index
ALTER TABLE customer 
ADD UNIQUE idx_email (email);

INSERT INTO customer (store_id, first_name, last_name,email, address_id, active)
VALUES (1, 'ALAN', 'KAHN', 'ALAN.KAHN@sakilacustomer.org', 394, 1);

-- Multicolumn indexes
ALTER TABLE customer
ADD INDEX idx_full_name (first_name, last_name);

EXPLAIN 
SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name LIKE 'S%' AND last_name LIKE 'P%';

-- Constraints
-- #1 retreive a row from customer table
SELECT 
    c.first_name, c.last_name, c.address_id, a.address
FROM
    customer c
        INNER JOIN
    address a ON c.address_id = a.address_id
WHERE
    a.address_id = 123;
    
-- #2 try to delete a single customer row 
DELETE FROM address WHERE address_id = 123;


-- modifying a value in adrress.address_id column
UPDATE address 
SET 
    address_id = 9999
WHERE
    address_id = 123;
    
-- check if the modified row still points to the same row in cusotmer table
SELECT c.first_name, c.last_name, c.address_id, a.address
FROM customer c
INNER JOIN address a 
ON c.address_id = a.address_id
WHERE a.address_id = 9999;

