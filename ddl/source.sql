CREATE SCHEMA IF NOT EXISTS source;

CREATE TABLE source.stores (
 store_id INTEGER PRIMARY KEY,
 store_name VARCHAR(255) NOT NULL,
 city VARCHAR(100) NOT NULL,
 region VARCHAR(100) NOT NULL,
 opened_date DATE NOT NULL,
 manager VARCHAR(255),
 is_active BOOLEAN NOT NULL DEFAULT true,
 updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.products
CREATE TABLE source.products (
 product_id INTEGER PRIMARY KEY,
 product_name VARCHAR(255) NOT NULL,
 category VARCHAR(100) NOT NULL,
 subcategory VARCHAR(100),
 barcode VARCHAR(50),
 cost_price NUMERIC(10,2) NOT NULL,
 is_active BOOLEAN NOT NULL DEFAULT true,
 updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.customers
CREATE TABLE source.customers (
 customer_id INTEGER PRIMARY KEY,
 full_name VARCHAR(255),
 phone VARCHAR(30),
 loyalty_tier VARCHAR(20),
 registered_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.sales
CREATE TABLE source.sales (
 sale_id BIGINT NOT NULL,
 store_id INTEGER NOT NULL,
 product_id INTEGER NOT NULL,
 customer_id INTEGER,
 quantity INTEGER NOT NULL,
 unit_price NUMERIC(10,2) NOT NULL,
 discount_pct NUMERIC(5,2),
 payment_type VARCHAR(20),
 sale_ts TIMESTAMP NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT NOW()
);
