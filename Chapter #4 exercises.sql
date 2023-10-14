-- Exercise 4-1
SELECT payment_id
FROM payment
WHERE customer_id <> 5 AND(amount > 8 OR date(payment_date) = '2005-08-23');

-- Exercise 4-2
SELECT payment_id
FROM payment
WHERE customer_id = 5 AND NOT(amount > 6 OR date(payment_date) = '2005-06-19');

-- Exercise 4-3
SELECT *
from payment
WHERE amount IN('1.98', '7.98', '9.98');

-- Exercise 4-4
SELECT 
    *
FROM
    customer
WHERE
    last_name LIKE '_A%W%'; -- A in second position & W anywhere after A
