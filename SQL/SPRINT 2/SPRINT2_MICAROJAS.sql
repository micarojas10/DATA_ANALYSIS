   #SPRINT 2, PARTE 1
   
   -- Creamos la base de datos
    CREATE DATABASE IF NOT EXISTS transactions;
    USE transactions;

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
    );
    
/* insertamos los datos*/


#EXERCICI 1

USE transactions;

SELECT *
FROM company;

DESCRIBE company;

SELECT * 
FROM transaction;

DESCRIBE transaction;


#EXERCICI 2

## Llistat dels països que estan generant vendes.

SELECT country 
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE transaction.declined = "0"
GROUP BY country;

## Des de quants països es generen les vendes.

SELECT COUNT(DISTINCT country) AS total_countries
FROM company
JOIN transaction
ON company.id = transaction.company_id
WHERE transaction.declined = "0";

## Identifica la companyia amb la mitjana més gran de vendes.

###mitjana 
SELECT AVG(amount) as mitj_vendes
FROM transaction
GROUP BY company_id;

###max
SELECT MAX(mitj_vendes)
FROM (SELECT AVG(amount) AS mitj_vendes
        FROM transaction
        GROUP BY company_id) AS max_media;

###total

SELECT company_name, mitj_vendes
FROM company
JOIN (SELECT company_id, AVG(amount) as mitj_vendes
		FROM transaction
		GROUP BY company_id) mitjanes
ON mitjanes.company_id = company.id
WHERE mitj_vendes=( SELECT MAX(mitj_vendes)
					FROM (SELECT AVG(amount) AS mitj_vendes
							FROM transaction
							GROUP BY company_id) AS max_media);
                            
#EXERCICI 3

##Mostra totes les transaccions realitzades per empreses d'Alemanya.

### empreses alemanes
SELECT *
FROM company
WHERE country = 'germany';

###total
SELECT *
FROM transaction
WHERE company_id IN (SELECT id
		FROM company
		WHERE country = 'germany');
        
        #13291 OPERACIONES
        
##Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

###mitjana transaccions
SELECT AVG(amount)
FROM transaction;

###amount superior a mitjana
SELECT company_id
FROM transaction
WHERE amount > (SELECT AVG(amount)
				FROM transaction);

### total

SELECT *
FROM company
WHERE id IN (SELECT company_id
				FROM transaction
				WHERE amount > (SELECT AVG(amount)
								FROM transaction));
                                
                                
##Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT *
FROM company
WHERE id NOT IN (SELECT company_id
		FROM transaction);
        
###pruebas porque no me fio...
SELECT COUNT(*) AS total_empresas
FROM company;


SELECT COUNT(*) AS total_transacciones
FROM transaction;

SELECT company_id, COUNT(*) AS num_transacciones
FROM transaction
GROUP BY company_id;

SELECT COUNT(*) AS valores_null
FROM transaction
WHERE company_id IS NULL;

SELECT c.*
FROM company c
LEFT JOIN transaction t
    ON c.id = t.company_id
WHERE t.company_id IS NULL;

#Exercici 4
#La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. 
#La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). 

CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(50) PRIMARY KEY,
    iban VARCHAR(50),
    pan VARCHAR(25),
    pin VARCHAR(10),
    cvv VARCHAR(10),
    expiring_date VARCHAR(10)
);

/* INSERTAMOS DATOS*/
#Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". 
##modifiquem la base de dades amb l'estructura de datas correcte.

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

SELECT *
FROM credit_card; 


#Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.
DESCRIBE credit_card;


#Exercici 5
#El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
#La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.


UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';


#Exercici 6
#En la taula "transaction" ingressa una nova transacció amb la següent informació:
#Id 108B1D1D-5B23-A76C-55EF-C568E49A99DD credit_card_id CcU-9999 company_id b-9999 user_id 9999 lat 829.999 longitude -117.999 amount 111.11 declined 0 

INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999',  '111.11', '0');

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

#Exercici 7
#Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

DESCRIBE credit_card; #ya no esta pan :)


#Exercici 8
#Estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes: La taula de products.csv l'utilitzarem més endavant.

CREATE DATABASE transactions_star;

USE transactions_star;

CREATE TABLE dim_user (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    surname VARCHAR(100),
    phone VARCHAR(30),
    email VARCHAR(150),
    birth_date DATE,
    country VARCHAR(100),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    address VARCHAR(255),
    signup_date DATE,
    user_segment VARCHAR(50),
    income_band VARCHAR(30)
);


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

SET GLOBAL local_infile = 1;

SHOW VARIABLES LIKE 'local_infile';


LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__american_users.csv'
INTO TABLE stg_american_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__european_users.csv'
INTO TABLE stg_european_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*)
FROM stg_european_users;

SELECT *
FROM stg_american_users
LIMIT 10;

INSERT INTO dim_user (
    id, name, surname, phone, email, birth_date,
    country, city, postal_code, address, signup_date,
    user_segment, income_band
)
SELECT
    id, name, surname, phone, email,
    STR_TO_DATE(birth_date, '%b %e, %Y'),
    country, city, postal_code, address,
    STR_TO_DATE(signup_date, '%Y-%m-%d'),
    user_segment, income_band
FROM stg_american_users;

INSERT INTO dim_user (
    id, name, surname, phone, email, birth_date,
    country, city, postal_code, address, signup_date,
    user_segment, income_band
)
SELECT
    id, name, surname, phone, email,
    STR_TO_DATE(birth_date, '%b %e, %Y'),
    country, city, postal_code, address,
    STR_TO_DATE(signup_date, '%Y-%m-%d'),
    user_segment, income_band
FROM stg_european_users;

SELECT COUNT(*) FROM dim_user;

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

LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__companies.csv'
INTO TABLE dim_company
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM dim_company;
SELECT * FROM dim_company LIMIT 10;

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

LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__credit_cards.csv'
INTO TABLE dim_credit_card
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    user_id,
    iban,
    pan,
    pin,
    cvv,
    track1,
    track2,
    @expiring_date,
    card_type,
    card_renewal_flag
)
SET expiring_date = STR_TO_DATE(@expiring_date, '%m/%d/%y');

DESCRIBE dim_credit_card;

SELECT COUNT(*) FROM dim_credit_card;

SELECT *
FROM dim_credit_card
LIMIT 10;

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


LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__transactions.csv'
INTO TABLE fact_transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    card_id,
    business_id,
    @timestamp,
    amount,
    declined,
    product_ids,
    user_id,
    lat,
    longitude,
    discount_amount,
    tax_amount,
    shipping_amount,
    channel,
    campaign_id,
    device_type,
    is_international,
    decline_reason,
    distance_km
)
SET transaction_timestamp = STR_TO_DATE(@timestamp, '%Y-%m-%d %H:%i:%s');

SELECT *
FROM fact_transaction
LIMIT 4;

DESCRIBE fact_transaction;

### limpiamos las tablas:
DROP TABLE stg_american_users;
DROP TABLE stg_european_users;

### creamos las relaciones:

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

#EXERCICI 9
#Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.


SELECT *
FROM dim_user u
JOIN (SELECT user_id, count(id) as n_transactions
FROM fact_transaction
GROUP BY user_id) sq
ON u.id = sq.user_id
WHERE sq.n_transactions > 80;


#Exercici 10
#Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.


SELECT dc.iban, ROUND(AVG(ft.amount),2) AS average_amount
FROM dim_credit_card dc
JOIN fact_transaction ft
ON dc.id = ft.card_id
WHERE ft.business_id = (SELECT company_id
						FROM dim_company
						WHERE company_name LIKE 'Donec Ltd%')
GROUP BY dc.iban;
					
                        
                        
#NIVELL 2

