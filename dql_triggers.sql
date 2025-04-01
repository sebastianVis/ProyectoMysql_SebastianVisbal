-- Implementar 20 triggers que respondan automáticamente a cambios en las tablas, como:
-- 🔁 TRIGGERS SQL (20)
-- 1. Al insertar una evaluación, calcular automáticamente la nota final.

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

-- 2. Al actualizar la nota final de un módulo, verificar si el camper aprueba o reprueba.

DROP TRIGGER IF EXISTS ApruebaOno;

DELIMITER $$
CREATE TRIGGER ApruebaOno
AFTER UPDATE ON evaluacion
FOR EACH ROW
BEGIN
    DECLARE estadoAprobado INT;
    DECLARE estadoReprobado INT;
    
    -- Buscar los estados de aprobado y reprobado
    SELECT estado_id INTO estadoAprobado FROM estados WHERE nombre = 'Aprobado' LIMIT 1;
    SELECT estado_id INTO estadoReprobado FROM estados WHERE nombre = 'Reprobado' LIMIT 1;
    
    -- Si la nota final es 60 o más, el camper aprueba, de lo contrario, reprueba
    IF NEW.nota_final >= 60 THEN
        UPDATE campers SET estado_id = estadoAprobado WHERE camper_id = NEW.camper_id;
    ELSE
        UPDATE campers SET estado_id = estadoReprobado WHERE camper_id = NEW.camper_id;
    END IF;
END$$

DELIMITER ;


-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".
-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.
-- 5. Al eliminar una inscripción, marcar al camper como “Retirado”.
-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.
-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.
-- 8. Al asignar un área, validar que no exceda su capacidad.
-- 9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.
-- 10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.
-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.
-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.
-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.
-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.
-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.
-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.
-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.
-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.
-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.
-- 20. Al modificar una ruta, notificar cambios a los trainers asignados