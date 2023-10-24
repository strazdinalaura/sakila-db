-- 13-1 Generate an alter table statement for the rental table so that an error will be raised if a row having a value found on teh rental.customer_id column is deleted from the cusotmer table

ALTER TABLE rental 
ADD CONSTRAINT fk_rental_customer_id FOREIGN KEY (customer_id)
REFERENCES customer (customer_id) ON DELETE RESTRICT; -- means that you cannot delete a customer from the customer table if there are corresponding rentals in the rental


-- 13-2 Generate multicolumn index on the payment table that could be used by both of the following queries 

SELECT 
    customer_id, payment_date, amount
FROM
    payment
WHERE
    payment_date > CAST('2019-12-31 23:59:59' AS DATETIME);
    
SELECT 
    customer_id, payment_date, amount
FROM
    payment
WHERE
    payment_date > CAST('2019-12-31 23:59:59' AS DATETIME)
    AND amount < 5;
    
CREATE INDEX idx_payment01
ON payment (payment_date, amount);
