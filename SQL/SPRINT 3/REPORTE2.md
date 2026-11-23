## Micaela Rojas - Especialización Análisis de Datos

Corrector: GABRIELLA NOGUEIRA ALVES

Contenidos: BIG QUERY + SQL niveles 1 y 2

# SPRINT 3 - BIG QUERY, INFORME DE EJERCICIOS 

SPRINT 3  |   Big Query Presentación
Este documento reúne los ejercicios prácticos realizados durante el Sprint 3 del curso de especialización en Data Analysis. El trabajo se organiza por niveles e incluye consultas SQL, operaciones sobre tablas, creación de vistas y tablas en Big Query, dentro de Google Cloude. Cada ejercicio incorpora una breve explicación y capturas de la Consola de Google Cloud que muestran el desarrollo y los resultados obtenidos.

## BQ – Nivel 1

En esta sección se recogen los ejercicios prácticos de Big Query correspondientes al primer nivel de la formación en Data Analytics con bases introductorias.

### Ejercicio 1

Comenzamos creando los tres dataset físicos:
<img width="1386" height="675" alt="Captura de pantalla 2026-11-16 a las 12 52 09" src="https://github.com/user-attachments/assets/5711da98-2efa-47a0-acbd-4abf53468c45" />

En la imagen anterior observamos que la capa lógica bronze se encuentra creada a través del método UI, mientras la silver es creada a travez de codigo SQL. 
A continuación, se crea la tabla gold por el método de Cloud Shell:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-16 a las 13 37 53" src="https://github.com/user-attachments/assets/007aa2ed-0ce7-4294-9b51-df16acded46f" />

### Ejercicio 2

Procedemos a inyectar los datos que se encuentran en la nube de IT ACADEMY a través de los URL proporcionados, mientras seguimos con las instrucciones de importación indicadas: 

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 11 05 02" src="https://github.com/user-attachments/assets/a8b84a5b-ad03-417a-a87c-6c83d8eb98be" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 11 05 14" src="https://github.com/user-attachments/assets/fb57eff4-b214-4d87-b050-67a7ab75e85c" />

Con tal de comprobar la tabla companies, se adjunta la siguiente foto de la estructura de las columnas de la misma:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 10 57 28" src="https://github.com/user-attachments/assets/009680b1-c59e-431c-8357-6f2fd0c4d565" />


### Ejercicio 3

Carga de datos locales de la tabla products con el método manual:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 11 12 36" src="https://github.com/user-attachments/assets/5479290f-ed52-47f4-b87a-73f34d8931f7" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 11 15 23" src="https://github.com/user-attachments/assets/f10a8bec-60ce-488d-88cb-c41f7293d3d7" />


### Ejercicio 4

En el ejercicio A utilizamos IA para poder diseñar el codigo de copia de tabla mientras corregimos estructura o posibles errores:

 <img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 11 43 00" src="https://github.com/user-attachments/assets/dfc0cae9-aaf8-4d10-87bd-e9b6d2540f7c" />



En el ejercicio B utilizamos dos códigos para comparar la cantidad de bytes procesadas dependiendo de las tablas que se usen (nativas o externas);

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 12 31 43" src="https://github.com/user-attachments/assets/13513ec3-69f5-43c3-9319-79a32ff03373" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 12 32 08" src="https://github.com/user-attachments/assets/65563ed9-6382-4828-9c7f-be5d928ab7f1" />

El nativo es mucho más eficiente en cuanto a costos, gasta tres veces menos aproximadamente (de 3 a 12). Por lo tanto, usar datos externos no optimiza el consumo de bytes, aun asi los bytes facturados no tienen mucha diferencia, ya que pasamos de 10 a 13. Las tablas externas dependen de archivos almacenados en Cloud Storage y pueden tener limitaciones de rendimiento y estimación de costes más altos.



En el ejercicio C comprobamos las estimaciones de gastos de LIMIT comparándolo tambien en ambas tablas (externa o nativa):

<img width="1031" height="334" alt="Captura de pantalla 2026-11-17 a las 12 48 15" src="https://github.com/user-attachments/assets/edd9f977-5b0e-4525-a2b1-bfcd8766361f" />

<img width="1032" height="341" alt="Captura de pantalla 2026-11-17 a las 12 49 36" src="https://github.com/user-attachments/assets/e1d35eb5-1fd6-4f5b-9dd5-dd2a573526cb" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-17 a las 12 49 01" src="https://github.com/user-attachments/assets/07745ebb-d3b3-4236-ba6c-22c1cece550d" />

Como podemos observar, el uso de LIMIT no rebaja ni ahora bytes facturados ni procesados. Pero al procesar solo una columna de la tabla de datos, observamos cierta reducción en la cantidad de bytes.

A continuación, observamos el análisis y comparación pero con los datos nativos;

<img width="1029" height="345" alt="Captura de pantalla 2026-11-17 a las 12 50 18" src="https://github.com/user-attachments/assets/cf5057a9-5c52-4c80-a11b-c68f69233a8c" />

Podemos observar que usando la base de datos nativo se usa menos bytes, básicamente lo que sucede (en vocabulario técnico) es que en tablas nativas, BigQuery almacena los datos en formato columnar y puede aprovechar esa organización para leer solo las columnas solicitadas. En tablas externas CSV, los datos están almacenados en archivos de texto. BigQuery no puede aprovechar la misma organización columnar, por lo que seleccionar una columna puede seguir requiriendo leer gran parte del archivo. 
Seleccionar las columnas necesarias reduce el uso de lectura.



