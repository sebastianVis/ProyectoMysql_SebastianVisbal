DROP DATABASE IF EXISTS campusdatabase;
CREATE DATABASE campusdatabase;
USE campusdatabase;

CREATE TABLE sedeCampus (
    sede_id INT PRIMARY KEY AUTO_INCREMENT,
    lugar VARCHAR(50)
);

CREATE TABLE estados (
    estado_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20)
);

CREATE TABLE nivelriesgo (
    nivelriesgo_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(15)
);

CREATE TABLE pais (
    pais_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE departamento (
    departamento_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    pais_id INT,
    FOREIGN KEY (pais_id) REFERENCES pais(pais_id)
);

CREATE TABLE ciudad (
    ciudad_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    zipcode VARCHAR(10),
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES departamento(departamento_id)
);

CREATE TABLE direccion (
    direccion_id INT PRIMARY KEY AUTO_INCREMENT,
    direccion VARCHAR(100),
    ciudad_id INT,
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);

CREATE TABLE telefonos (
    telefono_id INT PRIMARY KEY AUTO_INCREMENT,
    numero VARCHAR(15)
);

CREATE TABLE backend (
    backend_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE sgbd (
    sgbd_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE programacionFormal (
    programacionformal_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE modulo (
    modulo_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE horarios (
    horario_id INT PRIMARY KEY AUTO_INCREMENT,
    hora_inicio TIME,
    hora_fin TIME
);


CREATE TABLE areas (
    area_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    capacidad INT DEFAULT 33
);

CREATE TABLE rutaEntrenamiento (
    nombre VARCHAR(50),
    ruta_id INT PRIMARY KEY AUTO_INCREMENT,
    horario_id INT,
    backend_id INT,
    programacionformal_id INT,
    sgbd_id INT,
    sgbda_id INT,
    area_id INT,
    FOREIGN KEY (area_id) REFERENCES areas(area_id),
    FOREIGN KEY (horario_id) REFERENCES horarios(horario_id),
    FOREIGN KEY (backend_id) REFERENCES backend(backend_id),
    FOREIGN KEY (programacionformal_id) REFERENCES programacionFormal(programacionformal_id),
    FOREIGN KEY (sgbd_id) REFERENCES sgbd(sgbd_id),
    FOREIGN KEY (sgbda_id) REFERENCES sgbd(sgbd_id)
);

CREATE TABLE acudientes (
    acudiente_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion_id INT,
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id)
);

CREATE TABLE campers (
    camper_id INT PRIMARY KEY AUTO_INCREMENT,
    sede_id INT,
    nombre VARCHAR(50),
    direccion_id INT,
    acudiente_id INT,
    nivelriesgo_id INT,
    estado_id INT,
    FOREIGN KEY (estado_id) REFERENCES estados(estado_id),
    FOREIGN KEY (sede_id) REFERENCES sedeCampus(sede_id),
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id),
    FOREIGN KEY (acudiente_id) REFERENCES acudientes(acudiente_id),
    FOREIGN KEY (nivelriesgo_id) REFERENCES nivelriesgo(nivelriesgo_id)
);

CREATE TABLE estadosAsistencia(
    estadoasistencia_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(15)
);

CREATE TABLE asistencias (
    asistencia_id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT,
    area_id INT,
    estadoasistencia_id INT,
    fecha DATE NOT NULL,
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (estadoasistencia_id) REFERENCES estadosAsistencia(estadoasistencia_id),
    FOREIGN KEY (area_id) REFERENCES areas(area_id)
);

CREATE TABLE historialEstados (
    historial_id INT PRIMARY KEY AUTO_INCREMENT,
    camper_id INT,
    estado_id INT,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (estado_id) REFERENCES estados(estado_id)
);

CREATE TABLE camperRuta (
    camper_id INT,
    ruta_id INT,
    modulo_id INT,
    inscripcion DATE DEFAULT (CURDATE()),
    PRIMARY KEY (camper_id, ruta_id, modulo_id),
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (ruta_id) REFERENCES rutaEntrenamiento(ruta_id),
    FOREIGN KEY (modulo_id) REFERENCES modulo(modulo_id)
);


CREATE TABLE trainers (
    trainer_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    direccion_id INT,
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id)
);

CREATE TABLE camperTelefono(
    camper_id INT,
    telefono_id INT,
    PRIMARY KEY (camper_id, telefono_id),
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (telefono_id) REFERENCES telefonos(telefono_id)
);

CREATE TABLE trainerTelefono(
    trainer_id INT,
    telefono_id INT,
    PRIMARY KEY (trainer_id, telefono_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (telefono_id) REFERENCES telefonos(telefono_id)
);

CREATE TABLE acudienteTelefono(
    acudiente_id INT,
    telefono_id INT,
    PRIMARY KEY (acudiente_id, telefono_id),
    FOREIGN KEY (acudiente_id) REFERENCES acudientes(acudiente_id),
    FOREIGN KEY (telefono_id) REFERENCES telefonos(telefono_id)
);

CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);

CREATE TABLE conocimientoTrainer (
    trainer_id INT,
    skill_id INT,
    PRIMARY KEY (trainer_id, skill_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

CREATE TABLE asignacionTrainer (
    asignacion_id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT,
    ruta_id INT,
    horario_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (ruta_id) REFERENCES rutaEntrenamiento(ruta_id),
    FOREIGN KEY (horario_id) REFERENCES horarios(horario_id)
);

CREATE TABLE egresados (
    camper_id INT,
    ruta_id INT,
    PRIMARY KEY (camper_id, ruta_id),
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (ruta_id) REFERENCES rutaEntrenamiento(ruta_id)
);

CREATE TABLE evaluacion (
    camper_id INT,
    ruta_id INT,
    modulo_id INT,
    nota_teorica DECIMAL(5,2),
    nota_practica DECIMAL(5,2),
    nota_trabajo DECIMAL(5,2),
    nota_final DECIMAL(5,2),
    PRIMARY KEY (camper_id, ruta_id, modulo_id),
    FOREIGN KEY (camper_id) REFERENCES campers(camper_id),
    FOREIGN KEY (ruta_id) REFERENCES rutaEntrenamiento(ruta_id),
    FOREIGN KEY (modulo_id) REFERENCES modulo(modulo_id)
);
