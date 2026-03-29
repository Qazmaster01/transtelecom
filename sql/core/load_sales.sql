
truncate core.sales;

insert into core.sales (
    sale_id,
    sale_ts,
    sale_date,
    customer_id,
    product_id,
    store_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    is_return,
    created_at
)
select
    sale_id,
    sale_ts,
    sale_ts::date AS sale_date,
    customer_id,
    product_id,
    store_id,
    quantity,
    unit_price,
    case
        when discount_pct is null then 0
        when discount_pct < 0 then 0
        when discount_pct > 100 then 100
        else discount_pct
    end as discount_pct,
    quantity * unit_price *
    (1 - (
        case
            when discount_pct is null then 0
            when discount_pct < 0 then 0
            when discount_pct > 100 then 100
            else discount_pct
        end
    ) / 100.0) as revenue,

    (quantity < 0) as is_return,

    NOW() as created_at

from (
    select *, 
            ROW_NUMBER() OVER ( PARTITION BY sale_id ORDER BY _loaded_at DESC ) AS rn
    from staging.sales
    where sale_ts::date = current_Date - 1
) t

where rn = 1 and quantity <> 0

on conflict (sale_id)
do update set
    sale_ts = EXCLUDED.sale_ts,
    sale_date = EXCLUDED.sale_date,
    customer_id = EXCLUDED.customer_id,
    product_id = EXCLUDED.product_id,
    store_id = EXCLUDED.store_id,
    quantity = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    discount_pct = EXCLUDED.discount_pct,
    revenue = EXCLUDED.revenue,
    is_return = EXCLUDED.is_return,
    created_at = NOW();