CREATE DATABASE DEFENSA_HITO_4_2023;

USE DEFENSA_HITO_4_2023;


CREATE TABLE DEPARTAMENTO(
    id_dep  int primary key,
    nombre  varchar(50)
);

CREATE TABLE PROVINCIA(
    id_prov int primary key,
    nombre  varchar(50),
    id_dep  int,
    foreign key (id_dep) references DEPARTAMENTO (id_dep)
);

CREATE TABLE PERSONA(
    id_per int primary key,
    nombre varchar(50),
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


CREATE TABLE PROYECTO (
    id_proy int primary key,
    nombre_proy varchar(100),
    tipo_proy varchar(30)

);

create table DETALLE_DE_PROYECTO (
    id_dp int primary key,
    id_per int,
    id_proy int,
    FOREIGN KEY (id_per) REFERENCES PERSONA (id_per),
    FOREIGN KEY (id_proy) REFERENCES PROYECTO (id_proy)
);


# insertando datos a las tablas

insert into DEPARTAMENTO(ID_DEP, NOMBRE)
VALUES(1,'La paz'),
       (2,'Cochabamba');

select * from DEPARTAMENTO;

insert into PROVINCIA(ID_PROV, NOMBRE, ID_DEP)
values(1,'Murillo',1),
      (2,'Cercado',2);

select * from PROVINCIA;

insert into PERSONA(id_per,nombre, apellido, fecha_nac, edad, email, id_dep, id_prov, sexo)
values
    (1,'Juan', 'Pérez', '1990-05-15', 31, 'juan.perez@example.com', 1, 1, 'M'),
    (2,'María', 'López', '1995-08-22', 26, 'maria.lopez@example.com', 2, 2, 'F');


select * from PERSONA;

insert into PROYECTO(ID_PROY, NOMBRE_PROY, TIPO_PROY)
values
    (1,'Carretera','Infraestructura'),
    (2,'Proyecto de educación digital', 'Educación');

select * from PROYECTO;

INSERT INTO DETALLE_DE_PROYECTO(ID_DP, ID_PER, ID_PROY)
VALUES
    (1,1,1),
    (2,2,2);

select * from DETALLE_DE_PROYECTO;

######################## EXAMEN #######################

# 1) EJERCICIO
# CREAR 3 TRIGGERS CON AFTER

#CREAR TABLA AUDIT_PROYECTOS
#ESTA TABLA TIENE QUE TENER 7 CAMPOS

CREATE OR REPLACE TABLE AUDIT_PROYECTOS(
    nombre_proy_anterior varchar(30),
    nombre_proy_posterior varchar(30),
    tipo_proy_anterior    varchar(30),
    tipo_proy_posterior    varchar(30),
    operation varchar(30),
    userid varchar(30),
    hostname varchar(30),
    fecha   date
);
#crear trigger BEFORE/AFTER para el evento INSERT, UPDATE Y DELETE
# CADA VEZ QUE SE MODIFIQUE UN REGISTRO (NOMBRE DEL PROYECTO) DE LA TABLA PROYECTOS
# SE TIENE QUE ALMACENAR EN LA TABLA AUDIT_PROYECTO LOS SIGUIENTES:

SELECT * FROM PROYECTO;
SELECT * FROM AUDIT_PROYECTOS;

CREATE OR REPLACE TRIGGER TRIGGER1
    BEFORE UPDATE
    ON PROYECTO
    FOR EACH ROW
    BEGIN
    insert into AUDIT_PROYECTOS(NOMBRE_PROY_ANTERIOR, NOMBRE_PROY_POSTERIOR, TIPO_PROY_ANTERIOR, TIPO_PROY_POSTERIOR, OPERATION, USERID, HOSTNAME, fecha)
    values(old.nombre_proy,new.nombre_proy,old.tipo_proy,NEW.tipo_proy,'UPDATE ',USER(),@@HOSTNAME,CURRENT_DATE);
    end;

CREATE OR REPLACE TRIGGER TRIGGER2
    BEFORE INSERT
    ON PROYECTO
    FOR EACH ROW
    BEGIN
    insert into AUDIT_PROYECTOS(NOMBRE_PROY_ANTERIOR, NOMBRE_PROY_POSTERIOR, TIPO_PROY_ANTERIOR, TIPO_PROY_POSTERIOR, OPERATION, USERID, HOSTNAME,fecha)
    values('No existe valor anterior',new.nombre_proy,'No existe valor anterior',NEW.tipo_proy,'INSERT ',USER(),@@HOSTNAME,CURRENT_DATE);
    end;

CREATE OR REPLACE TRIGGER TRIGGER3
    BEFORE DELETE
    ON PROYECTO
    FOR EACH ROW
    BEGIN
    insert into AUDIT_PROYECTOS(NOMBRE_PROY_ANTERIOR, NOMBRE_PROY_POSTERIOR, TIPO_PROY_ANTERIOR, TIPO_PROY_POSTERIOR, OPERATION, USERID, HOSTNAME,fecha)
    values(old.nombre_proy,'No existe valor posterior',old.tipo_proy,'No existe valor posterior','DELETE',USER(),@@HOSTNAME,CURRENT_DATE);
    end;

# 2) EJERCICIO
# CREAR UNA VISTA DE NOMBRE REPORTE_PROYECTO
# CAMPOS: FULLNAME,DESC_PROYECTO,DEPARTAMENTO,CODIGO_DEP
CREATE OR REPLACE VIEW REPORTE_PROYECTO AS
SELECT CONCAT(per.nombre,' ',per.apellido) as fullname,
       concat(pro.nombre_proy,': ',pro.tipo_proy) as Desc_proyecto,
       dep.nombre as Departamento,
       (case
           when dep.nombre = 'La paz' then 'LPZ'
           when dep.nombre = 'Cochabamba' then  'CBB'
           when dep.nombre = 'Oruro' then  'CBB'
           when dep.nombre = 'Santa cruz' then  'SC'
           when dep.nombre = 'Pando' then  'PD'
           when dep.nombre = 'Beni' then  'BN'
           when dep.nombre = 'Tarija' then  'TJ'
           when dep.nombre = 'Chuquisaca' then  'CS'
           when dep.nombre = 'Potosi' then  'PT'
           when dep.nombre = 'El alto' then 'EAT' END) as Codigo_dep
FROM PERSONA AS per
inner join DETALLE_DE_PROYECTO as DE on DE.id_per=PER.id_per
inner join PROYECTO as pro on pro.id_proy=de.id_proy
inner join departamento as dep on per.id_dep = dep.id_dep

# 3) EJERCICIO
# CREAR UN TRIGGER PARA LA TABLA PROYECTO

CREATE OR REPLACE TRIGGER TRIGGERFORE
    BEFORE INSERT
    ON PROYECTO
    FOR EACH ROW
    BEGIN
        DECLARE DIA_DE_LA_SEMANA TEXT DEFAULT '';
        DECLARE MES TEXT DEFAULT '';
        SET DIA_DE_LA_SEMANA = DAYNAME(CURRENT_DATE);
        SET MES = MONTHNAME(CURRENT_DATE);
        IF NEW.tipo_proy = 'Forestacion' and DIA_DE_LA_SEMANA = 'WEDNESDAY' and MES= 'JUNE'then
         SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'NO PUEDE INSERCIONAES DEL TIPO FORESTACION';
        end if;
    end;
SELECT * FROM PROYECTO;

# 4) EJERCICIO EXTRA
# CREAR UNA FUNCION DICCIONARIO DE DIAS DE LA SEMANA
CREATE OR REPLACE FUNCTION DICCIONARIO(DAY TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
     CASE
        WHEN DAY = 'MONDAY' THEN SET RESP='LUNES';
        WHEN DAY = 'TUESDAY' THEN SET RESP='MARTES';
        WHEN DAY = 'WEDNESDAY' THEN SET RESP='MIERCOLES';
        WHEN DAY = 'THURSDAY' THEN SET RESP='JUEVES';
        WHEN DAY = 'FRIDAY' THEN SET RESP='VIERNES';
        WHEN DAY = 'SATURDAY' THEN SET RESP='SABADO';
        WHEN DAY = 'SUNDAY' THEN SET RESP='DOMINGO';
     END CASE;
    RETURN RESP;
end;


SELECT DICCIONARIO(DAYNAME(CURRENT_DATE));
SELECT DICCIONARIO('MONDAY');
SELECT DICCIONARIO('TUESDAY');
SELECT DICCIONARIO('THURSDAY');
SELECT DICCIONARIO('FRIDAY');
SELECT DICCIONARIO('SATURDAY');
SELECT DICCIONARIO('SUNDAY');