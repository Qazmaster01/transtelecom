truncate core.customers;

insert into core.customers (
    customer_id,
    loyalty_tier,
    phone,
    updated_at
)
select
    customer_id,
    lower(trim(loyalty_tier)) as loyalty_tier,
    phone,
    NOW() as updated_at
from (
    select *,
           row_number() over (partition by customer_id order by registered_at desc, _loaded_at desc ) as rn
    from staging.customers
) t
where rn = 1

on conflict (customer_id)
do update set
    loyalty_tier = EXCLUDED.loyalty_tier,
    phone = EXCLUDED.phone,
    updated_at = NOW();