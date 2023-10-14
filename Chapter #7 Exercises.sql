-- Exercise 7-1: query that returns the 17th-25th characters of the string 'Please find the substring in this string'
SELECT substring('Please find the substring in this string', 17, 9);

-- Exercise 7-2: query that returns the absolute value and sign (-1, 0, or 1) of the number -25.76823. Also return the number rounded to the nearest hundredth
SELECT sign('-25.76823'), abs('-25.76823'), round(-25.76823, 2);

-- Exercise 7-3: query that return just the month portion of the current date
SELECT extract(month from current_date());


