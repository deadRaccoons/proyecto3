﻿/*Esto es un comentario*/
--esto tambien
/*
los constraint son por si queremos modificar una llave primaria
o si queremos que haya (aparte de la llave primaria) una tupla que no se repita
*/

create table valor(
  idvalor int primary key ,
  costomilla double precision not null,
  fecha date not null,
  tipomoneda text not null,
  tipomedida text not null 
);
alter table valor
add constraint valorc
unique (fecha);

alter table valor
add constraint valorc2
check (costomilla > 0);

create or replace function fvalor() returns trigger as $tvalor$
  begin 
    new.fecha = (select current_date);
    if (select max(idvalor) from valor) is null then new.idvalor = 1;
    return new;
    end if;
    new.idvalor = (select max(idvalor) from valor) + 1;
    return new;
  end;
$tvalor$ language plpgsql;

create trigger tvalor
before insert on valor
for each row
execute procedure fvalor()


--tabla avion
create table avion(
  idAvion int primary key,
  modelo varchar(6) NOT NULL,
  marca text not null,
  capacidadPrimera int NOT NULL check(capacidadPrimera > 0),
  capacidadTurista int NOT NULL check(capacidadTurista > 0),
  disponible varchar(1) not null check(disponible in ('y', 'n'))
);

create or replace function favion() returns trigger as $tavion$
  begin 
    if (select max(idavion) from avion) is null then new.idAvion = 1;
    return new;
    end if;
    new.idavion = (select max(idavion) from avion) + 1;
    return new;
  end;
$tavion$ language plpgsql;

create trigger tavion
before insert on avion
for each row
execute procedure favion()

create or replace view avions 
as select modelo, marca, capacidadprimera, capacidadturista 
from avion
where idavion < 21;


--tabla ciudad
CREATE TABLE ciudades(
  nombre text NOT NULL,
  pais text NOT NULL,
  distancia int NOT NULL check(distancia >= 0),
  descripcion text not null,
  zonahoraria text not null,
  aeropuerto text not null,
  IATA text not null,
  slug text not null,
  photo_file_name varchar(255) not null,
  photo_content_type varchar(255) not null,
  photo_file_size int not null,
  photo_updated_at timestamp not null
);
alter table ciudades
add constraint ciudadesc
primary key (nombre);


--tabla login
CREATE TABLE logins(
  correo text not null,
  contraseña varchar(18) not null,
  activo char(1) not null check(activo in ('y', 'n'))
);
alter table logins
add constraint loginc
primary key (correo);

--tabla usuario
CREATE TABLE usuarios(
  correo text NOT NULL references login(correo),
  idusuario int NOT NULL,
  nombres text NOT NULL,
  apellidoPaterno text NOT NULL,
  apellidoMaterno text NOT NULL,
  nacionalidad text NOT NULL,
  genero varchar(1) NOT NULL check (genero in ('H', 'M')),
  fechaNacimiento date NOT NULL,
  url_imagen text
);
ALTER TABLE usuarios
ADD CONSTRAINT usuarioc
unique (correo);

create or replace function fusuarios() returns trigger as $tusuarios$
  begin 
    if (select max(idusuario) from usuarios) is null then new.usuario = 1;
    return new;
    end if;
    new.idusuario = (select max(idusuario) from usuarios) + 1;
    return new;
  end;
$tusuarios$ language plpgsql;

create trigger tusuarios
before insert on usuarios
for each row
execute procedure fusuarios()

--forma en como se insertaran los usuarios
insert into usuario
values (/*'string'*/, /*(select max(dni) from usuario) + 1*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'string'*/, /*'char'*/);


create table tarjetas(
  noTarjeta varchar(16) not null primary key,
  valor int not null,
  idusuario int not null references usuarios(idusuario),
  disponible varchar(1) not null check(disponible in ('y', 'n'))
);

--tabla promocion
REATE TABLE promocion(
  idpromocion integer NOT NULL PRIMARY KEY,
  codigopromocion character varying(255) NOT NULL,
  iniciopromo date NOT NULL,
  finpromo date NOT NULL,
  ciudad text NOT NULL,
  descripcion text NOT NULL,
  slug text NOT NULL,
  photo_file_name character varying(255) not null,
  photo_content_type character varying(255) not null,
  photo_file_size integer not null,
  photo_updated_at timestamp without time zone not null,
  porcentaje double precision,
);

