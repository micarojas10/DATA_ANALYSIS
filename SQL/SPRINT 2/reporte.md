## Micaela Rojas - Especialización Análisis de Datos

Corrector: Marc Ponce
Contenidos: SQL niveles 1,2 y 3

# SPRINT 2 - SQL, INFORME DE EJERCICOS 

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

```sql
    -- Creamos la tabla company
    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );

    -- Creamos la tabla transaction
    CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) PRIMARY KEY,
        credit_card_id VARCHAR(15),
        company_id VARCHAR(20), 
        user_id INT,
        lat FLOAT,
        longitude FLOAT,
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        FOREIGN KEY (company_id) REFERENCES company(id) 

```
Las tablas company y transactions nos muestran un conjunto de datos sobre las compras de diferentes empresas en el mundo. 

<img width="926" height="651" alt="Captura de pantalla 2026-11-12 a las 21 57 25" src="https://github.com/user-attachments/assets/853e8330-7611-4212-ac15-a780be1fa9c4" />

<img width="926" height="651" alt="Captura de pantalla 2026-11-12 a las 21 58 03" src="https://github.com/user-attachments/assets/934bd637-b7de-4f32-a997-fe386d188ffe" />

La tabla company hace referencia a los datos de las diferentes empresas, en esta encontramos la siguiente relación con transaction, la cual hace referencia a las diferentes transacciones que ha tenido nuestra empresa de las empresas en nuestra base de registros y los respectivos datos de las mismas en tiempo real y situación, _id_ de Company es su PK, esta misma se usará como FK en la tabla de transactions.

A continuación, vemos el diagrama que demuestra la relación mencionada:

<img width="533" height="309" alt="Captura de pantalla 2026-11-03 a las 16 17 46" src="https://github.com/user-attachments/assets/0b13c6a0-61fb-4c4d-953f-9c08bf5facc2" />


### Ejercicio 2

Se relacionan las tablas company y transaction para identificar los países que generan ventas y calcular la media de importe por empresa. A partir de esos cálculos se identifica la compañía con la media de ventas más elevada.

<img width="926" height="667" alt="Captura de pantalla 2026-11-12 a las 22 07 37" src="https://github.com/user-attachments/assets/7254599d-f1f3-4b54-85f1-076be8fd8b42" />

<img width="932" height="481" alt="Captura de pantalla 2026-11-12 a las 22 08 10" src="https://github.com/user-attachments/assets/06f67a28-7c20-48df-884d-64f7afdd6cea" />

<img width="926" height="667" alt="Captura de pantalla 2026-11-12 a las 22 09 03" src="https://github.com/user-attachments/assets/45a0ef4a-0045-4748-9fc3-6118318a667d" />


### Ejercicio 3

Se utilizan subconsultas para localizar empresas con transacciones cuyo importe supera la media de todas las transacciones. También se consulta si existen empresas sin transacciones registradas.

<img width="926" height="667" alt="Captura de pantalla 2026-11-12 a las 22 12 27" src="https://github.com/user-attachments/assets/15d49245-bf07-42d4-a473-7356fab2c8a6" />

<img width="926" height="667" alt="Captura de pantalla 2026-11-12 a las 22 14 03" src="https://github.com/user-attachments/assets/838c0392-1deb-4239-903d-dd436d2710be" />

<img width="926" height="667" alt="Captura de pantalla 2026-11-12 a las 22 14 33" src="https://github.com/user-attachments/assets/4f9a08b7-e596-4f19-8410-0b44e7878e78" />


### Ejercicio 4

Se incorpora la tabla credit_card y se establece su relación con transaction mediante una clave foránea. Se revisa la estructura de la nueva tabla y se representa la relación entre las tablas en el diagrama.


```sql
CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(50) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(10),
    cvv VARCHAR(10),
    expiring_date VARCHAR(10)
);
```

Al añadir la tabla credit card en la base de datos, ampliamos la información de las compañías y del método de pago de las transacciones. 

```sql
SET SQL_SAFE_UPDATES = 0;

UPDATE credit_card
SET expiring_date = DATE_FORMAT(
    STR_TO_DATE(expiring_date, '%m/%d/%y'),
    '%Y-%m-%d'
);

ALTER TABLE credit_card
MODIFY COLUMN expiring_date DATE;

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);
```

<img width="1048" height="667" alt="Captura de pantalla 2026-11-12 a las 22 19 03" src="https://github.com/user-attachments/assets/733686f5-8b6c-4d79-b2f1-0def457df714" />

Los datos de esta nueva tabla nos muestran los diferentes datos de cada tarjeta de crédito utilizada para las transferencias en transactions que usan las diferentes empresas. Esta se relaciona con el _card_id_ que se utiliza en transacciones, siendo asi la FK en ella y la PK en _credit_card_. Esto formara un modelo de estrella, siendo la central la tabla _transactions_. 

