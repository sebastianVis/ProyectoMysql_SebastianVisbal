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
('Carrera 17 #12-34', 2),
('Calle Los Nogales', 1),
('Avenida Principal', 2),
('Carrera 21', 1),
('Pasaje La Loma', 2),
('Diagonal San Martín', 1),
('Callejón El Sol', 2),
('Avenida Libertad', 1),
('Camino Real', 2),
('Calle 9 de Julio', 1),
('Vereda La Esperanza', 2),
('Boulevard Central', 1),
('Calle Las Rosas', 2),
('Avenida Los Pinos', 1),
('Pasaje La Paz', 2),
('Camino del Inca', 1),
('Callejón del Viento', 2),
('Carrera del Río', 1),
('Avenida del Bosque', 2),
('Diagonal La Cumbre', 1),
('Calle San Pedro', 2);


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

INSERT INTO acudientes (nombre, apellido, direccion_id) VALUES
('Carlos', 'Fernández', 1),
('María', 'Gómez', 2),
('Juan', 'López', 3),
('Ana', 'Ramírez', 4),
('Pedro', 'Díaz', 5),
('Sofía', 'Herrera', 6),
('Daniel', 'Vargas', 7),
('Valentina', 'Ruiz', 8),
('Mateo', 'Castro', 9),
('Camila', 'Fernández', 10),
('Alejandro', 'Ortega', 11),
('Gabriela', 'Jiménez', 12),
('Sebastián', 'Méndez', 13),
('Isabella', 'Ríos', 14),
('Tomás', 'Navarro', 15),
('Renata', 'Solano', 16),
('Emiliano', 'Cárdenas', 17),
('Martina', 'Pacheco', 18),
('Joaquín', 'Salas', 19),
('Paula', 'Estrada', 20),
('Hugo', 'Gutiérrez', 21),
('Diana', 'Muñoz', 22),
('Fernando', 'Arce', 23),
('Andrea', 'Palacios', 24),
('Samuel', 'Medina', 25),
('Luciana', 'Serrano', 26),
('Diego', 'Roldán', 27),
('Elena', 'Benítez', 28),
('Facundo', 'Morales', 29),
('Victoria', 'Chávez', 30),
('Rafael', 'Peña', 31),
('Marina', 'Fuentes', 32),
('Iván', 'Castillo', 33),
('Antonia', 'Valdez', 34),
('Julián', 'Cortés', 35),
('Mónica', 'Lara', 36),
('Luis', 'Santamaría', 37),
('Emma', 'Bravo', 38),
('Álvaro', 'Parra', 39),
('Beatriz', 'Toledo', 40),
('Rodrigo', 'Montes', 41),
('Lorena', 'Ibáñez', 42),
('Cristian', 'Navas', 43),
('Marisol', 'Quintero', 44),
('Adrián', 'Godoy', 45),
('Fabiola', 'Sandoval', 46),
('Raúl', 'Espinoza', 47),
('Patricia', 'Cáceres', 48),
('Héctor', 'Aguirre', 49),
('Cecilia', 'Vargas', 50),
('Carlos', 'Fernández', 54),
('María', 'Gómez', 55),
('Juan', 'Pérez', 56),
('Ana', 'López', 57),
('Luis', 'Ramírez', 58),
('Sofía', 'Díaz', 59),
('Daniel', 'Herrera', 60),
('Valentina', 'Vargas', 61),
('Mateo', 'Ruiz', 62),
('Camila', 'Castro', 63),
('Alejandro', 'Fernández', 64),
('Gabriela', 'Ortega', 65),
('Sebastián', 'Jiménez', 66),
('Isabella', 'Méndez', 67),
('Tomás', 'Ríos', 68),
('Renata', 'Navarro', 69),
('Emiliano', 'Solano', 70),
('Martina', 'Cárdenas', 54),
('Joaquín', 'Pacheco', 55),
('Paula', 'Salas', 56);

