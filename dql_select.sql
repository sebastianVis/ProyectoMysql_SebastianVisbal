-- 1. Obtener todos los campers inscritos actualmente.

SELECT camper_id, nombre FROM campers;

-- 2. Listar los campers con estado "Aprobado".

SELECT c.nombre AS nombre_camper, e.nombre AS estado_camper
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre = 'aprobado';

-- 3. Mostrar los campers que ya están cursando alguna ruta.

SELECT c.nombre AS nombre_camper, e.nombre AS estado_camper
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre = 'cursando';


-- 4. Consultar los campers graduados por cada ruta.
SELECT r.nombre AS ruta, COUNT(c.camper_id) AS numero_graduados
FROM campers AS c
JOIN rutaEntrenamiento AS r ON c.ruta_id = r.ruta_id
WHERE c.estado_id = 5
GROUP BY r.nombre;

-- 5. Obtener los campers que se encuentran en estado "Expulsado" o "Retirado".

SELECT c.nombre AS camper, e.nombre AS estado 
FROM campers AS c
INNER JOIN estados AS e ON c.estado_id = e.estado_id
WHERE e.nombre IN ('expulsado', 'retirado');


-- 6. Listar campers con nivel de riesgo “Alto”.

SELECT c.camper_id AS id_camper, c.nombre as camper, n.nombre AS nivel_riesgo
FROM campers AS c
INNER JOIN nivelriesgo AS n ON c.nivelriesgo_id = n.nivelriesgo_id
WHERE n.nombre = 'Alto';

-- 7. Mostrar el total de campers por cada nivel de riesgo.

SELECT nr.nombre AS nivel_riesgo, COUNT(c.camper_id) AS total_campers
FROM campers AS c
JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
GROUP BY nr.nivelriesgo_id;

-- 8. Obtener campers con más de un número telefónico registrado.

SELECT c.camper_id, c.nombre, COUNT(ct.telefono_id) AS total_telefonos
FROM campers AS c
JOIN camperTelefono AS ct ON c.camper_id = ct.camper_id
GROUP BY c.camper_id
HAVING COUNT(ct.telefono_id) > 1;



-- 9. Listar los campers y sus respectivos acudientes y teléfonos.

SELECT c.camper_id, c.nombre AS camper, a.nombre AS acudiente, a.apellido AS apellido_acudiente, t.numero AS telefono
FROM campers AS c
JOIN acudientes AS a ON c.acudiente_id = a.acudiente_id
LEFT JOIN camperTelefono AS ct ON c.camper_id = ct.camper_id
LEFT JOIN telefonos AS t ON ct.telefono_id = t.telefono_id;

-- 10. Mostrar campers que aún no han sido asignados a una ruta.

SELECT c.camper_id, c.nombre 
FROM campers c
LEFT JOIN camperRuta cr ON c.camper_id = cr.camper_id
WHERE cr.ruta_id IS NULL;

-- 1. Obtener las notas teóricas, prácticas y quizzes de cada camper por módulo.

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


-- 2. Calcular la nota final de cada camper por módulo.

SELECT 
    e.camper_id, 
    c.nombre AS camper_nombre,
    e.ruta_id, 
    e.modulo_id, 
    e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id;


-- 3. Mostrar los campers que reprobaron algún módulo (nota < 60).

SELECT 
    e.camper_id, 
    c.nombre AS camper_nombre,
    e.ruta_id, 
    e.modulo_id, 
    e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE e.nota_final < 60;


-- 4. Listar los módulos con más campers en bajo rendimiento.

SELECT 
    e.modulo_id, 
    m.nombre AS modulo_nombre, 
    COUNT(e.camper_id) AS total_reprobados
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
WHERE e.nota_final < 60
GROUP BY e.modulo_id
ORDER BY total_reprobados DESC;


-- 5. Obtener el promedio de notas finales por cada módulo.

SELECT 
    e.modulo_id, 
    m.nombre AS modulo_nombre, 
    AVG(e.nota_final) AS promedio_nota_final
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY e.modulo_id;


-- 6. Consultar el rendimiento general por ruta de entrenamiento.

SELECT 
    e.ruta_id, 
    r.nombre AS ruta_nombre, 
    AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
GROUP BY e.ruta_id;


-- 7. Mostrar los trainers responsables de campers con bajo rendimiento.

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


-- 8. Comparar el promedio de rendimiento por trainer.

