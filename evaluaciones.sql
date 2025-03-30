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