INSERT INTO campers (sede_id, nombre, direccion_id, acudiente_id, nivelriesgo_id, estado_id) VALUES
(1, 'Lucas Pérez', 1, 1, 1, 1),
(2, 'María Gómez', 2, 2, 2, 2),
(1, 'Juan López', 3, 3, 3, 6),
(2, 'Ana Ramírez', 4, 4, 1, 6),
(1, 'Carlos Díaz', 5, 5, 2, 7),
(2, 'Sofía Herrera', 6, 6, 3, 7),
(1, 'Daniel Vargas', 7, 7, 1, 3),
(2, 'Valentina Ruiz', 8, 8, 2, 3),
(1, 'Mateo Castro', 9, 9, 3, 3),
(2, 'Camila Fernández', 10, 10, 1, 3),
(1, 'Alejandro Ortega', 11, 11, 2, 3),
(2, 'Gabriela Jiménez', 12, 12, 3, 4),
(1, 'Sebastián Méndez', 13, 13, 1, 4),
(2, 'Isabella Ríos', 14, 14, 2, 4),
(1, 'Tomás Navarro', 15, 15, 3, 4),
(2, 'Renata Solano', 16, 16, 1, 4),
(1, 'Emiliano Cárdenas', 17, 17, 2, 4),
(2, 'Martina Pacheco', 18, 18, 3, 4),
(1, 'Joaquín Salas', 19, 19, 1, 4),
(2, 'Paula Estrada', 20, 20, 2, 4),
(1, 'Hugo Gutiérrez', 21, 21, 3, 4),
(2, 'Diana Muñoz', 22, 22, 1, 4),
(1, 'Fernando Arce', 23, 23, 2, 4),
(2, 'Andrea Palacios', 24, 24, 3, 4),
(1, 'Samuel Medina', 25, 25, 1, 4),
(2, 'Luciana Serrano', 26, 26, 2, 4),
(1, 'Diego Roldán', 27, 27, 3, 4),
(2, 'Elena Benítez', 28, 28, 1, 4),
(1, 'Facundo Morales', 29, 29, 2, 4),
(2, 'Victoria Chávez', 30, 30, 3, 4),
(1, 'Rafael Peña', 31, 31, 1, 4),
(2, 'Marina Fuentes', 32, 32, 2, 4),
(1, 'Iván Castillo', 33, 33, 3, 4),
(2, 'Antonia Valdez', 34, 34, 1, 4),
(1, 'Julián Cortés', 35, 35, 2, 4),
(2, 'Mónica Lara', 36, 36, 3, 4),
(1, 'Luis Santamaría', 37, 37, 1, 4),
(2, 'Emma Bravo', 38, 38, 2, 4),
(1, 'Álvaro Parra', 39, 39, 3, 4),
(2, 'Beatriz Toledo', 40, 40, 1, 4),
(1, 'Rodrigo Montes', 41, 41, 2, 4),
(2, 'Lorena Ibáñez', 42, 42, 3, 4),
(1, 'Cristian Navas', 43, 43, 1, 4),
(2, 'Marisol Quintero', 44, 44, 2, 4),
(1, 'Adrián Godoy', 45, 45, 3, 4),
(2, 'Fabiola Sandoval', 46, 46, 1, 4),
(1, 'Raúl Espinoza', 47, 47, 2, 4),
(2, 'Patricia Cáceres', 48, 48, 3, 4),
(1, 'Héctor Aguirre', 49, 49, 1, 4),
(2, 'Cecilia Vargas', 50, 50, 2, 4),
(1, 'Héctor Miguelito', 1, 1, 1, 4),
(2, 'Simon Manuelito', 2, 2, 1, 4),
(1, 'Héctor Sinrutica', 1, 1, 1, 1),
(1, 'Gabriel Mendoza', 51, 51, 1, 4),
(2, 'Julieta Rojas', 52, 52, 2, 3),
(1, 'Ezequiel Torres', 53, 53, 3, 7),
(2, 'Carolina Pineda', 54, 54, 1, 6),
(1, 'Bruno Esquivel', 55, 55, 2, 4),
(2, 'Melissa Salgado', 56, 56, 3, 3),
(1, 'Leonardo Fuentes', 57, 57, 1, 4),
(2, 'Natalia Peña', 58, 58, 2, 3),
(1, 'Damián Castillo', 59, 59, 3, 4),
(2, 'Ximena Beltrán', 60, 60, 1, 3),
(1, 'Raúl Villanueva', 61, 61, 2, 4),
(2, 'Fernanda Lucero', 62, 62, 3, 4),
(1, 'Adolfo Becerra', 63, 63, 1, 4),
(2, 'Estefanía Araya', 64, 64, 2, 4),
(1, 'Matías Gálvez', 65, 65, 3, 4),
(2, 'Valeria Ponce', 66, 66, 1, 4),
(1, 'Gustavo Ávila', 67, 67, 2, 4),
(2, 'Tamara Cifuentes', 68, 68, 3, 4),
(1, 'Francisco Del Valle', 69, 69, 1, 4),
(2, 'Isidora Olivares', 70, 70, 2, 4);

