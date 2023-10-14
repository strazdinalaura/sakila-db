
CREATE TABLE string_tbl (
    char_fld CHAR(30),
    vchar_fld VARCHAR(30),
    text_fld TEXT
);


-- String Generation
INSERT INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This is char data', 'This is varchar data', 'This is text data');


UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long varchar data';


SELECT @@session.sql_mode;


SET sql_mode='ansi';


SELECT @@session.sql_mode;


SHOW WARNINGS;


SELECT vchar_fld FROM string_tbl;


UPDATE string_tbl
SET vchar_fld = 'This is a piece of extremely long varchar data';


-- Including single quotes
-- 👇 escape single quote
UPDATE string_tbl
SET text_fld = 'This string doesn''t work';


SELECT text_fld FROM string_tbl;


-- 👇 retrieve via built-in function
SELECT quote(text_fld)
FROM string_tbl;


-- Including special characters
-- 👇 retrieves typed string and its equivalent
SELECT 'abcdefg', CHAR(97,98,99,100,101,102,103);


-- 👇 retrieves special characters (check layout first)
SELECT CHAR(128,129,130,131,132,133,134,135,136,137);


-- 👇 check layout for ö special character
SELECT ASCII('ö');


-- String Manipulation
-- 👇 reset table
DELETE FROM string_tbl;


INSERT INTO string_tbl(char_fld, vchar_fld, text_fld)
VALUES ('This string is 28 characters', 'This string is 28 characters', 'This string is 28 characters');


-- String functions that return numbers
SELECT 
    LENGTH(char_fld) char_length,
    LENGTH(vchar_fld) vchar_length,
    LENGTH(text_fld) text_length
FROM
    string_tbl;
    
    
-- 👇 find position at which 'characters' appears
SELECT 
    POSITION('characters' IN vchar_fld)
FROM
    string_tbl;
-- 💡 It doesn't count the total number of characters in the string; it only tells you where the specified substring begins in the string.

    
-- 👇 search at something other than the first character
SELECT LOCATE('is', vchar_fld, 5)
FROM string_tbl;
-- 💡 counts empty spaces (whitespace characters) as positions when searching for a substring within a string. In other words, spaces are included in the position count.


-- 👇 comparing strings
DELETE FROM string_tbl;
INSERT INTO string_tbl(vchar_fld)
VALUES ('abc'), ('xyz'), ('QRSTUV'), ('qrstuv'), ('12345');


SELECT 
    vchar_fld
FROM
    string_tbl
ORDER BY char_fld;


SELECT 
    STRCMP('12345', '12345') 12345_12345,
    STRCMP('abcd', 'xyz') abcd_xyz,
    STRCMP('abcd', 'QRSTUV') abcd_QRSTUV,
    STRCMP('qrstuv', 'QRSTUV') qrstuv_QRSTUV,
    STRCMP('12345', 'xyz') 12345_xyz,
    STRCMP('xyz', 'qrstuv') xyz_qrstuv;

-- comparing string in SELECT clause
SELECT 
    name, name LIKE '%y' ends_in_y
FROM
    category;
-- 💡 the result set includes a column named ends_in_y which contains a 1 if the name ends with 'y', and 0 otherwise.


SELECT 
    name, name REGEXP 'y$' ends_in_y
FROM
    category;
-- 💡 The result set includes a column named ends_in_y, which contains a 1 if the regular expression matches (i.e., if the name ends with 'y'), and 0 otherwise.

-- 💡💡 The first query uses the LIKE operator with a wildcard to find names that end with 'y', while the second query uses a regular expression to achieve the same result. The choice between them depends on the complexity of the pattern you need to match.


-- String funstions that return strings
DELETE FROM string_tbl;


INSERT INTO string_tbl (text_fld)
VALUES('This string was 29 characters');


-- 👇 modify the string by adding a phrase on the end, replace data stored in column
UPDATE string_tbl
SET text_fld = CONCAT(text_fld, ', but bow this string is longer');


SELECT text_fld
FROM string_tbl;