### Ejercicio 5

Verificamos el formato de DATA en la tabla de transacciones.
Los 5 dias con mas ingresos del 2021:

<img width="883" height="613" alt="Captura de pantalla 2026-11-18 a las 11 29 03" src="https://github.com/user-attachments/assets/7f93c768-5615-4878-b235-8bf77e8722ae" />


### Ejercicio 6

Informe donde cruzamos datos:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 11 44 38" src="https://github.com/user-attachments/assets/d4bf4453-5f07-440b-b3e3-cf900e4c771e" />


## BQ – Nivel 2

En esta sección se recogen los ejercicios prácticos de Big Query correspondientes al segundo nivel de la formación en Data Analytics aprendiendo métodos ELT.

### Ejercicio 1

Limpiamos la tabla productos para la capa de datos SILVER. Primeramente observamos su composición y columnas para hacer el cambio correcto:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 12 41 42" src="https://github.com/user-attachments/assets/30d57ca6-e757-4f99-95cd-36a7e4028e60" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 12 49 47" src="https://github.com/user-attachments/assets/a6597023-428b-4bf5-959d-1ed9996fd7ae" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 23 26 44" src="https://github.com/user-attachments/assets/e5915522-26d2-45e3-9aae-15a856569b95" />


### Ejercicio 2

Seguimos las instrucciones de cambio de nombre, formato y orden de la tabla transactions en SILVER:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 23 42 32" src="https://github.com/user-attachments/assets/8d67632b-d244-4ab0-933c-aa44de742381" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 23 49 04" src="https://github.com/user-attachments/assets/aa579eb8-508c-4a2b-b98c-21d60b3e6490" />

Como podemos observar, la tabla limpia muestra la estructura de products_ids como un array, las filas completas de información hacen referencia a los consiguientes productos listados en esta columna, esto no afecta la tabla con las demás filas varias, y lo podemos comprobar con la columna creada _numero_productos_:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 10 30 17" src="https://github.com/user-attachments/assets/a3661152-4ab3-40a0-ae19-8daf548ac358" />


### Ejercicio 3

Para crear la tabla de usuarios combinados, usaremos UNION ALL y modificaremos esta tabla añadiendo una columna que identifique el origen de cada dato/fila/usuario guardado: 

<img width="1470" height="956" alt="Captura de pantalla 2026-11-18 a las 23 57 04" src="https://github.com/user-attachments/assets/da6b7170-ce22-4b3c-9431-1602997b3f50" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 10 30 24" src="https://github.com/user-attachments/assets/44838636-c7cf-469e-ac76-e6d516ccaf68" />

### Ejercicio 4

Creamos las tablas de credit_card y companies manteniendo todos los datos en orden y con el mismo formato:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 0 04 46" src="https://github.com/user-attachments/assets/be89dbb7-b485-4166-928a-5823873ca637" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 0 09 40" src="https://github.com/user-attachments/assets/6c345134-22b1-4338-9166-8a90c99de334" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 0 09 50" src="https://github.com/user-attachments/assets/f0babf58-24f2-47d7-9755-98090263cbee" />


Con esto nos aseguramos de que es una tabla nativa:

<img width="716" height="416" alt="Captura de pantalla 2026-11-19 a las 10 34 14" src="https://github.com/user-attachments/assets/445193d2-20ad-4496-a970-6edddbe4048f" />


## BQ – Nivel 3

En esta sección se recogen los ejercicios prácticos de Big Query correspondientes al tercer nivel de la formación en Data Analytics correspondiente a la presentación de datos y visualizaciones.

### Ejercicio 1

Creación de vista para Marketing de clientes de manera segmentada por media de compra:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 11 41 59" src="https://github.com/user-attachments/assets/6368e189-3b0b-4cdc-90e5-8b0bd4da9eb9" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 11 46 01" src="https://github.com/user-attachments/assets/2cd0684d-a107-4820-bdc7-ad970b3dcef6" />



### Ejercicio 2

Comenzamos creando el codigo que contendrá el calculo de numero de productos para despues utilizarlo (siguiendo los requisitos del informe) en los rankings de productos mas rentables/vendidos, numerando cada uno de ellos:

```sql

CREATE OR REPLACE TABLE
  `sprint3-analytics-mica.sprint3_gold.product_sales_ranking`
AS

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
  p.product_id = s.product_id;

```

A continuación, mostramos las siguientes imágenes que verifican la creación y la tabla:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 12 32 39" src="https://github.com/user-attachments/assets/33e32e6e-3280-47c9-884a-307aa4a0eaab" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 12 40 27" src="https://github.com/user-attachments/assets/e8076b71-5fd3-4469-9474-cbd9a7fa8626" />


### Ejercicio 3

Descargamos en formato CSV y verificamos los datos en el programa Numbers:

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 12 45 00" src="https://github.com/user-attachments/assets/30a0692f-df6b-4cc6-ba90-e66d7d8c6b10" />

<img width="1470" height="956" alt="Captura de pantalla 2026-11-19 a las 12 45 43" src="https://github.com/user-attachments/assets/41e3dbf4-caa8-40be-9bd3-ce53e6ea433e" />



VINCULO BIG QUERY SQL: https://console.cloud.google.com/bigquery?ws=!1m7!1m6!12m5!1m3!1ssprint3-analytics-mica!2seurope-southwest1!3s9efa3aa3-fc6a-4939-84df-1b9ba9075228!2e1 
















