-- Day 12 - Snowflake Fundamentals

-- Create and manage virtual warehouse
CREATE WAREHOUSE my_warehouse
    WAREHOUSE_SIZE = 'SMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

-- Create database and schema
CREATE DATABASE ecommerce_db;
CREATE SCHEMA ecommerce_db.raw;

-- Create table
CREATE TABLE ecommerce_db.raw.orders (
    order_id INT,
    customer_id INT,
    amount DECIMAL(10,2),
    order_date DATE
);

-- Load data using COPY INTO
COPY INTO ecommerce_db.raw.orders
FROM @my_stage/orders.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Time Travel
SELECT * FROM orders AT (OFFSET => -60*60); -- 1 hour ago
SELECT * FROM orders BEFORE (STATEMENT => '<query_id>');

-- Zero-copy cloning
CREATE TABLE orders_backup CLONE orders;
