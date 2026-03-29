truncate mart.top_products_30d;

insert into mart.top_products_30d (
    product_id,
    product_name,
    category,
    total_revenue_30d,
    units_sold_30d,
    rank_in_category,
    is_top10_overall,
    updated_at
)
with base as(
    select p.product_id,
            p.product_name,
            p.category,
        sum(s.revenue) as total_revenue_30d,
        sum(case when not s.is_return then s.quantity else 0 end) as units_sold_30d
    from core.sales s
    join core.products p ON s.product_id = p.product_id
    where s.sale_date >= '{{ ds }}'::date - interval '30 day'
    group by 
        p.product_id,
        p.product_name,
        p.category
),

ranked AS (
    SELECT *,
        RANK() OVER (
            PARTITION BY category
            ORDER BY total_revenue_30d DESC
        ) AS rank_in_category,

        RANK() OVER (
            ORDER BY total_revenue_30d DESC
        ) AS overall_rank
    FROM base
)

SELECT
    product_id,
    product_name,
    category,
    total_revenue_30d,
    units_sold_30d,
    rank_in_category,
    (overall_rank <= 10) AS is_top10_overall,
    NOW() AS updated_at
from ranked;