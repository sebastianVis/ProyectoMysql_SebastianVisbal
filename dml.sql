INSERT INTO sedeCampus (lugar) VALUES
('Floridablanca'),
('Bucaramanga'),
('Bogotá');

INSERT INTO estados (nombre) VALUES
('Ingreso'), ('Inscrito'), ('Aprobado'), ('Cursando'), ('Graduado'),
('Expulsado'), ('Retirado');

INSERT INTO nivelriesgo (nombre) VALUES
('Bajo'),
('Medio'),
('Alto');

INSERT INTO pais (nombre) VALUES
('Colombia');

INSERT INTO departamento (nombre, pais_id) VALUES
('Santander', 1),
('Cundinamarca', 1);

INSERT INTO ciudad (nombre, zipcode, departamento_id) VALUES
('Bucaramanga', '050001', 1),
('Bogotá', '110111', 2);

INSERT INTO direccion (direccion, ciudad_id) VALUES
('Calle 1 #10-20', 1),
('Avenida Siempre Viva 742', 2),
('Carrera 5 #23-45', 1),
('Calle 9 #15-30', 2),
('Diagonal 12 #34-56', 1),
('Transversal 18 #67-89', 2),
('Carrera 7 #89-12', 1),
('Calle 3 #21-54', 2),
('Avenida Central #45-67', 1),
('Carrera 11 #98-76', 2),
('Calle 4 #56-78', 1),
('Avenida Norte #34-56', 2),
('Diagonal 22 #65-43', 1),
('Transversal 9 #12-34', 2),
('Carrera 15 #43-21', 1),
('Calle 6 #87-65', 2),
('Avenida Sur #76-54', 1),
('Carrera 19 #54-32', 2),
('Calle 8 #34-12', 1),
('Diagonal 10 #23-41', 2),
('Transversal 5 #67-89', 1),
('Carrera 8 #76-54', 2),
('Calle 12 #90-78', 1),
('Avenida Este #54-32', 2),
('Diagonal 14 #76-54', 1),
('Carrera 10 #12-34', 2),
('Calle 7 #45-67', 1),
('Avenida Oeste #34-56', 2),
('Diagonal 5 #23-45', 1),
('Transversal 7 #89-67', 2),
('Carrera 14 #32-10', 1),
('Calle 11 #67-45', 2),
('Avenida Bolívar #54-21', 1),
('Diagonal 8 #90-76', 2),
('Transversal 3 #45-78', 1),
('Carrera 6 #12-89', 2),
('Calle 2 #34-67', 1),
('Avenida Libertad #23-45', 2),
('Diagonal 16 #78-90', 1),
('Carrera 13 #56-12', 2),
('Calle 20 #76-32', 1),
('Avenida Central #98-76', 2),
('Diagonal 19 #12-45', 1),
('Transversal 11 #45-23', 2),
('Carrera 16 #78-34', 1),
('Calle 15 #90-67', 2),
('Avenida Colombia #43-21', 1),
('Diagonal 7 #23-12', 2),
('Transversal 14 #65-78', 1),
('Carrera 17 #12-34', 2);


-- Insertar teléfonos (50 únicos)
INSERT INTO telefonos (numero) VALUES
('3001234567'),
('3102345678'),
('3203456789'),
('3304567890'),
('3405678901'),
('3506789012'),
('3607890123'),
('3708901234'),
('3809012345'),
('3900123456'),
('3001122334'),
('3102233445'),
('3203344556'),
('3304455667'),
('3405566778'),
('3506677889'),
('3607788990'),
('3708899001'),
('3809900112'),
('3901011223'),
('3002122233'),
('3103233344'),
('3204344455'),
('3305455566'),
('3406566677'),
('3507677788'),
('3608788899'),
('3709899000'),
('3800990111'),
('3901101222'),
('3002213321'),
('3104321432'),
('3205432543'),
('3306543654'),
('3407654765'),
('3508765876'),
('3609876987'),
('3700987098'),
('3801098209'),
('3902109310'),
('3003214432'),
('3104325543'),
('3205436654'),
('3306547765'),
('3407658876'),
('3508769987'),
('3609870000'),
('3700981111'),
('3801092222'),
('3902103333');


