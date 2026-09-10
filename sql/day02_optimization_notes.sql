-- Day 02 - SQL Optimization
-- Scenario: 500M-row orders table, query takes 20 minutes

-- Original slow query:
-- SELECT * FROM orders WHERE YEAR(order_date) = 2024 AND status = 'completed'

-- Fix 1: Remove function from date column to allow index usage
SELECT order_id, customer_id, status, order_date
FROM orders
WHERE order_date >= '2024-01-01' 
AND order_date < '2025-01-01'
AND status = 'completed';

-- Fix 2: Create composite index on filtering columns
CREATE INDEX idx_status_date ON orders (status, order_date);

-- Fix 3: Replace SELECT * with specific columns
-- SELECT * forces the DB to fetch every column, including unused ones
-- Always select only what you need
