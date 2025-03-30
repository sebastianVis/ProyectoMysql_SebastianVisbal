-- 🔁 JOINs Básicos (INNER JOIN, LEFT JOIN, etc.)
-- 1. Obtener los nombres completos de los campers junto con el nombre de la ruta a la que
-- están inscritos.

SELECT c.nombre AS camper, r.nombre AS ruta
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id;


-- 2. Mostrar los campers con sus evaluaciones (nota teórica, práctica, quizzes y nota final) por
-- cada módulo.

SELECT c.nombre AS camper, r.nombre AS ruta, m.nombre AS modulo, 
       e.nota_teorica, e.nota_practica, e.nota_trabajo, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
JOIN modulo m ON e.modulo_id = m.modulo_id;


-- 3. Listar todos los módulos que componen cada ruta de entrenamiento.

SELECT r.nombre AS ruta, m.nombre AS modulo
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN modulo m ON cr.modulo_id = m.modulo_id
GROUP BY r.nombre, m.nombre
ORDER BY r.nombre, m.nombre;

-- 4. Consultar las rutas con sus trainers asignados y las áreas en las que imparten clases.

SELECT r.nombre AS ruta, t.nombre AS trainer, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id;

-- 5. Mostrar los campers junto con el trainer responsable de su ruta actual.

SELECT c.nombre AS camper, r.nombre AS ruta, t.nombre AS trainer
FROM camperRuta cr
JOIN campers c ON cr.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN asignacionTrainer at ON r.ruta_id = at.ruta_id
JOIN trainers t ON at.trainer_id = t.trainer_id;

-- 6. Obtener el listado de evaluaciones realizadas con nombre de camper, módulo y ruta.

SELECT c.nombre AS camper, m.nombre AS modulo, r.nombre AS ruta, 
       e.nota_teorica, e.nota_practica, e.nota_trabajo, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN modulo m ON e.modulo_id = m.modulo_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id;


-- 7. Listar los trainers y los horarios en que están asignados a las áreas de entrenamiento.

SELECT t.nombre AS trainer, h.hora_inicio, h.hora_fin, r.nombre AS ruta
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id;

-- 8. Consultar todos los campers junto con su estado actual y el nivel de riesgo.

SELECT c.nombre AS camper, e.nombre AS estado, nr.nombre AS nivel_riesgo
FROM campers c
JOIN estados e ON c.estado_id = e.estado_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id;

-- 9. Obtener todos los módulos de cada ruta junto con su porcentaje teórico, práctico y de
-- quizzes.

SELECT r.nombre AS ruta, m.nombre AS modulo, 
       e.nota_teorica AS porcentaje_teorico, 
       e.nota_practica AS porcentaje_practico, 
       e.nota_trabajo AS porcentaje_quizzes
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id;

-- 10. Mostrar los nombres de las áreas junto con los nombres de los campers que están asistiendo
-- en esos espacios.

SELECT a.nombre AS area, c.nombre AS camper
FROM campers AS c
JOIN camperRuta AS cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento AS r ON cr.ruta_id = r.ruta_id
JOIN areas AS a ON r.area_id = a.area_id;


-- 🔀 JOINs con condiciones específicas
-- 1. Listar los campers que han aprobado todos los módulos de su ruta (nota_final >= 60).

SELECT c.camper_id, c.nombre, cr.ruta_id
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
GROUP BY c.camper_id, cr.ruta_id
HAVING MIN(e.nota_final) >= 60;


-- 2. Mostrar las rutas que tienen más de 10 campers inscritos actualmente.

SELECT r.nombre AS ruta, COUNT(cr.camper_id) AS inscritos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id
HAVING COUNT(cr.camper_id) > 10;

-- 3. Consultar las áreas que superan el 80% de su capacidad con el número actual de campers
-- asignados.

SELECT a.area_id, a.nombre, COUNT(cr.camper_id) AS total_campers, 
       (COUNT(cr.camper_id) / a.capacidad) * 100 AS porcentaje_ocupacion
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY a.area_id
HAVING porcentaje_ocupacion > 80;

-- 4. Obtener los trainers que imparten más de una ruta diferente.

SELECT t.nombre AS trainer, COUNT(DISTINCT at.ruta_id) AS rutas_asignadas
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
GROUP BY t.trainer_id
HAVING COUNT(DISTINCT at.ruta_id) > 1;

