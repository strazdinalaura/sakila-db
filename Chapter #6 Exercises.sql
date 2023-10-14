-- Exercise 6-2
SELECT 
    'ACTR' typ, a.first_name fname, a.last_name lname
FROM
    actor a
WHERE
    a.last_name LIKE 'L%' 
UNION SELECT 
    'CUST' typ, c.first_name, c.last_name
FROM
    customer c
WHERE
    c.last_name LIKE 'L%';


-- Exercise 6-3
SELECT 
    'ACTR' typ, a.first_name fname, a.last_name lname
FROM
    actor a
WHERE
    a.last_name LIKE 'L%' 
UNION SELECT 
    'CUST' typ, c.first_name, c.last_name
FROM
    customer c
WHERE
    c.last_name LIKE 'L%'
    ORDER BY lname, fname;