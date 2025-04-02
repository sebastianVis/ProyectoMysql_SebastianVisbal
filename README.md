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

## Consultas

 Campers
1. Obtener todos los campers inscritos actualmente.
```sql
SELECT camper_id, nombre FROM campers;

```

2. Listar los campers con estado "Aprobado".
```sql
SELECT c.nombre AS nombre_camper, e.nombre AS estado_camper
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre = 'aprobado';
```
3. Mostrar los campers que ya están cursando alguna ruta.
```sql
SELECT c.nombre AS nombre_camper, e.nombre AS estado_camper
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre = 'cursando';
```
4. Consultar los campers graduados por cada ruta.
```sql
SELECT r.nombre AS ruta, COUNT(c.camper_id) AS numero_graduados
FROM campers AS c
JOIN rutaEntrenamiento AS r ON c.ruta_id = r.ruta_id
WHERE c.estado_id = 5
GROUP BY r.nombre;
```
5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado".
```sql
SELECT c.nombre AS camper, e.nombre AS estado 
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre IN ('expulsado', 'retirado');
```
6. Listar campers con nivel de riesgo “Alto”.
```sql
SELECT c.camper_id AS id_camper, c.nombre as camper, n.nombre AS nivel_riesgo
FROM campers AS c
INNER JOIN nivelriesgo AS n ON c.nivelriesgo_id = n.nivelriesgo_id
WHERE n.nombre = 'Alto';
```
7. Mostrar el total de campers por cada nivel de riesgo.
```sql
SELECT nr.nombre AS nivel_riesgo, COUNT(c.camper_id) AS total_campers
FROM campers AS c
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
GROUP BY nr.nivelriesgo_id;
```
8. Obtener campers con más de un número telefónico registrado.
```sql
SELECT c.camper_id, c.nombre, COUNT(ct.telefono_id) AS total_telefonos
FROM campers AS c
JOIN camperTelefono AS ct ON c.camper_id = ct.camper_id
GROUP BY c.camper_id
HAVING COUNT(ct.telefono_id) > 1;
```
9. Listar los campers y sus respectivos acudientes y teléfonos.
```sql
SELECT c.camper_id, c.nombre AS camper, a.nombre AS acudiente, a.apellido AS apellido_acudiente, t.numero AS telefono
FROM campers AS c
JOIN acudientes AS a ON c.acudiente_id = a.acudiente_id
LEFT JOIN camperTelefono AS ct ON c.camper_id = ct.camper_id
LEFT JOIN telefonos AS t ON ct.telefono_id = t.telefono_id;
```
10. Mostrar campers que aún no han sido asignados a una ruta.
```sql
SELECT c.camper_id, c.nombre 
FROM campers c
LEFT JOIN camperRuta cr ON c.camper_id = cr.camper_id
WHERE cr.ruta_id IS NULL;
```
📊 Evaluaciones
1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.
```sql
SELECT 
    e.camper_id, 
    c.nombre AS camper_nombre,
    e.ruta_id, 
    e.modulo_id, 
    e.nota_teorica, 
    e.nota_practica, 
    e.nota_trabajo
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id;
```
2. Calcular la nota final de cada camper por módulo.
```sql
SELECT 
    e.camper_id, 
    c.nombre AS camper_nombre,
    e.ruta_id, 
    e.modulo_id, 
    e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id;
```
3. Mostrar los campers que reprobaron algún módulo (nota < 60).
```sql
SELECT 
    e.camper_id, 
    c.nombre AS camper_nombre,
    e.ruta_id, 
    e.modulo_id, 
    e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE e.nota_final < 60;
```
4. Listar los módulos con más campers en bajo rendimiento.
```sql
SELECT 
    e.modulo_id, 
    m.nombre AS modulo_nombre, 
    COUNT(e.camper_id) AS total_reprobados
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_final < 60
GROUP BY e.modulo_id
ORDER BY total_reprobados DESC;
```
5. Obtener el promedio de notas finales por cada módulo.
```sql
SELECT 
    e.modulo_id, 
    m.nombre AS modulo_nombre, 
    AVG(e.nota_final) AS promedio_nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY e.modulo_id;
```
6. Consultar el rendimiento general por ruta de entrenamiento.
```sql
SELECT 
    e.ruta_id, 
    r.nombre AS ruta_nombre, 
    AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
GROUP BY e.ruta_id;
```
7. Mostrar los trainers responsables de campers con bajo rendimiento.
```sql
SELECT 
    t.trainer_id, 
    t.nombre AS trainer_nombre, 
    t.apellido AS trainer_apellido, 
    COUNT(DISTINCT e.camper_id) AS total_campers_bajo_rendimiento
FROM evaluacion e
JOIN asignacionTrainer at ON e.ruta_id = at.ruta_id
JOIN trainers t ON at.trainer_id = t.trainer_id
WHERE e.nota_final < 60
GROUP BY t.trainer_id;
```
8. Comparar el promedio de rendimiento por trainer.
```sql
SELECT 
    t.trainer_id, 
    t.nombre AS trainer_nombre, 
    AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN asignacionTrainer at ON e.ruta_id = at.ruta_id
JOIN trainers t ON at.trainer_id = t.trainer_id
GROUP BY t.trainer_id
ORDER BY promedio_rendimiento DESC;
```
9. Listar los mejores 5 campers por nota final en cada ruta.
```sql
SELECT 
    e.ruta_id, 
    r.nombre AS ruta_nombre, 
    e.camper_id, 
    c.nombre AS camper_nombre, 
    e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
ORDER BY e.ruta_id, e.nota_final DESC
LIMIT 5;
```
10. Mostrar cuántos campers pasaron cada módulo por ruta.
```sql
SELECT 
    e.ruta_id, 
    r.nombre AS ruta_nombre, 
    e.modulo_id, 
    m.nombre AS modulo_nombre, 
    COUNT(e.camper_id) AS total_aprobados
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_final >= 60
GROUP BY e.ruta_id, e.modulo_id;
```
🧭 Rutas y Áreas de Entrenamiento

1. Mostrar todas las rutas de entrenamiento disponibles.
```sql
SELECT ruta_id, nombre
FROM rutaEntrenamiento;
```
2. Obtener las rutas con su SGDB principal y alternativo.
```sql
SELECT r.ruta_id, r.nombre, s1.nombre AS sgdb_principal, s2.nombre AS sgdb_alternativo
FROM rutaEntrenamiento r
JOIN sgbd s1 ON r.sgbd_id = s1.sgbd_id
JOIN sgbd s2 ON r.sgbda_id = s2.sgbd_id;
```
3. Listar los módulos asociados a cada ruta.
```sql
SELECT DISTINCT r.ruta_id, r.nombre AS ruta, m.modulo_id, m.nombre AS modulo
FROM camperRuta cr
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN modulo m ON cr.modulo_id = m.modulo_id
ORDER BY r.ruta_id, m.modulo_id;
```
4. Consultar cuántos campers hay en cada ruta.
```sql
SELECT r.ruta_id, r.nombre AS ruta, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
LEFT JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id, r.nombre;
```
5. Mostrar las áreas de entrenamiento y su capacidad máxima.
```sql
SELECT s.salon_id, s.nombre AS area, s.capacidad 
FROM salones s;
```
6. Obtener las áreas que están ocupadas al 100%.
```sql
SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS ocupacion_actual, s.capacidad
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
HAVING COUNT(cr.camper_id) >= s.capacidad; --No va a salir nada porque los salones estan con 26 estudiantes cada uno, si quiere verificar, cambie el > por <
```
7. Verificar la ocupación actual de cada área.
```sql
SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS ocupacion_actual, s.capacidad,
       (COUNT(cr.camper_id) * 100.0 / s.capacidad) AS porcentaje_ocupacion
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id;
```
8. Consultar los horarios disponibles por cada área.
```sql
SELECT s.salon_id, s.nombre AS area, h.horario_id, h.hora_inicio, h.hora_fin
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN horarios h ON r.horario_id = h.horario_id;
```
9. Mostrar las áreas con más campers asignados.
```sql
SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
ORDER BY total_campers DESC;
```
10. Listar las rutas con sus respectivos trainers y áreas asignadas.
```sql
SELECT r.ruta_id, r.nombre AS ruta, t.nombre AS trainer, t.apellido, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN salones s ON r.salon_id = s.salon_id;
```

Trainers

