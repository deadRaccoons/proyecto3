﻿/*Esto es un comentario*/
--esto tambien
/*
los constraint son por si queremos modificar una llave primaria
o si queremos que haya (aparte de la llave primaria) una tupla que no se repita
*/

create database mameline;

--tabla avion
create table avions(
  idAvion int primary key,
  modelo varchar(6) NOT NULL,
  marca text not null,
  capacidadPrimera int NOT NULL,
  capacidadTurista int NOT NULL,
  disponible varchar(1) check(disponible in ('y', 'n'))
);

create or replace function favion() returns trigger as $tavion$
  begin 
    if new.idavion is null then new.idavion = (select max(idavion) from avions) + 1;
    end if;
    return new;
  end;
$tavion$ language plpgsql;

create trigger tavion
before insert on avions
for each row
execute procedure favion()

--como insertar en la tabla avion
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values (/* 'string' */, /* 'string' */, /*int*/, /*int*/, /*'char'*/);

/*
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('AC-90', 'Airbong' , 40, 100, 'y');
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('D-23', 'Airbong', 23, 80, 'y');
insert into avion(modelo, marca, capacidadPrimera, capacidadTurista, disponible)
values ('A-12D', 'McMarell', 20, 60, 'y');
*/


--tabla ciudad
--tiempoviaje es en minutos
CREATE TABLE ciudad(
  nombre text NOT NULL,
  pais text NOT NULL,
  costo float NOT NULL,
  tiempoViaje int NOT NULL,
  descripcion text not null
);
alter table ciudad
add constraint ciudadc
primary key (nombre);

--como insertar en la tabla ciudad
insert into ciudad
values (/* 'string' */, /* 'string' */, /*float*/, /*int*/);

/*
insert into ciudad
values ('Acapulco', 'Mexico', 400.00, 30);
insert into ciudad
values ('Monterrey', 'Mexico', 650.00, 200);
insert into ciudad
values ('Guadalajara', 'Mexico', 500.00, 70);
*/


--tabla login
CREATE TABLE login(
  correo text not null,
  contraseña varchar(18) not null,
  activo char(1) not null check(activo in ('y', 'n'))
);
alter table login
add constraint loginc
primary key (correo);

--como insertar en la tabla login
insert into login
values (/*'string'*/, /*'string'*/, /*'char'*/);

/*
insert into login
values ('dsaa@hotmail.com', '1234', 'n');
insert into login
values ('vfgbf@hotmail.com', '123ab', 'n');
insert into login
values ('sffd@hotmail.com', '23ge', 'n');
insert into login
values ('htdf@hotmail.com', 'abcs', 'n');
insert into login
values ('sggds@hotmail.com', 'porsa', 'n');
insert into login
values ('lksd@hotmail.com', 'perd', 'n');
insert into login
values ('kfds@hotmail.com', 'jghg', 'n');
insert into login
values ('str@hotmail.com', 'str', 'n');
insert into login
values ('stri@hotmail.com', 'ring', 'n');
insert into login
values ('strin@hotmail.com', 'trin', 'n');
*/

--tabla acciones que puede realizar el usuario
CREATE TABLE accion(
  idaccion integer primary key,
  tipoAccion text not null,
  unique (tipoAccion)
);

--acciones realizadas por el usuario
CREATE TABLE historialusuario(
  idaccion integer not null references accion(idaccion),
  correo text not null references login(correo),
  fecha date not null
);

--como insertar en accionusuario
insert into usuario
values (/*'string'*/, /*'string'*/, /*'dd-MM-yyyy'*/)


--tabla usuario
CREATE TABLE usuario(
  correo text NOT NULL references login(correo),
  dni serial NOT NULL,
  nombres text NOT NULL,
  apellidoPaterno text NOT NULL,
  apellidoMaterno text NOT NULL,
  nacionalidad text NOT NULL,
  genero char(1) NOT NULL check (genero in ('H', 'M')),
  fechaNacimiento date NOT NULL
);
ALTER TABLE usuario
ADD CONSTRAINT usuarioc
PRIMARY KEY (dni);

--forma en como se insertaran los usuarios
insert into usuario
values (/*'string'*/, /*(select max(dni) from usuario) + 1*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'char'*/);


--tarjetas que posee el usuario
CREATE TABLE tarjetas(
  noTarjeta varchar(16) not null primary key,
  dni serial not null references usuario(dni)
);

--como insertar en tarjetas
insert into tarjetas
values (/*'string'*/, /*int*/);


--tabla promocion
CREATE TABLE promocion(
  idPromocion serial not null,
  codigoPromocion varchar(10) not null,
  porcentaje double precision not null,
  fechaEntrada date not null,
  vigencia date not null
);
alter table promocion
add constraint proomocionc
primary key (idPromocion);

--como insertar en la tabla promocion
insert into promocion
values (/*(select max(idPromocion) from promocion) + 1*/, /*'string'*/, /*double*/, /*'dd-MM-yyyy'*/, /*'dd-MM-yyyy'*/);

--tabla viaje
CREATE TABLE viaje(
  idViaje serial not null,
  origen text not null references ciudad(nombre),
  destino text not null references ciudad(nombre),
  fecha date not null,
  horasalida text not null,
  horallegada text not null,
  idAvion serial not null references avion(idAvion),
  costoViaje double precision not null,
  realizado char(1) not null check (realizado in ('y', 'n'))
);
alter table viaje
add constraint viajec
primary key (idViaje);

--como insertar en la tabla viaje
insert into viaje
values (/*(select max(idViaje) from viaje) + 1*/, /*'string'*/, /*'string'*/, /*'dd-MM-yyyy'*/, /*'string'*/, /*'string'*/, /*int*/, /*double*/);

/*
--tabla asignado
CREATE TABLE asignado(
  idViaje serial not null references viaje(idViaje),
  idAvion serial not null references avion(idAvion)
);
alter table  asignado
add constraint asignadoc
unique (idViaje);
*/


--tabla viajepromocion
CREATE TABLE viajepromocion(
  idViaje serial not null references viaje(idViaje),
  idpromocion serial not null references promocion(idpromocion),
  unique (idViaje)
);


--tabla pasajero (los usuarios que han viajado y los que viajes han tomado)
CREATE TABLE pasajero(
  dni serial not null references usuario(dni),
  idViaje serial not null,
  clase text not null check (clase in ('Primera', 'Turista')),
  asiento integer not null
);
alter table pasajero
add constraint pasajeroc1
unique (idViaje, clase, asiento);

--como insertar en pasajero
insert into pasajero
values (/*int*/, /*int*/, /*'string'*/, /*int*/);