-- 👇 build a string from individual pieces of data, generate a narrative string for each customer
SELECT 
    CONCAT(first_name,
            ' ',
            last_name,
            'has been a customer since',
            DATE(create_date)) cust_narrative
FROM
    customer;
    
    
-- 👇 insert or replace characters in a string
SELECT INSERT('goodbye world', 9, 0, 'cruel ') string;
-- 💡 The result is a new string formed by inserting 'cruel ' at position 9 in the original string.


SELECT INSERT('goodbye world', 1, 7, 'hello') string;
-- 💡 The result is a new string formed by replacing the first 7 characters of the original string with 'hello'.


-- 👇 all instances with 'goodbye' will be replaced with 'hello'
SELECT REPLACE('goodbye world', 'goodbye', 'hello')
FROM dual;


-- 👇 modified the original string by replacing the first 5 characters with 'goodbye cruel,' resulting in "goodbye cruel world" as the final output.
SELECT STUFF('hello world', 1, 5, 'goodbye cruel');

-- 👇 the substring 'cruel' is extracted from the input string 'goodbye cruel world' starting at position 9 with a length of 5 characters.
SELECT SUBSTRING('goodbye cruel world', 9, 5);


-- Working with numeric data
SELECT (37 * 59) / (78 - (8 * 6));


-- Performing Arithmetic Functions
-- the remainder of 10 when divided by 4
SELECT MOD(10, 4);

SELECT MOD(22.75, 5);


-- first number raised to the power of the second number
SELECT POW(2, 8);


-- used to determine the exact number of bytes in a certain amount of memory
SELECT 
    POW(2, 10) kilobyte,
    POW(2, 10) megabyte,
    POW(2, 30) gigabyte,
    POW(2, 40) terabyte;
    
    
-- Controlling Number Precision
SELECT CEIL(72.445), FLOOR(72.445);

SELECT CEIL(72.0000001), FLOOR(72.9999999);

SELECT ROUND(72.0909, 1), ROUND(72.0909, 2), ROUND(72.0909, 3);

-- discards unwanted digits without rounding
SELECT TRUNCATE(72.0909, 1), TRUNCATE(72.0909, 2), TRUNCATE(72.0909, 3);

SELECT ROUND(17, -1), TRUNCATE(17, -1);


-- 🕑 Working with Temporal data
SELECT @@global.time_zone, @@session.time_zone;

SET time_zone = 'US/Eastern'; -- returns error, timezone tables need to be created 

-- Generating Temporal Data
UPDATE rental 
SET 
    return_date = '2019-09-17 15:30:00'
WHERE
    rental_id = 99999;


-- String-to-date conversions: convert a value from one data type to another 
SELECT CAST('2009-09-17 15:30:00' AS DATETIME);

SELECT CAST('2019-09-17' AS DATE) date_field,
CAST('108:17:57' AS TIME) time_field;


-- Functions for generating dates: format string along with the date string
UPDATE rental
SET return_date = STR_TO_DATE('September 17, 2019', '%M %d %Y')
WHERE rental_id = 99999;

SELECT current_date(), current_time(), current_timestamp();


-- Manipulating Temporal Data: how to add days or time to the current date/time
SELECT date_add(current_date(), interval 5 day);

UPDATE rental
SET return_date = date_add(return_date, interval '3:27:11' hour_second)
WHERE rental_id = 99999;

UPDATE employee
SET birth_date = date_add(birth_date, interval '9-11' year_month)
WHERE emp_id = 4789;

SELECT last_day('2019-09-17');

-- Temporal functions that return strings: how to extract time or date
SELECT dayname('2019-09-18');

SELECT extract(year from '2019-09-18 22:19:05');

-- Temporal functions that return numbers: determine number of intervals between to dates
SELECT DATEDIFF('2019-09-03', '2019-06-21');

SELECT DATEDIFF('2019-09-03 23:59:59', '2019-06-21 00:00:01');

SELECT DATEDIFF('2019-06-21', '2019-09-03');

-- Conversion Functions
SELECT cast('1456328' as signed integer);



