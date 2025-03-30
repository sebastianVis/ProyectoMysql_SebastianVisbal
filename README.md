# Campuslands Database Proyecto MySQL II Sebastian Visbal

Este repositorio contiene la estructura y consultas de una base de datos MySQL diseñada para la gestión de información en Campuslands.

## 📌 Descripción

El proyecto define la base de datos de Campuslands utilizando MySQL, organizando la información en distintas tablas y proporcionando consultas para extraer datos relevantes. La base de datos gestiona campers, rutas de entrenamiento, evaluaciones, trainers y más.

## 📂 Estructura del Proyecto

- `ddl.sql` → Contiene la definición de todas las tablas de la base de datos.
- `dml.sql` → Contiene las inserciones de datos iniciales.
- `consultas.sql` → Todas las consultas estan en la carpeta, con diferentes archivos .sql, abre los archivos y encontraras todas las consultas, tanto triggers, subconsultas, procedimientos almacenados, etc.

## ⚙️ Requisitos

- MySQL 8.x o superior
- Cliente SQL (MySQL Workbench, DBeaver, etc.)

## 🚀 Instalación y Uso

1. Clona este repositorio:
   ```sh
   git clone https://github.com/sebastianVis/ProyectoMysql_SebastianVisbal
   ```
2. Accede al directorio del proyecto:
   ```sh
   cd campuslands-database
   ```
3. Importa y ejecuta el archivo `ddl.sql` para crear la base de datos:
   ```sql
   source ddl.sql;
   ```
4. Ejecuta `dml.sql` para poblar la base de datos con datos iniciales:
   ```sql
   source dml.sql;
   ```
5. Ejecuta las consultas SQL que estan en el repositorio.

## 📊 Funcionalidades

- Gestión de campers y su información personal.
- Asignación de rutas de entrenamiento y trainers.
- Registro de evaluaciones y calificaciones.
- Consultas avanzadas con `JOINs`, `subconsultas` y `funciones de agregación`.