-- 5. Listar las evaluaciones donde la nota práctica es mayor que la nota teórica.

SELECT c.nombre AS camper, m.nombre AS modulo, e.nota_teorica, e.nota_practica
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_practica > e.nota_teorica;

-- 6. Mostrar campers que están en rutas cuyo SGDB principal es MySQL.

SELECT DISTINCT c.nombre AS camper, r.nombre AS ruta, s.nombre AS sgbd
FROM campers c
JOIN camperRuta cr ON c.camper_id = cr.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id
WHERE s.nombre = 'MySQL';

-- 7. Obtener los nombres de los módulos donde los campers han tenido bajo rendimiento.

SELECT DISTINCT m.nombre AS modulo, e.nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_final < 60;


-- 8. Consultar las rutas con más de 3 módulos asociados.

SELECT r.nombre AS ruta, COUNT(cr.modulo_id) AS total_modulos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id
HAVING COUNT(cr.modulo_id) > 3;

-- 9. Listar las inscripciones realizadas en los últimos 30 días con sus respectivos campers y rutas.

SELECT c.nombre AS camper, r.nombre AS ruta, cr.inscripcion
FROM camperRuta cr
JOIN campers c ON cr.camper_id = c.camper_id
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
WHERE cr.inscripcion >= CURDATE() - INTERVAL 30 DAY;


-- 10. Obtener los trainers que están asignados a rutas con campers en estado de “Alto Riesgo”.

SELECT DISTINCT t.nombre AS trainer_con_campers_alto_riesgo, r.nombre AS ruta
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nombre = 'Alto';


-- 🔎 JOINs con funciones de agregación
-- 1. Obtener el promedio de nota final por módulo.

SELECT m.nombre AS modulo, AVG(e.nota_final) AS promedio_nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY m.nombre;

-- 2. Calcular la cantidad total de campers por ruta.

SELECT r.ruta_id, r.nombre AS ruta, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id;

-- 3. Mostrar la cantidad de evaluaciones realizadas por cada trainer (según las rutas que
-- imparte).

SELECT t.trainer_id, t.nombre, COUNT(e.camper_id) AS total_evaluaciones
FROM trainers t
JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
JOIN evaluacion e ON at.ruta_id = e.ruta_id
GROUP BY t.trainer_id;

-- 4. Consultar el promedio general de rendimiento por cada área de entrenamiento.

SELECT a.area_id, a.nombre AS area, AVG(e.nota_final) AS promedio_nota_final
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
GROUP BY a.area_id;

-- 5. Obtener la cantidad de módulos asociados a cada ruta de entrenamiento.

SELECT r.ruta_id, r.nombre AS ruta, COUNT(DISTINCT cr.modulo_id) AS total_modulos
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id;

-- 6. Mostrar el promedio de nota final de los campers en estado “Cursando”.

SELECT AVG(e.nota_final) AS promedio_nota_cursando
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN estados es ON c.estado_id = es.estado_id
WHERE es.nombre = 'Cursando';

-- 7. Listar el número de campers evaluados en cada módulo.

SELECT m.modulo_id, m.nombre AS modulo, COUNT(e.camper_id) AS total_campers_evaluados
FROM modulo m
JOIN evaluacion e ON m.modulo_id = e.modulo_id
GROUP BY m.modulo_id;

-- 8. Consultar el porcentaje de ocupación actual por cada área de entrenamiento.

SELECT a.area_id, a.nombre AS area, 
       COUNT(DISTINCT cr.camper_id) AS campers_asignados, 
       (COUNT(DISTINCT cr.camper_id) / 33.0) * 100 AS porcentaje_ocupacion
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY a.area_id;

-- 9. Mostrar cuántos trainers tiene asignados cada área.

SELECT a.area_id, a.nombre AS area, COUNT(DISTINCT at.trainer_id) AS total_trainers
FROM areas a
JOIN rutaEntrenamiento r ON a.area_id = r.area_id
JOIN asignacionTrainer at ON r.ruta_id = at.ruta_id
GROUP BY a.area_id;

-- 10. Listar las rutas que tienen más campers en riesgo alto.

SELECT r.ruta_id, r.nombre AS ruta, COUNT(c.camper_id) AS total_campers_alto_riesgo
FROM rutaEntrenamiento r
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nombre = 'Alto'
GROUP BY r.ruta_id
ORDER BY total_campers_alto_riesgo DESC;