create or replace function fpromocion() returns trigger as $tpromocion$
  begin 
    new.porcentaje = 1 - (new.porcentaje / 100);
    if (select max(idpromocion) from promociones) is null then new.idpromocion = 1;
    return new;
    end if;
    new.idpromocion = (select max(idpromocion) from promociones) + 1;
    return new;
  end;
$tpromocion$ language plpgsql;

create trigger tpromocion
before insert on promocion
for each row
execute procedure fpromocion()


--tabla viaje
CREATE TABLE viaje(
  idViaje int not null primary key,
  origen text not null references ciudad(nombre),
  destino text not null references ciudad(nombre) check(destino <> origen),  
  fechasalida date not null,
  horasalida time with time zone not null,
  fechallegada date not null,
  horallegada time with time zone not null,
  distancia int not null,
  tiempo interval not null,
  costoViaje double precision not null,
  realizado char(1) not null,
  idavion int references avion(idavion) not null,
  unique(origen, destino, fechasalida, horasalida)
);
alter table viaje
add constraint viajesc
check (realizado in ('y', 'n', 'c'))

create or replace function fviaje() returns trigger as $tviaje$
  begin 
    update viaje set realizado = 'y' where fechasalida + horasalida <= (select current_timestamp);
    new.horasalida = cast(new.horasalida::time without time zone ||' '|| (select zonahora from ciudades where nombre = new.origen) as time with time zone);
    new.tiempo = cast((new.distancia/360) ||' hours' as interval);
    new.costoViaje = cast(new.distancia * (select costomilla from valor) as double precision);
    new.horallegada = (new.horasalida + new.tiempo)::time with time zone at time zone (select zonahora from ciudades where nombre = new.destino);
    new.fechallegada = cast(cast((new.fechasalida+ new.horasalida + new.tiempo)::timestamp with time zone at time zone (select zonahora from ciudades where nombre = new.destino) as timestamp) as date);
    new.realizado = 'n';
    if (select max(idviaje) from viajes) is null then new.idviaje = 1;
	return new;
    end if;
    new.idviaje = (select max(idviajes) from viaje) + 1;
    return new;
  end;
$tviaje$ language plpgsql;

create trigger tviaje
before insert on viajes
for each row
execute procedure fviaje();

create or replace rule rviaje as on update
to viajes where old.realizado = 'y' or old.realizado = 'c'
do instead nothing

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
CREATE TABLE promocionespecial(
  idViaje serial not null references viaje(idViaje),
  idpromocion serial not null references promocion(idpromocion),
  unique (idViaje)
);


--tabla pasajero (los usuarios que han viajado y los que viajes han tomado)
CREATE TABLE boleto(
  idboleto integer,
  idusuario serial not null references usuarios(idusuario),
  idViaje serial not null,
  clase text not null check (clase in ('Primera', 'Turista')),
  asiento integer not null,
  costototal double precision,
  unique (idViaje, clase, asiento),
  primary key (idboleto, idviaje)
);

--tabla donde los usuarios aplican promocion
create table aplica(
  idviaje integer references viaje(idviaje),
  codigopromocion integer references promocions(codigopromocion),
  idusuario integer references usuarios(idusuario)
);
alter table aplica
add constraint aplicac
primary key (idusuario, promocion);

--tabla administrador
create table administrador (
  correo text not null references logins(correo),
  nombres text not null,
  apellidos text not null,
);
alter table administrador
add constraint adiministradorc
primary key (correo)

--tabla cancelados
create table cancelados(
  idviaje int references viajes(idviaje) not null,
  primary key (idviaje)
);
create or replace function fcancelado() returns trigger as $tcancelado$
  begin 
    update viajes set realizado = 'c' where idviaje = new.idviaje;
    return new;
  end;
$tcancelado$ language plpgsql;

create trigger tcancelado
before insert on cancelado
for each row
execute procedure fcancelado();

