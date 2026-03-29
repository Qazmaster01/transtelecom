CREATE SCHEMA IF NOT EXISTS core;


drop table if EXISTS core.stores;
drop table if EXISTS core.products;
drop table if EXISTS core.customers;
drop table if EXISTS core.sales;
 

-- SALES (clean + enriched)
CREATE TABLE core.sales (
    sale_id BIGINT PRIMARY KEY,
    store_id INTEGER,
    product_id INTEGER,
    customer_id INTEGER,

    quantity INTEGER,
    unit_price NUMERIC(10,2),
    discount_pct NUMERIC(5,2),

    payment_type VARCHAR(20),
    sale_ts TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,

    revenue NUMERIC(14,2),
    is_return BOOLEAN,
    sale_date DATE
);

-- PRODUCTS
CREATE TABLE core.products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    category TEXT,
    subcategory TEXT,
    cost_price NUMERIC(10,2),
    updated_at TIMESTAMP
);

-- CUSTOMERS
CREATE TABLE core.customers (
    customer_id INTEGER PRIMARY KEY,
    loyalty_tier TEXT,
    phone TEXT,
    updated_at TIMESTAMP
);

-- STORES
create table core.stores as    
select *
FROM staging.stores;

-- INDEXES (важно для perf)
CREATE INDEX idx_sales_date ON core.sales (sale_date);
CREATE INDEX idx_sales_store ON core.sales (store_id);
CREATE INDEX idx_sales_product ON core.sales (product_id);