INSERT INTO camperTelefono (camper_id, telefono_id) VALUES
(1, 1), (1, 2),
(2, 3), (2, 4),
(3, 5), (3, 6),
(4, 7),
(5, 8),
(6, 9),
(7, 10),
(8, 11),
(9, 12),
(10, 13),
(11, 14),
(12, 15),
(13, 16),
(14, 17),
(15, 18),
(16, 19),
(17, 20),
(18, 21),
(19, 22),
(20, 23),
(21, 24),
(22, 25),
(23, 26),
(24, 27),
(25, 28),
(26, 29),
(27, 30),
(28, 31),
(29, 32),
(30, 33),
(31, 34),
(32, 35),
(33, 36),
(34, 37),
(35, 38),
(36, 39),
(37, 40),
(38, 41),
(39, 42),
(40, 43),
(41, 44),
(42, 45),
(43, 46),
(44, 47),
(45, 48),
(46, 49),
(47, 50);


INSERT INTO acudienteTelefono (acudiente_id, telefono_id) VALUES
(1, 3),
(2, 5),
(3, 7),
(4, 9),
(5, 11),
(6, 13),
(7, 15),
(8, 17),
(9, 19),
(10, 21),
(11, 23),
(12, 25),
(13, 27),
(14, 29),
(15, 31),
(16, 33),
(17, 35),
(18, 37),
(19, 39),
(20, 41),
(21, 43),
(22, 45),
(23, 47),
(24, 49),
(25, 1);



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

INSERT INTO estadomodulo (nombre) VALUES ('Pendiente'), ('En Curso'), ('Aprobado'), ('Reprobado');


INSERT INTO estadoarea(nombre) VALUES ('Activo'), ('Inactivo');

INSERT INTO areas(nombre) VALUES ('Apolo'), ('Sputnik'), ('Artemis'), ('Naves');

INSERT INTO rutaEntrenamiento (nombre, horario_id, backend_id, programacionformal_id, sgbd_id, sgbda_id, area_id) VALUES
('Backend con Netcore', 1, 1, 1, 1, 2, 1),
('Backend con NodeJS', 2, 1, 2, 2, 1, 2),
('Backend con Netcore', 1, 2, 1, 1, 2, 1),
('Backend con NodeJS', 2, 2, 2, 2, 1, 2);

INSERT INTO modulo (nombre, estadomodulo_id, ruta_id) VALUES 
('Introducción a la Programación', 1, 1),
('Estructuras de Datos', 1, 1),
('Bases de Datos SQL', 1, 1),
('Desarrollo Backend', 1, 1);

INSERT INTO trainers (nombre, apellido, direccion_id) VALUES
('Jholver', 'Pardo', 1),
('Andrea', 'García', 2),
('Felipe', 'Torres', 3);


INSERT INTO trainerTelefono (trainer_id, telefono_id) VALUES
(1, 2),
(2, 3),
(3, 4);

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
(1, 2, 2),
(2, 2, 2);

