# Day 08 - Spark + PySpark
# Key concepts

# Lazy evaluation - transformations build a DAG, actions trigger execution
# Transformation examples (lazy):
df.filter(df['amount'] > 100)
df.select('customer_id', 'amount')
df.groupBy('customer_id')

# Action examples (triggers execution):
df.count()
df.show()
df.collect()
