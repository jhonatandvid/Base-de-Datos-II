Create database Estudiantes;
use Estudiantes;
create TABLE Estudiante(
  Id_est int not null primary key auto_increment,
  Nombre varchar(50) not null,
  Apellido varchar(50) not null,
  Edad int not null,
  Telefono int not null,
  Email varchar(100) not null,
  Direccion varchar(100) not null,
  Sexo VARCHAR(10) NOT NULL
);
create TABLE Materias(
  Id_mat int not null primary key auto_increment,
  Nom_materia varchar(100) not null,
  Cod_mat varchar(100) not null
);
create table Inscripcion(
  Id_ins int not null primary key auto_increment,
  Semestre varchar(20) not null,
  Gestion int not null,
  Id_mat int not null,
  Id_est int not null,
  foreign key (Id_mat) references Materias (Id_mat),
  foreign key (Id_est) references Estudiante (Id_est)
);
insert into Estudiante (Nombre, Apellido, Edad, Telefono, Email, Direccion, Sexo)
 values ('Miguel','Gonzalo Veliz',20,2835115,'miguel@gmail.com','Av. 6 de agosto','Masculino'),
 ('Sandra','Mavir Uria',25,2835116,'sandra@gmail.com','Av. 6 de agosto','Femeninio'),
 ('Joel','Adubiri Mordar',30,2835117,'joel@gmail.com','Av. 6 de agosto','Masculino'),
 ('Andrea','Arias Ballesteros',21,2835118,'andrea@gmail.com','Av. 6 de agosto','Femenino'),
 ('Santos','Montes Valenzuela',24,2835119,'santos@gmail.com','Av. 6 de agosto','Masculino');
insert into Materias (Nom_materia, Cod_mat)
values
    ('Introduccion a la Arquitectura','ARQ-101'),
    ('Urbanismo y Diseño','ARQ-102'),
    ('Dibujo y Pintura Arquitectonico','ARQ-103'),
    ('Matematica discreta','ARQ-104'),
    ('Fisica Basica','ARQ-105');
insert into Inscripcion (Semestre, Gestion, Id_mat, Id_est)
values
    ('1er Semestre',2018,1,1),
    ('2er Semestre',2018,1,2),
    ('1er Semestre',2019,2,4),
    ('2er Semestre',2019,2,3),
    ('2er Semestre',2020,3,3),
    ('3er Semestre',2020,3,1),
    ('4er Semestre',2021,4,4),
    ('5er Semestre',2021,5,5);
