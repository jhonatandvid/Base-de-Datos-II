create database empresa;
use empresa;

create table empleado(
    id_empleado integer auto_increment primary key not null,
    nombre varchar(100) not null,
    apellidos varchar(100) not null,
    telefono integer not null
);
create table empresa(
    id_empresa integer auto_increment primary key not null,
    nombre_emp varchar(100) not null,
    sede varchar(100),
    id_empleado integer not null,
    id_area integer not null,
    foreign key (id_empleado) references empleado(id_empleado),
    foreign key (id_area) references  area(id_area)
);
create table area(
    id_area integer auto_increment primary key not null,
    area varchar(100) not null,
    id_empleado integer  not null,
     foreign key (id_empleado) references empleado(id_empleado)
);

insert into empleado( nombre, apellidos, telefono)
values ('juan','gomez',78654321),('Robert','Lopez',78654322),('Edson','Condori',78654323)
     ,('Mijail','Choque',78654324),('Victor','Paz',78654325);

insert into area(area,id_empleado)
values ('limpieza',1),('recursos humanos',2),('movilistico',3),('gerente',4),('oficina',5);

insert into empresa( nombre_emp, sede, id_empleado, id_area)
values ('Imcruz','El alto',1,1),('Imcruz','El alto',2,2),('Imcruz','El alto',3,3)
     ,('Imcruz','El alto',4,4),('Imcruz','El alto',5,5);


select em.nombre_emp,ar.area,emp.nombre
from empleado as emp
inner join empresa as em on em.id_empleado=emp.id_empleado
inner join area as ar on emp.id_empleado=ar.id_empleado
where emp.nombre='Edson'
