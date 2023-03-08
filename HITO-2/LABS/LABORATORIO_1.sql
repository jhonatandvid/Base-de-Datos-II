SHOW DATABASES;

CREATE DATABASE hito_2;

use hito_2;

create table estudiante
(
    codigo  varchar(50) primary key not null,
    nombre varchar (50) not null,
    apellido varchar (50) not null
);

insert into estudiante(codigo,nombre,apellido)
    values ('SIS6903691','WILLIAM','ESCALANTE');

insert into estudiante(codigo,nombre,apellido)
    values ('ODF7803691','JORGE','MARTINEZ');

SELECT* FROM estudiante;

DROP DATABASE  IF EXISTS hito_2; -- CODIGO (BORRA EL BASE DE DATOS SI SOLO ESXISTE)
DROP TABLE IF EXISTS estudiante;

-- DML = Data manipulation language (INSERT UPDATE DELETE)
-- DDL = Data definition language (DROP)

create database  universidad;
drop database universidad;
use universidad;

create table estudiantes
(
    id_est integer auto_increment primary key not null ,
    nombres varchar (100) not null ,
    apellidos varchar (100) not null ,
    edad integer not null ,
    fono integer not null ,
    email varchar (50) not null
);

insert into estudiantes(nombres,apellidos,edad,fono,email) values
    ('nombre1','apellido1',10,11111,'using1@gmail.com'),
    ('nombre2','apellido2',20,22222,'using2@gmail.com'),
    ('nombre3','apellido3',30,33333,'using3@gmail.com');

select* from estudiantes;

alter table estudiantes
    add column direccion varchar(200) default 'el alto';