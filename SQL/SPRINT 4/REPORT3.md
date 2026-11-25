## Micaela Rojas - Especialización Análisis de Datos

Corrector:

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


### Ejercicio 2: Re-arquitectura i Optimització de l'Emmagatzematge (Partition & Cluster)

#### Pas 1: Generació de Dades Recents (Mocking Data) 

#### Pas 2: Creació de la Taula Optimitzada (Partitioning & Clustering) 


### Ejercicio 3: La Prova del Cotó (Benchmark)

#### Pas 1 (Taula no optimitzada)
#### Pas 2 (Taula optimitzada)

\[
\text{Ahorro (\%)} =
\frac{\text{Bytes sin optimizar}-\text{Bytes optimizados}}
{\text{Bytes sin optimizar}}\times100
\]



### Ejercicio 4: Smart Caching (Vistes Materialitzades)

## Nivell 2: SQL Analític Avançat
