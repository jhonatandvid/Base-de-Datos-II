create database DEFENSA_HITO4_BDA_2023;

USE DEFENSA_HITO4_BDA_2023;

# 9)
#CREACION DE LAS TABLAS
CREATE TABLE DEPARTAMENTO(
    id_dep int primary key,
    nombre varchar(50)
);

CREATE TABLE PROVINCIA(
    id_prov int primary key,
    nombre varchar(50),
    id_dep int,
    foreign key (id_dep) references DEPARTAMENTO (id_dep)
);

CREATE or replace TABLE PERSONA(
    id_per int primary key,
    nombre varchar(20),
    apellido varchar(50),
    fecha_nac date,
    edad int,
    email varchar(50),
    id_dep int,
    id_prov int,
    sexo char(1),
    foreign key (id_dep) references DEPARTAMENTO (id_dep),
    foreign key (id_prov) references PROVINCIA (id_prov)
);

CREATE TABLE PROYECTO(
    id_proy int primary key,
    nombre_proy varchar(100),
    tipo_proy varchar(30)
);
CREATE TABLE DETALLE_DE_PROYECTO(
    id_dp int primary key,
    id_per int,
    id_proy int,
    foreign key (id_per) references PERSONA (id_per),
    foreign key (id_proy) references PROYECTO (id_proy)
);
#NGRESAR 2 DATOS A CADA TABLA

INSERT INTO DEPARTAMENTO(id_dep, nombre)
values
    (1,'La paz'),
    (2,'Cochabamba');

INSERT INTO PROVINCIA(id_prov, nombre, id_dep)
values
    (1,'Murillo',1),
    (2,'Cercado',2);

INSERT INTO PERSONA(id_per, nombre, apellido, fecha_nac, edad, email, id_dep, id_prov,sexo)
 values
     (1,'Juan','Perez','1990-05-15',31,'Juanperez@gmial.com',1,1,'M'),
     (2,'Maria','Lopez','1995-08-22',26,'Maria@gmial.com',2,2,'F');

INSERT INTO PROYECTO(id_proy, nombre_proy, tipo_proy)
values
    (1,'Carretera','Infraestructura'),
    (2,'Proyecto de educacion digital','Educacion');

INSERT INTO DETALLE_DE_PROYECTO(id_dp, id_per, id_proy)
values
    (1,1,1),
    (2,2,2);

# 10) crear serie fibonacci y que se sume utilizando 2 funciones

# primera funcion

