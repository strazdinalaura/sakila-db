-- 12-1: generate a unit of work to transfer $50 from account 123 to account 789. 
-- Insert two rows into transactions table and update two rows in the account table.

START TRANSACTION;

INSERT INTO transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1003, now(), 123, 'D', 50);

INSERT INTO transaction (txn_id, txn_date, account_id, txn_type_cd, amount)
VALUES (1004, now(), 123, 'C', 50);

UPDATE account
SET avail_balance = avail_balance - 50,
last_activity_date = now()
WHERE account_id = 123;

UPDATE account
SET avail_balance = avail_balance + 50,
last_activity_date = now()
WHERE account_id = 789;

COMMIT;