-- 🧮 FUNCIONES SQL (20)
-- 1. Calcular el promedio ponderado de evaluaciones de un camper.DELIMITER //

DROP FUNCTION IF EXISTS PromedioPonderadoEvaluaciones;

DELIMITER //

CREATE FUNCTION PromedioPonderadoEvaluaciones(camper_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    
    SELECT COALESCE(AVG((nota_teorica * 0.3) + (nota_practica * 0.5) + (nota_trabajo * 0.2)), 0)
    INTO promedio
    FROM evaluacion
    WHERE camper_id = camper_id;
    
    RETURN promedio;
END //

DELIMITER ;

SELECT PromedioPonderadoEvaluaciones(1);

-- 2. Determinar si un camper aprueba o no un módulo específico.

DELIMITER //

CREATE FUNCTION DeterminarAprobacion(camperID INT, rutaID INT, moduloID INT) 
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
    DECLARE resultado VARCHAR(10);
    
    SELECT 
        CASE 
            WHEN nota_final >= 60 THEN 'Aprobado' 
            ELSE 'Reprobado' 
        END 
    INTO resultado
    FROM evaluacion 
    WHERE camper_id = camperID AND ruta_id = rutaID AND modulo_id = moduloID;

    RETURN COALESCE(resultado, 'Sin datos');
END //

DELIMITER ;

SELECT DeterminarAprobacion(1, 1, 2);

-- 3. Evaluar el nivel de riesgo de un camper según su rendimiento promedio.

DELIMITER //

CREATE FUNCTION EvaluarNivelRiesgo(camperID INT) 
RETURNS VARCHAR(15) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);
    DECLARE riesgo VARCHAR(15);

    SELECT AVG(nota_final) INTO promedio
    FROM evaluacion
    WHERE camper_id = camperID;

    SET riesgo = CASE 
        WHEN promedio >= 80 THEN 'Bajo'
        WHEN promedio >= 60 THEN 'Medio'
        ELSE 'Alto'
    END;

    RETURN COALESCE(riesgo, 'Sin datos');
END //

DELIMITER ;

SELECT EvaluarNivelRiesgo(1);


-- 4. Obtener el total de campers asignados a una ruta específica.

DELIMITER //

