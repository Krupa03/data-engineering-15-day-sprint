# Day 11 - Medallion Architecture + Auto Loader

# Bronze - raw ingestion with Auto Loader
bronze_df = (spark.readStream
    .format("cloudFiles")
    .option("cloudFiles.format", "csv")
    .option("cloudFiles.schemaLocation", "/schema/bronze")
    .load("/raw/orders/"))

bronze_df.writeStream \
    .format("delta") \
    .option("checkpointLocation", "/checkpoints/bronze") \
    .start("/delta/bronze/orders")

# Silver - clean and deduplicate
from pyspark.sql.functions import row_number
from pyspark.sql.window import Window

silver_df = spark.read.format("delta").load("/delta/bronze/orders")
silver_df = silver_df.dropna(subset=["order_id", "customer_id"])
silver_df = silver_df.dropDuplicates(["order_id"])

silver_df.write.format("delta").mode("overwrite").save("/delta/silver/orders")

# Gold - aggregate for business metrics
from pyspark.sql.functions import sum, count

gold_df = silver_df.groupBy("customer_id").agg(
    sum("amount").alias("total_revenue"),
    count("order_id").alias("total_orders")
)

gold_df.write.format("delta").mode("overwrite").save("/delta/gold/customer_metrics")