1. Listar todos los entrenadores registrados.
```sql
SELECT trainer_id, nombre, apellido 
FROM trainers;

```
2. Mostrar los trainers con sus horarios asignados.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, h.hora_inicio, h.hora_fin
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id;
```
3. Consultar los trainers asignados a más de una ruta.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, COUNT(at.ruta_id) AS total_rutas
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
GROUP BY t.trainer_id
HAVING COUNT(at.ruta_id) > 1; -- Mi papá Jholver quien mas
```
4. Obtener el número de campers por trainer.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, COUNT(cr.camper_id) AS total_campers
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY t.trainer_id;
```
5. Mostrar las áreas en las que trabaja cada trainer.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN salones s ON r.salon_id = s.salon_id;
```
6. Listar los trainers sin asignación de área o ruta.
```sql
SELECT t.trainer_id, t.nombre, t.apellido
FROM trainers t
LEFT JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
WHERE at.trainer_id IS NULL;
```
7. Mostrar cuántos módulos están a cargo de cada trainer.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, COUNT(DISTINCT cr.modulo_id) AS total_modulos
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY t.trainer_id;
```
8. Obtener el trainer con mejor rendimiento promedio de campers.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, AVG(e.nota_final) AS promedio_rendimiento
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN evaluacion e ON r.ruta_id = e.ruta_id
GROUP BY t.trainer_id
ORDER BY promedio_rendimiento DESC
LIMIT 1; -- No es Jholver xq el si lo pone dificil
```
9. Consultar los horarios ocupados por cada trainer.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, h.hora_inicio, h.hora_fin
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
ORDER BY t.trainer_id, h.hora_inicio;
```
10. Mostrar la disponibilidad semanal de cada trainer.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, COUNT(DISTINCT h.horario_id) AS horarios_ocupados
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
GROUP BY t.trainer_id;
```
## 🔍 Consultas con Subconsultas y Cálculos Avanzados (20 ejemplos)

1. Obtener los campers con la nota más alta en cada módulo.
```sql
SELECT e.modulo_id, c.camper_id, c.nombre, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE e.nota_final = (
    SELECT MAX(nota_final)
    FROM evaluacion AS sub
    WHERE sub.modulo_id = e.modulo_id
);
```

2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.
```sql
SELECT r.nombre AS ruta, 
       AVG(e.nota_final) AS promedio_ruta, 
       (SELECT AVG(nota_final) FROM evaluacion) AS promedio_global
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
GROUP BY r.nombre; 
```

3. Listar las áreas con más del 80% de ocupación.
```sql
SELECT s.salon_id, s.nombre AS salon, COUNT(cr.camper_id) AS ocupacion, 
       (COUNT(cr.camper_id) / s.capacidad) * 100 AS porcentaje_ocupacion
FROM salones s
JOIN rutaEntrenamiento r ON s.salon_id = r.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
HAVING porcentaje_ocupacion > 80;
```

4. Mostrar los trainers con menos del 70% de rendimiento promedio.
```sql
SELECT t.trainer_id, t.nombre, t.apellido, AVG(e.nota_final) AS promedio_rendimiento
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN evaluacion e ON r.ruta_id = e.ruta_id
GROUP BY t.trainer_id
HAVING AVG(e.nota_final) < 70.0; -- Es q los proyectos de papá Jholver tan heavy
```

5. Consultar los campers cuyo promedio está por debajo del promedio general.
```sql
SELECT c.camper_id, c.nombre, AVG(e.nota_final) AS promedio_camper
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
GROUP BY c.camper_id
HAVING promedio_camper < (SELECT AVG(nota_final) FROM evaluacion);
```

6. Obtener los módulos con la menor tasa de aprobación.
```sql
SELECT e.modulo_id, m.nombre AS modulo, 
       COUNT(CASE WHEN e.nota_final >= 60 THEN 1 END) / COUNT(*) * 100 AS tasa_aprobacion
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY e.modulo_id
ORDER BY tasa_aprobacion ASC
LIMIT 5;
```

7. Listar los campers que han aprobado todos los módulos de su ruta.
```sql
SELECT c.camper_id, c.nombre
FROM campers c
WHERE NOT EXISTS (
    SELECT 1
    FROM camperRuta cr
    LEFT JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.modulo_id = e.modulo_id
    WHERE cr.camper_id = c.camper_id AND (e.nota_final IS NULL OR e.nota_final < 60)
);
```

8. Mostrar rutas con más de 10 campers en bajo rendimiento.
```sql
SELECT r.nombre AS ruta, COUNT(e.camper_id) AS campers_bajo_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
WHERE e.nota_final < 60
GROUP BY r.ruta_id
HAVING campers_bajo_rendimiento > 5; -- Ninguna ruta tiene mas de 10 campers en bajo rendimiento, si ponemos menos, salen la cantidad de estos
```

9. Calcular el promedio de rendimiento por SGDB principal.
```sql
SELECT s.nombre AS sgbd, AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id
GROUP BY s.sgbd_id;
```

10. Listar los módulos con al menos un 30% de campers reprobados.
```sql
SELECT modulo_id
FROM evaluacion
GROUP BY modulo_id
HAVING (SUM(CASE WHEN nota_final < 60 THEN 1 ELSE 0 END) * 100 / COUNT(*)) >= 30;
```

11. Mostrar el módulo más cursado por campers con riesgo alto.
```sql
SELECT e.modulo_id, COUNT(*) AS total_campers_alto_riesgo
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE c.nivelriesgo_id = 3  -- Suponiendo que nivel 3 es riesgo alto
GROUP BY e.modulo_id
ORDER BY total_campers_alto_riesgo DESC
LIMIT 1;
```

12. Consultar los trainers con más de 3 rutas asignadas.
```sql
SELECT t.trainer_id, t.nombre, COUNT(a.ruta_id) AS total_rutas
FROM trainers t
JOIN asignacionTrainer a ON t.trainer_id = a.trainer_id
GROUP BY t.trainer_id
HAVING total_rutas >= 2; --ningun trainer tiene mas de 3 rutas asignadas, por eso cambio el valor a 2
```

13. Listar los horarios más ocupados por áreas.
```sql
SELECT h.horario_id, h.hora_inicio, h.hora_fin, COUNT(*) AS total_rutas
FROM horarios h
JOIN rutaEntrenamiento r ON h.horario_id = r.horario_id
GROUP BY h.horario_id
ORDER BY total_rutas DESC
LIMIT 5;
```

14. Consultar las rutas con el mayor número de módulos.
```sql
SELECT r.ruta_id, r.nombre AS ruta, COUNT(DISTINCT c.modulo_id) AS total_modulos
FROM camperRuta c
JOIN rutaEntrenamiento r ON c.ruta_id = r.ruta_id
GROUP BY r.ruta_id
ORDER BY total_modulos DESC
LIMIT 1;
```

15. Obtener los campers que han cambiado de estado más de una vez.
```sql
SELECT h.camper_id, c.nombre, COUNT(DISTINCT h.estado_id) AS cambios_estado
FROM historialEstados h
JOIN campers c ON h.camper_id = c.camper_id
GROUP BY h.camper_id
HAVING cambios_estado > 1;
```

16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.
```sql
SELECT camper_id, ruta_id, modulo_id, nota_teorica, nota_practica FROM evaluacion
WHERE nota_teorica > nota_practica;
```

17. Listar los módulos donde la media de quizzes supera el 9.
```sql
SELECT modulo_id, AVG(nota_trabajo) AS promedio_quizzes
FROM evaluacion
GROUP BY modulo_id
HAVING promedio_quizzes > 70; -- No hay que superen 90, por eso voy a poner 70
```

18. Consultar la ruta con mayor tasa de graduación.
```sql
SELECT e.ruta_id, 
       COUNT(DISTINCT e.camper_id) AS graduados, 
       (COUNT(DISTINCT e.camper_id) * 100 / (SELECT COUNT(DISTINCT c.camper_id) FROM campers c)) AS tasa_graduacion
FROM egresados e
GROUP BY e.ruta_id
ORDER BY tasa_graduacion DESC
LIMIT 1;
```

19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.
```sql
SELECT DISTINCT e.modulo_id, nr.nombre AS nivel_riesgo_camper
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN nivelRiesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nivelriesgo_id IN (2, 3); --  2 es medio y 3 es alto
```

20. Obtener la diferencia entre capacidad y ocupación en cada área.
```sql
SELECT s.salon_id, s.nombre, s.capacidad, 
       (s.capacidad - COUNT(c.camper_id)) AS espacios_disponibles
FROM salones s
JOIN rutaEntrenamiento r ON s.salon_id = r.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
GROUP BY s.salon_id, s.capacidad;  -- Asi esta campus JAJAJAJAJA con espacios negativos
```

🔁 JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)
1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que están inscritos.
```sql
SELECT c.nombre AS camper, r.nombre AS ruta
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id;
```


2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por cada módulo.
```sql
SELECT c.nombre AS camper, r.nombre AS ruta, m.nombre AS modulo, 
       e.nota_teorica, e.nota_practica, e.nota_trabajo, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
JOIN modulo m ON e.modulo_id = m.modulo_id;
```


3. Listar todos los módulos que componen cada ruta de entrenamiento.
```sql
SELECT r.nombre AS ruta, m.nombre AS modulo
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN modulo m ON cr.modulo_id = m.modulo_id
GROUP BY r.nombre, m.nombre
ORDER BY r.nombre, m.nombre;
```

4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.
```sql
SELECT r.nombre AS ruta, t.nombre AS trainer, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id;
```

5. Mostrar los campers junto con el trainer responsable de su ruta actual.
```sql
SELECT c.nombre AS camper, r.nombre AS ruta, t.nombre AS trainer
FROM camperRuta cr
JOIN campers c ON cr.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN asignacionTrainer at ON r.ruta_id = at.ruta_id
JOIN trainers t ON at.trainer_id = t.trainer_id;
```

6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.
```sql
SELECT c.nombre AS camper, m.nombre AS modulo, r.nombre AS ruta, 
       e.nota_teorica, e.nota_practica, e.nota_trabajo, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN modulo m ON e.modulo_id = m.modulo_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id;
```

