delete from mart.daily_sales_summary
where report_date = '{{ ds }}'::date - 1;

insert into mart.daily_sales_summary (
    report_date,
    store_id,
    store_name,
    region,
    category,
    total_revenue,
    total_returns,
    net_revenue,
    total_cost,
    gross_profit,
    margin_pct,
    transactions_count,
    returns_count,
    units_sold,
    avg_discount_pct,
    updated_at
)
select s.sale_date as report_date,
    s.store_id,
    st.store_name,
    st.region,
    p.category,
    sum(case when not s.is_return then s.revenue else 0 end) as total_revenue,
    abs(sum(case when s.is_return then s.revenue else 0 end)) as total_returns,
    sum(s.revenue) as net_revenue,
    sum(abs(s.quantity) * p.cost_price) as total_cost,
    sum(s.revenue) - sum(abs(s.quantity) * p.cost_price) as gross_profit,
    round((sum(s.revenue) - sum(abs(s.quantity) * p.cost_price)) / nullif(sum(s.revenue), 0) * 100, 2 ) as margin_pct,
    COUNT(*) filter (where not s.is_return) as transactions_count,
    COUNT(*) filter (where s.is_return) as returns_count,
    sum(case when not s.is_return then s.quantity else 0 end) as units_sold,
    avg(s.discount_pct) filter (where s.discount_pct > 0) as avg_discount_pct,
    NOW() as updated_at
from core.sales s
join core.stores st on s.store_id = st.store_id
join core.products p on s.product_id = p.product_id
where s.sale_date = '{{ ds }}'::date - 1
group by 
    s.sale_date,
    s.store_id,
    st.store_name,
    st.region,
    p.category;