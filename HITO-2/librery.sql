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
    foreign key  (publisher_id) references publisher(publisher_id)#gaaaaaaaaaaa
);