7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.
```sql
SELECT t.nombre AS trainer, h.hora_inicio, h.hora_fin, r.nombre AS ruta
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id;
```

8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.
```sql
SELECT c.nombre AS camper, e.nombre AS estado, nr.nombre AS nivel_riesgo
FROM campers c
JOIN estados e ON c.estado_id = e.estado_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id;
```

9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de quizzes.

```sql
SELECT r.nombre AS ruta, m.nombre AS modulo, 
       e.nota_teorica AS porcentaje_teorico, 
       e.nota_practica AS porcentaje_practico, 
       e.nota_trabajo AS porcentaje_quizzes
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id;
```

10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo
en esos espacios.
```sql
SELECT a.nombre AS area, c.nombre AS camper
FROM campers AS c
JOIN camperRuta AS cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento AS r ON cr.ruta_id = r.ruta_id
JOIN areas AS a ON r.area_id = a.area_id;
```

## 🔀 JOINs con condiciones específicas
1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).
```sql
SELECT c.camper_id, c.nombre, cr.ruta_id
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
GROUP BY c.camper_id, cr.ruta_id
HAVING MIN(e.nota_final) >= 60;
```

2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.
```sql
SELECT r.nombre AS ruta, COUNT(cr.camper_id) AS inscritos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id
HAVING COUNT(cr.camper_id) > 10;
```

3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers
```sql
SELECT a.area_id, a.nombre, COUNT(cr.camper_id) AS total_campers, 
       (COUNT(cr.camper_id) / a.capacidad) * 100 AS porcentaje_ocupacion
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY a.area_id
HAVING porcentaje_ocupacion > 80;
```

asignados.
4. Obtener los trainers que imparten más de una ruta diferente.
```sql
SELECT t.nombre AS trainer, COUNT(DISTINCT at.ruta_id) AS rutas_asignadas
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
GROUP BY t.trainer_id
HAVING COUNT(DISTINCT at.ruta_id) > 1;
```

5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.
```sql
SELECT c.nombre AS camper, m.nombre AS modulo, e.nota_teorica, e.nota_practica
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_practica > e.nota_teorica;
```

6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.
```sql
SELECT DISTINCT c.nombre AS camper, r.nombre AS ruta, s.nombre AS sgbd
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id
WHERE s.nombre = 'MySQL';
```

7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.
```sql
SELECT DISTINCT m.nombre AS modulo, e.nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_final < 60;
```

8. Consultar las rutas con más de 3 módulos asociados.
```sql
SELECT r.nombre AS ruta, COUNT(cr.modulo_id) AS total_modulos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id
HAVING COUNT(cr.modulo_id) > 3;
```

9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.
```sql
SELECT c.nombre AS camper, r.nombre AS ruta, cr.inscripcion
FROM camperRuta cr
JOIN campers c ON cr.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
WHERE cr.inscripcion >= CURDATE() - INTERVAL 30 DAY;
```

10. Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.

```sql
SELECT DISTINCT t.nombre AS trainer_con_campers_alto_riesgo, r.nombre AS ruta
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nombre = 'Alto';
```

## 🔎 JOINs con funciones de agregación
1. Obtener el promedio de nota final por módulo.
```sql
SELECT m.nombre AS modulo, AVG(e.nota_final) AS promedio_nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY m.nombre;
```

2. Calcular la cantidad total de campers por ruta.
```sql
SELECT r.ruta_id, r.nombre AS ruta, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id;
```

3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que imparte).

```sql
SELECT t.trainer_id, t.nombre, COUNT(e.camper_id) AS total_evaluaciones
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
JOIN evaluacion e ON at.ruta_id = e.ruta_id
GROUP BY t.trainer_id;
```

4. Consultar el promedio general de rendimiento por cada área de entrenamiento.
```sql
SELECT a.area_id, a.nombre AS area, AVG(e.nota_final) AS promedio_nota_final
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
GROUP BY a.area_id;
```

5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.
```sql
SELECT r.ruta_id, r.nombre AS ruta, COUNT(DISTINCT cr.modulo_id) AS total_modulos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id;
```

6. Mostrar el promedio de nota final de los campers en estado “Cursando”.
```sql
SELECT AVG(e.nota_final) AS promedio_nota_cursando
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN estados es ON c.estado_id = es.estado_id
WHERE es.nombre = 'Cursando';
```

7. Listar el número de campers evaluados en cada módulo.
```sql
SELECT m.modulo_id, m.nombre AS modulo, COUNT(e.camper_id) AS total_campers_evaluados
FROM modulo m
JOIN evaluacion e ON m.modulo_id = e.modulo_id
GROUP BY m.modulo_id;
```

8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.
```sql
SELECT a.area_id, a.nombre AS area, 
       COUNT(DISTINCT cr.camper_id) AS campers_asignados, 
       (COUNT(DISTINCT cr.camper_id) / 33.0) * 100 AS porcentaje_ocupacion
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY a.area_id;
```

9. Mostrar cuántos trainers tiene asignados cada área.
```sql
SELECT a.area_id, a.nombre AS area, COUNT(DISTINCT at.trainer_id) AS total_trainers
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN asignacionTrainer at ON r.ruta_id = at.ruta_id
GROUP BY a.area_id;
```

10. Listar las rutas que tienen más campers en riesgo alto.
```sql
SELECT r.ruta_id, r.nombre AS ruta, COUNT(c.camper_id) AS total_campers_alto_riesgo
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nombre = 'Alto'
GROUP BY r.ruta_id
ORDER BY total_campers_alto_riesgo DESC;
```

## ⚙️ PROCEDIMIENTOS ALMACENADOS (20)
1. Registrar un nuevo camper con toda su información personal y estado inicial.
```sql
DROP PROCEDURE IF EXISTS RegistrarCamper;

DELIMITER $$

CREATE PROCEDURE RegistrarCamper(
    IN p_nombre VARCHAR(50),
    IN p_sede_id INT,
    IN p_direccion_id INT,
    IN p_acudiente_id INT,
    IN p_nivelriesgo_id INT,
    IN p_estado_id INT
)
BEGIN
    INSERT INTO campers (nombre, sede_id, direccion_id, acudiente_id, nivelriesgo_id, estado_id)
    VALUES (p_nombre, p_sede_id, p_direccion_id, p_acudiente_id, p_nivelriesgo_id, p_estado_id);
END $$

DELIMITER ;

CALL RegistrarCamper('Juan Pérez', 1, 1, 1, 1, 1);
```

2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
```sql
DELIMITER //

DROP PROCEDURE IF EXISTS ActualizarEstadoCamper;
CREATE PROCEDURE ActualizarEstadoCamper (
    IN p_camper_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(50);
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe';
    END IF;

    UPDATE campers 
    SET estado_id = 2
    WHERE camper_id = p_camper_id;
    
    SELECT 'Estado actualizado correctamente' AS mensaje;
END //

DELIMITER ;

CALL ActualizarEstadoCamper(74);
```

3. Procesar la inscripción de un camper a una ruta específica.
```sql
DELIMITER //

DROP PROCEDURE IF EXISTS InscribirCamperRuta;
CREATE PROCEDURE InscribirCamperRuta (
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(50);

    -- Verificar si el camper existe
    IF (SELECT COUNT(*) FROM campers WHERE camper_id = p_camper_id) = 0 THEN
        SET mensaje = 'El camper no existe';
    -- Verificar si la ruta existe
    ELSEIF (SELECT COUNT(*) FROM rutaEntrenamiento WHERE ruta_id = p_ruta_id) = 0 THEN
        SET mensaje = 'La ruta de entrenamiento no existe';
    -- Verificar si el módulo existe
    ELSEIF (SELECT COUNT(*) FROM modulo WHERE modulo_id = p_modulo_id) = 0 THEN
        SET mensaje = 'El módulo no existe';
    -- Verificar si el camper ya está inscrito en la ruta y módulo
    ELSEIF (SELECT COUNT(*) FROM camperRuta 
            WHERE camper_id = p_camper_id 
              AND ruta_id = p_ruta_id 
              AND modulo_id = p_modulo_id) > 0 THEN
        SET mensaje = 'El camper ya está inscrito en esta ruta y módulo';
    ELSE
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        VALUES (p_camper_id, p_ruta_id, p_modulo_id, CURDATE());

        SET mensaje = 'Inscripción realizada con éxito';
    END IF;

    SELECT mensaje AS resultado;
END //

DELIMITER ;

CALL InscribirCamperRuta(74, 1, 1)
```

