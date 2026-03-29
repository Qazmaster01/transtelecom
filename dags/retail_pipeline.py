from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime
from airflow.exceptions import AirflowException
from airflow.operators.python import PythonOperator
from airflow.hooks.base import BaseHook
import logging

def validate_staging(**context):
    import psycopg2
    import logging
    from airflow.exceptions import AirflowException

    conn = psycopg2.connect(
        host="postgres",
        dbname="krisha",
        user="postgres",
        password="asdnmk",
        port=5432
    )

    cur = conn.cursor()

    warnings = {
        "qty_warnings": 0,
        "qty_duplicates": 0,
        "qty_bad_discounts": 0
    }

    cur.execute("""
        select COUNT(*)
        from staging.sales
        where sale_ts::date = current_Date - 1
    """)
    rows = cur.fetchone()[0]
    if rows == 0:
        raise AirflowException("Строк за вчера в staging.sales равен к 0")

    cur.execute("""
        select COUNT(*)
        from staging.sales s
        left join staging.stores st on s.store_id = st.store_id
        where st.store_id is null
    """)
    invalid_store = cur.fetchone()[0]
    if invalid_store > 0:
        raise AirflowException(f"Нет store_id не из staging.stores")

    cur.execute("""
        select count(*)
        from staging.sales s
        left join staging.products p on s.product_id = p.product_id
        where p.product_id IS NULL
    """)
    invalid_product = cur.fetchone()[0]

    if invalid_product < 0:
        raise AirflowException(f"Нет product_id не из staging.products")

    cur.execute("""
        select COUNT(*)
        from staging.sales
        where unit_price <= 0
    """)
    bad_price = cur.fetchone()[0]
    if bad_price > 0:
        raise AirflowException(f"Нет unit_price <= 0")

    cur.execute("""
        select COUNT(*)
        from staging.sales
        where discount_pct between 0 and 100 or discount_pct is null
    """)
    bad_discount = cur.fetchone()[0]
    warnings["qty_bad_discounts"] = bad_discount

    if bad_discount > 0:
        logging.warning(f"Проверка не прошел по колонке discount_pct")
        warnings["qty_warnings"] += 1

    cur.execute("""
        select avg( case when customer_id is null then 1 else 0 end)
        from staging.sales
        where sale_ts::date = current_Date - 1
    """)
    null_ratio = cur.fetchone()[0] or 0
    if null_ratio > 0.6:
        logging.warning(f"доля null = {null_ratio}")
        warnings["qty_warnings"] += 1

    cur.execute("""
        select count(*)
        from ( select sale_id
                from staging.sales
                where sale_ts::date = current_Date - 1
                group by  sale_id
                having count(*) > 1
        ) t
    """)
    dup = cur.fetchone()[0]
    warnings["qty_duplicates"] = dup
    if dup > 0:
        logging.warning(f"Есть дубликаты= {dup}")
        warnings["qty_warnings"] += 1
        
    cur.execute("""
        select COUNT(*)
        from staging.products
        where cost_price <= 0
    """)
    cost_bad = cur.fetchone()[0]

    if cost_bad > 0:
        logging.warning(f"cost_price меньеш или равен к 0 = {cost_bad}")
        warnings["qty_warnings"] += 1

    context["ti"].xcom_push(
        key="validation_metrics",
        value=warnings
    )

    cur.close()
    conn.close()



def pipeline_success_log(**context):
    ti = context["ti"]

    metrics = ti.xcom_pull(
        task_ids="validate_staging",
        key="validation_metrics"
    )

    if not metrics:
        logging.warning("Нету метрики ваоидаций в XCOM")
        return

    logging.info("Пайплайм отработал")
    logging.info(f"Предупреждение: {metrics['qty_warnings']}")
    logging.info(f"Дубликаты: {metrics['qty_duplicates']}")
    logging.info(f"Bad discounts: {metrics['qty_bad_discounts']}")
    logging.info("============================")
    
    
def on_failure_callback(context):
    task = context.get("task_instance")
    dag_id = context.get("dag").dag_id
    task_id = task.task_id

    logging.error("Ошибка пайплайна")
    logging.error(f"Даг: {dag_id}")
    logging.error(f"Таск: {task_id}")
    logging.error(f"Дата: {context.get('execution_date')}")    



with DAG(
    dag_id="retail_pipeline",
    template_searchpath=["/opt/airflow/sql", "/opt/airflow/data"],
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,  
    catchup=False,
    on_failure_callback=on_failure_callback   
) as dag:

    create_staging_ddl = PostgresOperator(
        task_id="create_staging_ddl",
        postgres_conn_id="postgres_default",
        sql="ddl/staging.sql"
    )

    create_core_ddl = PostgresOperator(
        task_id="create_core_ddl",
        postgres_conn_id="postgres_default",
        sql="ddl/core.sql"
    )

    create_mart_ddl = PostgresOperator(
        task_id="create_mart_ddl",
        postgres_conn_id="postgres_default",
        sql="ddl/mart.sql"
    )
    
    load_source = PostgresOperator(
        task_id="load_source",
        postgres_conn_id="postgres_default",
        sql="seed_source.sql"
    )   

    load_staging_sales = PostgresOperator(
        task_id="load_staging_sales",
        postgres_conn_id="postgres_default",
        sql="staging/load_sales.sql"
    )

    load_staging_products = PostgresOperator(
        task_id="load_staging_products",
        postgres_conn_id="postgres_default",
        sql="staging/load_products.sql"
    )

    load_staging_customers = PostgresOperator(
        task_id="load_staging_customers",
        postgres_conn_id="postgres_default",
        sql="staging/load_customers.sql"
    )

    load_staging_stores = PostgresOperator(
        task_id="load_staging_stores",
        postgres_conn_id="postgres_default",
        sql="staging/load_stores.sql"
    )    
      
    
    
    
    
    load_core_sales = PostgresOperator(
        task_id="load_core_sales",
        postgres_conn_id="postgres_default",
        sql="core/load_sales.sql"
    )

    load_core_products = PostgresOperator(
        task_id="load_core_products",
        postgres_conn_id="postgres_default",
        sql="core/load_products.sql"
    )

    load_core_customers = PostgresOperator(
        task_id="load_core_customers",
        postgres_conn_id="postgres_default",
        sql="core/load_customers.sql"
    )    
    
    load_core_stores = PostgresOperator(
        task_id="load_core_stores",
        postgres_conn_id="postgres_default",
        sql="core/load_stores.sql"
    )    
    
    load_mart_daily_sales_summary = PostgresOperator(
        task_id="load_mart_daily_sales_summary",
        postgres_conn_id="postgres_default",
        sql="mart/daily_sales_summary.sql"
    )

    load_mart_top_products_30d = PostgresOperator(
        task_id="load_mart_top_products_30d",
        postgres_conn_id="postgres_default",
        sql="mart/top_products_30d.sql"
    )        
    
    validate = PythonOperator(
    task_id="validate_staging",
    python_callable=validate_staging
    )
    
    pipeline_log = PythonOperator(
        task_id="pipeline_success_log",
        python_callable=pipeline_success_log
    )    
    
    create_staging_ddl >> create_core_ddl >> create_mart_ddl >> load_source >> [load_staging_products >> load_staging_customers >> load_staging_stores >> load_staging_sales >> load_core_stores]  >> validate >> [load_core_sales, load_core_products, load_core_customers] >> load_mart_daily_sales_summary >> load_mart_top_products_30d >> pipeline_log
    