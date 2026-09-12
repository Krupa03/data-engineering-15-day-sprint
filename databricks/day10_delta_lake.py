# Day 10 - Databricks + Delta Lake

# Create Delta table
df.write.format("delta").save("/delta/orders")

# MERGE (upsert)
from delta.tables import DeltaTable
delta_table = DeltaTable.forPath(spark, "/delta/orders")
delta_table.alias("target").merge(
    updates_df.alias("source"),
    "target.order_id = source.order_id"
).whenMatchedUpdateAll().whenNotMatchedInsertAll().execute()

# Time Travel
df_v0 = spark.read.format("delta").option("versionAsOf", 0).load("/delta/orders")
df_yesterday = spark.read.format("delta").option("timestampAsOf", "2024-01-01").load("/delta/orders")

# Schema enforcement - Delta rejects writes with wrong schema
# Schema evolution - explicitly allow new columns
df.write.format("delta").option("mergeSchema", "true").save("/delta/orders")
