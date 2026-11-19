-- MICAELA ROJAS

#NIVEL 1

#EJERCICIO 2

-- 1. Companies
CREATE EXTERNAL TABLE `sprint3-analytics-mica.sprint3_bronze.companies_raw` (
  company_id STRING,
  company_name STRING,
  phone STRING,
  email STRING,
  country STRING,
  website STRING
)
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/companies.csv'],
  skip_leading_rows = 1
);

-- 2. Transactions
CREATE EXTERNAL TABLE `sprint3-analytics-mica.sprint3_bronze.transactions_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/ERP/transactions.csv'],
  field_delimiter = ';'
);

-- 3. American users
CREATE EXTERNAL TABLE `sprint3-analytics-mica.sprint3_bronze.american_users_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/american_users.csv']
);

-- 4. European users
CREATE EXTERNAL TABLE `sprint3-analytics-mica.sprint3_bronze.european_users_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/european_users.csv']
);

-- 5. Credit cards
CREATE EXTERNAL TABLE `sprint3-analytics-mica.sprint3_bronze.credit_cards_raw`
OPTIONS (
  format = 'CSV',
  uris = ['gs://bootcamp-data-analytics-public/CRM/credit_cards.csv']
);


#EJERCICIO 4

##A
CREATE OR REPLACE TABLE `sprint3-analytics-mica`.sprint3_bronze.transactions_raw_native
AS
SELECT * 
FROM `sprint3-analytics-mica`.sprint3_bronze.transactions_raw;

##B

SELECT id
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw`;

SELECT id
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw_native`;

##C

SELECT *
FROM `sprint3-analytics-mica`.sprint3_bronze.transactions_raw_native
LIMIT 10;

#EJERCICIO 5

SELECT *
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw`
LIMIT 5;

SELECT
  timestamp,
  DATE(timestamp) AS fecha
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw`
LIMIT 5;

SELECT
  DATE(timestamp) AS fecha,
  SUM(amount) AS ingresos_totales
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw`
WHERE EXTRACT(YEAR FROM timestamp) = 2021
  AND declined = 0
GROUP BY fecha
ORDER BY ingresos_totales DESC
LIMIT 5;


#EJERCICIO 6

SELECT
  c.company_name,
  c.country,
  DATE(t.timestamp) AS transaction_date
FROM `sprint3-analytics-mica.sprint3_bronze.transactions_raw` AS t
INNER JOIN `sprint3-analytics-mica.sprint3_bronze.companies_raw` AS c
  ON t.business_id = c.company_id
WHERE
  t.amount BETWEEN 100 AND 200
  AND DATE(t.timestamp) IN (
    DATE '2015-04-29',
    DATE '2018-07-20',
    DATE '2024-03-13'
  );

#NIVEL 2
#EJERCICIO 1

SELECT *
FROM `sprint3-analytics-mica.sprint3_bronze.products_raw`
LIMIT 10;


CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.products_clean`
AS (
  SELECT
    id AS product_id,
    product_name AS name,
    SAFE_CAST(price AS FLOAT64) AS price,
    colour,
    weight,
    SAFE_CAST(REPLACE(warehouse_id, 'WH-', '') AS INT64) AS warehouse_id,
    category,
    brand,
    cost,
    launch_date

  FROM `sprint3-analytics-mica.sprint3_bronze.products_raw`
  );

# EJERCICIO 2


CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.transactions_clean`
AS (
  SELECT
    id AS transaction_id,
    card_id,
    business_id,
    timestamp,
    IFNULL(SAFE_CAST(amount AS FLOAT64), 0) AS amount,
    declined,
    ARRAY(
      SELECT SAFE_CAST(product_id AS INT64)
      FROM UNNEST(SPLIT(product_ids, ',')) AS product_id
    ) AS product_ids,
    user_id,
    SAFE_CAST(lat AS FLOAT64) AS lat,
    SAFE_CAST(longitude AS FLOAT64) AS longitude
  FROM
    `sprint3-analytics-mica.sprint3_bronze.transactions_raw`
);

SELECT
  transaction_id,
  product_ids,
  ARRAY_LENGTH(product_ids) AS numero_productos
FROM `sprint3-analytics-mica.sprint3_silver.transactions_clean`
LIMIT 5;


#EJERCICIO 3


CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.users_combined`
AS (

SELECT
  * EXCEPT(id),
  id AS user_id,
  'American' AS origin
FROM
  `sprint3-analytics-mica.sprint3_bronze.american_users_raw`

UNION ALL

SELECT
  * EXCEPT(id),
  id AS user_id,
  'European' AS origin
FROM
  `sprint3-analytics-mica.sprint3_bronze.european_users_raw`
);

#EJERCICIO 4


CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.companies_clean`
AS
SELECT *
FROM
  `sprint3-analytics-mica.sprint3_bronze.companies_raw`;



CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.credit_cards_clean`
AS
SELECT *
FROM
  `sprint3-analytics-mica.sprint3_bronze.credit_cards_raw`;


SELECT
  table_name,
  table_type
FROM
  `sprint3-analytics-mica.sprint3_silver.INFORMATION_SCHEMA.TABLES`
WHERE
  table_name IN ('companies_clean', 'credit_cards_clean');


#NIVEL 3

#EJERCICIO 1


CREATE OR REPLACE VIEW
  `sprint3-analytics-mica.sprint3_gold.v_marketing_kpis`
AS (
SELECT
  c.company_name,
  c.phone,
  c.country,
  AVG(t.amount) AS avg_purchase,
  CASE
    WHEN AVG(t.amount) > 260 THEN 'Premium'
    ELSE 'Standard'
  END AS client_tier
FROM
  `sprint3-analytics-mica.sprint3_silver.companies_clean` AS c
LEFT JOIN
  `sprint3-analytics-mica.sprint3_silver.transactions_clean` AS t
ON
  c.company_id = t.business_id
GROUP BY
  c.company_id,
  c.company_name,
  c.phone,
  c.country
);


# ordenamos la vista:

SELECT *
FROM
  `sprint3-analytics-mica.sprint3_gold.v_marketing_kpis`
ORDER BY
  client_tier ASC,
  avg_purchase DESC;

#EJERCICIO 2


CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_gold.product_sales_ranking`
AS
(
WITH product_sales AS (
  SELECT
    product_id,
    COUNT(*) AS total_sold
  FROM
    `sprint3-analytics-mica.sprint3_silver.transactions_clean`,
    UNNEST(product_ids) AS product_id
  GROUP BY
    product_id
)

SELECT
  p.product_id,
  p.name,
  p.price,
  p.colour,
  IFNULL(s.total_sold, 0) AS total_sold
FROM
  `sprint3-analytics-mica.sprint3_silver.products_clean` AS p
LEFT JOIN
  product_sales AS s
ON
  p.product_id = s.product_id
  
);


SELECT *
FROM `sprint3-analytics-mica.sprint3_gold.product_sales_ranking`
ORDER BY total_sold DESC;
