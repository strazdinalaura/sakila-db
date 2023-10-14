-- 11 - 1: rewrite query so that the same results are acheived using searched case expression
SELECT 
    name,
    CASE
        WHEN name IN ('English' , 'Italian', 'French', 'German') THEN 'latin1'
        WHEN name IN ('Japanese' , 'Mandarin') THEN 'utf8'
        ELSE 'Unknown'
    END character_set
FROM
    language;
    

-- 11-2: rewrite the query so that the result set contains a single row with five columns for each rating: G, PG, PG_13, R, and NC_17
SELECT 
    SUM(CASE
        WHEN rating = 'G' THEN 1
        ELSE 0 
    END) G_rated,
    SUM(CASE
        WHEN rating = 'PG' THEN 1
        ELSE 0
    END) PG_rated,
    SUM(CASE
        WHEN rating = 'PG-13' THEN 1
        ELSE 0
    END) PG13_rated,
    SUM(CASE
        WHEN rating = 'R' THEN 1
        ELSE 0
    END) R_rated,
    SUM(CASE
        WHEN rating = 'NC-17' THEN 1
        ELSE 0
    END) NC_17_rated
FROM
    film;