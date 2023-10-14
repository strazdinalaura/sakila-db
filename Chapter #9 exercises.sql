-- Exercise 9-1: construct query against film table that uses filter condition with a non-correlated subquery against the category table to find all action films

SELECT 
    title
FROM
    film
WHERE
    film_id IN (SELECT 
            fc.film_id
        FROM
            film_category fc
                INNER JOIN
            category c ON fc.category_id = c.category_id
        WHERE
            c.name = 'Action');
            
-- Exercise 9-2: rewrite the query from 1st exercise using correlated subquery angainst the category and film_categiry tables to achieve the same results

SELECT 
    title
FROM
    film f
WHERE
    EXISTS( SELECT 
            1
        FROM
            film_category fc
                INNER JOIN
            category c ON c.category_id = fc.category_id
        WHERE
            fc.film_id = f.film_id
                AND c.name = 'Action');
                
-- Exercise 9-3 Join the following subquery against the film_actor table to show the level of each actor.
-- The subquery against the film_actor table should count the number of rows for each actor using group by actor_id, and the count should be compared to the min_roles/max_roles columns to determine which level each actor belongs to 

SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
UNION ALL 
SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
UNION ALL 
SELECT 'Newcomer' level, 1 min_roles, 19 max_roles;

SELECT 
    level_grps.level, COUNT(*) tot_actors
FROM
    (SELECT 
        actor_id, COUNT(*) num_actors
    FROM
        film_actor
    GROUP BY actor_id) actr
        INNER JOIN
    (SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles UNION ALL SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles UNION ALL SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) level_grps ON actr.num_actors BETWEEN level_grps.min_roles AND level_grps.max_roles
GROUP BY level_grps.level;




