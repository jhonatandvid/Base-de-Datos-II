#AUDITORIA DE BASE DE DATOS
USE hito_4_2023;

# 1ra tabla
CREATE OR REPLACE TABLE USUARIO_RRHH(
    id_usr int primary key not null,
    nombre_completo varchar(50) not null,
    fecha_nac date not null,
    correo varchar(100) not null,
    password varchar(50)
);
insert into USUARIO_RRHH(ID_USR, NOMBRE_COMPLETO, FECHA_NAC,CORREO, PASSWORD)
VALUES
    (123456,'JHONATAND DAVID','2001-03-06','JHONATAN@GMAIL.COM','123456');

SELECT * FROM USUARIO_RRHH;

# ME PERMITE SABER LA FECHA Y HORA ACTUAL
SELECT NOW();
select current_date;
# ME PERMITE VER EL USUARIO LOGEADO
SELECT USER();
SELECT @@HOSTNAME; # ME PERMITE SABER EL NOMBRE DEL EQUIPO
# TODAS LAS VARIABLES DEL BDA
SHOW VARIABLES;

# 2da tabla

CREATE OR REPLACE TABLE AUDIT_USUARIOS_RRHH (
    fecha_mod text not null,
    usuario_log text not null,
    hostname text not null,
    accion text not null,

    id_usr text not null ,
    nombre_completo text not null,
    password text not null
);

#creacion de trigger
CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh
    after delete
    on USUARIO_RRHH
    for each row
    begin
        declare id_usuario text;
        declare nombres text;
        declare password1 text;

        set id_usuario = old .id_usr;
        set nombres  = old.nombre_completo;
        set password1 = old.password ;

        insert into AUDIT_USUARIOS_RRHH(fecha_mod, usuario_log, hostname, accion, id_usr, nombre_completo, password)
            select now(),user(),@@HOSTNAME,'DELETE',id_usuario,nombres,password1;
    end;
# INSERTANDO NUEVOS DATOS
insert into USUARIO_RRHH(ID_USR, NOMBRE_COMPLETO, FECHA_NAC,CORREO, PASSWORD)
VALUES
    (654321,'PEPITO','2003-02-01','PEPITO@GMAIL.COM','654321');

select * from AUDIT_USUARIOS_RRHH;
# CREAR PARA INSERT
CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh_INSERT
    BEFORE INSERT
    on USUARIO_RRHH
    for each row
    begin
        insert into AUDIT_USUARIOS_RRHH(fecha_mod, usuario_log, hostname, accion, id_usr, nombre_completo, password)
            select now(),user(),@@HOSTNAME,'INSERT',NEW.id_usr,NEW.nombre_completo,NEW.password;
    end;

# INSERTANDO NUEVO DATO
insert into USUARIO_RRHH(ID_USR, NOMBRE_COMPLETO, FECHA_NAC,CORREO, PASSWORD)
VALUES
    (654322,'SAUL GOODMAN','2000-02-01','SAUL@GMAIL.COM','65432');

# 1ER EJERCICIO
# CREAR TRIGGER UPDATE PARA LA TABLA USUARIOS_RRHH
# AGREGAR 2 CAMPOS ADICIONALES
# ANTES DEL CAMBIO  = CONCAT  (ID_USR-NOMBRE-FECHA DE NACIMIENTO)
# DESPUES DEL CAMBIO = CONCAT (ID_USR-NOMBRE-FECAH_NACIMIENTO)
CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh_UPDATE
    AFTER UPDATE
    on USUARIO_RRHH
    for each row
    begin
        DECLARE ANTES TEXT DEFAULT '';
        DECLARE DESPUES TEXT DEFAULT '';
        SET ANTES = CONCAT(OLD.id_usr,' ',OLD.nombre_completo,' ',OLD.fecha_nac);
        SET DESPUES = CONCAT(NEW.id_usr,' ',NEW.nombre_completo,' ',NEW.fecha_nac);
        insert into AUDIT_USUARIOS_RRHH(fecha_mod, usuario_log, hostname, accion, ANTES_DEL_CAMBIO, DESPUES_DEL_CAMBIO)
            select now(),user(),@@HOSTNAME,'UPDATE',ANTES,DESPUES;
    end;
# 2DA TABLA MODIFICADA
CREATE OR REPLACE TABLE AUDIT_USUARIOS_RRHH (
    fecha_mod text not null,
    usuario_log text not null,
    hostname text not null,
    accion text not null,

    ANTES_DEL_CAMBIO TEXT NOT NULL,
    DESPUES_DEL_CAMBIO TEXT NOT NULL
);
########################################################################################################################
##################################### CREANDO PROCEDIMENTOS ALMACENADOS ################################################
########################################################################################################################

CREATE OR REPLACE PROCEDURE INSERTA_DATOS(FECHA TEXT,USUARIO TEXT,HOSTNAME TEXT,ACCION TEXT,ANTES TEXT,DESPUES TEXT)
BEGIN
    insert into AUDIT_USUARIOS_RRHH(fecha_mod, usuario_log, hostname, accion, ANTES_DEL_CAMBIO,DESPUES_DEL_CAMBIO)
          VALUES
              (FECHA,USUARIO,HOSTNAME,ACCION,ANTES,DESPUES);
end;

# 2DA VERSION
CREATE OR REPLACE TRIGGER tr_audit_usuarios_rrhh_UPDATE
    AFTER UPDATE
    on USUARIO_RRHH
    for each row
    begin
        DECLARE ANTES TEXT DEFAULT '';
        DECLARE DESPUES TEXT DEFAULT '';
        SET ANTES = CONCAT(OLD.id_usr,' ',OLD.nombre_completo,' ',OLD.fecha_nac);
        SET DESPUES = CONCAT(NEW.id_usr,' ',NEW.nombre_completo,' ',NEW.fecha_nac);
        #CALL NOS PERMITE LLAMAR UN PROCEDIMIENTO ALMACENADO
        CALL INSERTA_DATOS(
            NOW(),USER(),@@HOSTNAME,'UPDATE',ANTES,DESPUES);
    end;
SELECT * FROM AUDIT_USUARIOS_RRHH;