-- Insertar acudientes (50 únicos)
INSERT INTO acudientes (nombre, apellido, direccion_id, telefono_id) VALUES
('Carlos', 'Fernández', 1, 1),
('María', 'Gómez', 2, 2),
('Juan', 'López', 3, 3),
('Ana', 'Ramírez', 4, 4),
('Pedro', 'Díaz', 5, 5),
('Sofía', 'Herrera', 6, 6),
('Daniel', 'Vargas', 7, 7),
('Valentina', 'Ruiz', 8, 8),
('Mateo', 'Castro', 9, 9),
('Camila', 'Fernández', 10, 10),
('Alejandro', 'Ortega', 11, 11),
('Gabriela', 'Jiménez', 12, 12),
('Sebastián', 'Méndez', 13, 13),
('Isabella', 'Ríos', 14, 14),
('Tomás', 'Navarro', 15, 15),
('Renata', 'Solano', 16, 16),
('Emiliano', 'Cárdenas', 17, 17),
('Martina', 'Pacheco', 18, 18),
('Joaquín', 'Salas', 19, 19),
('Paula', 'Estrada', 20, 20),
('Hugo', 'Gutiérrez', 21, 21),
('Diana', 'Muñoz', 22, 22),
('Fernando', 'Arce', 23, 23),
('Andrea', 'Palacios', 24, 24),
('Samuel', 'Medina', 25, 25),
('Luciana', 'Serrano', 26, 26),
('Diego', 'Roldán', 27, 27),
('Elena', 'Benítez', 28, 28),
('Facundo', 'Morales', 29, 29),
('Victoria', 'Chávez', 30, 30),
('Rafael', 'Peña', 31, 31),
('Marina', 'Fuentes', 32, 32),
('Iván', 'Castillo', 33, 33),
('Antonia', 'Valdez', 34, 34),
('Julián', 'Cortés', 35, 35),
('Mónica', 'Lara', 36, 36),
('Luis', 'Santamaría', 37, 37),
('Emma', 'Bravo', 38, 38),
('Álvaro', 'Parra', 39, 39),
('Beatriz', 'Toledo', 40, 40),
('Rodrigo', 'Montes', 41, 41),
('Lorena', 'Ibáñez', 42, 42),
('Cristian', 'Navas', 43, 43),
('Marisol', 'Quintero', 44, 44),
('Adrián', 'Godoy', 45, 45),
('Fabiola', 'Sandoval', 46, 46),
('Raúl', 'Espinoza', 47, 47),
('Patricia', 'Cáceres', 48, 48),
('Héctor', 'Aguirre', 49, 49),
('Cecilia', 'Vargas', 50, 50);


