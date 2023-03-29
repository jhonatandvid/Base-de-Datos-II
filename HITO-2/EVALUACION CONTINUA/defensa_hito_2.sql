CREATE DATABASE DEFENSA_HITO2;
USE DEFENSA_HITO2;
CREATE TABLE autor
(
    id_autor    INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name        VARCHAR(100),
    nacionality VARCHAR(50)
);

CREATE TABLE book
(
    id_book   INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    codigo    VARCHAR(25)                        NOT NULL,
    isbn      VARCHAR(50),
    title     VARCHAR(100),
    editorial VARCHAR(50),
    pages     INTEGER,
    id_autor  INTEGER,
    FOREIGN KEY (id_autor) REFERENCES autor (id_autor)
);

CREATE TABLE category
(
    id_cat  INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    type    VARCHAR(50),
    id_book INTEGER,
    FOREIGN KEY (id_book) REFERENCES book (id_book)
);

CREATE TABLE users
(
    id_user  INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    ci       VARCHAR(15)                        NOT NULL,
    fullname VARCHAR(100),
    lastname VARCHAR(100),
    address  VARCHAR(150),
    phone    INTEGER
);

CREATE TABLE prestamos
(
    id_prestamo    INTEGER AUTO_INCREMENT PRIMARY KEY NOT NULL,
    id_book        INTEGER,
    id_user        INTEGER,
    fec_prestamo   DATE,
    fec_devolucion DATE,
    FOREIGN KEY (id_book) REFERENCES book (id_book),
    FOREIGN KEY (id_user) REFERENCES users (id_user)
);



INSERT INTO autor (name, nacionality)
VALUES ('autor_name_1', 'Bolivia'),
       ('autor_name_2', 'Argentina'),
       ('autor_name_3', 'Mexico'),
       ('autor_name_4', 'Paraguay');

INSERT INTO book (codigo, isbn, title, editorial, pages, id_autor)
VALUES ('codigo_book_1', 'isbn_1', 'title_book_1', 'NOVA', 30, 1),
       ('codigo_book_2', 'isbn_2', 'title_book_2', 'NOVA II', 25, 1),
       ('codigo_book_3', 'isbn_3', 'title_book_3', 'NUEVA SENDA', 55, 2),
       ('codigo_book_4', 'isbn_4', 'title_book_4', 'IBRANI', 100, 3),
       ('codigo_book_5', 'isbn_5', 'title_book_5', 'IBRANI', 200, 4),
       ('codigo_book_6', 'isbn_6', 'title_book_6', 'IBRANI', 85, 4);

INSERT INTO category (type, id_book)
VALUES ('HISTORIA', 1),
       ('HISTORIA', 2),
       ('COMEDIA', 3),
       ('MANGA', 4),
       ('MANGA', 5),
       ('MANGA', 6);

INSERT INTO users (ci, fullname, lastname, address, phone)
VALUES ('111 cbba', 'user_1', 'lastanme_1', 'address_1', 111),
       ('222 cbba', 'user_2', 'lastanme_2', 'address_2', 222),
       ('333 cbba', 'user_3', 'lastanme_3', 'address_3', 333),
       ('444 lp', 'user_4', 'lastanme_4', 'address_4', 444),
       ('555 lp', 'user_5', 'lastanme_5', 'address_5', 555),
       ('666 sc', 'user_6', 'lastanme_6', 'address_6', 666),
       ('777 sc', 'user_7', 'lastanme_7', 'address_7', 777),
       ('888 or', 'user_8', 'lastanme_8', 'address_8', 888);


INSERT INTO prestamos (id_book, id_user, fec_prestamo, fec_devolucion)
VALUES (1, 1, '2017-10-20', '2017-10-25'),
       (2, 2, '2017-11-20', '2017-11-22'),
       (3, 3, '2018-10-22', '2018-10-27'),
       (4, 3, '2018-11-15', '2017-11-20'),
       (5, 4, '2018-12-20', '2018-12-25'),
       (6, 5, '2019-10-16', '2019-10-18');
