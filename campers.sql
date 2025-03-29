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