<img width="752" height="329" alt="Captura de pantalla 2026-11-04 a las 22 44 10" src="https://github.com/user-attachments/assets/ab8cf3b7-0919-4037-9a06-d2d95c6ff28c" />

### Ejercicio 5

Se actualiza el IBAN de una tarjeta concreta mediante UPDATE, utilizando el identificador de la tarjeta en la condición WHERE. Después se consulta el registro para comprobar el cambio.

<img width="1053" height="667" alt="Captura de pantalla 2026-11-12 a las 22 25 06" src="https://github.com/user-attachments/assets/e21e0b58-168e-4ef4-a7c2-193f9bb0cc0a" />

### Ejercicio 6

Se insertan nuevos registros en las tablas credit_card, company y transaction. El ejercicio permite practicar INSERT y comprobar que los registros relacionados se incorporan correctamente.

<img width="1053" height="667" alt="Captura de pantalla 2026-11-12 a las 22 26 31" src="https://github.com/user-attachments/assets/bafa810f-f6a5-4f28-9d69-cb905a8cd742" />

### Ejercicio 7

Se modifica la estructura de credit_card eliminando la columna pan mediante ALTER TABLE y DROP COLUMN. Finalmente, se comprueba la estructura actualizada de la tabla.

<img width="1057" height="536" alt="Captura de pantalla 2026-11-12 a las 22 28 00" src="https://github.com/user-attachments/assets/7aa2d17c-071b-4088-84ae-5d38bb107a39" />

## Parte 2 – Ejercicios 8 al 10

Segundo bloque de ejercicios, desarrollado a partir de un conjunto de datos diferente.

En esta parte se trabaja con la creación e importación de tablas, la transformación de datos y el diseño de un modelo dimensional mediante un esquema en estrella (*Star Schema*).

### Ejercicio 8 

Se construye un modelo dimensional en estrella a partir de los archivos CSV. Se crean e importan las tablas de dimensiones y la tabla de hechos, se transforman los campos necesarios y se definen las relaciones entre ellas.

Comenzamos creando la nueva database y la primera tabla de datos de usuarios _dim_user_:

<img width="1053" height="667" alt="Captura de pantalla 2026-11-12 a las 22 30 24" src="https://github.com/user-attachments/assets/beff31e2-6515-4e8e-a7a7-d53023a06991" />


para esto, utilizamos primero tablas borrador para la importación de los usuarios americanos y europeos:

```sql
/* tenemos que crear tablas temporales para cada continente para despues unirlos en dim_user*/

CREATE TABLE stg_american_users (
    id INT,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(150),
    birth_date VARCHAR(30),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255),
    signup_date VARCHAR(30),
    user_segment VARCHAR(50),
    income_band VARCHAR(30)
);

CREATE TABLE stg_european_users (
    id INT,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(150),
    birth_date VARCHAR(30),
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255),
    signup_date VARCHAR(30),
    user_segment VARCHAR(50),
    income_band VARCHAR(30)
);
```

Cargamos los datos:

<img width="1057" height="560" alt="Captura de pantalla 2026-11-12 a las 22 33 22" src="https://github.com/user-attachments/assets/65119baf-66d1-4bb1-a446-85bc32fe903f" />

Comprobamos que los usuarios americanos son de un total de 1010 y los europeos de 3990. 

Despues procedemos a insertar ambas tablas en _dim_user_, por ejemplo la de Europa a continuación:

<img width="1202" height="667" alt="Captura de pantalla 2026-11-12 a las 22 36 09" src="https://github.com/user-attachments/assets/3ceb8637-09cc-43da-aee0-96f300c6fabf" />

Vemos 5000 usuarios en total con sus diferentes datos, localizaciones, vías de contacto y capacidad de compra. 

Procedemos con la creación de las tablas de 100 empresas, _dim_company_:

```sql
CREATE TABLE dim_company (
    company_id VARCHAR(20) PRIMARY KEY,
    company_name VARCHAR(150),
    phone VARCHAR(30),
    email VARCHAR(150),
    country VARCHAR(100),
    website VARCHAR(255),
    merchant_category VARCHAR(100),
    merchant_price_position VARCHAR(50)
);
```

<img width="1202" height="580" alt="Captura de pantalla 2026-11-12 a las 22 40 58" src="https://github.com/user-attachments/assets/bce0a093-a9f3-4b50-91cc-3b2b21dfb663" />


Ahora la dimensión de metodo de pago: _dim_credit_card_:

```sql
CREATE TABLE dim_credit_card (
    id VARCHAR(20) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(40),
    pan VARCHAR(30),
    pin VARCHAR(10),
    cvv VARCHAR(10),
    track1 TEXT,
    track2 TEXT,
    expiring_date DATE,
    card_type VARCHAR(50),
    card_renewal_flag TINYINT
);
```

