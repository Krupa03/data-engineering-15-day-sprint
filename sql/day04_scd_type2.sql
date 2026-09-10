-- Day 04 - SCD Type 2 Example
-- Customer moves from Mumbai to Delhi

-- Before: one active record
-- customer_id | name | city   | start_date | end_date | is_current
-- 1           | John | Mumbai | 2023-01-01 | NULL     | True

-- Step 1: Expire old record
UPDATE customers_history
SET end_date = '2024-09-09', is_current = False
WHERE customer_id = 1 AND is_current = True;

-- Step 2: Insert new record
INSERT INTO customers_history VALUES
(1, 'John', 'Delhi', '2024-09-09', NULL, True);
