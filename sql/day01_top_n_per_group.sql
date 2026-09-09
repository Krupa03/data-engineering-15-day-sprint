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


-- Problem 2 — Second highest distinct salary:
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 1;


-- Problem 3 — Running total:
SELECT
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales;


-- Problem 4 — Moving average:
SELECT
    sale_date,
    amount,
    ROUND(AVG(amount) OVER(
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg
FROM sales;


-- Problem 5 — Deduplication:
WITH RankedCustomers AS (
    SELECT 
        id, 
        name, 
        email, 
        created_at,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at DESC) as rn
    FROM customers
)
SELECT id, name, email, created_at
FROM RankedCustomers
WHERE rn = 1;


-- Problem 6 — Month-over-month growth:
WITH MoM AS (
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS prev_revenue
    FROM monthly_revenue
)
SELECT
    month,
    revenue,
    prev_revenue,
	ROUND(((revenue - prev_revenue) * 100.0 / prev_revenue), 2) AS growth_pct
FROM MoM;


-- Problem 7 — Consecutive dates:
WITH ranked_logins AS (
    -- Step 1: Give each login a sequence number per user
    SELECT 
        user_id,
        login_date,
        ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY login_date) as rn
    FROM user_logins
),
grouped_logins AS (
    -- Step 2: Subtract the row number from the date to find constant groups
    SELECT 
        user_id,
        login_date - CAST(rn AS INT) AS date_group
    FROM ranked_logins
)
-- Step 3: Keep only the users who have at least 3 matching group dates
SELECT user_id
FROM grouped_logins
GROUP BY user_id, date_group
HAVING COUNT(*) >= 3;
