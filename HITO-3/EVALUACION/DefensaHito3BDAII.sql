create database defensa_hito3_2023;
use defensa_hito3_2023;
#1)CREAR UNA FUNCION QUE RECIBA UN PARAMETRO DE TIPO STRING(TEXT) ELIMINA NUMEROS Y CONSONANTES;
CREATE OR REPLACE function elimina_consonantes_y_numeros(cadena text)
returns text
begin
    declare resp text default '';
    DECLARE PUNTERO char;
    DECLARE CONT INT DEFAULT 1;
    WHILE CONT <=CHAR_LENGTH(CADENA) DO
        SET PUNTERO = SUBSTRING(CADENA,CONT,1);
        IF PUNTERO = 'a' OR PUNTERO = 'e' OR PUNTERO = 'i' OR PUNTERO = 'o' OR PUNTERO = 'u'  then
            SET CONT  = CONT +1;
            SET RESP = CONCAT(RESP,PUNTERO);
        ELSE IF PUNTERO = ' ' THEN
            SET CONT = CONT +1;
            SET RESP = CONCAT(RESP,PUNTERO,' ');
        ELSE
            SET CONT  = CONT +1;
        end if;
        end if;
    end WHILE;
    return RESP;
end;
select elimina_consonantes_y_numeros('BASE DE DATOS II 2023');
select elimina_consonantes_y_numeros('BBBBBBB');
select elimina_consonantes_y_numeros('1284723647816320');
#fin del ejercicio 1
#2) CREAR UNA TABLA DE SERIES I
create table CLIENTES(
  ID_cliente int primary key not null auto_increment,
  fullname varchar(20) not null,
  last_name varchar(20) not null,
  age int  not null,
  genero char(1)
);
insert into CLIENTES(fullname, last_name, age, genero)
values
    ('Miguel','Gonzalo Veliz',20,'m'),
 ('Sandra','Mavir Uria',25,'f'),
 ('Joel','Adubiri Mordar',30,'m');
#crear una funcion que retorne la edad maxima
create or replace function edad_maxima()
returns int
begin
    declare resp int default 0;
    select max(cl.age) into resp
    from CLIENTES  as cl;
    return resp;
end;
select edad_maxima();
#crear una funcion que maneje la funcion previa usando loop
CREATE OR REPLACE FUNCTION PAR_IMPAR(EDAD INT )
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
   # DECLARE EDAD INT DEFAULT edad_maxima();
    DECLARE PAR INT DEFAULT 0;
    DECLARE x INT DEFAULT 0;
    DECLARE IMPAR INT DEFAULT EDAD;
    LOOP_LABEL:LOOP
    if PAR > edad  then
        SET PAR = PAR + 2;
    LEAVE LOOP_LABEL;
    end if;
    IF EDAD MOD 2 = 0  THEN
    SET RESP = CONCAT(RESP,PAR,',');
    SET PAR = PAR + 2;
    ELSE
    SET RESP = CONCAT(RESP,IMPAR,',');
    SET IMPAR = IMPAR + 2;
     end if;
    set x = x +1;
    ITERATE LOOP_LABEL;
    end loop;
    RETURN RESP;
end;
SELECT PAR_IMPAR(20);
#fin del ejercicio 2
#3) GENERAR SERIE FIBONACII
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
SELECT FIBO(7);
#4) CREAR UNA FUNCION QUE  RECIBA UN PARAMETRO DE TIPO STRING(TEXT)
CREATE OR REPLACE FUNCTION REEMPLAZA_PALABRA(CADENA1 TEXT,CADENA2 TEXT,CADENA3 TEXT)
RETURNS TEXT
BEGIN
    DECLARE PUNTERO TEXT DEFAULT '';
    DECLARE PALABRA TEXT DEFAULT LOCATE(CADENA2,CADENA1);
    DECLARE PALABRA2 INT DEFAULT CHAR_LENGTH(CADENA2);
    DECLARE AUX TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 0;
    IF LOCATE(CADENA2,CADENA1)>0 THEN
        WHILE CONT <=CHAR_LENGTH(CADENA1) DO
        SET PUNTERO = SUBSTRING(CADENA1,PALABRA,PALABRA2);
        IF PUNTERO = CADENA2  then
            SET CONT  = CONT +1;
            SET PUNTERO = CADENA3;
            SET AUX = REPLACE(CADENA1,CADENA2,CADENA3);
        end if;
       end WHILE;
    end if;
    RETURN AUX;
end;
SELECT REEMPLAZA_PALABRA('Bienvenidos a UNIFRANZ,UNIFRANZ tiene 10 carreras','UNIFRANZ',
    'UNIVALLE');
#comandos de prueba/////////
SELECT LOCATE('UNIFRANZ','Bienvenidos a UNIFRANZ,UNIFRANZ tiene 10 carreras');
SELECT SUBSTRING('Bienvenidos a UNIFRANZ,UNIFRANZ tiene 10 carreras',15,8);
SELECT REPLACE('Bienvenidos a UNIFRANZ,UNIFRANZ tiene 10 carreras','UNIFRANZ',
    'UNIVALLE');
#comandos  de prueba///////////////////
#5) CREAR UNA FUNCION QUE RECIBA UN PARAMETRO Y RETORNA LA CADENA AL REVEZ;
#PRIMERA FORMA 1
CREATE  OR REPLACE FUNCTION MUEVA(CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    SET RESP=REVERSE(CADENA);
    return RESP;
END;
#SEGUNDA FORMA
CREATE  OR REPLACE FUNCTION MUEVA2(CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE PUNTERO2 TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT CHAR_LENGTH(CADENA);
    WHILE CONT >=1 DO
        SET PUNTERO2 = SUBSTRING(CADENA,CONT,1);
        SET CONT = CONT -1;
        SET RESP = CONCAT(RESP,PUNTERO2);
    END WHILE;
    return RESP;
END;
SELECT MUEVA2('HOLA');
SELECT MUEVA2('BDA II 2023');
SELECT MUEVA('BDAII');