INSERT INTO camperRuta (camper_id, ruta_id, modulo_id, inscripcion) VALUES
(1, 1, 1, '2025-03-01'),
(2, 2, 2, '2025-03-02'),
(3, 1, 3, '2025-03-03'),
(4, 2, 1, '2025-03-04'),
(5, 1, 2, '2025-03-05'),
(6, 2, 3, '2025-03-06'),
(7, 1, 1, '2025-03-07'),
(8, 2, 2, '2025-03-08'),
(9, 1, 3, '2025-03-09'),
(10, 2, 1, '2025-03-10'),
(11, 1, 2, '2025-03-11'),
(12, 2, 3, '2025-03-12'),
(13, 1, 1, '2025-03-13'),
(14, 2, 2, '2025-03-14'),
(15, 1, 3, '2025-03-15'),
(16, 2, 1, '2025-03-16'),
(17, 1, 2, '2025-03-17'),
(18, 2, 3, '2025-03-18'),
(19, 1, 1, '2025-03-19'),
(20, 2, 2, '2025-03-20'),
(21, 1, 3, '2025-03-21'),
(22, 2, 1, '2025-03-22'),
(23, 1, 2, '2025-03-23'),
(24, 2, 3, '2025-03-24'),
(25, 1, 1, '2025-03-25'),
(26, 2, 2, '2025-03-26'),
(27, 1, 3, '2025-03-27'),
(28, 2, 1, '2025-03-28'),
(29, 1, 2, '2025-03-29'),
(30, 2, 3, '2025-03-30'),
(31, 1, 1, '2025-03-01'),
(32, 2, 2, '2025-03-02'),
(33, 1, 3, '2025-03-03'),
(34, 2, 1, '2025-03-04'),
(35, 1, 2, '2025-03-05'),
(36, 2, 3, '2025-03-06'),
(37, 1, 1, '2025-03-07'),
(38, 2, 2, '2025-03-08'),
(39, 1, 3, '2025-03-09'),
(40, 2, 1, '2025-03-10'),
(41, 1, 2, '2025-03-11'),
(42, 2, 3, '2025-03-12'),
(43, 1, 1, '2025-03-13'),
(44, 2, 2, '2025-03-14'),
(45, 1, 3, '2025-03-15'),
(46, 2, 1, '2025-03-16'),
(47, 1, 2, '2025-03-17'),
(48, 2, 3, '2025-03-18'),
(49, 1, 1, '2025-03-19'),
(50, 2, 2, '2025-03-20'),
(51, 1, 3, '2025-03-21'),
(52, 2, 1, '2025-03-22'),
(54, 1, 1, '2025-03-23'),
(55, 2, 2, '2025-03-24'),
(56, 1, 3, '2025-03-25'),
(57, 2, 1, '2025-03-26'),
(58, 1, 2, '2025-03-27'),
(59, 2, 3, '2025-03-28'),
(60, 1, 1, '2025-03-29'),
(61, 2, 2, '2025-03-30'),
(62, 1, 3, '2025-03-01'),
(63, 2, 1, '2025-03-02'),
(64, 1, 2, '2025-03-03'),
(65, 2, 3, '2025-03-04'),
(66, 1, 1, '2025-03-05'),
(67, 2, 2, '2025-03-06'),
(68, 1, 3, '2025-03-07'),
(69, 2, 1, '2025-03-08'),
(70, 1, 2, '2025-03-09'),
(71, 2, 3, '2025-03-10'),
(72, 1, 1, '2025-03-11'),
(73, 2, 2, '2025-03-12');

