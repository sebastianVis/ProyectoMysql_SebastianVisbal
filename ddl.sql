CREATE DATABASE campusdatabase;
USE campusdatabase;


CREATE TABLE sedeCampus (
    sede_id INT PRIMARY KEY,
    lugar VARCHAR(30)
);

CREATE TABLE nivelriesgo (
    nivelriesgo_id INT PRIMARY KEY,
    nombre VARCHAR(15)
);

CREATE TABLE pais (
    pais_id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

CREATE TABLE estado (
    estado_id INT PRIMARY KEY,
    nombre VARCHAR(20),
    pais_id INT,
    FOREIGN KEY (pais_id) REFERENCES pais(pais_id)
);

CREATE TABLE ciudad (
    ciudad_id INT PRIMARY KEY,
    nombre VARCHAR(20),
    zipcode VARCHAR(10),
    estado_id INT,
    FOREIGN KEY (estado_id) REFERENCES estado(estado_id)
);

CREATE TABLE direccion (
    direccion_id INT PRIMARY KEY,
    direccion VARCHAR(50),
    ciudad_id INT,
    FOREIGN KEY (ciudad_id) REFERENCES ciudad(ciudad_id)
);

CREATE TABLE telefonos (
    telefono_id INT PRIMARY KEY,
    numero VARCHAR(15)
);

CREATE TABLE campers (
    camper_id INT PRIMARY KEY,
    sede_id INT,
    nombre VARCHAR(20),
    direccion_id INT,
    acudiente_id INT,
    nivelriesgo_id INT,
    ruta_id INT,
    modulo_id INT,
    FOREIGN KEY (sede_id) REFERENCES sedeCampus(sede_id),
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id),
    FOREIGN KEY (acudiente_id) REFERENCES acudientes(acudiente_id),
    FOREIGN KEY (nivelriesgo_id) REFERENCES nivelriesgo(nivelriesgo_id)
);

CREATE TABLE acudientes (
    acudiente_id INT PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    direccion_id INT,
    telefono_id INT,
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id),
    FOREIGN KEY (telefono_id) REFERENCES telefonos(telefono_id)
);

CREATE TABLE horarios (
    horario_id INT PRIMARY KEY,
    hora_inicio TIME,
    hora_fin TIME
);

CREATE TABLE trainers (
    trainer_id INT PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    direccion_id INT,
    telefono_id INT,
    FOREIGN KEY (direccion_id) REFERENCES direccion(direccion_id),
    FOREIGN KEY (telefono_id) REFERENCES telefonos(telefono_id)
);

CREATE TABLE skills (
    skill_id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

CREATE TABLE conocimientoTrainer (
    trainer_id INT,
    skill_id INT,
    PRIMARY KEY (trainer_id, skill_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

CREATE TABLE rutaEntrenamiento (
    ruta_id INT PRIMARY KEY,
    horario_id INT,
    backend_id INT,
    programacionformal_id INT,
    sgbd_id INT,
    FOREIGN KEY (horario_id) REFERENCES horarios(horario_id),
    FOREIGN KEY (backend_id) REFERENCES backend(backend_id),
    FOREIGN KEY (programacionformal_id) REFERENCES programacionFormal(programacionformal_id),
    FOREIGN KEY (sgbd_id) REFERENCES sgbd(sgbd_id)
);

CREATE TABLE asignacionTrainer (
    asignacion_id INT PRIMARY KEY,
    trainer_id INT,
    ruta_id INT,
    horario_id INT,
    FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
    FOREIGN KEY (ruta_id) REFERENCES rutaEntrenamiento(ruta_id),
    FOREIGN KEY (horario_id) REFERENCES horarios(horario_id)
);

CREATE TABLE backend (
    backend_id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

CREATE TABLE sgbd (
    sgbd_id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

CREATE TABLE programacionFormal (
    programacionformal_id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

CREATE TABLE modulo (
    modulo_id INT PRIMARY KEY,
    nombre VARCHAR(20)
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
