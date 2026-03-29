CREATE SCHEMA IF NOT EXISTS source;

drop table if exists source.stores;
drop table if exists source.sales;
drop table if exists source.products;
drop table if exists source.customers;



CREATE TABLE source.stores (
 store_id INTEGER PRIMARY KEY,
 store_name VARCHAR(255) NOT NULL,
 city VARCHAR(100) NOT NULL,
 region VARCHAR(100) NOT NULL,
 opened_date DATE NOT NULL,
 manager VARCHAR(255),
 is_active BOOLEAN NOT NULL DEFAULT true,
 updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.products
CREATE TABLE source.products (
 product_id INTEGER PRIMARY KEY,
 product_name VARCHAR(255) NOT NULL,
 category VARCHAR(100) NOT NULL,
 subcategory VARCHAR(100),
 barcode VARCHAR(50),
 cost_price NUMERIC(10,2) NOT NULL,
 is_active BOOLEAN NOT NULL DEFAULT true,
 updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.customers
CREATE TABLE source.customers (
 customer_id INTEGER PRIMARY KEY,
 full_name VARCHAR(255),
 phone VARCHAR(30),
 loyalty_tier VARCHAR(20),
 registered_at TIMESTAMP NOT NULL DEFAULT NOW()
);
-- source.sales
CREATE TABLE source.sales (
 sale_id BIGINT NOT NULL,
 store_id INTEGER NOT NULL,
 product_id INTEGER NOT NULL,
 customer_id INTEGER,
 quantity INTEGER NOT NULL,
 unit_price NUMERIC(10,2) NOT NULL,
 discount_pct NUMERIC(5,2),
 payment_type VARCHAR(20),
 sale_ts TIMESTAMP NOT NULL,
 created_at TIMESTAMP NOT NULL DEFAULT NOW()
);


truncate source.stores;


INSERT INTO source.stores
 (store_id, store_name, city, region, opened_date, manager, is_active, updated_at)
VALUES
 (1, 'Магазин Центр', 'Алматы', 'Юг', '2019-03-01', 'Иванов А.К.',
true, NOW()),
 (2, 'Магазин Медеу', 'Алматы', 'Юг', '2020-07-15', 'Петрова О.Н.',
true, NOW()),
 (3, 'Магазин Бостандык', 'Алматы', 'Юг', '2021-01-10', 'Сейткали Б.',
true, NOW()),
 (4, 'Магазин Байконыр', 'Астана', 'Север', '2018-11-20', 'Ахметов Д.С.',
true, NOW()),
 (5, 'Магазин Есиль', 'Астана', 'Север', '2020-05-05', 'Кузнецова И.',
true, NOW()),
 (6, 'Магазин Сарыарка', 'Астана', 'Север', '2022-02-14', NULL,
true, NOW()),
 (7, 'Магазин Актобе Главный','Актобе', 'Запад', '2017-06-30', 'Жаксыбеков
Т.',true, NOW()),
 (8, 'Магазин Актобе Северный','Актобе','Запад', '2023-09-01', 'Мухамбетов
А.',true, NOW()),
 (9, 'Магазин Атырау', 'Атырау', 'Запад', '2016-04-18', 'Бекова С.Т.',
false, NOW()-'2 year'::interval),
 (10, 'Магазин Шымкент', 'Шымкент', 'Юг', '2024-01-20', 'Досымбек Р.',
true, NOW());


truncate  source.products;

INSERT INTO source.products
 (product_id, product_name, category, subcategory, barcode, cost_price, is_active,
updated_at)
VALUES
 (101, 'Молоко 1л 3.2%', 'Продукты', 'Молочное', '4600001010101', 120.00,
true, NOW()),
 (102, 'Молоко 2л 2.5%', 'Продукты', 'Молочное', '4600001010102', 210.00,
true, NOW()),
 (103, 'Хлеб белый нарезной', 'Продукты', 'Выпечка', '4600001010103', 60.00,
true, NOW()),
 (104, 'Хлеб ржаной', 'Продукты', 'Выпечка', '4600001010104', 75.00,
true, NOW()),
 (105, ' Йогурт клубника ', 'Продукты', 'Молочное', '4600001010105', 80.00,
true, NOW()),
 (106, 'Кефир 1%', 'Продукты', 'Молочное', NULL, 55.00,
true, NOW()),
 (107, 'Масло сливочное 200г', 'Продукты', 'Молочное', '4600001010107', 290.00,
true, NOW()),
 (108, 'Наушники BT Pro', 'ЭЛЕКТРОНИКА', NULL, '7890001080001',
4500.00, true, NOW()),
 (109, 'Смартфон X12', 'Электроника', NULL, '7890001090001',
45000.00, true, NOW()),
 (110, 'Кабель USB-C 1м', 'Электроника', 'Аксессуары','7890001100001', 350.00,
true, NOW()),
 (111, 'Зарядное устройство', 'Электроника', 'Аксессуары','7890001110001', 600.00,
true, NOW()),
 (112, 'Шампунь 400мл', 'Гигиена', 'Волосы', '5000001120001', 180.00,
true, NOW()),
 (113, 'Зубная паста 100г', 'Гигиена', 'Зубы', '5000001130001', 95.00,
true, NOW()),
(114, 'Гель для душа 250мл', 'ГИГИЕНА', 'Тело', '5000001140001', 130.00,
true, NOW()),
 (115, 'Вода питьевая 1.5л', 'Напитки', NULL, '3000001150001', 0.00,
true, NOW()),
 (116, 'Сок апельсиновый 1л', 'Напитки', NULL, '3000001160001', 145.00,
true, NOW()),
 (117, 'Чай чёрный 100г', 'Напитки', NULL, '3000001170001', 220.00,
true, NOW()),
 (118, 'Кофе растворимый 90г', 'Напитки', NULL, '3000001180001', 380.00,
true, NOW()),
 (119, 'Пакет фирменный', 'Прочее', NULL, NULL, -5.00,
true, NOW()),
 (120, 'Подарочная карта 5000', 'Прочее', NULL, NULL,
5000.00, false, NOW());


truncate source.customers;

INSERT INTO source.customers
 (customer_id, full_name, phone, loyalty_tier, registered_at)
VALUES
 (1, 'Алиев Марат Серикович', '+7 701 123 4567', 'gold', '2019-05-10 10:00:00'),
 (2, 'Петрова Анна Ивановна', '87772345678', 'silver', '2020-01-15 12:30:00'),
 (3, 'Сейткали Берик', '8 (727) 345-67-89','bronze','2021-03-20 09:15:00'),
 (4, 'Омарова Гульнар', '+7 705 456 7890', 'silver', '2020-08-05 14:00:00'),
 (5, 'Ким Владимир', '+7 747 567 8901', 'gold', '2018-11-22 16:45:00'),
 (6, NULL, NULL, 'bronze', '2022-06-01 08:00:00'),
 (7, 'Жаксыбеков Тимур', '701-678-90-12', 'gold', '2019-02-14 11:20:00'),
 (8, 'Нурланова Айгерим', '+7 708 789 0123', NULL, '2023-01-10 13:00:00'),
 (9, 'Смирнов Павел', '+7 776 890 1234', 'bronze', '2022-09-30 15:30:00'),
 (10, 'Бекова Сауле', '+7 700 901 2345', 'silver', '2021-07-18 10:10:00'),
 (11, 'Дюсенов Азамат', '+7 702 012 3456', 'SILVER', '2020-04-25 09:00:00'),
 (12, 'Калиева Дина', '+7 771 123 4568', 'bronze', '2023-05-15 14:30:00'),
 (13, 'Ахметов Данияр', '+7 777 234 5679', 'gold', '2019-12-01 16:00:00'),
 (14, 'Рысбекова Камила', '+7 707 345 6780', NULL, '2024-02-10 11:45:00'),
 (15, 'Байжанов Ерлан', '+7 747 456 7891', 'silver', '2022-11-08 08:30:00');

truncate source.sales;

INSERT INTO source.sales
 (sale_id, store_id, product_id, customer_id, quantity, unit_price,
 discount_pct, payment_type, sale_ts, created_at)
VALUES
-- ── ДЕНЬ -2 (позавчера) ──────────────────────────────────────────
 (1001, 1, 101, 1, 3, 155.00, 5.00, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1001, 1, 101, 1, 3, 155.00, 5.00, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval), -- ДУБЛЬ!
 (1002, 1, 108, NULL,1,5999.00, 10.00, 'QR', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1003, 2, 103, 77, 5, 90.00, 0.00, 'Наличные', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1004, 2, 116, 12, 2, 165.00, NULL, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1005, 3, 107, 5, 1, 340.00, 3.00, 'QR', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1006, 3, 113, 8, 4, 115.00, NULL, 'Наличные', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1007, 4, 109, 7, 1,52000.00, 8.00, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1008, 4, 110, 13, 3, 450.00, 5.00, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1009, 5, 102, 2, 4, 250.00, NULL, 'QR', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1010, 5, 115, 10, 6, 35.00, 0.00, 'Наличные', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1011, 6, 117, 4, 2, 270.00, NULL, 'QR', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1012, 7, 112, 9, 1, 220.00, 10.00, 'Карта', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1013, 8, 118, 15, 3, 450.00, 5.00, 'Наличные', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
 (1014,10, 104, 6, 2, 95.00, NULL, 'QR', NOW()-'2 days'::interval,
NOW()-'2 days'::interval),
-- ── ДЕНЬ -1 (вчера) — основной тестовый день ────────────────────
 (1015, 1, 101, 1, 5, 155.00, 5.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1016, 1, 103, 3, 3, 90.00, 0.00, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1017, 1, 108, NULL,1,5999.00, 15.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1018, 1, 101, 2, -1, 155.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval), -- ВОЗВРАТ
 (1019, 2, 109, 13, 1,52000.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1020, 2, 116, 4, 3, 165.00, NULL, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1021, 2, 102, 5, 2, 250.00, 10.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1022, 3, 107, 10, 1, 340.00, NULL, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1023, 3, 112, 8, 2, 220.00, 5.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1024, 3, 113, 14, 5, 115.00, NULL, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1025, 4, 106, 6, 10, 70.00,150.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval), -- discount > 100!
 (1026, 4, 117, 7, 1, 270.00, 0.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1027, 4, 110, 11, 4, 450.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1028, 5, 105, 1, 3, 100.00, NULL, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1029, 5, 118, 9, 2, 450.00, 3.00, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1030, 5, 115, 12, 12, 35.00, 0.00, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1031, 6, 104, 3, 6, 95.00, NULL, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1032, 6, 109, 5, -1,52000.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval), -- ВОЗВРА
 (1033, 7, 111, 15, 2, 750.00, 8.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1034, 7, 116, 4, 4, 165.00, NULL, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1035, 7, 112, 13, 1, 220.00, 12.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1036, 8, 101, 2, 8, 155.00, 5.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1037, 8, 103, NULL,4, 90.00, 0.00, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1038, 8, 117, 7, 3, 270.00, NULL, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1039,10, 108, 1, 1,5999.00, 10.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1040,10, 113, 8, 2, 115.00, NULL, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1041,10, 102, 10, 3, 250.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1042, 1, 107, 6, 1, 340.00, NULL, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1043, 2, 111, 14, 1, 750.00, 5.00, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1044, 3, 118, 15, 2, 450.00, NULL, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1045, 4, 116, 3, 5, 165.00, 3.00, 'QR', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1046, 5, 112, 11, 1, 220.00, NULL, 'Карта', NOW()-'1 day'::interval, NOW()-'1
day'::interval),
 (1047, 6, 103, 9, -2, 90.00, 0.00, 'Наличные', NOW()-'1 day'::interval, NOW()-'1
day'::interval), -- ВОЗВРАТ
 (1048,10, 115, NULL,20, 35.00, 0.00, 'Наличные', NOW()-'1 day'::interval,
NOW()-'1 day'::interval),
-- ── СТРОКИ С ОШИБКАМИ (для теста валидации) ─────────────────────
 (1049,99, 101, 1, 1, 155.00, 0.00, 'Карта', NOW()-'1 day'::interval, NOW()),
-- store_id=99 НЕ СУЩЕСТВУЕТ
 (1050, 1, 999, 1, 1, 100.00, 0.00, 'QR', NOW()-'1 day'::interval, NOW());
-- product_id=999 НЕ СУЩЕСТВУЕТ

-- Добавить строку с несуществующим store_id
INSERT INTO source.sales
 (sale_id, store_id, product_id, quantity, unit_price, sale_ts, created_at)
VALUES
 (1049, 99, 101, 1, 155.00, NOW()-'1 day'::interval, NOW());
