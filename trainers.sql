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