INSERT INTO evaluacion (camper_id, ruta_id, modulo_id, nota_teorica, nota_practica, nota_trabajo, nota_final) VALUES
(1, 1, 2, 90.53, 84.82, 67.2, 80.85),
(2, 2, 2, 75.6, 88.24, 81.91, 81.92),
(3, 1, 2, 66.05, 94.32, 98.02, 86.13),
(4, 2, 1, 49.66, 91.04, 49.39, 63.36),
(5, 1, 2, 74.74, 76.58, 51.27, 67.53),
(6, 2, 2, 66.21, 69.51, 58.78, 64.83),
(7, 1, 2, 71.33, 78.92, 58.1, 69.45),
(8, 2, 1, 73.39, 73.65, 71.92, 72.99),
(9, 1, 2, 72.2, 64.81, 44.15, 60.39),
(10, 2, 1, 58.14, 82.55, 68.34, 69.68),
(11, 1, 2, 65.8, 62.3, 39.31, 55.8),
(12, 2, 1, 74.19, 59.95, 50.31, 61.48),
(13, 1, 1, 93.13, 53.48, 66.01, 70.87),
(14, 2, 2, 69.56, 52.3, 83.35, 68.4),
(15, 1, 1, 100.00, 71.13, 54.99, 75.66),
(16, 2, 2, 69.4, 77.5, 59.1, 68.67),
(17, 1, 1, 53.17, 93.42, 52.31, 66.3),
(18, 2, 2, 74.74, 58.37, 96.77, 76.63),
(19, 1, 1, 78.23, 73.8, 72.52, 74.85),
(20, 2, 2, 77.22, 87.09, 87.18, 83.83),
(21, 1, 1, 68.34, 94.09, 76.07, 79.5),
(22, 2, 2, 67.98, 60.62, 76.76, 68.45),
(23, 1, 2, 74.17, 70.06, 81.18, 75.14),
(24, 2, 1, 63.62, 81.68, 80.6, 75.97),
(25, 1, 1, 53.46, 83.87, 60.68, 66.00),
(26, 2, 2, 70.56, 71.09, 70.10, 70.58),
(27, 1, 2, 65.96, 78.43, 73.07, 72.49),
(28, 2, 1, 83.10, 75.66, 49.00, 69.25),
(29, 1, 1, 51.92, 64.93, 70.97, 62.61),
(30, 2, 2, 96.84, 82.28, 88.06, 89.06),
(31, 1, 2, 60.17, 83.69, 53.70, 65.85),
(32, 2, 1, 90.38, 82.26, 74.99, 82.54),
(33, 1, 2, 74.25, 59.97, 93.06, 75.76),
(34, 2, 1, 72.09, 82.86, 53.20, 69.38),
(35, 1, 1, 83.97, 62.13, 89.79, 78.63),
(36, 2, 2, 67.59, 76.35, 93.94, 79.29),
(37, 1, 2, 68.31, 75.44, 86.56, 76.77),
(38, 2, 1, 49.91, 60.34, 62.45, 57.57),
(39, 1, 1, 63.50, 45.77, 82.06, 63.78),
(40, 2, 2, 67.67, 71.29, 78.68, 72.55),
(41, 1, 1, 78.14, 67.02, 82.28, 75.81),
(42, 2, 2, 55.29, 75.88, 76.07, 69.08),
(43, 1, 1, 66.01, 58.76, 82.79, 69.19),
(44, 2, 2, 51.13, 72.81, 61.54, 61.83),
(45, 1, 1, 60.56, 60.86, 68.30, 63.91),
(46, 2, 2, 65.44, 62.85, 61.97, 63.42),
(47, 1, 1, 37.75, 49.21, 41.37, 42.78),
(48, 2, 2, 58.59, 76.38, 70.32, 68.43),
(49, 1, 2, 54.09, 55.93, 74.01, 61.34),
(50, 2, 1, 71.91, 81.32, 57.77, 70.33),
(54, 1, 1, 88.5, 92.3, 85.4, 88.73),
(55, 2, 2, 91.2, 85.7, 89.9, 88.93),
(56, 1, 3, 87.4, 90.1, 92.0, 89.83),
(57, 2, 1, 95.3, 89.6, 91.8, 92.23),
(58, 1, 2, 90.8, 94.5, 88.2, 91.17),
(59, 2, 3, 89.1, 91.3, 87.7, 89.37),
(60, 1, 1, 92.0, 93.7, 90.5, 92.07),
(61, 2, 2, 90.5, 88.6, 91.2, 90.10),
(62, 1, 3, 86.9, 89.4, 90.8, 89.03),
(63, 2, 1, 94.2, 90.1, 93.5, 92.60),
(64, 1, 2, 45.3, 50.2, 48.1, 47.87),
(65, 2, 3, 52.7, 49.5, 51.2, 51.13),
(66, 1, 1, 40.6, 42.9, 39.8, 41.10),
(67, 2, 2, 48.3, 44.7, 46.9, 46.63),
(68, 1, 3, 39.9, 41.2, 38.7, 39.93),
(69, 2, 1, 50.1, 47.6, 45.3, 47.67),
(70, 1, 2, 42.8, 40.5, 44.1, 42.47),
(71, 2, 3, 46.9, 48.2, 49.7, 48.27),
(72, 1, 1, 41.5, 43.3, 40.9, 41.90),
(73, 2, 2, 49.6, 46.2, 48.4, 48.07);

INSERT INTO estadosAsistencia(nombre) VALUES ('presente'), ('ausente'), ('tardanza'), ('justificada');

INSERT INTO egresados (camper_id, ruta_id) VALUES (51, 1), (52, 2);

INSERT INTO historialEstados (camper_id, estado_id, fecha_cambio) 
VALUES 
(1, 2, '2024-03-01 10:00:00'),
(1, 3, '2024-03-15 12:00:00'),
(2, 2, '2024-02-20 08:30:00'),
(3, 3, '2024-03-10 15:45:00'),
(1, 4, '2024-03-25 18:00:00');