SELECT 
    t.trainer_id, 
    t.nombre AS trainer_nombre, 
    AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN asignacionTrainer at ON e.ruta_id = at.ruta_id
JOIN trainers t ON at.trainer_id = t.trainer_id
GROUP BY t.trainer_id
ORDER BY promedio_rendimiento DESC;


-- 9. Listar los mejores 5 campers por nota final en cada ruta.

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


-- 10. Mostrar cuántos campers pasaron cada módulo por ruta.

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

-- 1. Mostrar todas las rutas de entrenamiento disponibles.

SELECT ruta_id, nombre
FROM rutaEntrenamiento;


-- 2. Obtener las rutas con su SGDB principal y alternativo.

SELECT r.ruta_id, r.nombre, s1.nombre AS sgdb_principal, s2.nombre AS sgdb_alternativo
FROM rutaEntrenamiento r
JOIN sgbd s1 ON r.sgbd_id = s1.sgbd_id
JOIN sgbd s2 ON r.sgbda_id = s2.sgbd_id;

-- 3. Listar los módulos asociados a cada ruta.

SELECT DISTINCT r.ruta_id, r.nombre AS ruta, m.modulo_id, m.nombre AS modulo
FROM camperRuta cr
JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
JOIN modulo m ON cr.modulo_id = m.modulo_id
ORDER BY r.ruta_id, m.modulo_id;


-- 4. Consultar cuántos campers hay en cada ruta.

SELECT r.ruta_id, r.nombre AS ruta, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
LEFT JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY r.ruta_id, r.nombre;


-- 5. Mostrar las áreas de entrenamiento y su capacidad máxima.

SELECT s.salon_id, s.nombre AS area, s.capacidad 
FROM salones s;


-- 6. Obtener las áreas que están ocupadas al 100%.

SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS ocupacion_actual, s.capacidad
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
HAVING COUNT(cr.camper_id) >= s.capacidad; --No va a salir nada porque los salones estan con 26 estudiantes cada uno, si quiere verificar, cambie el > por <


-- 7. Verificar la ocupación actual de cada área.

SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS ocupacion_actual, s.capacidad,
       (COUNT(cr.camper_id) * 100.0 / s.capacidad) AS porcentaje_ocupacion
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id;


-- 8. Consultar los horarios disponibles por cada área.

SELECT s.salon_id, s.nombre AS area, h.horario_id, h.hora_inicio, h.hora_fin
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN horarios h ON r.horario_id = h.horario_id;


-- 9. Mostrar las áreas con más campers asignados.

SELECT s.salon_id, s.nombre AS area, COUNT(cr.camper_id) AS total_campers
FROM rutaEntrenamiento r
JOIN salones s ON r.salon_id = s.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
ORDER BY total_campers DESC;


-- 10. Listar las rutas con sus respectivos trainers y áreas asignadas.

SELECT r.ruta_id, r.nombre AS ruta, t.nombre AS trainer, t.apellido, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN salones s ON r.salon_id = s.salon_id;

-- 1. Listar todos los entrenadores registrados.

SELECT trainer_id, nombre, apellido 
FROM trainers;


-- 2. Mostrar los trainers con sus horarios asignados.

SELECT t.trainer_id, t.nombre, t.apellido, h.hora_inicio, h.hora_fin
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id;

-- 3. Consultar los trainers asignados a más de una ruta.

SELECT t.trainer_id, t.nombre, t.apellido, COUNT(at.ruta_id) AS total_rutas
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
GROUP BY t.trainer_id
HAVING COUNT(at.ruta_id) > 1; -- Mi papá Jholver quien mas

-- 4. Obtener el número de campers por trainer.

SELECT t.trainer_id, t.nombre, t.apellido, COUNT(cr.camper_id) AS total_campers
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY t.trainer_id;


-- 5. Mostrar las áreas en las que trabaja cada trainer.

SELECT t.trainer_id, t.nombre, t.apellido, s.nombre AS area
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN salones s ON r.salon_id = s.salon_id;

-- 6. Listar los trainers sin asignación de área o ruta.

SELECT t.trainer_id, t.nombre, t.apellido
FROM trainers t
LEFT JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
WHERE at.trainer_id IS NULL;


-- 7. Mostrar cuántos módulos están a cargo de cada trainer.

