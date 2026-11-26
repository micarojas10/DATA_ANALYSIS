#SPRINT 4

#NIVEL 1
#EJERCICIO 1

/*SELECT
  t.*,
  c.company_name,
  c.country
FROM
  `sprint3-analytics-mica.sprint3_silver.transactions_clean` AS t
INNER JOIN
  `sprint3-analytics-mica.sprint3_silver.companies_clean` AS c
ON
  t.business_id = c.company_id
WHERE
  DATE(t.timestamp) = DATE '2022-03-12'
  AND c.country = 'Germany'; */

#EJERCICIO 2

#PASO 1:

CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_silver.transactions_recent`
AS
SELECT
  * EXCEPT(timestamp),
  TIMESTAMP_SUB(
    CURRENT_TIMESTAMP(),
    INTERVAL CAST(RAND() * 50 AS INT64) DAY
  ) AS timestamp
FROM `sprint3-analytics-mica.sprint3_silver.transactions_clean`;


#comprobamos:

SELECT
  COUNT(*) AS total_transactions,
  MIN(timestamp) AS fecha_mas_antigua,
  MAX(timestamp) AS fecha_mas_reciente
FROM `sprint3-analytics-mica.sprint3_silver.transactions_recent`;

#PASO 2:

CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_gold.fact_transactions_optimized`
PARTITION BY DATE(timestamp)
CLUSTER BY business_id
AS (
SELECT *
FROM `sprint3-analytics-mica.sprint3_silver.transactions_recent`);


#comprobación extra (otra versión hecha con chatgpt):

SELECT
  table_name,
  column_name,
  data_type,
  is_partitioning_column,
  clustering_ordinal_position
