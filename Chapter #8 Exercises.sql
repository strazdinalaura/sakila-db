-- Exercise 8-1: query that counts the number of rows in the payment table
SELECT 
    COUNT(*)
FROM
    payment;


-- Exercise 8-2: count the number of payments made by each customer. Show the customer ID and the toal amount paid for each customer
SELECT 
    customer_id, SUM(amount), COUNT(*)
FROM
    payment
GROUP BY 1;

-- Exercise 8-3: include only those customers who have made at least 40 payments
SELECT 
    customer_id, SUM(amount), COUNT(*)
FROM
    payment
GROUP BY 1
HAVING COUNT(*) >= 40;