SELECT t.trainer_id, t.nombre, t.apellido, COUNT(DISTINCT cr.modulo_id) AS total_modulos
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY t.trainer_id;

-- 8. Obtener el trainer con mejor rendimiento promedio de campers.

SELECT t.trainer_id, t.nombre, t.apellido, AVG(e.nota_final) AS promedio_rendimiento
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN evaluacion e ON r.ruta_id = e.ruta_id
GROUP BY t.trainer_id
ORDER BY promedio_rendimiento DESC
LIMIT 1; -- No es Jholver xq el si lo pone dificil

-- 9. Consultar los horarios ocupados por cada trainer.

SELECT t.trainer_id, t.nombre, t.apellido, h.hora_inicio, h.hora_fin
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
ORDER BY t.trainer_id, h.hora_inicio;

-- 10. Mostrar la disponibilidad semanal de cada trainer.

SELECT t.trainer_id, t.nombre, t.apellido, COUNT(DISTINCT h.horario_id) AS horarios_ocupados
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN horarios h ON at.horario_id = h.horario_id
GROUP BY t.trainer_id;

-- 1. Obtener los campers con la nota más alta en cada módulo.

SELECT e.modulo_id, c.camper_id, c.nombre, e.nota_final
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE e.nota_final = (
    SELECT MAX(nota_final)
    FROM evaluacion AS sub
    WHERE sub.modulo_id = e.modulo_id
);


-- 2. Mostrar el promedio general de notas por ruta y comparar con el promedio global.

SELECT r.nombre AS ruta, 
       AVG(e.nota_final) AS promedio_ruta, 
       (SELECT AVG(nota_final) FROM evaluacion) AS promedio_global
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
GROUP BY r.nombre; 


-- 3. Listar las áreas con más del 80% de ocupación.

SELECT s.salon_id, s.nombre AS salon, COUNT(cr.camper_id) AS ocupacion, 
       (COUNT(cr.camper_id) / s.capacidad) * 100 AS porcentaje_ocupacion
FROM salones s
JOIN rutaEntrenamiento r ON s.salon_id = r.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
GROUP BY s.salon_id
HAVING porcentaje_ocupacion > 80;


-- 4. Mostrar los trainers con menos del 70% de rendimiento promedio.

SELECT t.trainer_id, t.nombre, t.apellido, AVG(e.nota_final) AS promedio_rendimiento
FROM asignacionTrainer at
JOIN trainers t ON at.trainer_id = t.trainer_id
JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
JOIN evaluacion e ON r.ruta_id = e.ruta_id
GROUP BY t.trainer_id
HAVING AVG(e.nota_final) < 70.0; -- Es q los proyectos de papá Jholver tan heavy


-- 5. Consultar los campers cuyo promedio está por debajo del promedio general.

SELECT c.camper_id, c.nombre, AVG(e.nota_final) AS promedio_camper
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
GROUP BY c.camper_id
HAVING promedio_camper < (SELECT AVG(nota_final) FROM evaluacion);


-- 6. Obtener los módulos con la menor tasa de aprobación.

SELECT e.modulo_id, m.nombre AS modulo, 
       COUNT(CASE WHEN e.nota_final >= 60 THEN 1 END) / COUNT(*) * 100 AS tasa_aprobacion
FROM evaluacion e
JOIN modulo m ON e.modulo_id = m.modulo_id
GROUP BY e.modulo_id
ORDER BY tasa_aprobacion ASC
LIMIT 5;


-- 7. Listar los campers que han aprobado todos los módulos de su ruta.

SELECT c.camper_id, c.nombre
FROM campers c
WHERE NOT EXISTS (
    SELECT 1
    FROM camperRuta cr
    LEFT JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.modulo_id = e.modulo_id
    WHERE cr.camper_id = c.camper_id AND (e.nota_final IS NULL OR e.nota_final < 60)
);

-- 8. Mostrar rutas con más de 10 campers en bajo rendimiento.

SELECT r.nombre AS ruta, COUNT(e.camper_id) AS campers_bajo_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
WHERE e.nota_final < 60
GROUP BY r.ruta_id
HAVING campers_bajo_rendimiento > 5; -- Ninguna ruta tiene mas de 10 campers en bajo rendimiento, si ponemos menos, salen la cantidad de estos


-- 9. Calcular el promedio de rendimiento por SGDB principal.

