# Day 14 - Kafka + Spark Structured Streaming

from pyspark.sql import SparkSession
from pyspark.sql.functions import from_json, col
from pyspark.sql.types import StructType, StringType, IntegerType, DoubleType

spark = SparkSession.builder.appName("KafkaStreaming").getOrCreate()

# Read from Kafka topic
df = spark \
    .readStream \
    .format("kafka") \
    .option("kafka.bootstrap.servers", "localhost:9092") \
    .option("subscribe", "orders") \
    .load()

# Define schema
schema = StructType() \
    .add("order_id", IntegerType()) \
    .add("customer_id", IntegerType()) \
    .add("amount", DoubleType()) \
    .add("status", StringType())

# Parse JSON messages
orders_df = df.select(
    from_json(col("value").cast("string"), schema).alias("data")
).select("data.*")

# Write to Delta Lake (Bronze)
query = orders_df.writeStream \
    .format("delta") \
    .option("checkpointLocation", "/checkpoints/kafka_orders") \
    .outputMode("append") \
    .start("/delta/bronze/orders")

query.awaitTermination()
