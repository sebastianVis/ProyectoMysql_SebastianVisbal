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

```
2. Calcular la nota final de cada camper por módulo.
```sql

```
3. Mostrar los campers que reprobaron algún módulo (nota < 60).
```sql

```
4. Listar los módulos con más campers en bajo rendimiento.
```sql

```
5. Obtener el promedio de notas finales por cada módulo.
```sql

```
6. Consultar el rendimiento general por ruta de entrenamiento.
```sql

```
7. Mostrar los trainers responsables de campers con bajo rendimiento.
```sql

```
8. Comparar el promedio de rendimiento por trainer.
```sql

```
9. Listar los mejores 5 campers por nota final en cada ruta.
```sql

```
10. Mostrar cuántos campers pasaron cada módulo por ruta.
```sql

```
🧭 Rutas y Áreas de Entrenamiento
```sql

```
1. Mostrar todas las rutas de entrenamiento disponibles.
```sql

```
2. Obtener las rutas con su SGDB principal y alternativo.
```sql

```
3. Listar los módulos asociados a cada ruta.
```sql

```
4. Consultar cuántos campers hay en cada ruta.
```sql

```
5. Mostrar las áreas de entrenamiento y su capacidad máxima.
```sql

```
6. Obtener las áreas que están ocupadas al 100%.
```sql

```
7. Verificar la ocupación actual de cada área.
```sql

```
8. Consultar los horarios disponibles por cada área.
```sql

```
9. Mostrar las áreas con más campers asignados.
```sql

```
10. Listar las rutas con sus respectivos trainers y áreas asignadas.
```sql

```

Trainers

1. Listar todos los entrenadores registrados.
```sql

```
2. Mostrar los trainers con sus horarios asignados.
```sql

```
3. Consultar los trainers asignados a más de una ruta.
```sql

```
4. Obtener el número de campers por trainer.
```sql

```
5. Mostrar las áreas en las que trabaja cada trainer.
```sql

```
6. Listar los trainers sin asignación de área o ruta.
```sql

```
7. Mostrar cuántos módulos están a cargo de cada train
```sql

```er.
8. Obtener el trainer con mejor rendimiento promedio d
```sql

```e campers.
9. Consultar los horarios ocupados por cada trainer.
```sql

```
10. Mostrar la disponibilidad semanal de cada trainer.
```sql

```
🔍 Consultas con Subconsultas y Cálculos Avanzados (20
ejemplos)
1. Obtener los campers con la nota más alta en cada módulo.
```sql

```

2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.
```sql

```

3. Listar las áreas con más del 80% de ocupación.
```sql

```

4. Mostrar los trainers con menos del 70% de rendimiento promedio.
```sql

```

5. Consultar los campers cuyo promedio está por debajo del promedio general.
```sql

```

6. Obtener los módulos con la menor tasa de aprobación.
```sql

```

7. Listar los campers que han aprobado todos los módulos de su ruta.
```sql

```

8. Mostrar rutas con más de 10 campers en bajo rendimiento.
```sql

```

9. Calcular el promedio de rendimiento por SGDB principal.
```sql

```

10. Listar los módulos con al menos un 30% de campers reprobados.
```sql

```

11. Mostrar el módulo más cursado por campers con riesgo alto.
```sql

```

12. Consultar los trainers con más de 3 rutas asignadas.
```sql

```

13. Listar los horarios más ocupados por áreas.
```sql

```

14. Consultar las rutas con el mayor número de módulos.
```sql

```

15. Obtener los campers que han cambiado de estado más de una vez.
```sql

```

16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.
```sql

```

17. Listar los módulos donde la media de quizzes supera el 9.
```sql

```

18. Consultar la ruta con mayor tasa de graduación.
```sql

```

19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.
```sql

```

20. Obtener la diferencia entre capacidad y ocupación en cada área.
```sql

```

🔁 JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)
1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que
```sql

```

están inscritos.
2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por
```sql

```

cada módulo.
3. Listar todos los módulos que componen cada ruta de entrenamiento.
```sql

```

4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.
```sql

```

5. Mostrar los campers junto con el trainer responsable de su ruta actual.
```sql

```

6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.
```sql

```

7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.
```sql

```

8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.
```sql

```

9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de
```sql

```

quizzes.
10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo
en esos espacios.
```sql

```

🔀 JOINs con condiciones específicas
1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).
```sql

```

2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.
```sql

```

3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers
```sql

```

asignados.
4. Obtener los trainers que imparten más de una ruta diferente.
```sql

```

5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.
```sql

```

6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.
```sql

```

7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.
```sql

```

8. Consultar las rutas con más de 3 módulos asociados.
```sql

```

9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.
```sql

```

10. Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.
```sql