select * from Estudiante;
select * from Materias;
select * from Inscripcion;
#12 GENERAR LA SERIE FIBONACCI
CREATE OR REPLACE FUNCTION FIBO(LIMITE INT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE a int default 0;
    DECLARE b int default 1;
    DECLARE c int default 0;
    DECLARE cont int default 0;
    while cont < LIMITE do
        SET resp = concat(RESP,c,',');
        SET a = b;
        SET b = c;
        SET c = a + b;
        SET cont  = cont + 1;
        end while;
    return resp;
end;
select FIBO(7);
#13 CREAR UNA VARIABLE GLOBAL QUE CONTENGA UN VALOR NUMERICO
SET @LIMITE = 11;
select FIBO(@LIMITE);
#14 CREAR 2 FUNCIONES 1 QUE CALCULE LA EDAD MINIMA Y LA OTRA QUE CALCULE SI ES PAR O IMPAR
CREATE OR REPLACE FUNCTION EDAD_MINIMA()
RETURNS INT
BEGIN
    DECLARE RESP INT DEFAULT 0;
    SELECT MIN(est.Edad) INTO RESP
    FROM Estudiante AS est;
    RETURN RESP;
end;
select EDAD_MINIMA();
#CREANDO SEGUNDA FUNCION
CREATE OR REPLACE FUNCTION PAR_IMPAR()
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE EDAD INT DEFAULT EDAD_MINIMA();
    DECLARE PAR INT DEFAULT 0;
    DECLARE IMPAR INT DEFAULT EDAD;
    IF EDAD MOD 2 = 0 THEN
        WHILE PAR<=EDAD DO
            SET RESP = CONCAT(RESP,PAR,',');
            SET PAR = PAR + 2;
        end while;
        ELSE IF EDAD MOD 2 = 1 THEN
        WHILE IMPAR >= 1 DO
            SET RESP = CONCAT(RESP,IMPAR,',');
            SET IMPAR = IMPAR - 2;
        end while;
        end if;
    end if;
    RETURN RESP;
end;
SELECT PAR_IMPAR();
#15 CREAR UNA FUNCION QUE NOS RETORNE CUANTAS VECES SE USA UNA VOCAL
CREATE OR REPLACE FUNCTION VOCALES(CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 0;
    DECLARE CONTa INT DEFAULT 0;
    DECLARE CONTe INT DEFAULT 0;
    DECLARE CONTi INT DEFAULT 0;
    DECLARE CONTo INT DEFAULT 0;
    DECLARE CONTu INT DEFAULT 0;
    DECLARE PUNTERO char;
    WHILE CONT <=CHAR_LENGTH(CADENA) DO
        SET PUNTERO = SUBSTRING(CADENA,CONT,1);
        IF PUNTERO = 'a' then
            set CONTa = CONTa +1;
        end if;
         IF PUNTERO = 'e' then
            set CONTe = CONTe +1;
        end if;
         IF PUNTERO = 'i' then
            set CONTi = CONTi +1;
        end if;
         IF PUNTERO = 'o' then
            set CONTo = CONTo +1;
        end if;
         IF PUNTERO = 'u' then
            set CONTu = CONTu +1;
        end if;
            set cont = cont +1;
    end while;
    set RESP = concat('a: ',CONTa,', e: ',CONTe,', i: ',CONTi,', o: ',CONTo,', u: ',CONTu);
    return RESP;
end;
select VOCALES('taller de base de datos');
#16 CREAR UNA FUNCION QUE RETORNE QUE CATEGORIA ES EL USUARIO
CREATE OR REPLACE FUNCTION CREDITO(CREDIT_NUMBER INT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    CASE
        WHEN CREDIT_NUMBER > 50000 THEN SET RESP='PLATINUM';
        WHEN CREDIT_NUMBER >= 10000 AND CREDIT_NUMBER <=50000 THEN SET RESP='GOLD';
        WHEN CREDIT_NUMBER < 10000 AND CREDIT_NUMBER >=0 THEN SET RESP='SILVER';
        END CASE;
    RETURN RESP;
end;
SELECT CREDITO(1000);
#17 ELIMINAR VOCALES
CREATE OR REPLACE FUNCTION SINVOCALES(CADENA1 TEXT,CADENA2 TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CADENA TEXT DEFAULT CONCAT(CADENA1,'-',CADENA2);
    DECLARE PUNTERO char;
    DECLARE CONT INT DEFAULT 1;
    WHILE CONT <=CHAR_LENGTH(CADENA) DO
        SET PUNTERO = SUBSTRING(CADENA,CONT,1);
        IF PUNTERO = 'a' OR PUNTERO = 'e' OR PUNTERO = 'i' OR PUNTERO = 'o' OR PUNTERO = 'u'  then
            SET CONT  = CONT +1;
        ELSE IF PUNTERO = ' ' THEN
            SET CONT = CONT +1;
            SET RESP = CONCAT(RESP,PUNTERO,' ');
        ELSE
            SET CONT  = CONT +1;
            SET RESP = CONCAT(RESP,PUNTERO);
        end if;
        end if;
    end WHILE;
    return RESP;
end;
SELECT SINVOCALES('TALLER DBA II','GESTION 2023');
SELECT SINVOCALES('BASE DE DATOS','ESTRUCTURA DE DATOS');
#18
CREATE  OR REPLACE FUNCTION REDUCCION(CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE PUNTERO TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 0;
    REPEAT
        SET PUNTERO = SUBSTRING(CADENA,CONT);
        SET RESP = CONCAT(RESP,PUNTERO,',');
        SET CONT = CONT +1;
    until CONT >CHAR_LENGTH(CADENA)
        end repeat;
    return RESP;
END;
SELECT REDUCCION('BDAII');