Observamos 5000 observaciones de estas:

<img width="1202" height="534" alt="Captura de pantalla 2026-11-12 a las 22 45 15" src="https://github.com/user-attachments/assets/bcd94133-9026-4ff9-adb1-ac5bfa1cbc67" />

La siguiente tabla ser fundamental para relacionar las demás tablas, ya que es la base de todas las foreign keys; la tabla _fact_transaction_ : 
Dada la cantidad de datos y para garantizar una visualización y búsqueda rápida, creamos indices de las columnas que serian mas usadas en este tipo de relaciones de datos. 

```sql
CREATE TABLE fact_transaction (
    id CHAR(36) PRIMARY KEY,
    card_id VARCHAR(20),
    business_id VARCHAR(20),
    transaction_timestamp DATETIME,
    amount DECIMAL(12,2),
    declined TINYINT,
    product_ids TEXT,
    user_id INT,
    lat DECIMAL(10,7),
    longitude DECIMAL(10,7),
    discount_amount DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    shipping_amount DECIMAL(12,2),
    channel VARCHAR(50),
    campaign_id VARCHAR(100),
    device_type VARCHAR(50),
    is_international BOOLEAN,
    decline_reason VARCHAR(255),
    distance_km DECIMAL(12,2),

    INDEX idx_card_id (card_id),
    INDEX idx_business_id (business_id),
    INDEX idx_user_id (user_id)
);
```

Recibimos warnings a la hora de cargar los datos de transacciones, pero al comprobar, vemos que todo esta correcto:

<img width="1202" height="522" alt="Captura de pantalla 2026-11-12 a las 22 49 49" src="https://github.com/user-attachments/assets/c95e35a4-6473-4c27-a6e7-fd5b8ba74de3" />


Una vez creadas las tablas fundamentales de nuestros datos de usuarios, transacciones, tarjetas de crédito y empresas, procedemos a crear las relaciones correspondientes: 

```sql
#entre tarjetas y usuarios

ALTER TABLE dim_credit_card
ADD CONSTRAINT fk_credit_card_user
FOREIGN KEY (user_id) REFERENCES dim_user(id);

#entre transacciones y las tarjetas

ALTER TABLE fact_transaction
ADD CONSTRAINT fk_transaction_card
FOREIGN KEY (card_id) REFERENCES dim_credit_card(id);

#entre transacciones y empresas

ALTER TABLE fact_transaction
ADD CONSTRAINT fk_transaction_company
FOREIGN KEY (business_id) REFERENCES dim_company(company_id);

#entre transacciones y usuarios:

ALTER TABLE fact_transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (user_id) REFERENCES dim_user(id);
```
<img width="1197" height="146" alt="Captura de pantalla 2026-11-12 a las 22 54 14" src="https://github.com/user-attachments/assets/a27ec139-e635-416f-9267-15d3570315b3" />

Nuestro diagrama es un modelo de estrella, siendo la tabla de hechos la dimensión de transacciones:

<img width="888" height="660" alt="Captura de pantalla 2026-11-09 a las 11 01 21" src="https://github.com/user-attachments/assets/279b1f96-d897-4292-9a89-4d17137d461f" />

### Ejercicio 9

Se utiliza una subconsulta que cuenta las transacciones por usuario. Después se relaciona ese resultado con dim_user para mostrar los usuarios que han realizado más de 80 transacciones.


<img width="1202" height="623" alt="Captura de pantalla 2026-11-12 a las 22 57 23" src="https://github.com/user-attachments/assets/a8891806-3582-4d65-b4d0-bbeaed4243bb" />


### Ejercicio 10

Se calcula la media del importe de las transacciones por IBAN para las tarjetas que han realizado compras en la empresa Donec Ltd. Para ello se relacionan las tablas de tarjetas y transacciones y se filtra la empresa mediante una subconsulta.


<img width="1202" height="623" alt="Captura de pantalla 2026-11-12 a las 23 05 04" src="https://github.com/user-attachments/assets/f570e785-fc39-4b04-b22e-78bc57700cdf" />

## SQL – Nivel 2

Segundo bloque de ejercicios prácticos de SQL, centrado en el trabajo con el segundo conjunto de datos.

### Ejercicio 1

Se agrupan las transacciones por día y se suman sus importes para obtener los cinco días con mayores ingresos. El resultado se ordena de mayor a menor total de ventas.

<img width="1186" height="540" alt="Captura de pantalla 2026-11-12 a las 23 07 54" src="https://github.com/user-attachments/assets/3aeb0917-6156-4a64-8dc6-9bb3e1698e62" />

