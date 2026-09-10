# Day 07 - dbt + Analytics Engineering

## ref() function
- Links models dynamically instead of hardcoding table names
- Builds dependency DAG automatically
- Separates dev and prod environments

## Model types
- Full refresh: rebuilds entire table from scratch. Use for small tables or when historical data changes.
- Incremental: appends only new rows since last run. Use for large tables where full rebuild is too slow.

## dbt model layers
raw → staging → intermediate → mart

## Tests
- not_null
- unique
- relationships
- accepted_values