4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
```sql
DELIMITER //

DROP PROCEDURE IF EXISTS RegistrarEvaluacionCompleta;

CREATE PROCEDURE RegistrarEvaluacionCompleta(
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT,
    IN p_nota_teorica DECIMAL(5,2),
    IN p_nota_practica DECIMAL(5,2),
    IN p_nota_quiz DECIMAL(5,2) 
)
BEGIN
    DECLARE mensaje VARCHAR(100);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe';
        
    -- Verificar si la ruta de entrenamiento existe
    ELSEIF NOT EXISTS (SELECT 1 FROM rutaEntrenamiento WHERE ruta_id = p_ruta_id) THEN
        SET mensaje = 'La ruta de entrenamiento no existe';

    -- Verificar si el módulo existe
    ELSEIF NOT EXISTS (SELECT 1 FROM modulo WHERE modulo_id = p_modulo_id) THEN
        SET mensaje = 'El módulo no existe';

    -- Verificar si el camper está inscrito en la ruta y módulo
    ELSEIF NOT EXISTS (
        SELECT 1 FROM camperRuta 
        WHERE camper_id = p_camper_id 
          AND ruta_id = p_ruta_id 
          AND modulo_id = p_modulo_id
    ) THEN
        SET mensaje = 'El camper no está inscrito en la ruta y módulo especificados';

    ELSE
        -- Insertar evaluación
        INSERT INTO evaluacion (camper_id, ruta_id, modulo_id, nota_teorica, nota_practica, nota_trabajo, nota_final)
        VALUES (p_camper_id, p_ruta_id, p_modulo_id, p_nota_teorica, p_nota_practica, p_nota_quiz, 0);
        
        SET mensaje = 'Evaluación registrada correctamente';
    END IF;

    -- Mostrar mensaje
    SELECT mensaje AS resultado;
END //

DELIMITER ;

CALL RegistrarEvaluacionCompleta(74, 1, 1, 88.5, 90.0, 92.0);
```

5. Calcular y registrar automáticamente la nota final de un módulo.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS CalcularNotaFinal $$
CREATE PROCEDURE CalcularNotaFinal (
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT
)
BEGIN
    DECLARE v_nota_teorica DECIMAL(5,2);
    DECLARE v_nota_practica DECIMAL(5,2);
    DECLARE v_nota_quizzes DECIMAL(5,2);
    DECLARE v_nota_final DECIMAL(5,2);
    DECLARE mensaje VARCHAR(255);

    -- Obtener las notas de la evaluación
    SELECT nota_teorica, nota_practica, nota_trabajo
    INTO v_nota_teorica, v_nota_practica, v_nota_quizzes
    FROM evaluacion
    WHERE camper_id = p_camper_id 
      AND ruta_id = p_ruta_id 
      AND modulo_id = p_modulo_id;

    -- Verificar si existen notas registradas
    IF v_nota_teorica IS NULL THEN
        SET mensaje = 'No hay evaluación registrada para este módulo.';
        SELECT mensaje;
    ELSE
        -- Calcular la nota final con ponderaciones (teórica 30%, práctica 50%, quizzes 20%)
        SET v_nota_final = (v_nota_teorica * 0.3) + (v_nota_practica * 0.5) + (v_nota_quizzes * 0.2);

        -- Actualizar la nota final en la tabla de evaluación
        UPDATE evaluacion
        SET nota_final = v_nota_final
        WHERE camper_id = p_camper_id 
          AND ruta_id = p_ruta_id 
          AND modulo_id = p_modulo_id;

        SET mensaje = CONCAT('Nota final calculada y registrada: ', v_nota_final);
        SELECT mensaje;
    END IF;
END $$

DELIMITER ;

CALL CalcularNotaFinal(74, 1, 1);
```

6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarCampersAprobados$$

CREATE PROCEDURE AsignarCampersAprobados(
    IN p_ruta_id INT
)
BEGIN
    DECLARE v_capacidad INT;
    DECLARE v_ocupados INT;
    DECLARE v_disponibles INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la capacidad total del área de la ruta
    SELECT a.capacidad INTO v_capacidad
    FROM areas a
    JOIN rutaEntrenamiento r ON a.area_id = r.area_id
    WHERE r.ruta_id = p_ruta_id;

    -- Obtener la cantidad de campers ya asignados a la ruta
    SELECT COUNT(*) INTO v_ocupados
    FROM camperRuta
    WHERE ruta_id = p_ruta_id;

    -- Calcular el espacio disponible
    SET v_disponibles = v_capacidad - v_ocupados;

    -- Verificar si hay cupo en el área de entrenamiento
    IF v_disponibles <= 0 THEN
        SET mensaje = 'Error: No hay cupo disponible en esta ruta.';
        SELECT mensaje;
    ELSE
        -- Insertar los campers aprobados que aún no han sido asignados a esta ruta
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        SELECT e.camper_id, p_ruta_id, 
               (SELECT MAX(m.modulo_id) FROM evaluacion e2 
                JOIN modulo m ON e2.modulo_id = m.modulo_id 
                WHERE e2.camper_id = e.camper_id AND e2.ruta_id = p_ruta_id),
               CURDATE()
        FROM evaluacion e
        WHERE e.ruta_id = p_ruta_id
        GROUP BY e.camper_id
        HAVING MIN(e.nota_final) >= 60
        LIMIT v_disponibles;

        SET mensaje = CONCAT('Campers asignados a la ruta ', p_ruta_id);
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;


CALL AsignarCampersAprobados(3);
```

7. Asignar un trainer a una ruta y área específica, validando el horario.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarTrainerARuta$$

CREATE PROCEDURE AsignarTrainerARuta(
    IN p_trainer_id INT,
    IN p_ruta_id INT,
    IN p_horario_id INT
)
BEGIN
    DECLARE v_area_id INT;
    DECLARE v_conflicto INT DEFAULT 0;
    DECLARE mensaje VARCHAR(255);

    -- Obtener el área de entrenamiento asociada a la ruta
    SELECT area_id INTO v_area_id
    FROM rutaEntrenamiento
    WHERE ruta_id = p_ruta_id;

    -- Verificar si el trainer ya tiene asignaciones en el mismo horario
    SELECT COUNT(*) INTO v_conflicto
    FROM asignacionTrainer
    WHERE trainer_id = p_trainer_id
      AND horario_id = p_horario_id;

    IF v_conflicto = 0 THEN
        -- Asignar el trainer a la ruta y horario
        INSERT INTO asignacionTrainer (trainer_id, ruta_id, horario_id)
        VALUES (p_trainer_id, p_ruta_id, p_horario_id);

        SET mensaje = 'Trainer asignado exitosamente.';
    ELSE
        SET mensaje = 'Error: El trainer ya tiene una asignación en este horario.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL AsignarTrainerARuta(2, 2, 1);
```

8. Registrar una nueva ruta con sus módulos y SGDB asociados.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarNuevaRuta$$

CREATE PROCEDURE RegistrarNuevaRuta(
    IN p_nombre VARCHAR(50),
    IN p_horario_id INT,
    IN p_backend_id INT,
    IN p_programacionformal_id INT,
    IN p_sgbd_id INT,
    IN p_sgbda_id INT,
    IN p_area_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Insertar la nueva ruta
    INSERT INTO rutaEntrenamiento (nombre, horario_id, backend_id, programacionformal_id, sgbd_id, sgbda_id, area_id)
    VALUES (p_nombre, p_horario_id, p_backend_id, p_programacionformal_id, p_sgbd_id, p_sgbda_id, p_area_id);

    SET mensaje = 'Nueva ruta registrada correctamente.';
    
    SELECT mensaje;
END$$

DELIMITER ;

CALL RegistrarNuevaRuta('Full Stack Web', 2, 1, 2, 1, 2, 3);
```

9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarNuevaArea$$

