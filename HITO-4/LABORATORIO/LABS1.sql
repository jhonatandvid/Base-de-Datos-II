create database hito_4_2023;
use hito_4_2023;
#Vista: es una tabla artificial.
#TEMA HITO 4 TRIGGERS
#TRIGGERS: Son programas almacenados. Que se ejecuta automaticamente cuando ocurra un evento.
#Nos permite monitorear eventos (INSERT-DELETE-UPDATE).

#ESTRUCTURA DEL TRIGGER
# CREATE TRIGGER nombre_trigger
# {BEFORE | AFTER} {INSERT | UPDATE | DELETE}
# ON nombre_tabla
# FOR EACH ROW
# BEGIN
#     -- Código del trigger
# END;

# FORMAS DE HACER
# INSERT- NEW     NEW.NOMBRE_DE_LA_COLUMNA
# UPDATE- NEW_OLD NEW.NOMBRE_DE_LA_COLUMNA-OLD.nombre_de_la_tabla
# DELETE- OLD     OLD.NOMBRE_DE_LA_COLUMNA

create or replace TABLE NUMEROS(
    numero bigint  primary key not null,#entero gigantesco
    cuadrado bigint ,
    cubo bigint ,
    raiz_cuadrada real,                 #numeros reales
    SumaTodo      real
);
insert into NUMEROS (numero) values (2);
insert into NUMEROS (numero) values (4);
SELECT * FROM NUMEROS;

CREATE OR REPLACE TRIGGER TR_completa_datos
    BEFORE INSERT
    ON NUMEROS
    for each row
    BEGIN
        DECLARE valor_cuadrado bigint;
        DECLARE valor_cubo bigint;
        DECLARE valor_raiz real;

        SET valor_cuadrado=POWER(NEW.numero,2);
        SET valor_cubo=POWER(NEW.numero,3);
        SET valor_raiz=SQRT(NEW.numero);

        SET new.cuadrado=valor_cuadrado;
        SET new.cubo=valor_cubo;
        SET new.raiz_cuadrada=valor_raiz;

    END;
show triggers; #Muestra los triggers
#2)forma mas corta
# CREATE OR REPLACE TRIGGER completa_datos
#     BEFORE INSERT
#     ON NUMEROS
#     for each row
#     BEGIN
#
#         SET new.cuadrado=POWER(NEW.numero,2);
#         SET new.cubo=POWER(NEW.numero,3);
#         SET new.raiz_cuadrada=SQRT(NEW.numero);
#
#     END;
#1)ejercicio 1: elimina los registros
#agregar sumatodo
CREATE OR REPLACE TRIGGER TR_completa_datos
    BEFORE INSERT
    ON NUMEROS
    for each row
    BEGIN
        DECLARE valor_cuadrado bigint;
        DECLARE valor_cubo bigint;
        DECLARE valor_raiz real;
        DECLARE valor_suma real;

        SET valor_cuadrado=POWER(NEW.numero,2);
        SET valor_cubo=POWER(NEW.numero,3);
        SET valor_raiz=SQRT(NEW.numero);
        SET valor_suma=valor_cuadrado+valor_cubo+valor_raiz+new.numero;

        SET new.cuadrado=valor_cuadrado;
        SET new.cubo=valor_cubo;
        SET new.raiz_cuadrada=valor_raiz;
        SET new.SumaTodo=valor_suma;

    END;
#EJERCICIO 2) Crear uan tabla de nombre usuarios
create or replace table Usuario(
    id_usr int auto_increment primary key not null ,
    nombres varchar(50) not null,
    Apellido varchar(50) not null,
    Edad int not null ,
    Correo varchar(50) not null,
    Password_ varchar(100)
);
insert into usuario(nombres, Apellido, Edad, Correo)
values ('juan','pedro',15,'juan@gmail.com');
#Creando trigger
create or replace trigger generar_password
    before insert
    on usuario
    for each row
    begin
        declare nombre varchar(100);
        declare apellido varchar(100);
        declare pass varchar(100);

        set nombre = substring(new.nombres,1,2);
        set apellido = substring(new.Apellido,1,2);
        set pass = concat(nombre,apellido,new.Edad);
         SET new.Password_=pass;
    end;
select * from usuario;
