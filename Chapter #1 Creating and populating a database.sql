-- create person table 
CREATE TABLE person
( person_id SMALLINT UNSIGNED,
fname VARCHAR(20),
lname VARCHAR(20),
eye_color ENUM('BR','BL','GR'),
birth_date DATE,
street VARCHAR(30),
city VARCHAR(20),
state VARCHAR(20),
country VARCHAR(20),
postal_code VARCHAR(20),
CONSTRAINT pk_person PRIMARY KEY (person_id)
);

desc person;


-- create favorite food table
CREATE TABLE favorite_food
(person_id SMALLINT UNSIGNED,
food VARCHAR(20),
CONSTRAINT pk_favorite_food PRIMARY KEY (person_id, food), #2-column Primary key, guarantess uniqueness in the table; won't be able to create another row value for the same person_id record
CONSTRAINT fk_fav_food_person_id FOREIGN KEY (person_id) #foreign key constraint
REFERENCES person (person_id)
);


-- if you forget to create FK constraints, you can add it later via alter table statement
desc favorite_food;


-- need to disable THE FK constraint on the favorite_food table table, then re-enable constraints
SET foreign_key_checks = 0;
ALTER TABLE person	
	MODIFY person_id SMALLINT UNSIGNED AUTO_INCREMENT;
SET foreign_key_checks=1;

DESC person;


-- Insert a new row into the person table
INSERT INTO person 
	(fname, lname, eye_color, birth_date)
VALUES ('Willian', 'Turner', 'BR', '1997-05-27');

SELECT person_id, fname, lname, birth_date
FROM person
WHERE person_id=1;


-- insert values into favorite_food table
INSERT INTO favorite_food (person_id, food)
VALUES (1, 'pizza');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'cookies');

INSERT INTO favorite_food (person_id, food)
VALUES (1, 'nachos');

SELECT food
FROM favorite_food
WHERE person_id=1
ORDER BY food;


-- insert values into person table
INSERT INTO person 
	(person_id,fname, lname, eye_color, birth_date, street, city, state, country, postal_code)
VALUES (null,'Susan', 'Smith', 'BL', '1975-11-02', '23 Maple St', 'Arlington', 'VA', 'USA', '20220');

SELECT person_id, fname, lname, birth_date
	FROM person;
    

-- UPDATE DATA STATEMENT
UPDATE person 
SET 
    street = '1225 Tremont St.',
    city = 'Boston',
    state = 'MA',
    country = 'USA',
    postal_code = '02138'
WHERE person_id=1;

-- DELETE DATA STATEMENT
DELETE FROM person
WHERE person_id=2;

-- NONEXISTENT FOREIGN KEY; favorite_food table is a child table (can not insert values that do not exist in person table)
INSERT INTO favorite_food (person_id, food)
VALUES (999, 'LASAGNA');

-- DATE CONVERSIONS
UPDATE person
SET birth_date = 'DEC-21-1980' -- Incorrect date value
WHERE person_id = 1;

UPDATE person
SET birth_date = str_to_date('DEC-21-1980', '%b-%d-%Y') -- date formatter
WHERE person_id=1;

DROP TABLE favorite_food;
DROP TABLE person;











