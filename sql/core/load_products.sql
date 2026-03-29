
insert into  core.products (
    product_id,
    product_name,
    category,
    subcategory,
    cost_price
)
select 
    product_id,
    trim(product_name),
    lower(trim(category)),
    lower(trim(subcategory)),
    cost_price
from staging.products

on conflict (product_id)
do update set
    product_name = EXCLUDED.product_name,
    category = EXCLUDED.category,
    subcategory = EXCLUDED.subcategory,
    cost_price = EXCLUDED.cost_price;