### Ejercicio 2

Se muestran los datos de las empresas que realizaron transacciones de entre 350 y 400 euros en cualquiera de las tres fechas indicadas. Se combinan las condiciones de importe y fecha y se ordenan los resultados por importe descendente.

<img width="1202" height="631" alt="Captura de pantalla 2026-11-12 a las 23 08 41" src="https://github.com/user-attachments/assets/6e0eaf4a-4ce2-4b65-a804-2e21a75b7df3" />


### Ejercicio 3

Se cuenta el número de transacciones de cada empresa y se clasifica cada una según alcance o no las 400 operaciones. Para incluir también empresas sin transacciones se utiliza LEFT JOIN.

<img width="1202" height="631" alt="Captura de pantalla 2026-11-12 a las 23 12 00" src="https://github.com/user-attachments/assets/93dbba41-e319-4756-9faa-27661ff94242" />


### Ejercicio 4

Se elimina de fact_transaction únicamente el registro cuyo identificador coincide con el indicado en el enunciado. La condición WHERE limita la operación al registro solicitado.

<img width="1202" height="571" alt="Captura de pantalla 2026-11-12 a las 23 13 30" src="https://github.com/user-attachments/assets/ce39c412-69ff-47ad-90c2-b6159c492983" />


### Ejercicio 5

Se crea la vista VistaMarketing con el nombre, teléfono y país de cada empresa, junto con la media del importe de sus transacciones. Los resultados se agrupan por empresa y se ordenan por la media de compra.

<img width="1540" height="949" alt="Captura de pantalla 2026-11-12 a las 23 14 31" src="https://github.com/user-attachments/assets/46fc59fe-9e7a-4edd-87c2-ac7383c572ab" />


## SQL – Nivel 3

### Ejercicio 1

Se determina el estado de cada tarjeta a partir de sus tres transacciones más recientes. ROW_NUMBER() ordena las operaciones por tarjeta y fecha; después se comprueba cuántas fueron rechazadas y se asigna el estado ACTIVA o INACTIVA. El resultado se guarda en una tabla.

<img width="1142" height="664" alt="Captura de pantalla 2026-11-12 a las 23 16 33" src="https://github.com/user-attachments/assets/5f145692-0f13-4c4e-ab47-a54a5c8c3a12" />

creamos la tabla de estado de tarjeta:

```sql
CREATE TABLE card_status AS
WITH tt AS (
SELECT
    card_id,
    transaction_timestamp,
    declined,
    ROW_NUMBER() OVER (
        PARTITION BY card_id
        ORDER BY transaction_timestamp DESC
    ) AS num_transaccion
FROM fact_transaction)
SELECT 
	card_id, 
    CASE
		WHEN SUM(declined) = 3 THEN 'INACTIVA'
		ELSE 'ACTIVA'
	END AS estado
FROM tt
WHERE num_transaccion < 4
GROUP BY card_id;
```

<img width="1136" height="391" alt="Captura de pantalla 2026-11-12 a las 23 18 24" src="https://github.com/user-attachments/assets/d7ec8d76-c7f4-49ff-9276-4416faf2d29f" />

Vemos que todas las tarjetas están activadas, las 5000!


### Ejercicio 2

Se separan los identificadores incluidos en product_ids para obtener una fila por producto y transacción. Después se relacionan los datos con la tabla products mediante una tabla intermedia y se cuenta cuántas veces aparece vendido cada producto.

```sql
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(150),
    price DECIMAL(10,2),
    colour VARCHAR(20),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(20),
    category VARCHAR(100),
    brand VARCHAR(100),
    cost DECIMAL(10,2),
    launch_date DATE
);
```

<img width="1131" height="429" alt="Captura de pantalla 2026-11-12 a las 23 19 54" src="https://github.com/user-attachments/assets/db0efad8-b399-4d01-9e89-6ee6473ce871" />

creación de tabla intermedia: 
```sql
CREATE TABLE transaction_products (
    transaction_id CHAR(36),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES fact_transaction(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
```

Hemos de separar la columna de productos, ya que los productos se encuentran todos juntos en formato de Texto, para eso usamos JSON;

```sql
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
```

Usamos las tablas creadas e intermedias para observar que el producto mas vendido es el de la primera fila:
<img width="1202" height="648" alt="Captura de pantalla 2026-11-12 a las 23 26 53" src="https://github.com/user-attachments/assets/2869f7fb-cfee-4f39-914a-a2313ad62e1f" />


El resultado final de relaciones del database _transaction_star_ es el siguiente: 

<img width="942" height="699" alt="Captura de pantalla 2026-11-12 a las 23 38 38" src="https://github.com/user-attachments/assets/eb392b52-47ab-4a36-8731-4e5ddb5ffd86" />














