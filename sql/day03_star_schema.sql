-- Day 03 - Data Warehousing + Star Schema Design
-- E-commerce Data Warehouse
-- Grain: one row per product per order

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    day INT,
    month INT,
    quarter INT,
    year INT
);

CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    region VARCHAR(50),
    manager_name VARCHAR(100)
);

CREATE TABLE fact_sales (
    order_id INT,
    customer_id INT REFERENCES dim_customer(customer_id),
    product_id INT REFERENCES dim_product(product_id),
    date_id INT REFERENCES dim_date(date_id),
    store_id INT REFERENCES dim_store(store_id),
    quantity_sold INT,
    total_price DECIMAL(10,2),
    discount_amount DECIMAL(10,2)
);