#Exercici 1
#Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.
SELECT DATE(transaction_timestamp) AS fecha, SUM(amount) AS total_ventas
FROM fact_transaction
GROUP BY DATE(transaction_timestamp)
ORDER BY total_ventas DESC
LIMIT 5;

#Exercici 2
#Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb 
#un valor comprès entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. Ordena els resultats de major a menor quantitat.

SELECT company_name, phone, country, transaction_timestamp, amount
FROM dim_company c
JOIN fact_transaction t
ON c.company_id = t.business_id
WHERE amount BETWEEN 350 AND 400
AND (transaction_timestamp LIKE ("2015-04-29%")
	OR transaction_timestamp LIKE ("2018-07-20%")
	OR transaction_timestamp LIKE ("2024-03-13%"))
ORDER BY amount DESC;

#Exercici 3
#Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
#per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
#però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen igual o més de 400 transaccions o menys.

SELECT 
	company_name, 
	COUNT(id) AS q_transactions,
    CASE
        WHEN COUNT(id) >= 400 THEN 'Igual o más de 400'
        ELSE 'Menos de 400'
    END AS classification
FROM dim_company c
LEFT JOIN fact_transaction t
    ON c.company_id = t.business_id
GROUP BY company_id, company_name;

#Exercici 4
#Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

DELETE FROM fact_transaction
WHERE id = "000447FE-B650-4DCF-85DE-C7ED0EE1CAAD";

#Exercici 5
#La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
#S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
#Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
#Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT company_name as NOM_EMPRESA, phone AS TELEFON, country AS PAIS, ROUND(AVG(amount),2) AS MITJANA_COMPRES
FROM dim_company c
JOIN fact_transaction t
ON c.company_id = t.business_id
GROUP BY company_name, phone, country
ORDER BY MITJANA_COMPRES DESC;


#NIVEL 3
#Exercici 1
#Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes 
#transaccions han estat declinades aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu. Partint d’aquesta taula respon:
#👉 Quantes targetes estan actives?


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
SELECT card_id, transaction_timestamp, declined, num_transaccion
FROM tt
WHERE num_transaccion IN ('1','2','3');

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
WHERE num_transaccion IN ('1','2','3')
GROUP BY card_id;
SELECT * FROM card_status;

#Exercici 2
#Crea una taula amb la qual puguem unir les dades de l'arxiu de products.csv amb la base de dades creada (ja que fins ara no podíem fer-ho), 
#tenint en compte que des de transaction tens product_ids. Genera la següent consulta:
#👉 Necessitem conèixer el nombre de vegades que s'ha venut cada producte.


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

LOAD DATA LOCAL INFILE '/Users/mica/Downloads/N1-Ex.8__products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    id,
    product_name,
    @price,
    colour,
    weight,
    warehouse_id,
    category,
    brand,
    @cost,
    launch_date
)
SET
    price = REPLACE(REPLACE(@price, '$', ''), ',', ''),
    cost = REPLACE(REPLACE(@cost, '$', ''), ',', '');
    

SELECT *
FROM products
LIMIT 10;

CREATE TABLE transaction_products (
    transaction_id CHAR(36),
    product_id INT,
    PRIMARY KEY (transaction_id, product_id),
    FOREIGN KEY (transaction_id) REFERENCES fact_transaction(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO transaction_products (transaction_id, product_id)
SELECT
    t.id,
    p.product_id
FROM fact_transaction t,
JSON_TABLE(
    CONCAT('["', REPLACE(t.product_ids, ',', '","'), '"]'),
    '$[*]' COLUMNS (
        product_id INT PATH '$'
    )
) AS p;


SELECT
    p.id,
    p.product_name,
    COUNT(tp.product_id) AS veces_vendido
FROM products p
LEFT JOIN transaction_products tp
    ON p.id = tp.product_id
GROUP BY p.id, p.product_name
ORDER BY veces_vendido DESC;


