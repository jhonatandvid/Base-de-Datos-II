CREATE DATABASE UNIVERSIDAD;
USE UNIVERSIDAD;
CREATE TABLE ESTUDIANTE(
    ID_EST INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    EDAD INT NOT NULL,
    FONO INT NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    DIRECCION VARCHAR(50) NOT NULL,
    SEXO VARCHAR(50) NOT NULL
);
CREATE TABLE MATERIAS(
    ID_MAT INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    NOMBRE_MAT VARCHAR(100),
    COD_MAT VARCHAR(100)

);
CREATE TABLE INSCRIPCION(
    ID_INS INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    SEMESTRE VARCHAR(20),
    GESTION INT NOT NULL,
    ID_EST INT NOT NULL,
    ID_MAT INT NOT NULL,
    FOREIGN KEY (ID_EST) REFERENCES ESTUDIANTE (ID_EST),
    FOREIGN KEY (ID_MAT) REFERENCES MATERIAS (ID_MAT)
);

INSERT INTO ESTUDIANTE (NOMBRE, APELLIDO, EDAD, FONO, EMAIL, DIRECCION, SEXO)
VALUES ('Miguel', 'Gonzales Veliz', 20, 2832115,'miguel@gmail.com', 'Av. 6 de Agosto', 'masculino'),
('Sandra', 'Mavir Uria', 25, 2832116, 'sandra@gmail.com','Av. 6 de Agosto', 'femenino'),
('Joel', 'Adubiri Mondar', 30, 2832117, 'joel@gmail.com','Av. 6 de Agosto', 'masculino'),
('Andrea', 'Arias Ballesteros', 21, 2832118,'andrea@gmail.com', 'Av. 6 de Agosto', 'femenino'),
('Santos', 'Montes Valenzuela', 24, 2832119,'santos@gmail.com', 'Av. 6 de Agosto', 'masculino');

INSERT INTO MATERIAS (nombre_mat, cod_mat)
VALUES ('Introduccion a la Arquitectura', 'ARQ-101'),
('Urbanismo y Diseno', 'ARQ-102'),
('Dibujo y Pintura Arquitectonico', 'ARQ-103'),
('Matematica discreta', 'ARQ-104'),
('Fisica Basica', 'ARQ-105');
INSERT INTO INSCRIPCION (id_est, id_mat, semestre, gestion)
VALUES (1, 1, '1er Semestre', 2018),
(1, 2, '2do Semestre', 2018),
(2, 4, '1er Semestre', 2019),
(2, 3, '2do Semestre', 2019),
(3, 3, '2do Semestre', 2020),
(3, 1, '3er Semestre', 2020),
(4, 4, '4to Semestre', 2021),
(5, 5, '5to Semestre', 2021);
#13.Crear un función que compare dos códigos de materia.
#Mostrar los nombres y apellidos de los estudiantes inscritos en la materia ARQ-105,
##adicionalmente mostrar el nombre de la materia.
SELECT est.NOMBRE,est.APELLIDO, mat.NOMBRE_MAT
FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST
inner join MATERIAS as mat on ins.ID_MAT = mat.ID_MAT
where mat.COD_MAT = 'ARQ-105';
#Deberá de crear una función que reciba dos parámetros y esta función deberá ser utilizada en la cláusula WHERE.
CREATE OR REPLACE FUNCTION COMPARA_MATERIAS (COD_MAT VARCHAR(50),COD_MAT2 VARCHAR(50))
RETURNS BOOL
BEGIN
    DECLARE RESPUESTA BOOL;
    IF COD_MAT = COD_MAT2 THEN
			SET RESPUESTA = TRUE;
			END IF;
    RETURN RESPUESTA;
end;
SELECT est.ID_EST,
       est.NOMBRE,
       est.APELLIDO,
       mat.NOMBRE_MAT,
       mat.COD_MAT
FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST
inner join MATERIAS as mat on ins.ID_MAT = mat.ID_MAT
where COMPARA_MATERIAS(mat.COD_MAT,'ARQ-105')=TRUE;
#14.Crear una función que permita obtener el promedio de las edades del
#género masculino o femenino de los estudiantes inscritos en la asignatura ARQ-104
#La función recibe como parámetro el género y el código de materia.
SELECT avg(est.EDAD) as promedio
FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST
inner join MATERIAS as mat on ins.ID_MAT = mat.ID_MAT
where est.SEXO = 'femenino' and mat.COD_MAT = 'ARQ-104';
#esta funcion solo servira para las mujeres
create or replace function promedio_genero(gen varchar(50), codmat varchar(50))
returns double
begin
    declare resp double;
    SELECT avg(est.EDAD) as promedio
    into resp
FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST
inner join MATERIAS as mat on ins.ID_MAT = mat.ID_MAT
where est.SEXO = gen and mat.COD_MAT = codmat;
    return resp;
end;
select promedio_genero('femenino','ARQ-104');
select promedio_genero('masculino','ARQ-104');
#15.Crear una función que permita concatenar 3 cadenas.
#○ La función recibe 3 parámetros.
#○ Si las cadenas fuesen:
#                                     ■ Pepito
#                                     ■ Pep
#                                     ■ 50
#○ La salida debería ser: (Pepito), (Pep), (50)
#○ La función creada utilizarlo en una consulta SQL.
#                                     ■ Es decir podría mostrar el nombre,apellidos y la
#                                       edad de los estudiantes.

create or replace function concatenar(prim varchar(50), seg varchar(50),ter varchar(50))
returns varchar(200)
begin
    declare resp varchar(200);
    SELECT concat('(',prim,')',',','(',seg,')',',','(',ter,')') as concatenacion
    into resp;
    return resp;
end;
select concatenar('Juan','Perez','50')
SELECT concatenar(est.NOMBRE,est.APELLIDO,est.EDAD)
FROM ESTUDIANTE AS est
where est.EDAD >= 25

#16.Crear la siguiente VISTA:
#○ La vista deberá llamarse ARQUITECTURA_DIA_LIBRE
#○ El dia viernes tendrán libre los estudiantes de la carrera de ARQUITECTURA debido a su aniversario
#                  ■ Este permiso es solo para aquellos estudiantes inscritos en
#                     el año   2021.
#                  ■ La vista deberá tener los siguientes campos.
#                  1. Nombres y apellidos concatenados = FULLNAME
#                  2. La edad del estudiante = EDAD
#                  3. El año de inscripción = GESTION
#                  4. Generar una columna de nombre DIA_LIBRE
#                            a. Si tiene libre mostrar LIBRE
#                            b. Caso contrario mostrar NO LIBRE
create or replace view ARQUITECTURA_DIA_LIBRE as
    select concat(est.NOMBRE,' ',est.APELLIDO) as FULLNAME,
    est.EDAD as EDAD,
    ins.GESTION as GESTION,
    (case
           when ins.GESTION = 2021 then 'DIA LIBRE'
           ELSE 'NO LIBRE'
    end) as DIA_LIBRE
FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST



#17. Crear la siguiente VISTA:
#○ Agregar una tabla cualquiera al modelo de base de datos.
#○ Después generar una vista que maneje las 4 tablas
#          ■ La vista deberá llamarse PARALELO_DBA_I

CREATE TABLE DOCENTE(
    ID_DOCENTE INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    EDAD INT NOT NULL,
    ID_MAT INT NOT NULL,
    FOREIGN KEY (ID_MAT) REFERENCES MATERIAS(ID_MAT)

);
INSERT INTO DOCENTE (NOMBRE, APELLIDO, EDAD, ID_MAT)
VALUES ('Iver','Mayta Flores',55,1),
       ('Edson','Quispe Apaza',45,2),
       ('Mijael','Chuquimia Flores',35,3),
       ('Brayan','Alanoca Colque',25,4),
       ('David','Blanco Fernandez',45,5);
#CREANDO VISTA
#MOSTRAR EL DOCENTE Y LOS ALUMNOS QUE CURSAN LA MATERIA CUYO CODIGO ES IGUAL A ARQ-103
create or replace view PARALELO_DBA_I as
    select concat(est.NOMBRE,' ',est.APELLIDO) as ESTUDIANTE,
           concat(doc.NOMBRE,' ',doc.APELLIDO) as DOCENTE,
           mat.NOMBRE_MAT as MATERIA

FROM INSCRIPCION AS ins
inner join ESTUDIANTE as est on ins.ID_EST = est.ID_EST
inner join MATERIAS as mat on ins.ID_MAT = mat.ID_MAT
inner join DOCENTE as doc on mat.ID_MAT = doc.ID_MAT
where COD_MAT='ARQ-103'