CREATE OR REPLACE FUNCTION FIBO(LIMITE INT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE a int default 0;
    DECLARE b int default 1;
    DECLARE c int default 0;
    DECLARE CONT INT DEFAULT 0;

    WHILE CONT < LIMITE DO
        SET RESP = CONCAT(RESP,C,',');
        SET a = b;
        SET b = c;
        SET c = a + b;
        SET CONT = CONT + 1;
        end while;
    RETURN RESP;
end;

SELECT FIBO(10);

# 2DA FUNCION SUMA FIBONACCI

CREATE OR REPLACE FUNCTION SUMAFIBO(SERIE TEXT)
RETURNS INT
BEGIN
    DECLARE SUMA INT DEFAULT 0;
    DECLARE FIBO TEXT;
    DECLARE COMAAUX INT;

    WHILE SERIE != '' DO
        SET COMAAUX = LOCATE(',',SERIE);
        IF COMAAUX = 0 THEN
            SET FIBO = SERIE;
            SET SERIE = '';
        ELSE
            SET FIBO = SUBSTRING(SERIE,1,COMAAUX-1);
            SET SERIE = SUBSTRING(SERIE,COMAAUX+1);
        end if;
        SET SUMA = SUMA + CAST(FIBO AS INT);
        end while;
    RETURN SUMA;
end;
SELECT SUMAFIBO(FIBO(10));

# 11) MANEJO DE VITAS

CREATE OR REPLACE VIEW DATOS AS
    SELECT CONCAT(per.nombre,' ',per.apellido) as fullname,
           per.edad as edad,
           per.fecha_nac as fecha_de_nacimiento,
           P.nombre_proy AS nombre_del_proyecto
FROM PERSONA AS per
inner join DETALLE_DE_PROYECTO AS DDP on per.id_per = DDP.id_per
INNER JOIN PROYECTO AS P on DDP.id_proy = P.id_proy
INNER JOIN DEPARTAMENTO AS D on per.id_dep = D.id_dep
where per.sexo = 'F' and D.nombre = 'La paz' and '2000-10-10';## Maria lopez,22,proyecto de educacion digital

select * from PERSONA;

# 12) manejo de triggers I

# crear 2 triggers

# 1er trigger // CADA VEZ QUE SE USE UN DATO ALMACENAR EN UNA TABLA LLAMAD AUDITORIA
CREATE or replace TABLE AUDITORIA(
     id_proy int,
    nombre_proy_antes varchar(100),
    nombre_proy_despues varchar(100),
    tipo_proy_antes varchar(30),
    tipo_proy_despues varchar(30),
    fecha date
);

CREATE OR REPLACE TRIGGER TRIGGER1
    before insert
    on PROYECTO
    for each row
    begin
        insert AUDITORIA(id_proy, nombre_proy_antes, nombre_proy_despues, tipo_proy_antes, tipo_proy_despues, fecha)
            values(new.id_proy,'no hay anteriores datos',new.nombre_proy,'no hay anteriores datos',new.tipo_proy,now());
    end;

select * from auditoria;
# 2do trigger // almacenar en la tabla auditoria los datos actualizados

CREATE OR REPLACE TRIGGER TRIGGER2
    before update
    on PROYECTO
    for each row
    begin
        insert AUDITORIA(id_proy, nombre_proy_antes, nombre_proy_despues, tipo_proy_antes, tipo_proy_despues, fecha)
            values(new.id_proy,new.nombre_proy,old.nombre_proy,new.tipo_proy,old.tipo_proy,now());
    end;


# 3er trigger
# agregar una columna a la tabla proyecto
alter table PROYECTO
add column Estado varchar(10);

# creando trigger

CREATE OR REPLACE TRIGGER ACTIVO
    BEFORE insert
    ON PROYECTO
    FOR EACH ROW
    BEGIN
        IF NEW.tipo_proy = 'Educacion' or NEW.tipo_proy = 'Forestacion' or NEW.tipo_proy = 'Cultura' then
        set new.Estado = 'ACTIVO';
        ELSE
            SET NEW.Estado = 'INACTIVO';
        end if;
    end;

CREATE OR REPLACE TRIGGER ACTIVO2
    BEFORE update
    ON PROYECTO
    FOR EACH ROW
    BEGIN
        IF NEW.tipo_proy = 'Educacion' or NEW.tipo_proy = 'Forestacion' or NEW.tipo_proy = 'Cultura' then
        set new.Estado = 'ACTIVO';
        ELSE
            SET NEW.Estado = 'INACTIVO';
        end if;
    end;
SELECT * FROM PROYECTO;
SELECT * FROM AUDITORIA;

# 13) manejo de triggers II

CREATE OR REPLACE TRIGGER EDAD
    BEFORE INSERT
    ON PERSONA
    FOR EACH ROW
    BEGIN
        SET NEW.edad = TIMESTAMPDIFF(YEAR,NEW.fecha_nac,CURDATE());
    end;

SELECT * FROM PERSONA;

# 14) MANEJO DE TRIGGER III

# CREAR UNA TABLA CON LOS MISMOS ATRIVUTOS QUE LA TABLA PERSONA
CREATE TABLE NUEVOS(
    nombre varchar(20),
    apellido varchar(50),
    fecha_nac date,
    edad int,
    email varchar(50),
    id_dep int,
    id_prov int,
    sexo char(1)
);

#CREAR TRIGGER
CREATE OR REPLACE TRIGGER PERSONANUEVOS
    BEFORE INSERT
    ON PERSONA
    FOR EACH ROW
    BEGIN
        INSERT INTO NUEVOS(NOMBRE, APELLIDO, FECHA_NAC, EDAD, EMAIL, ID_DEP, ID_PROV, SEXO)
            VALUES(new.nombre,new.apellido,new.fecha_nac,new.edad,new.email,new.id_dep,new.id_prov,new.sexo);
    end;

select * from persona;
select * from NUEVOS;

# 15) crear una consulta que use todas las tablas y convertirlo en un view

# CREAR UN VIEW QUE TE MUESTRE EL NOMBRE COMPLETO, DEPARTAMENTO, PROVINCIA, NOMBRE DEL PROYECTO DE TODAS LAS PERSONAS NACIDAD DESPUES DEL 2000
CREATE OR REPLACE VIEW DATOS_GENERALESV1 AS
    SELECT CONCAT(PER.nombre,' ',PER.apellido) AS FULLNAME,
           PER.edad AS EDAD,
           CONCAT(DEP.nombre,': ',PV.nombre) AS UBICACION,
           PRO.nombre_proy AS PROYECTO
FROM PERSONA AS PER
inner join DETALLE_DE_PROYECTO AS DE on per.id_per = DE.id_per
INNER JOIN PROYECTO AS PRO on DE.id_proy = PRO.id_proy
INNER JOIN DEPARTAMENTO AS DEP on per.id_dep = DEP.id_dep
INNER JOIN PROVINCIA AS PV on DEP.id_dep = PV.id_dep
WHERE PER.fecha_nac > '2000-01-01';
