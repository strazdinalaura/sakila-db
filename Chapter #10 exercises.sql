-- Exercise 10-1: write a query that returns each customer name along with their total payments. Include all customers, even if no payment records exist for that customer 
SELECT 
    c.first_name, SUM(p.amount) tot_payment
FROM
    customer c
        LEFT OUTER JOIN
    payment p ON c.customer_id = p.customer_id
    GROUP BY c.first_name
    ORDER BY SUM(p.amount);
    
    
-- Exercise 10-2: Reformulate query to use the other outer join type such that the results are identical
SELECT 
    c.first_name, SUM(p.amount) tot_payment
FROM
    payment p
        RIGHT OUTER JOIN
    customer c ON p.customer_id = c.customer_id
    GROUP BY c.first_name
    ORDER BY SUM(p.amount);


-- Exercise 10-3