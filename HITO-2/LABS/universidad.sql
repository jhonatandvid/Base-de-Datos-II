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

#este comando me permite agregar nuevos cambios a una tabla
#sin la necesidad de eliminar la tabla
alter table estudiantes
add column fax varchar(10),
add column genero varchar(10);

#estecomando elimina una columna de una tabla
    alter table estudiantes
    drop column fax;

select *
from estudiantes as est
where est.nombres ="Nombre3";

select * from estudiantes;

#mostrar todos los datos del estudiante donde el estudiante sea mayor a 18
select *
from estudiantes as est
where est.edad >18;

#poner una nombre a la columna
select est.nombres,est.apellidos 'apellidos de la persona',est.edad
from estudiantes as est
where est.nombres ="Nombre3";
#mostrar registros de los estudiantes cuyo id es impar y par
select *
from estudiantes as est
where est.id_est %2=0 ;

select *
from estudiantes as est
where est.id_est %2=!0 ;

drop table estudianes;

create table estudiantes
(
    id_est integer auto_increment primary key not null ,
    nombres varchar (100) not null ,
    apellidos varchar (100) not null ,
    edad integer not null ,
    fono integer not null ,
    email varchar (50) not null
);

create table materias(
    id_mat integer auto_increment primary key not null,
    nombre_mat varchar(100) not null,
    cod_mat varchar(100)
);

create table inscripcion(
    id_ins integer auto_increment primary key not null,
    id_est integer not null,
    id_mat integer not null,
    foreign key  (id_est) references estudiantes(id_est),
    foreign key  (id_mat) references materias(id_mat)
);


create database libreria;
use libreria;
create table categorias(
category_id integer primary key not null,
name_ varchar(100) not null
);

create table publisher(
    publisher_id integer primary key not null ,
    name_ varchar(100)
);
create table books(
    book_id integer not null ,
    title varchar(100),
    isbn varchar(100),
    publisher_date date not null,
    description varchar(100),
    category_id integer not null ,
    publisher_id integer not null ,
    foreign key  (category_id) references categorias(category_id),
    foreign key  (publisher_id) references publisher(publisher_id)
);


















