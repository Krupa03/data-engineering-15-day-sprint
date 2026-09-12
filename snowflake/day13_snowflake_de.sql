-- Day 13 - Snowflake for Data Engineering

-- Snowpipe - auto ingest from S3
CREATE PIPE orders_pipe
    AUTO_INGEST = TRUE
AS
COPY INTO raw.orders
FROM @my_s3_stage/orders/
FILE_FORMAT = (TYPE = 'CSV');

-- Stream - track changes on staging table
CREATE STREAM orders_stream ON TABLE staging.orders;

-- Task - runs every 15 mins, merges stream data into warehouse
CREATE TASK merge_orders_task
    WAREHOUSE = my_warehouse
    SCHEDULE = '15 MINUTE'
WHEN
    SYSTEM$STREAM_HAS_DATA('orders_stream')
AS
MERGE INTO analytics.orders AS target
USING orders_stream AS source
ON target.order_id = source.order_id
WHEN MATCHED THEN UPDATE SET
    target.amount = source.amount,
    target.status = source.status
WHEN NOT MATCHED THEN INSERT
    (order_id, customer_id, amount, status)
VALUES
    (source.order_id, source.customer_id, source.amount, source.status);

-- Resume task
ALTER TASK merge_orders_task RESUME;

-- Time Travel
SELECT * FROM orders AT (OFFSET => -3600);

-- Zero-copy clone for testing
CREATE TABLE orders_dev CLONE orders;
