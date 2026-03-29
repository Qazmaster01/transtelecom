CREATE SCHEMA IF NOT EXISTS mart;

drop table if EXISTS mart.daily_sales_summary;
drop table if EXISTS mart.top_products_30d;

CREATE TABLE mart.daily_sales_summary (
    report_date DATE,
    store_id INTEGER,
    store_name VARCHAR,
    region VARCHAR,
    category VARCHAR,

    total_revenue NUMERIC(14,2),
    total_returns NUMERIC(14,2),
    net_revenue NUMERIC(14,2),
    total_cost NUMERIC(14,2),
    gross_profit NUMERIC(14,2),
    margin_pct NUMERIC(6,2),

    transactions_count INTEGER,
    returns_count INTEGER,
    units_sold INTEGER,
    avg_discount_pct NUMERIC(5,2),

    updated_at TIMESTAMP
);

CREATE INDEX idx_mart_daily_date ON mart.daily_sales_summary (report_date);


CREATE TABLE mart.top_products_30d (
    product_id INTEGER,
    product_name TEXT,
    category TEXT,

    total_revenue_30d NUMERIC(14,2),
    units_sold_30d INTEGER,

    rank_in_category INTEGER,
    is_top10_overall BOOLEAN,

    updated_at TIMESTAMP
);

CREATE INDEX idx_top_products_category ON mart.top_products_30d (category);