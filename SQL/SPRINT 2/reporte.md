Micaela Rojas - Especialización Análisis de Datos

Corrector: Marc Ponce
Contenidos: SQL niveles 1,2 y 3

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

Los datos de esta nueva tabla nos muestran los diferentes datos de cada tarjeta de crédito utilizada para las transferencias en transactions que usan las diferentes empresas. Esta se relaciona con el _card_id_ que se utiliza en transacciones, siendo asi la FK en ella y la PK en _credit_card_.

<img width="752" height="329" alt="Captura de pantalla 2026-11-04 a las 22 44 10" src="https://github.com/user-attachments/assets/ab8cf3b7-0919-4037-9a06-d2d95c6ff28c" />

### Ejercicio 5

Se actualiza el IBAN de una tarjeta concreta mediante UPDATE, utilizando el identificador de la tarjeta en la condición WHERE. Después se consulta el registro para comprobar el cambio.




