-- Set Theory
SELECT 1 num, 'abc' str
UNION
SELECT 9 num, 'xyz' str;

-- Set Operators
-- UNION Operation (sorts & removes duplicates, UNION ALL doesn't remove duplicates)
SELECT 
    'CUST' typ, c.first_name, c.last_name
FROM
    customer c 
UNION ALL SELECT 
    'ACTR' typ, a.first_name, a.last_name
FROM
    actor a;

-- 👇 returns duplicate data
SELECT 
    'ACTR' typ, a.first_name, a.last_name
FROM
    actor a 
UNION ALL SELECT 
    'ACTR' typ, a.first_name, a.last_name
FROM
    actor a;
    
    
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'J%'
        AND c.last_name LIKE 'D%' 
UNION ALL SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'J%'
        AND a.last_name LIKE 'D%';
        
        
-- exclude duplicates 
SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'J%'
        AND c.last_name LIKE 'D%' 
UNION SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'J%'
        AND a.last_name LIKE 'D%';
  
  
-- INTERSECT Operator 
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'D%' AND c.last_name LIKE 'T%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'D%' AND a.last_name LIKE 'T%';


SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%'
INTERSECT
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%';


-- Except Operator
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
EXCEPT
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%';


-- Sorting Compound Query Results
SELECT 
    a.first_name fname, a.last_name lname
FROM
    actor a
WHERE
    a.first_name LIKE 'J%'
        AND a.last_name LIKE 'D%' 
UNION ALL SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'J%'
        AND c.last_name LIKE 'D%'
ORDER BY lname , fname;

-- Set Operation Precedence
SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'J%'
        AND a.last_name LIKE 'D%' 
UNION ALL SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'M%'
        AND a.last_name LIKE 'T%' 
UNION SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'J%'
        AND c.last_name LIKE 'D%';
-- 👆 compound query includes three queries that return sets of nonunique names, 1st & 2nd separated with union all, 2nd & 3rd separated with union

-- 👇 same query with the set operations reversed
SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'J%'
        AND a.last_name LIKE 'D%' 
UNION SELECT 
    a.first_name, a.last_name
FROM
    actor a
WHERE
    a.first_name LIKE 'M%'
        AND a.last_name LIKE 'T%' 
UNION ALL SELECT 
    c.first_name, c.last_name
FROM
    customer c
WHERE
    c.first_name LIKE 'J%'
        AND c.last_name LIKE 'D%';


-- ANSI SQL
-- 👇 the 2nd & 3rd queries would be combined using the union all, then combined with the 1st query using union 
SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'J%' AND a.last_name LIKE 'D%'
UNION
(SELECT a.first_name, a.last_name
FROM actor a
WHERE a.first_name LIKE 'M%' AND a.last_name LIKE 'T%'
UNION ALL
SELECT c.first_name, c.last_name
FROM customer c
WHERE c.first_name LIKE 'J%' AND c.last_name LIKE 'D%')







