# Day 09 - Spark Optimization Checklist
# When a PySpark job takes 2+ hours:

# 1. Check data skew - look at Spark UI for slow tasks
# Fix: broadcast small tables
from pyspark.sql.functions import broadcast
df_joined = large_df.join(broadcast(small_df), 'key')

# 2. Tune shuffle partitions
spark.conf.set("spark.sql.shuffle.partitions", "400")

# 3. Replace UDFs with native functions
from pyspark.sql import functions as f
df = df.withColumn('upper_name', f.upper(f.col('name')))

# 4. Cache reused DataFrames
df.cache()
# ... reuse df multiple times ...
df.unpersist()

# 5. Review resource allocation
# spark.executor.memory, spark.executor.cores
# Avoid GC overhead and disk spilling
