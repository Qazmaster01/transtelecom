

INSERT INTO staging.sales
SELECT *,
       NOW() AS _loaded_at
FROM source.sales
WHERE sale_ts::date = '{{ ds }}'::date - 1;


SELECT COUNT(*) FROM staging.sales;