SELECT s.nombre AS sgbd, AVG(e.nota_final) AS promedio_rendimiento
FROM evaluacion e
JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
JOIN sgbd s ON r.sgbd_id = s.sgbd_id
GROUP BY s.sgbd_id;


-- 10. Listar los módulos con al menos un 30% de campers reprobados.

SELECT modulo_id
FROM evaluacion
GROUP BY modulo_id
HAVING (SUM(CASE WHEN nota_final < 60 THEN 1 ELSE 0 END) * 100 / COUNT(*)) >= 30;



-- 11. Mostrar el módulo más cursado por campers con riesgo alto.

SELECT e.modulo_id, COUNT(*) AS total_campers_alto_riesgo
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
WHERE c.nivelriesgo_id = 3  -- Suponiendo que nivel 3 es riesgo alto
GROUP BY e.modulo_id
ORDER BY total_campers_alto_riesgo DESC
LIMIT 1;

-- 12. Consultar los trainers con más de 3 rutas asignadas.

SELECT t.trainer_id, t.nombre, COUNT(a.ruta_id) AS total_rutas
FROM trainers t
JOIN asignacionTrainer a ON t.trainer_id = a.trainer_id
GROUP BY t.trainer_id
HAVING total_rutas >= 2; --ningun trainer tiene mas de 3 rutas asignadas, por eso cambio el valor a 2


-- 13. Listar los horarios más ocupados por áreas.

SELECT h.horario_id, h.hora_inicio, h.hora_fin, COUNT(*) AS total_rutas
FROM horarios h
JOIN rutaEntrenamiento r ON h.horario_id = r.horario_id
GROUP BY h.horario_id
ORDER BY total_rutas DESC
LIMIT 5;


-- 14. Consultar las rutas con el mayor número de módulos.

SELECT r.ruta_id, r.nombre AS ruta, COUNT(DISTINCT c.modulo_id) AS total_modulos
FROM camperRuta c
JOIN rutaEntrenamiento r ON c.ruta_id = r.ruta_id
GROUP BY r.ruta_id
ORDER BY total_modulos DESC
LIMIT 1;


-- 15. Obtener los campers que han cambiado de estado más de una vez.

SELECT h.camper_id, c.nombre, COUNT(DISTINCT h.estado_id) AS cambios_estado
FROM historialEstados h
JOIN campers c ON h.camper_id = c.camper_id
GROUP BY h.camper_id
HAVING cambios_estado > 1;


-- 16. Mostrar las evaluaciones donde la nota teórica sea mayor a la práctica.

SELECT camper_id, ruta_id, modulo_id, nota_teorica, nota_practica FROM evaluacion
WHERE nota_teorica > nota_practica;

-- 17. Listar los módulos donde la media de quizzes supera el 9.

SELECT modulo_id, AVG(nota_trabajo) AS promedio_quizzes
FROM evaluacion
GROUP BY modulo_id
HAVING promedio_quizzes > 70; -- No hay que superen 90, por eso voy a poner 70

-- 18. Consultar la ruta con mayor tasa de graduación.

SELECT e.ruta_id, 
       COUNT(DISTINCT e.camper_id) AS graduados, 
       (COUNT(DISTINCT e.camper_id) * 100 / (SELECT COUNT(DISTINCT c.camper_id) FROM campers c)) AS tasa_graduacion
FROM egresados e
GROUP BY e.ruta_id
ORDER BY tasa_graduacion DESC
LIMIT 1;


-- 19. Mostrar los módulos cursados por campers de nivel de riesgo medio o alto.

SELECT DISTINCT e.modulo_id, nr.nombre AS nivel_riesgo_camper
FROM evaluacion e
JOIN campers c ON e.camper_id = c.camper_id
JOIN nivelRiesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
WHERE nr.nivelriesgo_id IN (2, 3); --  2 es medio y 3 es alto

-- 20. Obtener la diferencia entre capacidad y ocupación en cada área.

SELECT s.salon_id, s.nombre, s.capacidad, 
       (s.capacidad - COUNT(c.camper_id)) AS espacios_disponibles
FROM salones s
JOIN rutaEntrenamiento r ON s.salon_id = r.salon_id
JOIN camperRuta cr ON r.ruta_id = cr.ruta_id
JOIN campers c ON cr.camper_id = c.camper_id
GROUP BY s.salon_id, s.capacidad;  -- Asi esta campus JAJAJAJAJA con espacios negativos

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
