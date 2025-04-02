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


-- 3. Al insertar una inscripción, cambiar el estado del camper a "Inscrito".

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

-- 4. Al actualizar una evaluación, recalcular su promedio inmediatamente.

DELIMITER //
CREATE TRIGGER recalcularNotaFinalUpdate
BEFORE UPDATE ON evaluacion
FOR EACH ROW
BEGIN
    SET NEW.nota_final = (NEW.nota_teorica * 0.3) + (NEW.nota_practica * 0.3) + (NEW.nota_trabajo * 0.4);
END;
//
DELIMITER ;


-- 5. Al eliminar una inscripción, marcar al camper como “Retirado”.

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


-- 6. Al insertar un nuevo módulo, registrar automáticamente su SGDB asociado.

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


-- 7. Al insertar un nuevo trainer, verificar duplicados por identificación.

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



-- 8. Al asignar un área, validar que no exceda su capacidad.

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

-- 9. Al insertar una evaluación con nota < 60, marcar al camper como “Bajo rendimiento”.

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


-- 10. Al cambiar de estado a “Graduado”, mover registro a la tabla de egresados.

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


-- 11. Al modificar horarios de trainer, verificar solapamiento con otros.

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

-- 12. Al eliminar un trainer, liberar sus horarios y rutas asignadas.

DELIMITER //
CREATE TRIGGER liberarHorariosTrainer
AFTER DELETE ON trainers
FOR EACH ROW
BEGIN
    DELETE FROM asignacionTrainer WHERE trainer_id = OLD.trainer_id;
END;
//
DELIMITER ;

-- 13. Al cambiar la ruta de un camper, actualizar automáticamente sus módulos.

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

-- 14. Al insertar un nuevo camper, verificar si ya existe por número de documento.

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

-- 15. Al actualizar la nota final, recalcular el estado del módulo automáticamente.

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

-- 16. Al asignar un módulo, verificar que el trainer tenga ese conocimiento.

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


-- 17. Al cambiar el estado de un área a inactiva, liberar campers asignados.

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


-- 18. Al crear una nueva ruta, clonar la plantilla base de módulos y SGDBs.

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

-- 19. Al registrar la nota práctica, verificar que no supere 60% del total.

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

-- 20. Al modificar una ruta, notificar cambios a los trainers asignados

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
