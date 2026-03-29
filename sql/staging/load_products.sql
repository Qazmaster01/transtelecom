TRUNCATE staging.products;

INSERT INTO staging.products
SELECT *,
       NOW() AS _loaded_at
FROM source.products;