
CREATE DATABASE biblioteca;
USE biblioteca;

CREATE TABLE autor (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  nacionalidad VARCHAR(50),
  fecha_nacimiento DATE
);

CREATE TABLE usuario (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE,
  direccion VARCHAR(100)
);

CREATE TABLE libro (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100) NOT NULL,
  isbn VARCHAR(20),
  fecha_publicacion DATE,
  autor_id INTEGER,
  FOREIGN KEY (autor_id) REFERENCES autor(id)
);

CREATE TABLE prestamo (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  libro_id INTEGER REFERENCES libro(id) ON DELETE CASCADE,
  usuario_id INTEGER REFERENCES usuario(id) ON DELETE CASCADE
);

CREATE TABLE categoria (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL
);

CREATE TABLE libro_categoria (
  id INTEGER AUTO_INCREMENT PRIMARY KEY,
  libro_id INTEGER REFERENCES libro(id) ON DELETE CASCADE,
  categoria_id INTEGER REFERENCES categoria(id) ON DELETE CASCADE
);


INSERT INTO autor (nombre, nacionalidad, fecha_nacimiento) VALUES
('Gabriel Garcia Marquez', 'Colombiano', '1927-03-06'),
('Mario Vargas Llosa', 'Peruano', '1936-03-28'),
('Pablo Neruda', 'Chileno', '1904-07-12'),
('Octavio Paz', 'Mexicano', '1914-03-31'),
('Jorge Luis Borges', 'Argentino', '1899-08-24');


INSERT INTO libro (titulo, isbn, fecha_publicacion, autor_id) VALUES
('Cien años de soledad', '978-0307474728', '1967-05-30', 1),
('La ciudad y los perros', '978-8466333867', '1962-10-10', 2),
('Veinte poemas de amor y una canción desesperada', '978-0307477927', '1924-08-14', 3),
('El laberinto de la soledad', '978-9681603011', '1950-01-01', 4),
('El Aleph', '978-0307950901', '1949-06-30', 5);


INSERT INTO usuario (nombre, email, fecha_nacimiento, direccion) VALUES
('Juan Perez', 'juan.perez@gmail.com', '1985-06-20', 'Calle Falsa 123'),
('Maria Rodriguez', 'maria.rodriguez@hotmail.com', '1990-03-15', 'Av. Siempreviva 456'),
('Pedro Gomez', 'pedro.gomez@yahoo.com', '1982-12-10', 'Calle 7ma 789'),
('Laura Sanchez', 'laura.sanchez@gmail.com', '1995-07-22', 'Av. Primavera 234'),
('Jorge Fernandez', 'jorge.fernandez@gmail.com', '1988-04-18', 'Calle Real 567');


INSERT INTO prestamo (fecha_inicio, fecha_fin, libro_id, usuario_id) VALUES
('2022-01-01', '2022-01-15', 1, 1),
('2022-01-03', '2022-01-18', 2, 2),
('2022-01-05', '2022-01-20', 3, 3),
('2022-01-07', '2022-01-22', 4, 4),
('2022-01-09', '2022-01-24', 5, 5);


INSERT INTO categoria (nombre) VALUES
('Novela'),
('Poesía'),
('Ensayo'),
('Ciencia Ficción'),
('Historia');


INSERT INTO libro_categoria (libro_id, categoria_id) VALUES
(1, 1),
(1, 3),
(2, 1),
(2, 5),
(3, 2),
(4, 3),
(5, 4);

alter table libro add column paginas integer default 20;
alter table libro add column editorial varchar(70) default 'Don Bosco';
select * from libro

#EJERCICIOS LAB 4
#1) mostrar los libros de autor de nacionalidad argentina
select a.nombre,a.nacionalidad,lb.titulo
from autor as a
inner join libro as lb on lb.autor_id = a.id
where a.nacionalidad = 'Argentino';
#2) mostrar los libros de la categoria de ciencia ficcion
select lb.titulo
from libro as lb
inner join libro_categoria as lbc on lbc.libro_id=lb.id
inner join categoria as cat on cat.id=lbc.categoria_id
where cat.nombre='Ciencia Ficción';
##AHORA CON VISTAS
#1) mostrar los libros de autor de nacionalidad argentina
CREATE OR REPLACE VIEW nacionalidad as
select a.nombre,
       a.nacionalidad,
       lb.titulo
from autor as a
inner join libro as lb on lb.autor_id = a.id
where a.nacionalidad = 'Argentino';
#2) mostrar los libros de la categoria de ciencia ficcion
CREATE OR REPLACE VIEW libros_ciencia_ficcion as
select lb.titulo AS LIBRO,
       cat.nombre AS CATEGORIA
from libro as lb
inner join libro_categoria as lbc on lbc.libro_id=lb.id
inner join categoria as cat on cat.id=lbc.categoria_id
where cat.nombre='Ciencia Ficción';
##LABORATORIO MANEJO DE VISTAS Y CASE
create or replace view bookContent as
select lb.titulo as titleBook,
       lb.editorial as editorialBook,
       lb.paginas as pagesBook,
       (case
           when lb.paginas >0 and lb.paginas <= 30 then 'CONTENIDO BASICO'
           when lb.paginas >30 and lb.paginas <= 80 then 'CONTENIDO MEDIANO'
           when lb.paginas >80 and lb.paginas <= 150 then 'CONTENIDO SUPERIOR'
           ELSE 'CONTENIDO AVANZADO'
        end) as typeContentBook
