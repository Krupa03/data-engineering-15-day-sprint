-- Day 01 - Advanced SQL
-- Problem 1: Top N per group
-- Get top 2 orders by amount for each customer

WITH RankedOrders AS (
    SELECT
        customer_id,
        product,
        amount,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY amount DESC) as rank_num
    FROM orders
)
SELECT
    customer_id,
    product,
    amount
FROM RankedOrders
WHERE rank_num <= 2;
