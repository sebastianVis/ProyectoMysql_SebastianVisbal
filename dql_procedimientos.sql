-- ⚙️ PROCEDIMIENTOS ALMACENADOS (20)
-- 1. Registrar un nuevo camper con toda su información personal y estado inicial.

DROP PROCEDURE IF EXISTS RegistrarCamper;

DELIMITER $$

CREATE PROCEDURE RegistrarCamper(
    IN p_nombre VARCHAR(50),
    IN p_sede_id INT,
    IN p_direccion_id INT,
    IN p_acudiente_id INT,
    IN p_nivelriesgo_id INT,
    IN p_estado_id INT
)
BEGIN
    INSERT INTO campers (nombre, sede_id, direccion_id, acudiente_id, nivelriesgo_id, estado_id)
    VALUES (p_nombre, p_sede_id, p_direccion_id, p_acudiente_id, p_nivelriesgo_id, p_estado_id);
END $$

DELIMITER ;

CALL RegistrarCamper('Juan Pérez', 1, 1, 1, 1, 1);


-- 2. Actualizar el estado de un camper luego de completar el proceso de ingreso.

DELIMITER //

DROP PROCEDURE IF EXISTS ActualizarEstadoCamper;
CREATE PROCEDURE ActualizarEstadoCamper (
    IN p_camper_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(50);
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe';
    END IF;

    UPDATE campers 
    SET estado_id = 2
    WHERE camper_id = p_camper_id;
    
    SELECT 'Estado actualizado correctamente' AS mensaje;
END //

DELIMITER ;

CALL ActualizarEstadoCamper(74);


-- 3. Procesar la inscripción de un camper a una ruta específica.

DELIMITER //

DROP PROCEDURE IF EXISTS InscribirCamperRuta;
CREATE PROCEDURE InscribirCamperRuta (
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(50);

    -- Verificar si el camper existe
    IF (SELECT COUNT(*) FROM campers WHERE camper_id = p_camper_id) = 0 THEN
        SET mensaje = 'El camper no existe';
    -- Verificar si la ruta existe
    ELSEIF (SELECT COUNT(*) FROM rutaEntrenamiento WHERE ruta_id = p_ruta_id) = 0 THEN
        SET mensaje = 'La ruta de entrenamiento no existe';
    -- Verificar si el módulo existe
    ELSEIF (SELECT COUNT(*) FROM modulo WHERE modulo_id = p_modulo_id) = 0 THEN
        SET mensaje = 'El módulo no existe';
    -- Verificar si el camper ya está inscrito en la ruta y módulo
    ELSEIF (SELECT COUNT(*) FROM camperRuta 
            WHERE camper_id = p_camper_id 
              AND ruta_id = p_ruta_id 
              AND modulo_id = p_modulo_id) > 0 THEN
        SET mensaje = 'El camper ya está inscrito en esta ruta y módulo';
    ELSE
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        VALUES (p_camper_id, p_ruta_id, p_modulo_id, CURDATE());

        SET mensaje = 'Inscripción realizada con éxito';
    END IF;

    SELECT mensaje AS resultado;
END //

DELIMITER ;

CALL InscribirCamperRuta(74, 1, 1)

-- 4. Registrar una evaluación completa (teórica, práctica y quizzes) para un camper.

DELIMITER //

DROP PROCEDURE IF EXISTS RegistrarEvaluacionCompleta;

CREATE PROCEDURE RegistrarEvaluacionCompleta(
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT,
    IN p_nota_teorica DECIMAL(5,2),
    IN p_nota_practica DECIMAL(5,2),
    IN p_nota_quiz DECIMAL(5,2) 
)
BEGIN
    DECLARE mensaje VARCHAR(100);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe';
        
    -- Verificar si la ruta de entrenamiento existe
    ELSEIF NOT EXISTS (SELECT 1 FROM rutaEntrenamiento WHERE ruta_id = p_ruta_id) THEN
        SET mensaje = 'La ruta de entrenamiento no existe';

    -- Verificar si el módulo existe
    ELSEIF NOT EXISTS (SELECT 1 FROM modulo WHERE modulo_id = p_modulo_id) THEN
        SET mensaje = 'El módulo no existe';

    -- Verificar si el camper está inscrito en la ruta y módulo
    ELSEIF NOT EXISTS (
        SELECT 1 FROM camperRuta 
        WHERE camper_id = p_camper_id 
          AND ruta_id = p_ruta_id 
          AND modulo_id = p_modulo_id
    ) THEN
        SET mensaje = 'El camper no está inscrito en la ruta y módulo especificados';

    ELSE
        -- Insertar evaluación
        INSERT INTO evaluacion (camper_id, ruta_id, modulo_id, nota_teorica, nota_practica, nota_trabajo, nota_final)
        VALUES (p_camper_id, p_ruta_id, p_modulo_id, p_nota_teorica, p_nota_practica, p_nota_quiz, 0);
        
        SET mensaje = 'Evaluación registrada correctamente';
    END IF;

    -- Mostrar mensaje
    SELECT mensaje AS resultado;
END //

DELIMITER ;

CALL RegistrarEvaluacionCompleta(74, 1, 1, 88.5, 90.0, 92.0);

-- 5. Calcular y registrar automáticamente la nota final de un módulo.

DELIMITER $$

DROP PROCEDURE IF EXISTS CalcularNotaFinal $$
CREATE PROCEDURE CalcularNotaFinal (
    IN p_camper_id INT,
    IN p_ruta_id INT,
    IN p_modulo_id INT
)
BEGIN
    DECLARE v_nota_teorica DECIMAL(5,2);
    DECLARE v_nota_practica DECIMAL(5,2);
    DECLARE v_nota_quizzes DECIMAL(5,2);
    DECLARE v_nota_final DECIMAL(5,2);
    DECLARE mensaje VARCHAR(255);

    -- Obtener las notas de la evaluación
    SELECT nota_teorica, nota_practica, nota_trabajo
    INTO v_nota_teorica, v_nota_practica, v_nota_quizzes
    FROM evaluacion
    WHERE camper_id = p_camper_id 
      AND ruta_id = p_ruta_id 
      AND modulo_id = p_modulo_id;

    -- Verificar si existen notas registradas
    IF v_nota_teorica IS NULL THEN
        SET mensaje = 'No hay evaluación registrada para este módulo.';
        SELECT mensaje;
    ELSE
        -- Calcular la nota final con ponderaciones (teórica 30%, práctica 50%, quizzes 20%)
        SET v_nota_final = (v_nota_teorica * 0.3) + (v_nota_practica * 0.5) + (v_nota_quizzes * 0.2);

        -- Actualizar la nota final en la tabla de evaluación
        UPDATE evaluacion
        SET nota_final = v_nota_final
        WHERE camper_id = p_camper_id 
          AND ruta_id = p_ruta_id 
          AND modulo_id = p_modulo_id;

        SET mensaje = CONCAT('Nota final calculada y registrada: ', v_nota_final);
        SELECT mensaje;
    END IF;
END $$

DELIMITER ;

CALL CalcularNotaFinal(74, 1, 1);

-- 6. Asignar campers aprobados a una ruta de acuerdo con la disponibilidad del área.

DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarCampersAprobados$$

CREATE PROCEDURE AsignarCampersAprobados(
    IN p_ruta_id INT
)
BEGIN
    DECLARE v_capacidad INT;
    DECLARE v_ocupados INT;
    DECLARE v_disponibles INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la capacidad total del área de la ruta
    SELECT a.capacidad INTO v_capacidad
    FROM areas a
    JOIN rutaEntrenamiento r ON a.area_id = r.area_id
    WHERE r.ruta_id = p_ruta_id;

    -- Obtener la cantidad de campers ya asignados a la ruta
    SELECT COUNT(*) INTO v_ocupados
    FROM camperRuta
    WHERE ruta_id = p_ruta_id;

    -- Calcular el espacio disponible
    SET v_disponibles = v_capacidad - v_ocupados;

    -- Verificar si hay cupo en el área de entrenamiento
    IF v_disponibles <= 0 THEN
        SET mensaje = 'Error: No hay cupo disponible en esta ruta.';
        SELECT mensaje;
    ELSE
        -- Insertar los campers aprobados que aún no han sido asignados a esta ruta
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        SELECT e.camper_id, p_ruta_id, 
               (SELECT MAX(m.modulo_id) FROM evaluacion e2 
                JOIN modulo m ON e2.modulo_id = m.modulo_id 
                WHERE e2.camper_id = e.camper_id AND e2.ruta_id = p_ruta_id),
               CURDATE()
        FROM evaluacion e
        WHERE e.ruta_id = p_ruta_id
        GROUP BY e.camper_id
        HAVING MIN(e.nota_final) >= 60
        LIMIT v_disponibles;

        SET mensaje = CONCAT('Campers asignados a la ruta ', p_ruta_id);
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;


CALL AsignarCampersAprobados(3);


-- 7. Asignar un trainer a una ruta y área específica, validando el horario.

DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarTrainerARuta$$

CREATE PROCEDURE AsignarTrainerARuta(
    IN p_trainer_id INT,
    IN p_ruta_id INT,
    IN p_horario_id INT
)
BEGIN
    DECLARE v_area_id INT;
    DECLARE v_conflicto INT DEFAULT 0;
    DECLARE mensaje VARCHAR(255);

    -- Obtener el área de entrenamiento asociada a la ruta
    SELECT area_id INTO v_area_id
    FROM rutaEntrenamiento
    WHERE ruta_id = p_ruta_id;

    -- Verificar si el trainer ya tiene asignaciones en el mismo horario
    SELECT COUNT(*) INTO v_conflicto
    FROM asignacionTrainer
    WHERE trainer_id = p_trainer_id
      AND horario_id = p_horario_id;

    IF v_conflicto = 0 THEN
        -- Asignar el trainer a la ruta y horario
        INSERT INTO asignacionTrainer (trainer_id, ruta_id, horario_id)
        VALUES (p_trainer_id, p_ruta_id, p_horario_id);

        SET mensaje = 'Trainer asignado exitosamente.';
    ELSE
        SET mensaje = 'Error: El trainer ya tiene una asignación en este horario.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL AsignarTrainerARuta(2, 2, 1);

-- 8. Registrar una nueva ruta con sus módulos y SGDB asociados.

DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarNuevaRuta$$

CREATE PROCEDURE RegistrarNuevaRuta(
    IN p_nombre VARCHAR(50),
    IN p_horario_id INT,
    IN p_backend_id INT,
    IN p_programacionformal_id INT,
    IN p_sgbd_id INT,
    IN p_sgbda_id INT,
    IN p_area_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Insertar la nueva ruta
    INSERT INTO rutaEntrenamiento (nombre, horario_id, backend_id, programacionformal_id, sgbd_id, sgbda_id, area_id)
    VALUES (p_nombre, p_horario_id, p_backend_id, p_programacionformal_id, p_sgbd_id, p_sgbda_id, p_area_id);

    SET mensaje = 'Nueva ruta registrada correctamente.';
    
    SELECT mensaje;
END$$

DELIMITER ;

CALL RegistrarNuevaRuta('Full Stack Web', 2, 1, 2, 1, 2, 3);


-- 9. Registrar una nueva área de entrenamiento con su capacidad y horarios.

DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarNuevaArea$$

CREATE PROCEDURE RegistrarNuevaArea(
    IN p_nombre VARCHAR(50),
    IN p_capacidad INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Insertar la nueva área de entrenamiento
    INSERT INTO areas (nombre, capacidad)
    VALUES (p_nombre, p_capacidad);

    SET mensaje = 'Área de entrenamiento registrada correctamente.';
    
    SELECT mensaje;
END$$

DELIMITER ;

CALL RegistrarNuevaArea('Naves', 50);

-- 10. Consultar disponibilidad de horario en un área determinada.

DELIMITER $$

DROP PROCEDURE IF EXISTS ConsultarDisponibilidadHorario$$

CREATE PROCEDURE ConsultarDisponibilidadHorario(
    IN p_area_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE total_camper INT;
    DECLARE capacidad_area INT;

    -- Obtener la capacidad máxima del área
    SELECT capacidad INTO capacidad_area FROM areas WHERE area_id = p_area_id;

    -- Contar la cantidad de campers inscritos en rutas dentro del área
    SELECT COUNT(c.camper_id) INTO total_camper
    FROM camperRuta c
    JOIN rutaEntrenamiento r ON c.ruta_id = r.ruta_id
    WHERE r.area_id = p_area_id;

    -- Verificar disponibilidad
    IF total_camper < capacidad_area THEN
        SET mensaje = 'Hay disponibilidad en el área seleccionada.';
    ELSE
        SET mensaje = 'El área seleccionada ha alcanzado su capacidad máxima.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL ConsultarDisponibilidadHorario(3);

-- 11. Reasignar a un camper a otra ruta en caso de bajo rendimiento.

DELIMITER $$

DROP PROCEDURE IF EXISTS ReasignarCamperRuta$$

CREATE PROCEDURE ReasignarCamperRuta(
    IN p_camper_id INT,
    IN p_nueva_ruta_id INT
)
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE mensaje VARCHAR(255);
    DECLARE ruta_actual INT;

    -- Obtener la ruta actual del camper
    SELECT ruta_id INTO ruta_actual
    FROM camperRuta
    WHERE camper_id = p_camper_id
    LIMIT 1;

    -- Calcular el promedio de las evaluaciones del camper
    SELECT AVG(nota_final) INTO promedio
    FROM evaluacion
    WHERE camper_id = p_camper_id;

    -- Verificar si el camper tiene bajo rendimiento (nota promedio < 60)
    IF promedio < 60 THEN
        -- Eliminar al camper de la ruta actual
        DELETE FROM camperRuta WHERE camper_id = p_camper_id;

        -- Inscribir al camper en la nueva ruta
        INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion)
        SELECT p_camper_id, p_nueva_ruta_id, modulo_id, CURDATE()
        FROM modulo
        ORDER BY RAND() LIMIT 1;  -- Se asigna un módulo aleatorio de la nueva ruta

        SET mensaje = CONCAT('El camper ', p_camper_id, ' ha sido reasignado a la ruta ', p_nueva_ruta_id);
    ELSE
        SET mensaje = 'El camper tiene buen rendimiento y no necesita reasignación.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL ReasignarCamperRuta(5, 3);

-- 12. Cambiar el estado de un camper a “Graduado” al finalizar todos los módulos.

DELIMITER $$

DROP PROCEDURE IF EXISTS GraduarCamper$$

CREATE PROCEDURE GraduarCamper(
    IN p_camper_id INT
)
BEGIN
    DECLARE total_modulos INT;
    DECLARE modulos_aprobados INT;
    DECLARE estado_graduado INT;
    DECLARE ruta_asignada INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la cantidad total de módulos en la ruta del camper
    SELECT COUNT(DISTINCT modulo_id) INTO total_modulos
    FROM camperRuta
    WHERE camper_id = p_camper_id;

    -- Obtener la cantidad de módulos aprobados (nota_final >= 60)
    SELECT COUNT(DISTINCT modulo_id) INTO modulos_aprobados
    FROM evaluacion
    WHERE camper_id = p_camper_id AND nota_final >= 60;

    -- Obtener el ID del estado "Graduado"
    SELECT estado_id INTO estado_graduado FROM estados WHERE nombre = 'Graduado';

    -- Obtener la ruta actual del camper
    SELECT ruta_id INTO ruta_asignada FROM camperRuta WHERE camper_id = p_camper_id LIMIT 1;

    -- Si el camper aprobó todos los módulos, se cambia su estado y se agrega a la tabla egresados
    IF modulos_aprobados = total_modulos AND total_modulos > 0 THEN
        UPDATE campers SET estado_id = estado_graduado WHERE camper_id = p_camper_id;
        
        -- Insertar en historial de estados
        INSERT INTO historialEstados (camper_id, estado_id, fecha_cambio) 
        VALUES (p_camper_id, estado_graduado, NOW());

        -- Registrar en la tabla de egresados
        INSERT INTO egresados (camper_id, ruta_id) VALUES (p_camper_id, ruta_asignada);
        
        SET mensaje = CONCAT('El camper ', p_camper_id, ' ha sido graduado y registrado como egresado.');
    ELSE
        SET mensaje = 'El camper aún no ha aprobado todos los módulos.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL GraduarCamper(1);

-- 13. Consultar y exportar todos los datos de rendimiento de un camper.

DELIMITER $$

DROP PROCEDURE IF EXISTS ConsultarRendimientoCamper$$

CREATE PROCEDURE ConsultarRendimientoCamper(
    IN p_camper_id INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe.';
        SELECT mensaje;
    ELSE
        -- Obtener información general del camper
        SELECT 
            c.camper_id, 
            c.nombre AS camper_nombre,
            e.nombre AS estado_actual,
            nr.nombre AS nivel_riesgo,
            s.lugar AS sede
        FROM campers c
        JOIN estados e ON c.estado_id = e.estado_id
        JOIN nivelriesgo nr ON c.nivelriesgo_id = nr.nivelriesgo_id
        JOIN sedeCampus s ON c.sede_id = s.sede_id
        WHERE c.camper_id = p_camper_id;

        -- Obtener evaluaciones del camper
        SELECT 
            ev.camper_id, 
            r.nombre AS ruta,
            m.nombre AS modulo,
            ev.nota_teorica, 
            ev.nota_practica, 
            ev.nota_trabajo, 
            ev.nota_final
        FROM evaluacion ev
        JOIN rutaEntrenamiento r ON ev.ruta_id = r.ruta_id
        JOIN modulo m ON ev.modulo_id = m.modulo_id
        WHERE ev.camper_id = p_camper_id;

        -- Obtener historial de estados del camper
        SELECT 
            he.camper_id, 
            e.nombre AS estado, 
            he.fecha_cambio
        FROM historialEstados he
        JOIN estados e ON he.estado_id = e.estado_id
        WHERE he.camper_id = p_camper_id
        ORDER BY he.fecha_cambio DESC;
    END IF;
END$$

DELIMITER ;

CALL ConsultarRendimientoCamper(5);

-- 14. Registrar la asistencia a clases por área y horario.

DELIMITER $$

DROP PROCEDURE IF EXISTS RegistrarAsistencia$$

CREATE PROCEDURE RegistrarAsistencia(
    IN p_camper_id INT,
    IN p_area_id INT,
    IN p_estadoasistencia_id INT,
    IN p_fecha DATE
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper existe
    IF NOT EXISTS (SELECT 1 FROM campers WHERE camper_id = p_camper_id) THEN
        SET mensaje = 'El camper no existe.';
        SELECT mensaje;
    -- Verificar si el área existe
    ELSEIF NOT EXISTS (SELECT 1 FROM areas WHERE area_id = p_area_id) THEN
        SET mensaje = 'El área no existe.';
        SELECT mensaje;
    -- Verificar si el estado de asistencia es válido
    ELSEIF NOT EXISTS (SELECT 1 FROM estadosAsistencia WHERE estadoasistencia_id = p_estadoasistencia_id) THEN
        SET mensaje = 'El estado de asistencia no es válido.';
        SELECT mensaje;
    ELSE
        -- Insertar asistencia
        INSERT INTO asistencias (camper_id, area_id, estadoasistencia_id, fecha)
        VALUES (p_camper_id, p_area_id, p_estadoasistencia_id, p_fecha);

        SET mensaje = 'Asistencia registrada correctamente.';
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;


CALL RegistrarAsistencia(3, 2, 1, '2025-03-30');

-- 15. Generar reporte mensual de notas por ruta.

DELIMITER $$

DROP PROCEDURE IF EXISTS GenerarReporteMensual$$

CREATE PROCEDURE GenerarReporteMensual(
    IN p_mes INT,
    IN p_anio INT
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Verificar que el mes y año sean válidos
    IF p_mes < 1 OR p_mes > 12 THEN
        SET mensaje = 'El mes ingresado no es válido.';
        SELECT mensaje;
    ELSEIF p_anio < 2000 OR p_anio > YEAR(CURDATE()) THEN
        SET mensaje = 'El año ingresado no es válido.';
        SELECT mensaje;
    ELSE
        -- Obtener reporte de notas finales por ruta y módulo en el mes y año especificados
        SELECT 
            r.nombre AS ruta,
            m.nombre AS modulo,
            c.nombre AS camper,
            e.nota_teorica,
            e.nota_practica,
            e.nota_trabajo,
            e.nota_final
        FROM evaluacion e
        INNER JOIN campers c ON e.camper_id = c.camper_id
        INNER JOIN rutaEntrenamiento r ON e.ruta_id = r.ruta_id
        INNER JOIN modulo m ON e.modulo_id = m.modulo_id
        INNER JOIN camperRuta cr ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id
        WHERE MONTH(cr.inscripcion) = p_mes 
        AND YEAR(cr.inscripcion) = p_anio
        ORDER BY r.nombre, m.nombre, e.nota_final DESC;

        SET mensaje = 'Reporte generado correctamente.';
        SELECT mensaje;
    END IF;
END$$

DELIMITER ;

CALL GenerarReporteMensual(3, 2025);

-- 16. Validar y registrar la asignación de un salón a una ruta sin exceder la capacidad.

DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarSalonRuta$$

CREATE PROCEDURE AsignarSalonRuta(
    IN p_ruta_id INT,
    IN p_area_id INT
)
BEGIN
    DECLARE capacidad_actual INT;
    DECLARE capacidad_maxima INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la cantidad de campers actualmente asignados al área
    SELECT COUNT(cr.camper_id) INTO capacidad_actual
    FROM camperRuta cr
    INNER JOIN rutaEntrenamiento r ON cr.ruta_id = r.ruta_id
    WHERE r.area_id = p_area_id;

    -- Obtener la capacidad máxima del área
    SELECT capacidad INTO capacidad_maxima
    FROM areas
    WHERE area_id = p_area_id;

    -- Validar si hay espacio disponible
    IF capacidad_actual < capacidad_maxima THEN
        -- Asignar la ruta al área
        UPDATE rutaEntrenamiento 
        SET area_id = p_area_id
        WHERE ruta_id = p_ruta_id;

        SET mensaje = 'Ruta asignada al salón correctamente.';
    ELSE
        SET mensaje = 'No se puede asignar la ruta: el área está en su máxima capacidad.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;


CALL AsignarSalonRuta(3, 3);

-- 17. Registrar cambio de horario de un trainer.

DELIMITER $$

DROP PROCEDURE IF EXISTS CambiarHorarioTrainer$$

CREATE PROCEDURE CambiarHorarioTrainer(
    IN p_trainer_id INT,
    IN p_ruta_id INT,
    IN p_nuevo_horario_id INT
)
BEGIN
    DECLARE existe INT;
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el trainer ya tiene otra ruta en el mismo horario
    SELECT COUNT(*) INTO existe
    FROM asignacionTrainer
    WHERE trainer_id = p_trainer_id AND horario_id = p_nuevo_horario_id AND ruta_id <> p_ruta_id;

    IF existe = 0 THEN
        -- Actualizar el horario del trainer en la ruta asignada
        UPDATE asignacionTrainer 
        SET horario_id = p_nuevo_horario_id
        WHERE trainer_id = p_trainer_id AND ruta_id = p_ruta_id;

        SET mensaje = 'Horario del trainer actualizado correctamente.';
    ELSE
        SET mensaje = 'No se puede asignar el nuevo horario: conflicto con otra ruta.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL CambiarHorarioTrainer(5, 2, 3);

-- 18. Eliminar la inscripción de un camper a una ruta (en caso de retiro).

DELIMITER $$

DROP PROCEDURE IF EXISTS EliminarInscripcionCamper$$

CREATE PROCEDURE EliminarInscripcionCamper(
    IN p_camper_id INT,
    IN p_ruta_id INT
)
BEGIN
    DECLARE existeEvaluacion INT;
    DECLARE mensaje VARCHAR(255);

    -- Verificar si el camper tiene evaluaciones registradas en esa ruta
    SELECT COUNT(*) INTO existeEvaluacion
    FROM evaluacion
    WHERE camper_id = p_camper_id AND ruta_id = p_ruta_id;

    IF existeEvaluacion = 0 THEN
        -- Eliminar la inscripción del camper en la ruta
        DELETE FROM camperRuta
        WHERE camper_id = p_camper_id AND ruta_id = p_ruta_id;

        SET mensaje = 'Inscripción eliminada correctamente.';
    ELSE
        SET mensaje = 'No se puede eliminar la inscripción: el camper tiene evaluaciones registradas en esta ruta.';
    END IF;

    SELECT mensaje;
END$$

DELIMITER ;

CALL EliminarInscripcionCamper(10, 3);

-- 19. Recalcular el estado de todos los campers según su rendimiento acumulado.

DELIMITER $$

DROP PROCEDURE IF EXISTS RecalcularEstadoCampers$$

CREATE PROCEDURE RecalcularEstadoCampers()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_camper_id INT;
    DECLARE v_promedio DECIMAL(5,2);
    DECLARE estado_nuevo INT;
    DECLARE cur CURSOR FOR 
        SELECT e.camper_id, AVG(e.nota_final) 
        FROM evaluacion e
        GROUP BY e.camper_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_camper_id, v_promedio;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Determinar el nuevo estado basado en el rendimiento
        IF v_promedio >= 80 THEN
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Destacado' LIMIT 1);
        ELSEIF v_promedio >= 60 THEN
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Cursando' LIMIT 1);
        ELSE
            SET estado_nuevo = (SELECT estado_id FROM estados WHERE nombre = 'Alto Riesgo' LIMIT 1);
        END IF;

        -- Actualizar el estado del camper
        UPDATE campers SET estado_id = estado_nuevo WHERE camper_id = v_camper_id;

        -- Registrar el cambio en el historial
        INSERT INTO historialEstados (camper_id, estado_id, fecha_cambio)
        VALUES (v_camper_id, estado_nuevo, NOW());

    END LOOP;

    CLOSE cur;
    
    SELECT 'Estados recalculados correctamente' AS mensaje;
END$$

DELIMITER ;

CALL RecalcularEstadoCampers();

-- 20. Asignar horarios automáticamente a trainers disponibles según sus áreas.

DELIMITER $$

DROP PROCEDURE IF EXISTS AsignarHorariosTrainers $$

CREATE PROCEDURE AsignarHorariosTrainers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_trainer_id INT;
    DECLARE v_ruta_id INT;
    DECLARE v_horario_id INT;

    -- Cursor para seleccionar trainers sin horario asignado
    DECLARE cur CURSOR FOR 
    SELECT t.trainer_id, r.ruta_id, r.horario_id 
    FROM trainers t
    JOIN asignacionTrainer at ON t.trainer_id = at.trainer_id
    JOIN rutaEntrenamiento r ON at.ruta_id = r.ruta_id
    WHERE at.horario_id IS NULL;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_trainer_id, v_ruta_id, v_horario_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Asignar un horario disponible al trainer
        UPDATE asignacionTrainer 
        SET horario_id = v_horario_id
        WHERE trainer_id = v_trainer_id AND ruta_id = v_ruta_id;

    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;

CALL AsignarHorariosTrainers();