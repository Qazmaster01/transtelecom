TRUNCATE staging.customers;

INSERT INTO staging.customers
SELECT *,
       NOW() AS _loaded_at
FROM source.customers;