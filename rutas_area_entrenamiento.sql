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
