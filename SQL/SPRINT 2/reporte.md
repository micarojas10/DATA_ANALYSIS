# SPRINT 2 - SQL, INFORME DE EJERICIOS 

SPRINT 2  |  SQLPresentación
Este documento reúne los ejercicios prácticos realizados durante el Sprint 2 del curso de especialización en Data Analysis. El trabajo se organiza por niveles e incluye consultas SQL, operaciones sobre tablas, creación de vistas y tablas, relaciones entre datos y un modelo dimensional. Cada ejercicio incorpora una breve explicación y capturas de MySQL Workbench que muestran el desarrollo y los resultados obtenidos.

## SQL – Nivel 1

En esta sección se recogen los ejercicios prácticos de SQL correspondientes al primer nivel de la formación en Data Analytics.
Los ejercicios están organizados en dos partes, diferenciadas por los conjuntos de datos utilizados y los objetivos de trabajo.

## Parte 1 – Ejercicios 1 al 7

Primer bloque de ejercicios prácticos de SQL, centrado en el trabajo con el primer conjunto de datos.

### Ejercicio 1
Se realiza una primera exploración de las tablas company y transaction. Se consultan sus registros y se revisa la estructura de sus campos para reconocer la información disponible y cómo se relacionan las compras con las empresas.
Las tablas company y transactions nos muestran un conjunto de datos sobre las compras de diferentes empresas en el mundo. 

INSERT INTO transaction_products (transaction_id, product_id)
SELECT
    t.id,
    p.product_id
FROM fact_transaction t,
JSON_TABLE(
    CONCAT('[', t.product_ids, ']'),
    '$[*]' COLUMNS (
        product_id INT PATH '$'
    )
) AS p;


<img width="492" height="593" alt="Captura de pantalla 2026-11-10 a las 20 43 36" src="https://github.com/user-attachments/assets/8818b56a-c0b0-448e-8880-90d0faf6f56f" />