FROM `sprint3-analytics-mica.sprint3_gold.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'fact_transactions_optimized'
ORDER BY ordinal_position;

#EJERCICIO 3
#paso 1: no optimizada

SELECT *
FROM `sprint3-analytics-mica.sprint3_silver.transactions_recent`
WHERE DATE(timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);

#paso 2: optimizada

SELECT *
FROM `sprint3-analytics-mica.sprint3_gold.fact_transactions_optimized`
WHERE DATE(timestamp) >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY);

#EJERCICIO 4  

CREATE MATERIALIZED VIEW
  `sprint3-analytics-mica.sprint3_gold.mv_daily_sales`
AS
SELECT
  DATE(timestamp) AS sale_date,
  SUM(amount) AS total_sales
FROM `sprint3-analytics-mica.sprint3_gold.fact_transactions_optimized`
GROUP BY sale_date;

SELECT *
FROM `sprint3-analytics-mica.sprint3_gold.mv_daily_sales`
ORDER BY sale_date;


#NIVEL 2
#EJERCICIO 1

WITH vip_stats AS (
  SELECT
    user_id,
    SUM(amount) AS despesa_total,
    COUNT(*) AS num_trans,
    ROUND(AVG(amount), 2) AS tiquet_mig,
    MAX(amount) AS max_compra
  FROM `sprint3-analytics-mica.sprint3_silver.transactions_clean`
  WHERE declined = 0
  GROUP BY user_id
  HAVING despesa_total > 500
)

SELECT
  v.user_id,
  CONCAT(u.name, ' ', u.surname) AS nom_complet,
  u.email,
  v.num_trans,
  v.tiquet_mig,
  v.max_compra,
  v.despesa_total
FROM vip_stats AS v
INNER JOIN `sprint3-analytics-mica.sprint3_silver.users_combined` AS u
ON v.user_id = u.user_id
ORDER BY v.despesa_total DESC;


#EJERCICIO 2

WITH daily_comparison AS (
  SELECT
    sale_date AS Data,
    total_sales AS Vendes_Avui,
    LAG(total_sales) OVER (
      ORDER BY sale_date
    ) AS Vendes_Ahir
  FROM `sprint3-analytics-mica.sprint3_gold.mv_daily_sales`
)

SELECT
  Data,
  Vendes_Avui,
  Vendes_Ahir,
  ROUND(
    SAFE_DIVIDE( Vendes_Avui - Vendes_Ahir, Vendes_Ahir) * 100, 2
  ) AS Diff_Percentual
FROM daily_comparison
ORDER BY Data;

#EJERCICIO 3

SELECT
  sale_date AS Data,
  ROUND(total_sales, 2) AS Vendes_Dia,
  ROUND(
    SUM(total_sales) OVER (
      PARTITION BY EXTRACT(YEAR FROM sale_date)
      ORDER BY sale_date
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),2
  ) AS Vendes_Acumulades_YTD
FROM
  `sprint3-analytics-mica.sprint3_gold.mv_daily_sales`
ORDER BY
  sale_date;

#EJERCICIO 4

WITH first_three_purchases AS (
  SELECT
    transaction_id,
    user_id,
    timestamp,
    amount,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY timestamp, transaction_id
    ) AS num_compra
  FROM
    `sprint3-analytics-mica.sprint3_silver.transactions_clean`
  WHERE
    declined = 0
  QUALIFY
    num_compra <= 3
),

user_metrics AS (
  SELECT
    user_id,
    ROUND(AVG(amount), 2) AS mitjana_3_primeres,
    MAX(IF(num_compra = 3, DATE(timestamp), NULL)) AS data_tercera_compra,
    MAX(IF(num_compra = 3, amount, NULL)) AS import_tercera_compra
  FROM
    first_three_purchases
  GROUP BY
    user_id
  HAVING
    COUNT(*) = 3
)

SELECT
  m.user_id,
  CONCAT(u.name, ' ', u.surname) AS nom_complet,
  u.email,
  m.data_tercera_compra,
  m.import_tercera_compra,
  m.mitjana_3_primeres
FROM
  user_metrics AS m
INNER JOIN
  `sprint3-analytics-mica.sprint3_silver.users_combined` AS u
ON
  m.user_id = u.user_id
ORDER BY
  m.data_tercera_compra;


#NIVEL 3

#EJERCICIO 1

CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_gold.dim_transactions_flat`
AS (
SELECT
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket,
  product_id,
  p.name AS product_name,
  p.price AS product_price

FROM `sprint3-analytics-mica.sprint3_silver.transactions_clean` AS t
CROSS JOIN
  UNNEST(t.product_ids) AS product_id

INNER JOIN `sprint3-analytics-mica.sprint3_silver.products_clean` AS p
ON product_id = p.product_id
);

#comprobamos en orden de transaction y producto:

SELECT
  transaction_id,
  product_id,
  product_price
FROM `sprint3-analytics-mica.sprint3_gold.dim_transactions_flat`
ORDER BY
  transaction_id,
  product_id
LIMIT 10;

#EJERCICIO 2

SELECT product_name, COUNT(*) AS unidades_vendidas
FROM `sprint3-analytics-mica.sprint3_gold.dim_transactions_flat`
GROUP BY product_name
ORDER BY unidades_vendidas DESC
LIMIT 5;


#EJERCICIO 3

CREATE OR REPLACE FUNCTION
  `sprint3-analytics-mica.sprint3_gold.calculate_tax`(amount FLOAT64)
RETURNS FLOAT64
AS ( amount * 1.21);

SELECT`sprint3-analytics-mica.sprint3_gold.calculate_tax`(100) AS precio_con_iva;


CREATE OR REPLACE TABLE `sprint3-analytics-mica.sprint3_gold.dim_transactions_flat`
AS(
SELECT
  t.transaction_id,
  t.timestamp,
  t.amount AS total_ticket,
  product_id AS product_SKU,
  p.name AS product_name,
  p.price AS product_unit_price,
  `sprint3-analytics-mica.sprint3_gold.calculate_tax`(p.price) AS product_price_tax_inc
FROM `sprint3-analytics-mica.sprint3_silver.transactions_clean` AS t
CROSS JOIN
  UNNEST(t.product_ids) AS product_id
INNER JOIN `sprint3-analytics-mica.sprint3_silver.products_clean` AS p
ON product_id = p.product_id
);
