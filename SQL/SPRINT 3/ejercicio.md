## Micaela Rojas - Especialización Análisis de Datos

Corrector:

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




### Ejercicio 5


### Ejercicio 6