CREATE FUNCTION TotalCampersRuta(rutaID INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(DISTINCT camper_id) INTO total
    FROM camperRuta
    WHERE ruta_id = rutaID;

    RETURN total;
END //

DELIMITER ;

SELECT TotalCampersRuta(2);


-- 5. Consultar la cantidad de módulos que ha aprobado un camper.

DELIMITER //

CREATE FUNCTION ModulosAprobados(camperID INT) 
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM evaluacion
    WHERE camper_id = camperID AND nota_final >= 60;

    RETURN total;
END //

DELIMITER ;

SELECT ModulosAprobados(1);

-- 6. Validar si hay cupos disponibles en una determinada área.

DELIMITER //

CREATE FUNCTION HayCuposDisponibles(areaID INT) 
RETURNS VARCHAR(2) DETERMINISTIC
BEGIN
    DECLARE capacidad INT;
    DECLARE inscritos INT;
    DECLARE resultado VARCHAR(2);

    SELECT capacidad INTO capacidad FROM areas WHERE area_id = areaID;

    SELECT COUNT(DISTINCT camper_id) INTO inscritos 
    FROM camperRuta cr
    JOIN rutaEntrenamiento re ON cr.ruta_id = re.ruta_id
    WHERE re.area_id = areaID;

    SET resultado = IF(inscritos < capacidad, 'SI', 'NO');

    RETURN resultado;
END //

DELIMITER ;

SELECT HayCuposDisponibles(3);

-- 7. Calcular el porcentaje de ocupación de un área de entrenamiento.

DELIMITER //

CREATE FUNCTION PorcentajeOcupacion(areaID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE capacidad INT DEFAULT 0;
    DECLARE inscritos INT DEFAULT 0;
    DECLARE porcentaje DECIMAL(5,2) DEFAULT 0;

    -- Obtener la capacidad del área
    SELECT capacidad INTO capacidad FROM areas WHERE area_id = areaID;

    -- Obtener la cantidad de campers inscritos en esa área
    SELECT COUNT(DISTINCT cr.camper_id) INTO inscritos 
    FROM camperRuta cr
    JOIN rutaEntrenamiento re ON cr.ruta_id = re.ruta_id
    WHERE re.area_id = areaID;

    -- Evitar división por cero
    IF capacidad > 0 THEN
        SET porcentaje = (inscritos / capacidad) * 100;
    ELSE
        SET porcentaje = 0;
    END IF;

    RETURN porcentaje;
END //

DELIMITER ;


SELECT PorcentajeOcupacion(1);

-- 8. Determinar la nota más alta obtenida en un módulo.

DELIMITER //

CREATE FUNCTION NotaMasAlta(moduloID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE max_nota DECIMAL(5,2);

    SELECT MAX(nota_final) INTO max_nota
    FROM evaluacion
    WHERE modulo_id = moduloID;

    RETURN COALESCE(max_nota, 0);
END //

DELIMITER ;

SELECT NotaMasAlta(2);

-- 9. Calcular la tasa de aprobación de una ruta.

DELIMITER //

CREATE FUNCTION TasaAprobacionRuta(rutaID INT) 
RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE total INT;
    DECLARE aprobados INT;
    DECLARE tasa DECIMAL(5,2);

    SELECT COUNT(DISTINCT camper_id) INTO total
    FROM camperRuta
    WHERE ruta_id = rutaID;

    SELECT COUNT(DISTINCT camper_id) INTO aprobados
    FROM evaluacion
    WHERE ruta_id = rutaID AND nota_final >= 60;

    SET tasa = IF(total > 0, (aprobados / total) * 100, 0);

    RETURN tasa;
END //

DELIMITER ;

SELECT TasaAprobacionRuta(1);

-- 10. Verificar si un trainer tiene horario disponible.

DROP FUNCTION IF EXISTS verificarHorarioDisponible;

DELIMITER $$

CREATE FUNCTION verificarHorarioDisponible(trainer_id INT, horario_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE disponible BOOLEAN;

    -- Comprobamos si el trainer ya tiene asignado el horario
    SELECT COUNT(*)
    INTO disponible
    FROM asignacionTrainer
    WHERE trainer_id = trainer_id AND horario_id = horario_id;

    -- Si el conteo es 0, el horario está libre para el trainer
    IF disponible = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT verificarHorarioDisponible(1, 2); 


-- 11. Obtener el promedio de notas por ruta.

DROP FUNCTION IF EXISTS promedioNotasPorRuta;

DELIMITER $$

CREATE FUNCTION promedioNotasPorRuta(ruta_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    -- Calculamos el promedio de las notas en una ruta específica
    SELECT AVG((nota_teorica + nota_practica + nota_trabajo) / 3)
    INTO promedio
    FROM evaluacion
    WHERE ruta_id = ruta_id;

    RETURN promedio;
END $$

DELIMITER ;

SELECT promedioNotasPorRuta(1);

-- 12. Calcular cuántas rutas tiene asignadas un trainer.

DROP FUNCTION IF EXISTS contarRutasAsignadasTrainer;

DELIMITER $$

CREATE FUNCTION contarRutasAsignadasTrainer(trainer_id INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    -- Contamos cuántas rutas tiene asignadas el trainer
    SELECT COUNT(*)
    INTO cantidad
    FROM asignacionTrainer
    WHERE trainer_id = trainer_id;

    RETURN cantidad;
END $$

DELIMITER ;

SELECT contarRutasAsignadasTrainer(1);


-- 13. Verificar si un camper puede ser graduado.

DROP FUNCTION IF EXISTS puedeSerGraduado;

DELIMITER $$

CREATE FUNCTION puedeSerGraduado(camper_id INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE aprobado INT;
    
    -- Verificamos si el camper ha aprobado todos los módulos de las rutas asignadas
    SELECT COUNT(*)
    INTO aprobado
    FROM evaluacion
    WHERE camper_id = camper_id 
    AND (nota_teorica < 60 OR nota_practica < 60 OR nota_trabajo < 60);

    -- Si no tiene ninguna nota menor a 60, puede ser graduado
    IF aprobado = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT puedeSerGraduado(1);

-- 14. Obtener el estado actual de un camper en función de sus evaluaciones.

DROP FUNCTION IF EXISTS obtenerEstadoActualCamper;

DELIMITER $$

CREATE FUNCTION obtenerEstadoActualCamper(camperId INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE estadoActual VARCHAR(50);

    -- Verificamos si el camper tiene una evaluación
    SELECT 
        CASE 
            WHEN AVG(nota_final) >= 60 THEN 'Aprobado'
            ELSE 'No aprobado'
        END
    INTO estadoActual
    FROM evaluacion
    WHERE camper_id = camperId;

    -- Si no tiene evaluaciones, el estado será 'Sin evaluación'
    IF estadoActual IS NULL THEN
        SET estadoActual = 'Sin evaluación';
    END IF;

    RETURN estadoActual;
END $$

DELIMITER ;

SELECT obtenerEstadoActualCamper(1);

-- 15. Calcular la carga horaria semanal de un trainer.

DROP FUNCTION IF EXISTS calcularCargaHorariaSemanal;

DELIMITER $$

CREATE FUNCTION calcularCargaHorariaSemanal(trainerId INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cargaHoraria INT;

    -- Calculamos la carga horaria total de la semana para el trainer
    SELECT SUM(TIMESTAMPDIFF(MINUTE, h.hora_inicio, h.hora_fin)) / 60
    INTO cargaHoraria
    FROM asignacionTrainer at
    JOIN horarios h ON at.horario_id = h.horario_id
    WHERE at.trainer_id = trainerId;

    -- Si el trainer no tiene asignaciones, la carga horaria será 0
    IF cargaHoraria IS NULL THEN
        SET cargaHoraria = 0;
    END IF;

    RETURN cargaHoraria;
END $$

DELIMITER ;

SELECT calcularCargaHorariaSemanal(1);

-- 16. Determinar si una ruta tiene módulos pendientes por evaluación.

DROP FUNCTION IF EXISTS tieneModulosPendientesEvaluacion;

DELIMITER $$

CREATE FUNCTION tieneModulosPendientesEvaluacion(rutaId INT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE modulosPendientes INT;

    -- Verificamos si existen módulos en la ruta que no han sido evaluados
    SELECT COUNT(*)
    INTO modulosPendientes
    FROM camperRuta cr
    JOIN evaluacion e ON cr.camper_id = e.camper_id AND cr.ruta_id = e.ruta_id AND cr.modulo_id = e.modulo_id
    WHERE cr.ruta_id = rutaId AND e.nota_final IS NULL;

    -- Si hay módulos pendientes, devolvemos TRUE, de lo contrario FALSE
    IF modulosPendientes > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT tieneModulosPendientesEvaluacion(1);

-- 17. Calcular el promedio general del programa.

DROP FUNCTION IF EXISTS calcularPromedioGeneralPrograma;

DELIMITER $$

CREATE FUNCTION calcularPromedioGeneralPrograma(camperId INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(5,2);

    -- Calcular el promedio de todas las notas finales de los módulos de un camper
    SELECT AVG(e.nota_final)
    INTO promedio
    FROM evaluacion e
    WHERE e.camper_id = camperId AND e.nota_final IS NOT NULL;

    -- Si no hay evaluaciones, el promedio será 0
    IF promedio IS NULL THEN
        SET promedio = 0;
    END IF;

    RETURN promedio;
END $$

DELIMITER ;

SELECT calcularPromedioGeneralPrograma(1);

-- 18. Verificar si un horario choca con otros entrenadores en el área.

DROP FUNCTION IF EXISTS verificarHorarioChoca;

DELIMITER $$

CREATE FUNCTION verificarHorarioChoca(trainerId INT, areaId INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE horarioChoca BOOLEAN DEFAULT FALSE;

    -- Verificar si el horario de un trainer choca con otro trainer en el mismo área
    SELECT COUNT(*)
    INTO horarioChoca
    FROM asignacionTrainer at1
    JOIN asignacionTrainer at2 ON at1.horario_id = at2.horario_id
    JOIN rutaEntrenamiento re1 ON at1.ruta_id = re1.ruta_id
    JOIN rutaEntrenamiento re2 ON at2.ruta_id = re2.ruta_id
    WHERE at1.trainer_id != at2.trainer_id
      AND re1.area_id = areaId
      AND at1.horario_id = at2.horario_id;

    -- Si existe al menos un choque de horario, se devuelve TRUE
    IF horarioChoca > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END $$

DELIMITER ;

SELECT verificarHorarioChoca(1, 1);


-- 19. Calcular cuántos campers están en riesgo en una ruta específica.

DROP FUNCTION IF EXISTS calcularCampersEnRiesgo;

DELIMITER $$

CREATE FUNCTION calcularCampersEnRiesgo(rutaId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE campersEnRiesgo INT;

    -- Contar cuántos campers están en riesgo en la ruta, según su nota final
    SELECT COUNT(*)
    INTO campersEnRiesgo
    FROM evaluacion e
    JOIN camperRuta cr ON e.camper_id = cr.camper_id AND e.ruta_id = cr.ruta_id
    WHERE cr.ruta_id = rutaId AND e.nota_final < 60 AND e.nota_final IS NOT NULL;

    RETURN campersEnRiesgo;
END $$

DELIMITER ;

SELECT calcularCampersEnRiesgo(1);

-- 20. Consultar el número de módulos evaluados por un camper.

DROP FUNCTION IF EXISTS contarModulosEvaluadosPorCamper;

DELIMITER $$

CREATE FUNCTION contarModulosEvaluadosPorCamper(camperId INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE modulosEvaluados INT;

    -- Contar cuántos módulos han sido evaluados para el camper
    SELECT COUNT(*)
    INTO modulosEvaluados
    FROM evaluacion e
    WHERE e.camper_id = camperId AND e.nota_final IS NOT NULL;

    RETURN modulosEvaluados;
END $$

DELIMITER ;

SELECT contarModulosEvaluadosPorCamper(1);