```

🔎 JOINs con funciones de agregación
1. Obtener el promedio de nota final por módulo.
```sql

```

2. Calcular la cantidad total de campers por ruta.
```sql

```

3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que
```sql

```

imparte).
4. Consultar el promedio general de rendimiento por cada área de entrenamiento.
```sql

```

5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.
```sql

```

6. Mostrar el promedio de nota final de los campers en estado “Cursando”.
```sql

```

7. Listar el número de campers evaluados en cada módulo.
```sql

```

8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.
```sql

```

9. Mostrar cuántos trainers tiene asignados cada área.
```sql

```

10. Listar las rutas que tienen más campers en riesgo alto.
```sql

```

3. Procedimientos Almacenados
Desarrollar 20 procedimientos almacenados para automatizar tareas esenciales, tales
como:
⚙️ PROCEDIMIENTOS ALMACENADOS (20)
1. Registrar un nuevo camper con toda su información personal y estado inicial.
```sql

```

2. Actualizar el estado de un camper luego de completar el proceso de ingreso.
```sql

```

3. Procesar la inscripción de un camper a una ruta específica.
```sql

```

4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.
```sql

```

5. Calcular y registrar automáticamente la nota final de un módulo.
```sql

```

6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.
```sql

```

7. Asignar un trainer a una ruta y área específica, validando el horario.
```sql

```

8. Registrar una nueva ruta con sus módulos y SGDB asociados.
```sql

```

9. Registrar una nueva área de entrenamiento con su capacidad y horarios.
```sql

```

10. Consultar disponibilidad de horario en un área determinada.
```sql

```

11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.
```sql

```

12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.
```sql

```

13. Consultar y exportar todos los datos de rendimiento de un camper.
```sql

```

14. Registrar la asistencia a clases por área y horario.
```sql

```

15. Generar reporte mensual de notas por ruta.
```sql

```

16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.
```sql

```

17. Registrar cambio de horario de un trainer.
```sql

```

18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).
```sql

```

19. Recalcular el estado de todos los campers según su rendimiento acumulado.
```sql

```

20. Asignar horarios automáticamente a trainers disponibles según sus áreas.
```sql

```

4. Funciones SQL
Crear 20 funciones que permitan realizar cálculos personalizados, como:
🧮 FUNCIONES SQL (20)
1. Calcular el promedio ponderado de evaluaciones de un camper.
```sql

```

2. Determinar si un camper aprueba o no un módulo específico.
```sql

```

3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.
```sql

```

4. Obtener el total de campers asignados a una ruta específica.
```sql

```

5. Consultar la cantidad de módulos que ha aprobado un camper.
```sql

```

6. Validar si hay cupos disponibles en una determinada área.
```sql

```

7. Calcular el porcentaje de ocupación de un área de entrenamiento.
```sql

```

8. Determinar la nota más alta obtenida en un módulo.
```sql

```

9. Calcular la tasa de aprobación de una ruta.
```sql

```

10. Verificar si un trainer tiene horario disponible.
```sql

```

11. Obtener el promedio de notas por ruta.
```sql

```

12. Calcular cuántas rutas tiene asignadas un trainer.
```sql

```

13. Verificar si un camper puede ser graduado.
```sql

```

14. Obtener el estado actual de un camper en función de sus evaluaciones.
```sql

```

15. Calcular la carga horaria semanal de un trainer.
```sql

```

16. Determinar si una ruta tiene módulos pendientes por evaluación.
```sql

```

17. Calcular el promedio general del programa.
```sql

```

18. Verificar si un horario choca con otros entrenadores en el área.
```sql

```

19. Calcular cuántos campers están en riesgo en una ruta específica.
```sql

```

20. Consultar el número de módulos evaluados por un camper.
```sql

```



5. Triggers SQL
🔁 TRIGGERS SQL (20)
1. Al insertar una evaluación, calcular automáticamente la nota final.
```sql

```

2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.
```sql

```

3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
```sql

```

4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
```sql

```

5. Al eliminar una inscripción, marcar al camper como “Retirado”.
```sql

```

6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
```sql

```

7. Al insertar un nuevo trainer, verificar duplicados por identificación.
```sql

```

8. Al asignar un área, validar que no exceda su capacidad.
```sql

```

9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.
```sql

```

10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.
```sql

```

11. Al modificar horarios de trainer, verificar solapamiento con otros.
```sql

```

12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
```sql

```

13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
```sql

```

14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
```sql

```

15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
```sql

```

16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
```sql

```

17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
```sql

```

18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
```sql

```

19. Al registrar la nota práctica, verificar que no supere 60% del total.
```sql

```

20. Al modificar una ruta, notificar cambios a los trainers asignados.
```sql

```
