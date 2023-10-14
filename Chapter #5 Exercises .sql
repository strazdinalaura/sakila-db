-- Exercise 5-1
SELECT 
    c.first_name, c.last_name, a.address, ct.city
FROM
    customer c
        INNER JOIN
    address a ON c.address_id = a.address_id
        INNER JOIN
    city ct ON a.city_id = ct.city_id
WHERE
    a.district = 'California';
    
-- Exercise 5-2
SELECT 
    f.title, a.first_name
FROM
    film f
        INNER JOIN
    film_actor fa ON f.film_id = fa.film_id
        INNER JOIN
    actor a ON fa.actor_id = a.actor_id
WHERE
    a.first_name = 'JOHN';
    
-- Exercise 5-3 (all adresses in the same city)
SELECT 
    a1.address addr1, a2.address addr2, a1.city_id
FROM
    address a1
        INNER JOIN
    address a2 ON a1.city_id = a2.city_id
AND 
    a1.address < a2.address;