CREATE PROCEDURE RegistrarNuevaArea(
    IN p_nombre VARCHAR(50),
    IN p_capacidad INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Insertar la nueva área de entrenamiento
    INSERT INTO areas (nombre, capacidad)
    VALUES (p_nombre, p_capacidad);

    SET mensaje = 'Área de entrenamiento registrada correctamente.';
    
    SELECT mensaje;
END$$

DELIMITER ;

CALL RegistrarNuevaArea('Naves', 50);
```

10. Consultar disponibilidad de horario en un área determinada.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ConsultarDisponibilidadHorario$$

CREATE PROCEDURE ConsultarDisponibilidadHorario(
    IN p_area_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE total_camper INT;
    DECLARE capacidad_area INT;

    -- Obtener la capacidad máxima del área
    SELECT capacidad INTO capacidad_area FROM areas WHERE area_id = p_area_id;

    -- Contar la cantidad de campers inscritos en rutas dentro del área
    SELECT COUNT(c.camper_id) INTO total_camper
    FROM camperRuta c
    JOIN rutaEntrenamiento r ON c.ruta_id = r.ruta_id
    WHERE r.area_id = p_area_id;

    -- Verificar disponibilidad
    IF total_camper < capacidad_area THEN
        SET mensaje = 'Hay disponibilidad en el área seleccionada.';
    ELSE
        SET mensaje = 'El área seleccionada ha alcanzado su capacidad máxima.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL ConsultarDisponibilidadHorario(3);

```

11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ReasignarCamperRuta$$

CREATE PROCEDURE ReasignarCamperRuta(
    IN p_camper_id INT,
    IN p_nueva_ruta_id INT
)
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE mensaje VARCHAR(255);
    DECLARE ruta_actual INT;

    -- Obtener la ruta actual del camper
    SELECT ruta_id INTO ruta_actual
    FROM camperRuta
    WHERE camper_id = p_camper_id
    LIMIT 1;

    -- Calcular el promedio de las evaluaciones del camper
    SELECT AVG(nota_final) INTO promedio
    FROM evaluacion
    WHERE camper_id = p_camper_id;

    -- Verificar si el camper tiene bajo rendimiento (nota promedio < 60)
    IF promedio < 60 THEN
        -- Eliminar al camper de la ruta actual
        DELETE FROM camperRuta WHERE camper_id = p_camper_id;

        -- Inscribir al camper en la nueva ruta
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        SELECT p_camper_id, p_nueva_ruta_id, modulo_id, CURDATE()
        FROM modulo
        ORDER BY RAND() LIMIT 1;  -- Se asigna un módulo aleatorio de la nueva ruta

        SET mensaje = CONCAT('El camper ', p_camper_id, ' ha sido reasignado a la ruta ', p_nueva_ruta_id);
    ELSE
        SET mensaje = 'El camper tiene buen rendimiento y no necesita reasignación.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL ReasignarCamperRuta(5, 3);
```

12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS GraduarCamper$$

CREATE PROCEDURE GraduarCamper(
    IN p_camper_id INT
)
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_aprobados INT;
    DECLARE estado_graduado INT;
    DECLARE ruta_asignada INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la cantidad total de módulos en la ruta del camper
    SELECT COUNT(DISTINCT modulo_id) INTO total_modulos
    FROM camperRuta
    WHERE camper_id = p_camper_id;

    -- Obtener la cantidad de módulos aprobados (nota_final >= 60)
    SELECT COUNT(DISTINCT modulo_id) INTO modulos_aprobados
    FROM evaluacion
    WHERE camper_id = p_camper_id AND nota_final >= 60;

    -- Obtener el ID del estado "Graduado"
    SELECT estado_id INTO estado_graduado FROM estados WHERE nombre = 'Graduado';

    -- Obtener la ruta actual del camper
    SELECT ruta_id INTO ruta_asignada FROM camperRuta WHERE camper_id = p_camper_id LIMIT 1;

    -- Si el camper aprobó todos los módulos, se cambia su estado y se agrega a la tabla egresados
    IF modulos_aprobados = total_modulos AND total_modulos > 0 THEN
        UPDATE campers SET estado_id = estado_graduado WHERE camper_id = p_camper_id;
        
        -- Insertar en historial de estados
        INSERT INTO historialEstados (camper_id, estado_id, fecha_cambio) 
        VALUES (p_camper_id, estado_graduado, NOW());

        -- Registrar en la tabla de egresados
        INSERT INTO egresados (camper_id, ruta_id) VALUES (p_camper_id, ruta_asignada);
        
        SET mensaje = CONCAT('El camper ', p_camper_id, ' ha sido graduado y registrado como egresado.');
    ELSE
        SET mensaje = 'El camper aún no ha aprobado todos los módulos.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL GraduarCamper(1);
```

13. Consultar y exportar todos los datos de rendimiento de un camper.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS ConsultarRendimientoCamper$$

CREATE PROCEDURE ConsultarRendimientoCamper(
    IN p_camper_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe.';
        SELECT mensaje;
    ELSE
        -- Obtener información general del camper
        SELECT 
            c.camper_id, 
            c.nombre AS camper_nombre,
            e.nombre AS estado_actual,
            nr.nombre AS nivel_riesgo,
            s.lugar AS sede
        FROM campers c
        JOIN estados e ON c.estado_id = e.estado_id
        JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
        JOIN sedeCampus s ON c.sede_id = s.sede_id
        WHERE c.camper_id = p_camper_id;

        -- Obtener evaluaciones del camper
        SELECT 
            ev.camper_id, 
            r.nombre AS ruta,
            m.nombre AS modulo,
            ev.nota_teorica, 
            ev.nota_practica, 
            ev.nota_trabajo, 
            ev.nota_final
        FROM evaluacion ev
        JOIN rutaEntrenamiento r ON ev.ruta_id = r.ruta_id
        JOIN modulo m ON ev.modulo_id = m.modulo_id
        WHERE ev.camper_id = p_camper_id;

        -- Obtener historial de estados del camper
        SELECT 
            he.camper_id, 
            e.nombre AS estado, 
            he.fecha_cambio
        FROM historialEstados he
        JOIN estados e ON he.estado_id = e.estado_id
        WHERE he.camper_id = p_camper_id
        ORDER BY he.fecha_cambio DESC;
    END IF;
END$$

DELIMITER ;

CALL ConsultarRendimientoCamper(5);
```

14. Registrar la asistencia a clases por área y horario.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarAsistencia$$

CREATE PROCEDURE RegistrarAsistencia(
    IN p_camper_id INT,
    IN p_area_id INT,
    IN p_estadoasistencia_id INT,
    IN p_fecha DATE
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe.';
        SELECT mensaje;
    -- Verificar si el área existe
    ELSEIF NOT EXISTS (SELECT 1 FROM areas WHERE area_id = p_area_id) THEN
        SET mensaje = 'El área no existe.';
        SELECT mensaje;
    -- Verificar si el estado de asistencia es válido
    ELSEIF NOT EXISTS (SELECT 1 FROM estadosAsistencia WHERE estadoasistencia_id = p_estadoasistencia_id) THEN
        SET mensaje = 'El estado de asistencia no es válido.';
        SELECT mensaje;
    ELSE
        -- Insertar asistencia
        INSERT INTO asistencias (camper_id, area_id, estadoasistencia_id, fecha)
        VALUES (p_camper_id, p_area_id, p_estadoasistencia_id, p_fecha);

        SET mensaje = 'Asistencia registrada correctamente.';
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;


CALL RegistrarAsistencia(3, 2, 1, '2025-03-30');
```

15. Generar reporte mensual de notas por ruta.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS GenerarReporteMensual$$

CREATE PROCEDURE GenerarReporteMensual(
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar que el mes y año sean válidos
    IF p_mes < 1 OR p_mes > 12 THEN
        SET mensaje = 'El mes ingresado no es válido.';
        SELECT mensaje;
    ELSEIF p_anio < 2000 OR p_anio > YEAR(CURDATE()) THEN
        SET mensaje = 'El año ingresado no es válido.';
        SELECT mensaje;
    ELSE
        -- Obtener reporte de notas finales por ruta y módulo en el mes y año especificados
        SELECT 
            r.nombre AS ruta,
            m.nombre AS modulo,
            c.nombre AS camper,
            e.nota_teorica,
            e.nota_practica,
            e.nota_trabajo,
            e.nota_final
        FROM evaluacion e
        INNER JOIN campers c ON e.camper_id = c.camper_id
        INNER JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
        INNER JOIN modulo m ON e.modulo_id = m.modulo_id
        INNER JOIN camperRuta cr ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
        WHERE MONTH(cr.inscripcion) = p_mes 
        AND YEAR(cr.inscripcion) = p_anio
        ORDER BY r.nombre, m.nombre, e.nota_final DESC;

        SET mensaje = 'Reporte generado correctamente.';
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;

CALL GenerarReporteMensual(3, 2025);
```

16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarSalonRuta$$

CREATE PROCEDURE AsignarSalonRuta(
    IN p_ruta_id INT,
    IN p_area_id INT
)
BEGIN
    DECLARE capacidad_actual INT;
    DECLARE capacidad_maxima INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la cantidad de campers actualmente asignados al área
    SELECT COUNT(cr.camper_id) INTO capacidad_actual
    FROM camperRuta cr
    INNER JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
    WHERE r.area_id = p_area_id;

    -- Obtener la capacidad máxima del área
    SELECT capacidad INTO capacidad_maxima
    FROM areas
    WHERE area_id = p_area_id;

    -- Validar si hay espacio disponible
    IF capacidad_actual < capacidad_maxima THEN
        -- Asignar la ruta al área
        UPDATE rutaEntrenamiento 
        SET area_id = p_area_id
        WHERE ruta_id = p_ruta_id;

        SET mensaje = 'Ruta asignada al salón correctamente.';
    ELSE
        SET mensaje = 'No se puede asignar la ruta: el área está en su máxima capacidad.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;


CALL AsignarSalonRuta(3, 3);
```

17. Registrar cambio de horario de un trainer.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS CambiarHorarioTrainer$$

CREATE PROCEDURE CambiarHorarioTrainer(
    IN p_trainer_id INT,
    IN p_ruta_id INT,
    IN p_nuevo_horario_id INT
)
BEGIN
    DECLARE existe INT;
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el trainer ya tiene otra ruta en el mismo horario
    SELECT COUNT(*) INTO existe
    FROM asignacionTrainer
    WHERE trainer_id = p_trainer_id AND horario_id = p_nuevo_horario_id AND ruta_id <> p_ruta_id;

    IF existe = 0 THEN
        -- Actualizar el horario del trainer en la ruta asignada
        UPDATE asignacionTrainer 
        SET horario_id = p_nuevo_horario_id
        WHERE trainer_id = p_trainer_id AND ruta_id = p_ruta_id;

        SET mensaje = 'Horario del trainer actualizado correctamente.';
    ELSE
        SET mensaje = 'No se puede asignar el nuevo horario: conflicto con otra ruta.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL CambiarHorarioTrainer(5, 2, 3);
```

18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarInscripcionCamper$$

CREATE PROCEDURE EliminarInscripcionCamper(
    IN p_camper_id INT,
    IN p_ruta_id INT
)
BEGIN
    DECLARE existeEvaluacion INT;
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper tiene evaluaciones registradas en esa ruta
    SELECT COUNT(*) INTO existeEvaluacion
    FROM evaluacion
    WHERE camper_id = p_camper_id AND ruta_id = p_ruta_id;

    IF existeEvaluacion = 0 THEN
        -- Eliminar la inscripción del camper en la ruta
        DELETE FROM camperRuta
        WHERE camper_id = p_camper_id AND ruta_id = p_ruta_id;

        SET mensaje = 'Inscripción eliminada correctamente.';
    ELSE
        SET mensaje = 'No se puede eliminar la inscripción: el camper tiene evaluaciones registradas en esta ruta.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL EliminarInscripcionCamper(10, 3);
```

19. Recalcular el estado de todos los campers según su rendimiento acumulado.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS RecalcularEstadoCampers$$

CREATE PROCEDURE RecalcularEstadoCampers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_camper_id INT;
    DECLARE v_promedio DECIMAL(5,2);
    DECLARE estado_nuevo INT;
    DECLARE cur CURSOR FOR 
        SELECT e.camper_id, AVG(e.nota_final) 
        FROM evaluacion e
        GROUP BY e.camper_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_camper_id, v_promedio;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Determinar el nuevo estado basado en el rendimiento
        IF v_promedio >= 80 THEN
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Destacado' LIMIT 1);
        ELSEIF v_promedio >= 60 THEN
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Cursando' LIMIT 1);
        ELSE
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Alto Riesgo' LIMIT 1);
        END IF;

        -- Actualizar el estado del camper
        UPDATE campers SET estado_id = estado_nuevo WHERE camper_id = v_camper_id;

        -- Registrar el cambio en el historial
        INSERT INTO historialEstados (camper_id, estado_id, fecha_cambio)
        VALUES (v_camper_id, estado_nuevo, NOW());

    END LOOP;

    CLOSE cur;
    
    SELECT 'Estados recalculados correctamente' AS mensaje;
END$$

DELIMITER ;

CALL RecalcularEstadoCampers();
```

20. Asignar horarios automáticamente a trainers disponibles según sus áreas.
```sql
DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarHorariosTrainers $$

CREATE PROCEDURE AsignarHorariosTrainers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_trainer_id INT;
    DECLARE v_ruta_id INT;
    DECLARE v_horario_id INT;

    -- Cursor para seleccionar trainers sin horario asignado
    DECLARE cur CURSOR FOR 
    SELECT t.trainer_id, r.ruta_id, r.horario_id 
    FROM trainers t
    JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
    JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
    WHERE at.horario_id IS NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_trainer_id, v_ruta_id, v_horario_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Asignar un horario disponible al trainer
        UPDATE asignacionTrainer 
        SET horario_id = v_horario_id
        WHERE trainer_id = v_trainer_id AND ruta_id = v_ruta_id;

    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;

CALL AsignarHorariosTrainers();
```


## 🧮 FUNCIONES SQL (20)
1. Calcular el promedio ponderado de evaluaciones de un camper.
```sql
DROP FUNCTION IF EXISTS PromedioPonderadoEvaluaciones;

DELIMITER //

CREATE FUNCTION PromedioPonderadoEvaluaciones(camper_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT COALESCE(AVG((nota_teorica * 0.3) + (nota_practica * 0.5) + (nota_trabajo * 0.2)), 0)
    INTO promedio
    FROM evaluacion
    WHERE camper_id = camper_id;
    
    RETURN promedio;
END //

DELIMITER ;

SELECT PromedioPonderadoEvaluaciones(1);
```

2. Determinar si un camper aprueba o no un módulo específico.
```sql
DELIMITER //

CREATE FUNCTION DeterminarAprobacion(camperID INT, rutaID INT, moduloID INT) 
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(10);
    
    SELECT 
        CASE 
            WHEN nota_final >= 60 THEN 'Aprobado' 
            ELSE 'Reprobado' 
        END 
    INTO resultado
    FROM evaluacion 
    WHERE camper_id = camperID AND ruta_id = rutaID AND modulo_id = moduloID;

    RETURN COALESCE(resultado, 'Sin datos');
END //

DELIMITER ;

SELECT DeterminarAprobacion(1, 1, 2);
```

3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
```sql
DELIMITER //

CREATE FUNCTION EvaluarNivelRiesgo(camperID INT) 
RETURNS VARCHAR(15) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE riesgo VARCHAR(15);

    SELECT AVG(nota_final) INTO promedio
    FROM evaluacion
    WHERE camper_id = camperID;

    SET riesgo = CASE 
        WHEN promedio >= 80 THEN 'Bajo'
        WHEN promedio >= 60 THEN 'Medio'
        ELSE 'Alto'
    END;

    RETURN COALESCE(riesgo, 'Sin datos');
END //

DELIMITER ;

SELECT EvaluarNivelRiesgo(1);
```

4. Obtener el total de campers asignados a una ruta específica.
```sql
DELIMITER //

CREATE FUNCTION TotalCampersRuta(rutaID INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(DISTINCT camper_id) INTO total
    FROM camperRuta
    WHERE ruta_id = rutaID;

    RETURN total;
END //

DELIMITER ;

SELECT TotalCampersRuta(2);
```

5. Consultar la cantidad de módulos que ha aprobado un camper.
```sql
DELIMITER //

CREATE FUNCTION ModulosAprobados(camperID INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM evaluacion
    WHERE camper_id = camperID AND nota_final >= 60;

    RETURN total;
END //

DELIMITER ;

SELECT ModulosAprobados(1);
```

6. Validar si hay cupos disponibles en una determinada área.
```sql
DELIMITER //

CREATE FUNCTION HayCuposDisponibles(areaID INT) 
RETURNS VARCHAR(2) DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE inscritos INT;
    DECLARE resultado VARCHAR(2);

    SELECT capacidad INTO capacidad FROM areas WHERE area_id = areaID;

    SELECT COUNT(DISTINCT camper_id) INTO inscritos 
    FROM camperRuta cr
    JOIN rutaEntrenamiento re ON cr.ruta_id = re.ruta_id
    WHERE re.area_id = areaID;

    SET resultado = IF(inscritos < capacidad, 'SI', 'NO');

    RETURN resultado;
END //

DELIMITER ;

SELECT HayCuposDisponibles(3);
```

7. Calcular el porcentaje de ocupación de un área de entrenamiento.
```sql
DELIMITER //

CREATE FUNCTION PorcentajeOcupacion(areaID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE capacidad INT DEFAULT 0;
    DECLARE inscritos INT DEFAULT 0;
    DECLARE porcentaje DECIMAL(5,2) DEFAULT 0;

    -- Obtener la capacidad del área
    SELECT capacidad INTO capacidad FROM areas WHERE area_id = areaID;

    -- Obtener la cantidad de campers inscritos en esa área
    SELECT COUNT(DISTINCT cr.camper_id) INTO inscritos 
    FROM camperRuta cr
    JOIN rutaEntrenamiento re ON cr.ruta_id = re.ruta_id
    WHERE re.area_id = areaID;

    -- Evitar división por cero
    IF capacidad > 0 THEN
        SET porcentaje = (inscritos / capacidad) * 100;
    ELSE
        SET porcentaje = 0;
    END IF;

    RETURN porcentaje;
END //

DELIMITER ;


SELECT PorcentajeOcupacion(1);
```

8. Determinar la nota más alta obtenida en un módulo.
```sql
DELIMITER //

CREATE FUNCTION NotaMasAlta(moduloID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE max_nota DECIMAL(5,2);

    SELECT MAX(nota_final) INTO max_nota
    FROM evaluacion
    WHERE modulo_id = moduloID;

    RETURN COALESCE(max_nota, 0);
END //

DELIMITER ;

SELECT NotaMasAlta(2);
```

9. Calcular la tasa de aprobación de una ruta.
```sql
DELIMITER //

CREATE FUNCTION TasaAprobacionRuta(rutaID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE aprobados INT;
    DECLARE tasa DECIMAL(5,2);

    SELECT COUNT(DISTINCT camper_id) INTO total
    FROM camperRuta
    WHERE ruta_id = rutaID;

    SELECT COUNT(DISTINCT camper_id) INTO aprobados
    FROM evaluacion
    WHERE ruta_id = rutaID AND nota_final >= 60;

    SET tasa = IF(total > 0, (aprobados / total) * 100, 0);

    RETURN tasa;
END //

DELIMITER ;

SELECT TasaAprobacionRuta(1);
```

10. Verificar si un trainer tiene horario disponible.
```sql
DROP FUNCTION IF EXISTS verificarHorarioDisponible;

DELIMITER $$

CREATE FUNCTION verificarHorarioDisponible(trainer_id INT, horario_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE disponible BOOLEAN;

    -- Comprobamos si el trainer ya tiene asignado el horario
    SELECT COUNT(*)
    INTO disponible
    FROM asignacionTrainer
    WHERE trainer_id = trainer_id AND horario_id = horario_id;

    -- Si el conteo es 0, el horario está libre para el trainer
    IF disponible = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT verificarHorarioDisponible(1, 2); 
```

11. Obtener el promedio de notas por ruta.
```sql
DROP FUNCTION IF EXISTS promedioNotasPorRuta;

DELIMITER $$

CREATE FUNCTION promedioNotasPorRuta(ruta_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    -- Calculamos el promedio de las notas en una ruta específica
    SELECT AVG((nota_teorica + nota_practica + nota_trabajo) / 3)
    INTO promedio
    FROM evaluacion
    WHERE ruta_id = ruta_id;

    RETURN promedio;
END $$

DELIMITER ;

SELECT promedioNotasPorRuta(1);
```

12. Calcular cuántas rutas tiene asignadas un trainer.
```sql
DROP FUNCTION IF EXISTS contarRutasAsignadasTrainer;

DELIMITER $$

CREATE FUNCTION contarRutasAsignadasTrainer(trainer_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    -- Contamos cuántas rutas tiene asignadas el trainer
    SELECT COUNT(*)
    INTO cantidad
    FROM asignacionTrainer
    WHERE trainer_id = trainer_id;

    RETURN cantidad;
END $$

DELIMITER ;

SELECT contarRutasAsignadasTrainer(1);
```

13. Verificar si un camper puede ser graduado.
```sql
DROP FUNCTION IF EXISTS puedeSerGraduado;

DELIMITER $$

CREATE FUNCTION puedeSerGraduado(camper_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE aprobado INT;
    
    -- Verificamos si el camper ha aprobado todos los módulos de las rutas asignadas
    SELECT COUNT(*)
    INTO aprobado
    FROM evaluacion
    WHERE camper_id = camper_id 
    AND (nota_teorica < 60 OR nota_practica < 60 OR nota_trabajo < 60);

    -- Si no tiene ninguna nota menor a 60, puede ser graduado
    IF aprobado = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT puedeSerGraduado(1);
```

14. Obtener el estado actual de un camper en función de sus evaluaciones.
```sql
DROP FUNCTION IF EXISTS obtenerEstadoActualCamper;

DELIMITER $$

CREATE FUNCTION obtenerEstadoActualCamper(camperId INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE estadoActual VARCHAR(50);

    -- Verificamos si el camper tiene una evaluación
    SELECT 
        CASE 
            WHEN AVG(nota_final) >= 60 THEN 'Aprobado'
            ELSE 'No aprobado'
        END
    INTO estadoActual
    FROM evaluacion
    WHERE camper_id = camperId;

    -- Si no tiene evaluaciones, el estado será 'Sin evaluación'
    IF estadoActual IS NULL THEN
        SET estadoActual = 'Sin evaluación';
    END IF;

    RETURN estadoActual;
END $$

DELIMITER ;

SELECT obtenerEstadoActualCamper(1);
```

15. Calcular la carga horaria semanal de un trainer.
```sql
DROP FUNCTION IF EXISTS calcularCargaHorariaSemanal;

DELIMITER $$

CREATE FUNCTION calcularCargaHorariaSemanal(trainerId INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cargaHoraria INT;

    -- Calculamos la carga horaria total de la semana para el trainer
    SELECT SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60
    INTO cargaHoraria
    FROM asignacionTrainer at
    JOIN horarios h ON at.horario_id = h.horario_id
    WHERE at.trainer_id = trainerId;

    -- Si el trainer no tiene asignaciones, la carga horaria será 0
    IF cargaHoraria IS NULL THEN
        SET cargaHoraria = 0;
    END IF;

    RETURN cargaHoraria;
END $$

DELIMITER ;

SELECT calcularCargaHorariaSemanal(1);
```

16. Determinar si una ruta tiene módulos pendientes por evaluación.
```sql
DROP FUNCTION IF EXISTS tieneModulosPendientesEvaluacion;

DELIMITER $$

CREATE FUNCTION tieneModulosPendientesEvaluacion(rutaId INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE modulosPendientes INT;

    -- Verificamos si existen módulos en la ruta que no han sido evaluados
    SELECT COUNT(*)
    INTO modulosPendientes
    FROM camperRuta cr
    JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id AND cr.modulo_id = e.modulo_id
    WHERE cr.ruta_id = rutaId AND e.nota_final IS NULL;

    -- Si hay módulos pendientes, devolvemos TRUE, de lo contrario FALSE
    IF modulosPendientes > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT tieneModulosPendientesEvaluacion(1);
```

17. Calcular el promedio general del programa.
```sql
DROP FUNCTION IF EXISTS calcularPromedioGeneralPrograma;

DELIMITER $$

CREATE FUNCTION calcularPromedioGeneralPrograma(camperId INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    -- Calcular el promedio de todas las notas finales de los módulos de un camper
    SELECT AVG(e.nota_final)
    INTO promedio
    FROM evaluacion e
    WHERE e.camper_id = camperId AND e.nota_final IS NOT NULL;

    -- Si no hay evaluaciones, el promedio será 0
    IF promedio IS NULL THEN
        SET promedio = 0;
    END IF;

    RETURN promedio;
END $$

DELIMITER ;

SELECT calcularPromedioGeneralPrograma(1);
```

18. Verificar si un horario choca con otros entrenadores en el área.
```sql
DROP FUNCTION IF EXISTS verificarHorarioChoca;

DELIMITER $$

CREATE FUNCTION verificarHorarioChoca(trainerId INT, areaId INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE horarioChoca BOOLEAN DEFAULT FALSE;

    -- Verificar si el horario de un trainer choca con otro trainer en el mismo área
    SELECT COUNT(*)
    INTO horarioChoca
    FROM asignacionTrainer at1
    JOIN asignacionTrainer at2 ON at1.horario_id = at2.horario_id
    JOIN rutaEntrenamiento re1 ON at1.ruta_id = re1.ruta_id
    JOIN rutaEntrenamiento re2 ON at2.ruta_id = re2.ruta_id
    WHERE at1.trainer_id != at2.trainer_id
      AND re1.area_id = areaId
      AND at1.horario_id = at2.horario_id;

    -- Si existe al menos un choque de horario, se devuelve TRUE
    IF horarioChoca > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT verificarHorarioChoca(1, 1);
```

19. Calcular cuántos campers están en riesgo en una ruta específica.
```sql
DROP FUNCTION IF EXISTS calcularCampersEnRiesgo;

DELIMITER $$

CREATE FUNCTION calcularCampersEnRiesgo(rutaId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE campersEnRiesgo INT;

    -- Contar cuántos campers están en riesgo en la ruta, según su nota final
    SELECT COUNT(*)
    INTO campersEnRiesgo
    FROM evaluacion e
    JOIN camperRuta cr ON e.camper_id = cr.camper_id AND e.ruta_id = cr.ruta_id
    WHERE cr.ruta_id = rutaId AND e.nota_final < 60 AND e.nota_final IS NOT NULL;

    RETURN campersEnRiesgo;
END $$

DELIMITER ;

SELECT calcularCampersEnRiesgo(1);
```

20. Consultar el número de módulos evaluados por un camper.
```sql
DROP FUNCTION IF EXISTS contarModulosEvaluadosPorCamper;

DELIMITER $$

CREATE FUNCTION contarModulosEvaluadosPorCamper(camperId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE modulosEvaluados INT;

    -- Contar cuántos módulos han sido evaluados para el camper
    SELECT COUNT(*)
    INTO modulosEvaluados
    FROM evaluacion e
    WHERE e.camper_id = camperId AND e.nota_final IS NOT NULL;

    RETURN modulosEvaluados;
END $$

DELIMITER ;

SELECT contarModulosEvaluadosPorCamper(1);
```

## 🔁 TRIGGERS SQL (20)
1. Al insertar una evaluación, calcular automáticamente la nota final.
```sql
DROP TRIGGER IF EXISTS calcularNotaFinal;

DELIMITER $$

CREATE TRIGGER calcularNotaFinal
BEFORE INSERT ON evaluacion
FOR EACH ROW
BEGIN
    DECLARE promedio DECIMAL(5,2);

    -- Calcular el promedio de las notas registradas para la evaluación
    SET promedio = (NEW.nota_teorica + NEW.nota_practica + NEW.nota_trabajo) / 3;

    -- Asignar el promedio calculado a la nota_final antes de insertar
    SET NEW.nota_final = promedio;
END $$

DELIMITER ;
```

2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.
```sql

DELIMITER //
CREATE TRIGGER actualizarEstadoModulo
AFTER UPDATE ON evaluacion
FOR EACH ROW
BEGIN
    DECLARE aprobado_id INT;
    DECLARE desaprobado_id INT;
    
    -- Obtener los IDs de los estados "Aprobado" y "Desaprobado"
    SELECT estadomodulo_id INTO aprobado_id FROM estadoModulo WHERE nombre = 'Aprobado' LIMIT 1;
    SELECT estadomodulo_id INTO desaprobado_id FROM estadoModulo WHERE nombre = 'Reprobado' LIMIT 1;
    
    -- Verificar si el camper aprobó o desaprobó
    IF NEW.nota_final >= 60 THEN
        UPDATE modulo SET estadomodulo_id = aprobado_id
        WHERE modulo_id = NEW.modulo_id;
    ELSE
        UPDATE modulo SET estadomodulo_id = desaprobado_id
        WHERE modulo_id = NEW.modulo_id;
    END IF;
END //
DELIMITER ;
```

3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
```sql
DROP TRIGGER IF EXISTS cambiarEstadoCamperInscrito;
DELIMITER //
CREATE TRIGGER cambiarEstadoCamperInscrito
AFTER INSERT ON camperRuta
FOR EACH ROW
BEGIN
    UPDATE campers SET estado_id = (SELECT estado_id FROM estados WHERE nombre = 'Inscrito')
    WHERE camper_id = NEW.camper_id;
END //
DELIMITER ;
```

4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
```sql
DELIMITER //
CREATE TRIGGER recalcularNotaFinalUpdate
BEFORE UPDATE ON evaluacion
FOR EACH ROW
BEGIN
    SET NEW.nota_final = (NEW.nota_teorica * 0.3) + (NEW.nota_practica * 0.3) + (NEW.nota_trabajo * 0.4);
END;
//
DELIMITER ;
```

5. Al eliminar una inscripción, marcar al camper como “Retirado”.
```sql
DELIMITER //
CREATE TRIGGER marcarCamperRetirado
AFTER DELETE ON camperRuta
FOR EACH ROW
BEGIN
    UPDATE campers SET estado_id = (SELECT estado_id FROM estados WHERE nombre = 'Retirado')
    WHERE camper_id = OLD.camper_id;
END;
//
DELIMITER ;
```

6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
```sql
DELIMITER //
CREATE TRIGGER asignarSGDBModulo
AFTER INSERT ON modulo
FOR EACH ROW
BEGIN
    UPDATE modulo
    SET sgbd_id = (SELECT sgbd_id FROM rutaEntrenamiento WHERE ruta_id = NEW.ruta_id)
    WHERE modulo_id = NEW.modulo_id;
END;
//
DELIMITER ;
```

7. Al insertar un nuevo trainer, verificar duplicados por identificación.
```sql
DELIMITER //
CREATE TRIGGER verificarTrainerDuplicado
BEFORE INSERT ON trainers
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM trainers WHERE nombre = NEW.nombre AND apellido = NEW.apellido) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El trainer ya está registrado.';
    END IF;
END;
//
DELIMITER ;
```

8. Al asignar un área, validar que no exceda su capacidad.
```sql
DELIMITER //
CREATE TRIGGER validarCapacidadArea
BEFORE INSERT ON asistencias
FOR EACH ROW
BEGIN
    DECLARE capacidadMax INT;
    DECLARE ocupados INT;

    SELECT capacidad INTO capacidadMax FROM areas WHERE area_id = NEW.area_id;
    SELECT COUNT(*) INTO ocupados FROM asistencias WHERE area_id = NEW.area_id AND fecha = NEW.fecha;

    IF ocupados >= capacidadMax THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Capacidad del área excedida.';
    END IF;
END;
//
DELIMITER ;
```

9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.
```sql
DELIMITER //
CREATE TRIGGER marcarBajoRendimiento
AFTER INSERT ON evaluacion
FOR EACH ROW
BEGIN
    IF NEW.nota_final < 60 THEN
        UPDATE campers SET estado_id = (SELECT estado_id FROM estados WHERE nombre = 'Bajo rendimiento')
        WHERE camper_id = NEW.camper_id;
    END IF;
END;
//
DELIMITER ;
```

10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.
```sql
DELIMITER //
CREATE TRIGGER moverAGraduado
AFTER UPDATE ON campers
FOR EACH ROW
BEGIN
    IF NEW.estado_id = (SELECT estado_id FROM estados WHERE nombre = 'Graduado') THEN
        INSERT INTO egresados (camper_id, ruta_id)
        SELECT camper_id, ruta_id FROM camperRuta WHERE camper_id = NEW.camper_id;
    END IF;
END;
//
DELIMITER ;
```

11. Al modificar horarios de trainer, verificar solapamiento con otros.
```sql
DELIMITER //
CREATE TRIGGER validarSolapamientoHorarios
BEFORE UPDATE ON asignacionTrainer
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    IF EXISTS (
        SELECT 1 FROM asignacionTrainer
        WHERE trainer_id = NEW.trainer_id 
        AND horario_id = NEW.horario_id 
        AND asignacion_id != NEW.asignacion_id
    ) THEN
        SET mensaje = 'El trainer ya tiene un horario asignado en ese momento.';
        SELECT mensaje INTO @error;
    END IF;
END;
//
DELIMITER ;
```

12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
```sql
DELIMITER //
CREATE TRIGGER liberarHorariosTrainer
AFTER DELETE ON trainers
FOR EACH ROW
BEGIN
    DELETE FROM asignacionTrainer WHERE trainer_id = OLD.trainer_id;
END;
//
DELIMITER ;
```

13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
```sql
DELIMITER //
CREATE TRIGGER actualizarModulosAlCambiarRuta
AFTER UPDATE ON camperRuta
FOR EACH ROW
BEGIN
    UPDATE evaluacion
    SET ruta_id = NEW.ruta_id
    WHERE camper_id = NEW.camper_id;
END //
DELIMITER ;
```

14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
```sql
DELIMITER //
CREATE TRIGGER verificarDuplicadoCamper
BEFORE INSERT ON campers
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    IF (SELECT COUNT(*) FROM campers WHERE nombre = NEW.nombre AND direccion_id = NEW.direccion_id) > 0 THEN
        SET mensaje = 'El camper ya existe.';
        SELECT mensaje INTO @error;
    END IF;
END;
//
DELIMITER ;
```

15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
```sql
DELIMITER //
CREATE TRIGGER actualizarEstadoModulo
AFTER UPDATE ON evaluacion
FOR EACH ROW
BEGIN
    DECLARE aprobado_id INT;
    DECLARE desaprobado_id INT;
    
    -- Obtener los IDs de los estados "Aprobado" y "Desaprobado"
    SELECT estadomodulo_id INTO aprobado_id FROM estadoModulo WHERE nombre = 'Aprobado' LIMIT 1;
    SELECT estadomodulo_id INTO desaprobado_id FROM estadoModulo WHERE nombre = 'Reprobado' LIMIT 1;
    
    -- Verificar si el camper aprobó o desaprobó
    IF NEW.nota_final >= 60 THEN
        UPDATE modulo SET estadomodulo_id = aprobado_id
        WHERE modulo_id = NEW.modulo_id;
    ELSE
        UPDATE modulo SET estadomodulo_id = desaprobado_id
        WHERE modulo_id = NEW.modulo_id;
    END IF;
END //
DELIMITER ;
```

16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
```sql
DELIMITER //
CREATE TRIGGER validarConocimientoTrainer
BEFORE INSERT ON asignacionTrainer
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    
    IF NOT EXISTS (
        SELECT 1 FROM conocimientoTrainer
        WHERE trainer_id = NEW.trainer_id 
        AND skill_id IN (SELECT skill_id FROM skills)
    ) THEN
        SET mensaje = 'El trainer no tiene conocimientos en este módulo.';
        SELECT mensaje INTO @error;
    END IF;
END //
DELIMITER ;
```

17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
```sql
DELIMITER //
CREATE TRIGGER liberarCampersSiAreaInactiva
BEFORE UPDATE ON areas
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    IF NEW.estadoarea_id != OLD.estadoarea_id AND NEW.estadoarea_id = (SELECT estadoarea_id FROM estadoarea WHERE nombre = 'Inactiva' LIMIT 1) THEN
        UPDATE asistencias SET area_id = NULL WHERE area_id = OLD.area_id;
    END IF;
END //
DELIMITER ;
```

18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
```sql
DROP TRIGGER IF EXISTS clonarPlantilla;
DELIMITER $$
CREATE TRIGGER clonarPlantilla
AFTER INSERT ON rutaEntrenamiento
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    INSERT INTO modulo (nombre, ruta_id, estadomodulo_id)
    SELECT nombre, NEW.ruta_id, estadomodulo_id FROM modulo WHERE ruta_id = (SELECT MIN(ruta_id) FROM rutaEntrenamiento);
END$$
DELIMITER ;
```

19. Al registrar la nota práctica, verificar que no supere 60% del total.
```sql
DROP TRIGGER IF EXISTS notaPracticaVerificacion;
DELIMITER $$
CREATE TRIGGER notaPracticaVerificacion
BEFORE INSERT ON evaluacion
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    IF NEW.nota_practica > (NEW.nota_final * 0.6) THEN
        SET mensaje = 'Error: La nota práctica no puede superar el 60% de la nota final.';
        SET NEW.nota_practica = NEW.nota_final * 0.6; -- Ajustar automáticamente al 60%
    END IF;
END$$
DELIMITER ;
```

20. Al modificar una ruta, notificar cambios a los trainers asignados.
```sql
DROP TRIGGER IF EXISTS notificarTrainers;
DELIMITER $$
CREATE TRIGGER notificarTrainers
AFTER UPDATE ON rutaEntrenamiento
FOR EACH ROW
BEGIN
    DECLARE mensaje VARCHAR(255);
    IF OLD.nombre != NEW.nombre OR OLD.horario_id != NEW.horario_id THEN
        INSERT INTO trainernotificaciones (trainer_id, notificacion)
        SELECT trainer_id, CONCAT('Se ha modificado la ruta ', NEW.nombre, ' con nuevos horarios o cambios.')
        FROM asignacionTrainer WHERE ruta_id = NEW.ruta_id;
    END IF;
END$$
DELIMITER ;

```
