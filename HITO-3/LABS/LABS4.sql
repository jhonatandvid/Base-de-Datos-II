use hito3_2023;
#LABS 4
#EJERCICIO 1
#CREAR UNA FUNCION QUE RECIBA 2 PARAMETROS Y HAY QUE CONTAR CUANTAS VECES SE REPITE LA LETRA
CREATE OR REPLACE FUNCTION CONTARLETRA(CADENA TEXT,LETRA CHAR)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 0;
    DECLARE nVECES INT DEFAULT 0;
    DECLARE PUNTERO CHAR;
    IF LOCATE(LETRA,CADENA) > 0 THEN
         WHILE CONT <= CHAR_LENGTH(CADENA) DO
             SET PUNTERO = SUBSTRING(CADENA,CONT,1);
             IF PUNTERO = LETRA THEN
                 SET NVECES = NVECES + 1;
             end if;
         SET CONT =CONT+1;
         END WHILE;
          SET RESP=CONCAT('EN LA CADENA: ',CADENA,', LA LETRA: ',LETRA, ', SE REPITE: ',nVECES);
    ELSE
        SET RESP='LA LETRA NO EXISTE';
    end if;
    RETURN RESP;
END;
SELECT CONTARLETRA('BDAII','I');
SELECT CONTARLETRA('BASE DE DATOS RELACIONAL Y BASE DE DATOS NO RELACIONAL','A');
#EJERCICIO 2
#CREAR UNA FUNCION QUE CUENTE CUANTAS VOCALES HAY EN UNA CADENA
CREATE OR REPLACE FUNCTION VOCALBUSCAR (CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 0;
    DECLARE CONT1 INT DEFAULT 0;
    DECLARE PUNTERO CHAR;
         WHILE CONT <= CHAR_LENGTH(CADENA) DO
             SET PUNTERO = SUBSTRING(CADENA,CONT,1);
             IF PUNTERO = 'a' or PUNTERO = 'e' or PUNTERO = 'i' or PUNTERO = 'o' or puntero = 'u' THEN
                 SET CONT1 = CONT1 + 1;
             end if;
         SET CONT =CONT+1;
         END WHILE;
          SET RESP=CONCAT('EN LA CADENA: ',CADENA,', LAS VOCALES SE REPITE: ',CONT1);
    RETURN RESP;
end;
SELECT VOCALBUSCAR('PALABRA');
SELECT VOCALBUSCAR('paralelepipedo');
#EJERCICIO 3
#crear UNA FUNCION QUE DETERMINE EL NUEMRO DE PALABRAS
CREATE OR REPLACE FUNCTION CONTARPALABRAS (CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT 1;
    DECLARE CONT1 INT DEFAULT 1;
    DECLARE PUNTERO CHAR;
         WHILE CONT <= CHAR_LENGTH(CADENA) DO
             SET PUNTERO = SUBSTRING(CADENA,CONT,1);
             IF PUNTERO = ' ' THEN
                 SET CONT1 = CONT1 + 1;
             end if;
         SET CONT =CONT+1;
         END WHILE;
          SET RESP=CONCAT('EN LA CADENA: ',CADENA,', TIENE PALABRAS: ',CONT1);
    RETURN RESP;
end;
SELECT CONTARPALABRAS('BASE DE DATOS II 2023');
SELECT CONTARPALABRAS('DBA 2');
SELECT CONTARPALABRAS('LA BASE DE DATOS RELACIONAL');
#EJERCICIO 4
#MOSTRAR LOS APELLIDOS DE LAS PERSONAS
CREATE OR REPLACE FUNCTION RETORNARAPELLIDO (CADENA TEXT)
RETURNS TEXT
BEGIN
    DECLARE RESP TEXT DEFAULT '';
    DECLARE CONT INT DEFAULT  LOCATE(' ',CADENA) ;
    SET RESP = SUBSTRING(CADENA,CONT);
    RETURN RESP;
end;
SELECT RETORNARAPELLIDO('JHONATAN ALANOCA BLANCO')