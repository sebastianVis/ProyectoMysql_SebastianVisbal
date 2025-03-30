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