from libro as lb;
#DE ACUERDO A LA VISTA CONTAR CUANTOS LIBROS SON DE CONTENIDO MEDIO
select count(*) AS CONTENIDO_AVANZADO
from bookContent as bk
where BK.typeContentBook='CONTENIDO MEDIANO';

#CREAR UNA VISTA

CREATE OR REPLACE view book_and_autor as
    select concat(lb.titulo,' - ',lb.editorial,' - ',cat.nombre) AS BOOK_DETAIL,
           concat(a.nombre,' - ',a.nacionalidad)AS AUTOR_DETAIL
    from libro as lb
    inner join libro_categoria as lbc on lbc.libro_id=lb.id
    inner join categoria as cat on cat.id=lbc.categoria_id
    inner join autor as a on a.id=lb.autor_id;

#DE ACUERDO A LA VISTA CREADA GENERAR LO SIGUIENTE
# SI EN EL BOOK_DETAIL ESTA LA EDITORIAL NOVA GENERAR UNA COLUMNA QUE DIGA "EN VENTA"
#CASO CONTRARIO COLOCAR "EN PROCESO"

SELECT BOOK_DETAIL,
       (case
           when ba.BOOK_DETAIL LIKE '%NOVA%' then 'EN VENTA'
           ELSE 'EN PROCESO'
        end) as OFERTA
FROM book_and_autor AS BA

#crear la siguiente vista
CREATE OR REPLACE VIEW history_bolivia  AS
select cat.nombre as CATEGORY,
           a.nacionalidad AS NACIONALIDAD,
           a.nombre AS AUTOR
           from autor as a
inner join libro as lib on lib.autor_id =a.id
inner join libro_categoria as c on c.libro_id = lib.id
inner join categoria as cat on cat.id = c.categoria_id
where  cat.nombre = 'Historia' and a.nacionalidad = 'Peruano'

#CREANDO FUNCIONES
CREATE OR REPLACE FUNCTION fullName()
RETURNS VARCHAR(30)
BEGIN
    RETURN 'JHONATAN DAVID ALANOCA BLANCO';
END;
SELECT  fullName();
#CREAR UNA FUNCION QUE RESIVA UN PARAMETRO
CREATE OR REPLACE FUNCTION GetNombreCompleto(nombres varchar(30))
RETURNS VARCHAR(30)
BEGIN
    RETURN nombres;
END;
SELECT  GetNombreCompleto('JHONATAN DAVID ALANOCA BLANCO');

#realizar suma de 3 numeros

CREATE OR REPLACE FUNCTION suma(numero1 int,numero2 int,numero3 int)
RETURNS VARCHAR(30)
BEGIN
    declare  resultado INTEGER;
    set resultado = numero1+numero2+numero3;
    RETURN  resultado;
END;
SELECT  suma(5,5,5);
#CREAR UNA FUNCION  DE NOMBRE CALCULADORA LA FUNCION
# RECIBE 3 PARAMETROS 2 INT Y 1 VARCHAR
CREATE OR REPLACE FUNCTION OPERACIONES(numero1 int,numero2 int,CADENA VARCHAR(40))
RETURNS VARCHAR(30)
BEGIN
        DECLARE RESPUESTA INTEGER;
		IF CADENA = 'SUMA' THEN
			SET RESPUESTA = numero1 + numero2;
			END IF;
		IF CADENA = 'RESTA' THEN
			SET RESPUESTA = numero1 - numero2;
			END IF;
		IF CADENA = 'MULTIPLICACION' THEN
			SET RESPUESTA = numero1 * numero2;
			END IF;
		IF CADENA = 'DIVICION' THEN
			SET RESPUESTA = numero1 / numero2;
			END IF;
	RETURN RESPUESTA;
END;
#AHORA CON CASE
CREATE OR REPLACE FUNCTION OPERACIONES2(numero1 int,numero2 int,CADENA VARCHAR(40))
RETURNS VARCHAR(40)
BEGIN
        DECLARE RESPUESTA INTEGER;
        CASE WHEN CADENA = 'SUMA' THEN
			SET RESPUESTA = numero1 + numero2;
		WHEN CADENA = 'RESTA' THEN
			SET RESPUESTA = numero1 - numero2;
		WHEN CADENA = 'MULTIPLICACION' THEN
			SET RESPUESTA = numero1 * numero2;
		WHEN CADENA = 'DIVICION' THEN
			SET RESPUESTA = numero1 / numero2;
			END CASE;
	RETURN RESPUESTA;
END;
SELECT OPERACIONES2(5,10,'RESTA');
#CREAR UNA FUNCION QUE ME PERMITA VER QUE LA CATEGORIA ES HISTORIA Y OERUANO
CREATE OR REPLACE  FUNCTION VALIDA_HISTORIA(cat varchar(30), nac varchar(30))
RETURNS BOOL
BEGIN
    declare respuesta bool default false;
    if cat = 'Historia' and nac = 'Peruano' then
        set respuesta = true;
    end if;
 return respuesta;
end;
SELECT VALIDA_HISTORIA('Historia','Peruano');
#consutas usando funciones
select cat.nombre as CATEGORY,
           a.nacionalidad AS NACIONALIDAD,
           a.nombre AS AUTOR
           from autor as a
inner join libro as lib on lib.autor_id =a.id
inner join libro_categoria as c on c.libro_id = lib.id
inner join categoria as cat on cat.id = c.categoria_id
where  VALIDA_HISTORIA(cat.nombre,a.nacionalidad)=true;
#EVALUACION LO QUE ENTRARA
#CASE-