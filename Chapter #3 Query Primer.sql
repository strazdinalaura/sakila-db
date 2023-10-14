-- query primer 
SELECT * FROM language;

SELECT language_id, name, last_update
FROM language;

SELECT language_id,
'COMMON' language_usge,
language_id * 3.14155927 lang_pi_value,
upper(name) language_name