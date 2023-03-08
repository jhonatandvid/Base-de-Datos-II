CREATE DATABASE HITO2;
USE HITO2;

CREATE TABLE USUARIOS
(
    ID_usuario integer auto_increment primary key ,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    edad integer not null,
    email varchar(100) not null
);
insert into USUARIOS(nombres, apellidos, edad, email)
VALUES ('nombres1','apellido1',26,'nombres1@gmail.com'),
       ('nombres2','apellido2',30,'nombres2@gmail.com'),
       ('nombres3','apellido3',40,'nombres3@gmail.com');
select * from USUARIOS;
#Mostrar los usuarios mayores a 30
select * from USUARIOS
where edad > 30;
#Creando vista
create view mayores_a_30 as
select us.*
from USUARIOS as us
where edad > 30;
#mostrando el view
select  * from mayores_a_30;
#modificando view
alter view mayores_a_30 as
select us.nombres,
       us.apellidos,
       us.edad,
       us.email
from USUARIOS as us
where edad > 30;
select  * from mayores_a_30;
#Modificar la vista anterior para que me muestre los siguientes campos
# fullname: nombre y apellido
#edad_usuario: edad del usuario
#email_usuario: email del usuario
#fullname
create view fullname as
select us.nombres,
       us.apellidos
from USUARIOS as us
where edad > 30;
#edad
create view edad as
select us.edad
from USUARIOS as us
where edad > 30;
#email
create view email as
select us.email
from USUARIOS as us
where edad > 30;
select  * from fullname;
select  * from edad;
select  * from email;
# 1 ejercicio
ALTER view mayores_a as
select CONCAT (us.nombres,' ',
       us.apellidos) FULLNAME,
       us.edad EDAD,
       us.email EMAIL
from USUARIOS as us
where edad > 30;
select  * from mayores_a;

#MOSTRAR USUARIOS QUE EN SU APELLIDO TENGA EL NUMERO 3
select a.FULLNAME,
       a.edad,
       a.email
from mayores_a as a
where  a.FULLNAME LIKE '%3%';
#create or replace // si existe la va a crear si no la va a reemplazar
create or replace view mayores_a_30;
#eliminar view
drop view fullname;
#NO SE PUEDE TENER UNA VISTA CON EL MISMO NOMBRE DE UNA TABLA