INSERT INTO campers (sede_id, nombre, telefono_id, direccion_id, acudiente_id, nivelriesgo_id, ruta_id, modulo_id, estado_id) VALUES
(1, 'Lucas Pérez', 1, 1, 1, 1, 1, 1, 1),
(2, 'María Gómez', 2, 2, 2, 2, 2, 2, 2),
(1, 'Juan López', 3, 3, 3, 3, 3, 3, 1),
(2, 'Ana Ramírez', 4, 4, 4, 1, 4, 4, 2),
(1, 'Carlos Díaz', 5, 5, 5, 2, 5, 1, 1),
(2, 'Sofía Herrera', 6, 6, 6, 3, 1, 2, 2),
(1, 'Daniel Vargas', 7, 7, 7, 1, 2, 3, 1),
(2, 'Valentina Ruiz', 8, 8, 8, 2, 3, 4, 2),
(1, 'Mateo Castro', 9, 9, 9, 3, 4, 1, 1),
(2, 'Camila Fernández', 10, 10, 10, 1, 5, 2, 2),
(1, 'Alejandro Ortega', 11, 11, 11, 2, 1, 3, 1),
(2, 'Gabriela Jiménez', 12, 12, 12, 3, 2, 4, 2),
(1, 'Sebastián Méndez', 13, 13, 13, 1, 3, 1, 1),
(2, 'Isabella Ríos', 14, 14, 14, 2, 4, 2, 2),
(1, 'Tomás Navarro', 15, 15, 15, 3, 5, 3, 1),
(2, 'Renata Solano', 16, 16, 16, 1, 1, 4, 2),
(1, 'Emiliano Cárdenas', 17, 17, 17, 2, 2, 1, 1),
(2, 'Martina Pacheco', 18, 18, 18, 3, 3, 2, 2),
(1, 'Joaquín Salas', 19, 19, 19, 1, 4, 3, 1),
(2, 'Paula Estrada', 20, 20, 20, 2, 5, 4, 2),
(1, 'Hugo Gutiérrez', 21, 21, 21, 3, 1, 1, 1),
(2, 'Diana Muñoz', 22, 22, 22, 1, 2, 2, 2),
(1, 'Fernando Arce', 23, 23, 23, 2, 3, 3, 1),
(2, 'Andrea Palacios', 24, 24, 24, 3, 4, 4, 2),
(1, 'Samuel Medina', 25, 25, 25, 1, 5, 1, 1),
(2, 'Luciana Serrano', 26, 26, 26, 2, 1, 2, 2),
(1, 'Diego Roldán', 27, 27, 27, 3, 2, 3, 1),
(2, 'Elena Benítez', 28, 28, 28, 1, 3, 4, 2),
(1, 'Facundo Morales', 29, 29, 29, 2, 4, 1, 1),
(2, 'Victoria Chávez', 30, 30, 30, 3, 5, 2, 2),
(1, 'Rafael Peña', 31, 31, 31, 1, 1, 3, 1),
(2, 'Marina Fuentes', 32, 32, 32, 2, 2, 4, 2),
(1, 'Iván Castillo', 33, 33, 33, 3, 3, 1, 1),
(2, 'Antonia Valdez', 34, 34, 34, 1, 4, 2, 2),
(1, 'Julián Cortés', 35, 35, 35, 2, 5, 3, 1),
(2, 'Mónica Lara', 36, 36, 36, 3, 1, 4, 2),
(1, 'Luis Santamaría', 37, 37, 37, 1, 2, 1, 1),
(2, 'Emma Bravo', 38, 38, 38, 2, 3, 2, 2),
(1, 'Álvaro Parra', 39, 39, 39, 3, 4, 3, 1),
(2, 'Beatriz Toledo', 40, 40, 40, 1, 5, 4, 2),
(1, 'Rodrigo Montes', 41, 41, 41, 2, 1, 1, 1),
(2, 'Lorena Ibáñez', 42, 42, 42, 3, 2, 2, 2),
(1, 'Cristian Navas', 43, 43, 43, 1, 3, 3, 1),
(2, 'Marisol Quintero', 44, 44, 44, 2, 4, 4, 2),
(1, 'Adrián Godoy', 45, 45, 45, 3, 5, 1, 1),
(2, 'Fabiola Sandoval', 46, 46, 46, 1, 1, 2, 2),
(1, 'Raúl Espinoza', 47, 47, 47, 2, 2, 3, 1),
(2, 'Patricia Cáceres', 48, 48, 48, 3, 3, 4, 2),
(1, 'Héctor Aguirre', 49, 49, 49, 1, 4, 1, 1),
(2, 'Cecilia Vargas', 50, 50, 50, 2, 5, 2, 2);

INSERT INTO horarios (hora_inicio, hora_fin) VALUES
('06:00', '14:00'),
('14:00', '22:00');

INSERT INTO backend (nombre) VALUES
('NetCore'),
('NodeJS'),
('Spring Boot'),
('Express');

INSERT INTO sgbd (nombre) VALUES
('MySQL'),
('PostgreSQL'),
('MongoDB');

INSERT INTO programacionFormal (nombre) VALUES
('Java'),
('JavaScript'),
('C#');

INSERT INTO modulo (nombre) VALUES
('Introduccion'),
('Backend'),
('SQL');

INSERT INTO rutaEntrenamiento (horario_id, backend_id, programacionformal_id, sgbd_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2);

INSERT INTO trainers (nombre, apellido, direccion_id, telefono_id) VALUES
('Diego', 'Ruiz', 1, 1),
('Andrea', 'García', 2, 2),
('Felipe', 'Torres', 3, 3);

INSERT INTO skills (nombre) VALUES
('JavaScript'),
('Node.js'),
('Java'),
('C#');

INSERT INTO conocimientoTrainer (trainer_id, skill_id) VALUES
(1, 1),
(2, 2),
(3, 3);

INSERT INTO asignacionTrainer (trainer_id, ruta_id, horario_id) VALUES
(1, 1, 1),
(2, 2, 2);