# Day 05 - Python for Data Engineering
# Clean customer CSV: duplicates, missing emails, date formats

import pandas as pd

# Step 1: Load
df = pd.read_csv('customers.csv')

# Step 2: Remove duplicates (keep most recent)
df = df.drop_duplicates(subset=['customer_id'], keep='last')

# Step 3: Drop missing emails
df = df.dropna(subset=['email'])

# Step 4: Fix date format
df['signup_date'] = pd.to_datetime(df['signup_date'], errors='coerce')

# Step 5: Save cleaned data
df.to_csv('customers_cleaned.csv', index=False)
