-- TRUNCATE staging.stores;

INSERT INTO staging.stores
SELECT *,
       NOW() AS _loaded_at
FROM source.stores;


DELETE FROM source.sales WHERE sale_id IN (1049, 1050);