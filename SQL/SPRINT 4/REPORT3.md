## Micaela Rojas - Especialización Análisis de Datos

Corrector: ALEJANDRO PEREYRA

Contenidos: BIG QUERY + LOOKER STUDIO

# SPRINT 4 - BIG QUERY, INFORME DE EJERCICIOS 

SPRINT 4  |   Big Query Presentación
Este documento reúne los ejercicios prácticos realizados durante el Sprint 4 del curso de especialización en Data Analysis. El trabajo se organiza por niveles e incluye consultas SQL, operaciones sobre tablas, creación de vistas y tablas en Big Query, dentro de Google Cloude, utilizando también Looker Studio para la representación gráfica de los mismos. Cada ejercicio incorpora una breve explicación y capturas de la Consola de Google Cloud y Looker Studio que muestran el desarrollo y los resultados obtenidos.

## Nivell 1: Entorn i Ingesta Híbrida (Code-First)

En esta sección se recogen los ejercicios prácticos de Big Query correspondientes al primer nivel de la formación en Data Analytics para la reducción de bytes.

### Ejercicio 1: Consulta sobre Taula no Optimitzada (Diagnòstic)

```sql
SELECT
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
  AND c.country = 'Germany';
```
<img width="1470" height="956" alt="Captura de pantalla 2026-11-24 a las 13 12 47" src="https://github.com/user-attachments/assets/f29907af-da3e-4c61-955d-e6ae092d74b6" />

Podemos ver debajo la cantidad de MB que podrían ser procesados (Dry Run). 

### Ejercicio 2: Re-arquitectura i Optimització de l'Emmagatzematge (Partition & Cluster)

#### Pas 1: Generació de Dades Recents (Mocking Data) 

<img width="1436" height="946" alt="Captura de pantalla 2026-11-24 a las 13 30 41" src="https://github.com/user-attachments/assets/0fc6b4b0-7e51-4f82-9a3b-d450af68a9c0" />

<img width="891" height="426" alt="Captura de pantalla 2026-11-24 a las 13 31 54" src="https://github.com/user-attachments/assets/fe4cf181-5cd0-452a-9bda-76d1132294c9" />


#### Pas 2: Creació de la Taula Optimitzada (Partitioning & Clustering) 

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 10 09 36" src="https://github.com/user-attachments/assets/8cc6f2b9-5697-443a-9bfb-2b6d53503988" />

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 10 14 32" src="https://github.com/user-attachments/assets/eb31913a-dbd8-4cc9-a8b4-f674cdd2e262" />


### Ejercicio 3: La Prova del Cotó (Benchmark)

#### Pas 1 (Taula no optimitzada)

<img width="637" height="297" alt="Captura de pantalla 2026-11-25 a las 10 21 05" src="https://github.com/user-attachments/assets/32dcd872-20e8-49fe-9753-b79787faa848" />

#### Pas 2 (Taula optimitzada)

<img width="585" height="319" alt="Captura de pantalla 2026-11-25 a las 10 21 24" src="https://github.com/user-attachments/assets/16facce6-9c9a-492c-88f4-a078c35dfd5c" />


Ahorro (%) = ((Bytes sin optimizar-Bytes optimizados) / Bytes sin optimizar)* 100 = ((11.85 - 6.99)/11.85)*100= 41 %

Podemos observar que la tabla no optimizada, obviamente, procesa muchos mas bytes. Si procedemos a utilizar la tabla optimizada, el ahorro de bytes corresponde a un 41% respecto al valor inicial. 


### Ejercicio 4: Smart Caching (Vistes Materialitzades)

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 10 40 36" src="https://github.com/user-attachments/assets/780b9480-284c-4681-a144-ae44a7475e4c" />

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 10 44 09" src="https://github.com/user-attachments/assets/decee712-e0b1-4421-b429-2895e97048f3" />

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 10 44 24" src="https://github.com/user-attachments/assets/d2d351f9-7152-4364-adf4-0fa406773382" />


## Nivell 2: SQL Analític Avançat

### EJERCICIO 1: Perfilat de Clients VIP (Mètriques Agregades amb CTEs)

```sql

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
```
<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 11 23 34" src="https://github.com/user-attachments/assets/41dc94d4-fdd9-46bc-ad18-beecc204674a" />


### EJERCICIO 2: Anàlisi de Tendències (Window Functions sobre Vistes)

```sql
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
```

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 12 07 11" src="https://github.com/user-attachments/assets/426a903e-eb2a-4b30-bdf7-e04f324c2fc3" />


### EJERCICIO 3: Totals Acumulats (Running Totals sobre Vistes)

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 12 15 55" src="https://github.com/user-attachments/assets/a8b29d3e-7c81-441f-bc6a-38f527700929" />


### EJERCICIO 4:

Usaremos las funciones mencionadas en el enunciado y ```sql IF(condición, valor_si_verdadero, valor_si_falso) ```

```sql
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
```

Tenemos tres apartados del anterior comando de SQL:
- la creación de una tabla donde solo se identifiquen las tres primeras compras, utilizamos funciones coo ROW_NUMBER(), PARTITION y QUALIFY (filtrando filas antes de calcular medias para ahorrar bytes)
- la creación de las métricas de los usuarios donde indicamos el máximo de cada uno, dada la primera CTE creada y teniendo en cuenta que solo los usuarios con 3 registros de compras podrán participar en esta evaluación.
- la representación final de la consulta donde utilizamos las columnas indicadas en el ejercicio.

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 22 23 11" src="https://github.com/user-attachments/assets/db5055ee-719c-4d43-bb04-3a794fc3e51e" />

<img width="1470" height="920" alt="Captura de pantalla 2026-11-25 a las 22 23 51" src="https://github.com/user-attachments/assets/fca1230f-d1a0-43af-a240-0321924211ab" />






