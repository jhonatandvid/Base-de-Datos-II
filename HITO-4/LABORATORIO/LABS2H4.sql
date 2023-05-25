USE hito_4_2023;
#usando otra forma de hacer trigger
create or replace trigger generar_password2
    after insert
    on usuario
    for each row
begin
        UPDATE usuario set Password_=concat(
            substring(new.nombres,1,2),
            substring(new.Apellido,1,2),
            new.Edad)
        where id_usr=last_insert_id();
end;
select * from usuario;

#alterando tabla agregando fecha de nacimiento

create or replace table Usuario(
    id_usr int auto_increment primary key not null ,
    nombres varchar(50) not null,
    Apellido varchar(50) not null,
    Fecha_de_nacimiento date not null,
    Correo varchar(50) not null,
    Password_ varchar(100),
    Nacionalidad varchar(100),
    Edad int
);

#2) EJERCICIO

#LOWER = CONVIERTE LA PALABRA MINUSCULAS EN MAYUSCULA
# TIMESTAMPDIFF = SIRVE PARA CALCULAR EDAD
SELECT TIMESTAMPDIFF(YEAR,'2001-06-03',CURDATE());
#Añadiendo edad y contraseña
create or replace trigger tr_calcula_pass_edad
     before insert
     on usuario
     for each row
     begin
         set new.Password_ = lower(concat(
             substr(new.nombres,1,2),
             substr(new.Apellido,1,2),
             substr(new.Correo,1,2)
             ));
         SET NEW.Edad= TIMESTAMPDIFF(YEAR,new.Fecha_de_nacimiento,CURDATE());
     end;
insert into usuario(nombres, Apellido, Fecha_de_nacimiento, Correo)
values ('Jose','perez','2001-06-03','juan@gmail.com'),
       ('juanes','lopez','2003-01-03','juales@gmail.com');
select * from usuario;


#3)EJERCICIO

#CREAR UN TRIGGER PARA LA TABLA USUARIOS VERIFICAR SI EL PASSSWORD TIENE MAS DE 10 CARACTERES
#SI TIENE MAS DE 10 CARACTERES DEJAR ESE VALOR COMO ESTA, SI ES MAYOR DE 10 CARACTERES TOMAR
#LOS 2 ULTIMOS CARACTERES DEL NOMBRE APELIDO Y EDAD

create or replace trigger tr_calcula_passV2
     before insert
     on usuario
     for each row
     begin
         SET NEW.Edad= TIMESTAMPDIFF(YEAR,new.Fecha_de_nacimiento,CURDATE());
         IF CHAR_LENGTH(NEW.Password_) < 10 THEN
         set new.Password_ = lower(concat(
             substr(new.nombres,-2),
             substr(new.Apellido,-2),
             NEW.Edad
             ));
         END IF;
     end;

insert into usuario(nombres, Apellido,Fecha_de_nacimiento, Correo,Password_)
values ('JosS','perTO','2001-06-03','juan@gmail.com','1234567890'),
       ('juLES','loperico','2003-01-03','juales@gmail.com','123');


#DAYOFMONTH = NOS DA EL DIA EN QUE ESTAMOS
#DAYNAME = NOS DICE QUE DIA DE LA SEMANA ESTAMOS
#CURRENT_DATE = NOS DICE LA FECHA ACTUAL
SELECT DAYOFMONTH(CURRENT_DATE);
SELECT DAYNAME(CURRENT_DATE);
SELECT CURRENT_DATE;
#4) EJERCICIO
# NO DEJA INSERTAR DATOS

CREATE OR REPLACE TRIGGER TR_USUARIOS_MANTENIMIENTOS
    BEFORE INSERT
    ON Usuario
    FOR EACH ROW
    BEGIN
        DECLARE DIA_DE_LA_SEMANA TEXT DEFAULT '';
        SET DIA_DE_LA_SEMANA = DAYNAME(CURRENT_DATE);
        IF DIA_DE_LA_SEMANA = 'WEDNESDAY' THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Base de datos en MANTENIMIENTO';
        end if;
    end;

#5) EJERCICIO

create or replace trigger insertion
    before insert
    on usuario
    for each row
    begin
        DECLARE Na VARCHAR(20) DEFAULT '';
        SET Na = NEW.Nacionalidad;
        IF Na = 'BOLIVIA' OR Na = 'PARAGUAY' OR Na = 'ARGENTINA' THEN
            set new.Password_ = lower(concat(
             substr(new.nombres,-2),
             substr(new.Apellido,-2),
             NEW.Edad
             ));
        ELSE
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'NO PUEDES ERES CHILENO';
        end if;
    end;
insert into usuario(nombres, Apellido,Fecha_de_nacimiento, Correo,Password_,Nacionalidad)
values
    ('JosS','perTO','2001-06-03','juan@gmail.com','1234567890','chile'),
    ('JosS','perTO','2001-06-03','juan@gmail.com','1234567890','CHILE');