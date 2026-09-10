# Day 06 - ETL/ELT + Airflow
# Basic DAG structure example

from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'email_on_failure': True,
}

with DAG(
    dag_id='etl_pipeline',
    default_args=default_args,
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1),
    catchup=False,
) as dag:

    def extract(): pass
    def transform(): pass
    def load(): pass

    t1 = PythonOperator(task_id='extract_data', python_callable=extract)
    t2 = PythonOperator(task_id='transform_data', python_callable=transform)
    t3 = PythonOperator(task_id='load_data', python_callable=load)

    t1 >> t2 >> t3