#DEFENSA
#1)MOSTRAR DATOS DEL LIBRO, CATEGORIA Y USUARIO EN UNA VISTA DONDE EL TIPO DE CATEGORIA SEA MANGA Y COMEDIA
CREATE OR REPLACE VIEW LIBROS AS
select concat(us.fullname,' ',us.lastname) AS NOMBRE_COMPLETO,
       us.ci as CI_USUARIO,
       bk.title as LIBRO,
       cat.type AS CATEGORIA
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
    inner join users as us on pr.id_user = us.id_user
inner join category as cat on bk.id_book = cat.id_book
WHERE  cat.type  = 'MANGA' or cat.type = 'COMEDIA';

#2) SE DESA SABER CUANTOS USUARIOS SE PRESTARON LIBROS DE LA EDITORIAL IBRANI SOLO CUANDO EL NUMERO DE PAGINAS SEA MAYOR A 90

CREATE OR REPLACE FUNCTION USUARIOS_IBRANI (PAGINAS VARCHAR(50), EDITORIAL VARCHAR(50))
RETURNS INT
BEGIN
DECLARE RESP INT;
select COUNT(us.id_user) INTO RESP
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
inner join users as us on pr.id_user = us.id_user
WHERE  BK.pages > PAGINAS and BK.editorial = EDITORIAL;
RETURN RESP;
end;
SELECT USUARIOS_IBRANI('90','IBRANI')
#3)SE DESEA SABER QUE USUARIOS SE PRESTARON LIBROS DE LA CATEGORIA MANGA Y EDITORIAL IBRANI

#1RA FUNCION CORRECTA
CREATE OR REPLACE FUNCTION DETERMINAR (PAGINAS VARCHAR(50))
RETURNS VARCHAR(100)
BEGIN
DECLARE RESP VARCHAR(100);
        IF PAGINAS MOD 2 = 0 THEN
        SET  RESP = 'PAR';
        end if;
        IF PAGINAS MOD 2 = 1 THEN
        SET RESP = 'IMPAR';
        end if;
RETURN RESP;
end;
SELECT DETERMINAR('85');

#2DA FUNCION

CREATE OR REPLACE FUNCTION DESCRIPCION (CATEGORIA VARCHAR(50), EDITORIAL VARCHAR(50))
RETURNS VARCHAR(100)
BEGIN
DECLARE RESP VARCHAR(100);
Set RESP = CONCAT('CATEGORIA: ',CATEGORIA,',','EDITORIAL: ',EDITORIAL);
RETURN RESP;
end;
SELECT DESCRIPCION('MANGA','IBRANI');

#======================================================================================#

SELECT DESCRIPCION(CAT.type,BK.editorial) as DESCRIPCION,
       CONCAT(DETERMINAR(BK.pages),': ',BK.pages)   AS PAGINAS
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
inner join category as cat on bk.id_book = cat.id_book
WHERE  CAT.type = 'MANGA' and BK.editorial = 'IBRANI';

#EN UN SELECT
SELECT CONCAT('EDITORIAL: ',BK.editorial,',','CATEGORIA: ',CAT.type) AS DESCRIPTION,
       (CASE WHEN BK.pages MOD 2 = 0  THEN CONCAT('PAR: ',BK.pages)
           WHEN BK.pages MOD 2 = 1  THEN CONCAT('IMPAR: ',BK.pages)
           END) AS PAGE
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
inner join category as cat on bk.id_book = cat.id_book
WHERE  CAT.type = 'MANGA' and BK.editorial = 'IBRANI';

#4) SE DESEA SABER CUANTOS LIBROS FUERON PRESTADOS ENTRE LAS GESTIONES 2017 Y 2018
SELECT COUNT(BK.id_book)
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
inner join category as cat on bk.id_book = cat.id_book
WHERE PR.fec_prestamo LIKE '%2017%' OR PR.fec_prestamo LIKE '%2018%';

#AHORA EN FUNCION

CREATE OR REPLACE FUNCTION USUARIOSGESTION2017_2018()
RETURNS INT
BEGIN
DECLARE RESP INT;
SELECT COUNT(BK.id_book) INTO RESP
from book as bk
inner join prestamos as pr on bk.id_book = pr.id_book
WHERE PR.fec_prestamo LIKE '%2017%' OR PR.fec_prestamo LIKE '%2018%';
RETURN RESP;
end;
SELECT USUARIOSGESTION2017_2018();