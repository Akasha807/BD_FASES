/* *****************************************************
  INSTITUT TIC de Barcelona
    CFGS Desenvolupament d'Aplicacions Multiplataforma 
    CFGS Desenvolupament d'Aplicacions Web 
    Mòdul: 0484 Bases de dades. 
    AUTOR: Akasha Karam Y Karen 
    DATA: Gener 2025
****************************************************** */


-- ------------------------------------------------------
-- Base de dades de vols
-- ------------------------------------------------------

-- ------------------------------------------------------
--  Eliminació de taules
-- ------------------------------------------------------
drop table if exists volar;
drop table if exists vol;
drop table if exists pilot;
drop table if exists hostessa;
drop table if exists personal;
drop table if exists passatger;
drop table if exists Mostrador;
drop table if exists aeroport;
drop table if exists avio;
drop table if exists companyia;

-- ------------------------------------------------------
--  Creació de taula companyia
-- ------------------------------------------------------

CREATE TABLE companyia (	
	nom Varchar(40) not null, 
	IATA CHAR(6) not null, 
	CODE3 CHAR(6), 
	ICAO CHAR(6), 
	pais Varchar(40) NOT NULL, 
	filial_de Varchar(40)
) CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  hostessa
-- ------------------------------------------------------

CREATE TABLE hostessa ( 
	num_empleat int
) CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  avio
-- ------------------------------------------------------

CREATE TABLE avio (	
	num_serie CHAR(30), 
	tipus Varchar(10) not null, 
	fabricant Varchar(20) not null, 
	any_fabricacio year, 
	companyia Varchar(40) not null
)  CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  aeroport
-- ------------------------------------------------------

CREATE TABLE aeroport (
	codi CHAR(4), 
	pais Varchar(40) not null, 
	ciutat Varchar(40) not null, 
	IATA CHAR(4), 
	nom Varchar(55) not null, 
	any_construccio Year
) CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  Mostrador
-- ------------------------------------------------------

CREATE TABLE Mostrador (
	numero smallint, 
	codi_aeroport CHAR(4)
) CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  personal
-- ------------------------------------------------------

CREATE TABLE personal (
    num_empleat INT,
    nom VARCHAR(25) NOT NULL,
    cognom VARCHAR(35) NOT NULL,
    passaport CHAR(20) NOT NULL,
    sou FLOAT NOT NULL
)  CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  vol
-- ------------------------------------------------------

CREATE TABLE vol (
	codi CHAR(9), 
	aeroport_desti CHAR(4) not null, 
	data DATE not null, 
	durada smallint not null, 
	aeroport_origen CHAR(4) not null, 
	avio CHAR(30) not null, 
	hostessa int not null, 
    pilot int not null, 
	descripcio Varchar(30) not null
) CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  passatger
-- ------------------------------------------------------

CREATE TABLE passatger (
	passaport CHAR(20), 
	nom Varchar(30) not null, 
	cognom Varchar(50), 
	adreca Varchar(70), 
	telefon Varchar(9), 
	email Varchar(40), 
	data_naix DATE, 
	genere CHAR(1)
)  CHARACTER SET utf8mb4;
-- ------------------------------------------------------
--  Creació de la taula  pilot
-- ------------------------------------------------------

CREATE TABLE pilot (
	num_empleat int, 
	hores_Vol smallint
)CHARACTER SET utf8mb4;

-- ------------------------------------------------------
--  Creació de la taula  volar
-- ------------------------------------------------------  
CREATE TABLE volar(
	passatger char(20),
	vol char(9),
	seient tinyint
)CHARACTER SET utf8mb4;

-- Claus primarias en la taules 

alter table companyia 
add constraint pk_companyia primary key (nom);

alter table personal
add constraint pk_personal primary key (num_empleat);

alter table avio
add constraint pk_avio primary key (num_serie);

alter table passatger
add constraint pk_passatger primary key (passaport);

alter table aeroport
add constraint pk_aeroport primary key (codi);

alter table mostrador
add constraint pk_mostrador primary key (numero);

alter table vol
add constraint pk_vol primary key (codi);

-- restricions de les taules
-- El seient és un número entre 1 i 200.
alter table volar
add constraint asiento_ch check (seient >= 1 and seient <= 200);

-- El número de passaport del personal no es pot repetir.
-- Ya esta 


-- El tipus d’avió pot valer només COM-PAS, JET, o CARGO.
ALTER TABLE avio
ADD CONSTRAINT tipus_check CHECK (tipus IN ('COM-PAS', 'JET', 'CARGO'));

-- La descripció del vol pot valer només ON-TIME, DELAYED, o UNKNOWN.
ALTER TABLE vol
ADD CONSTRAINT vol_descripcio_check CHECK (descripcio IN ('ON_TIME', 'DELAYED', 'UNKNOWN'));

-- Per ser pilot s’han de tenir com a mínim 400 hores de vol.
add alter pilot
add constraint pilot_pilot check (hores >= 400);

-
-- Agregar restricción para que un asiento no pueda estar ocupado por más de un pasajero en el mismo vuelo
ALTER TABLE volar
ADD CONSTRAINT unique_seient_per_vol UNIQUE (vol, seient);

-- La durada dels vols ha de ser un valor entre 10 i 1200.
alter table vol
add constraint durada_duarda check (time >= 10 or time <= 1200);

-- El sou no pot ser negatiu. A més el sou mínim ha de ser de 20.000 dolars.
alter table personal
add constraint sou_sou check (sou > 0 and sou >= 20.000);

-- El codi IATA dels aeroports no es pot repetir.
alter table aeroport
add constraint codi_codi codi unique;

-- Inclore frogein clau a les taules
alter table companyia
add constraint fk_companyia
foreign key (filial_de)
references companyia(nom)
on delete restrict
on update cascade;

alter table hostessa
add constraint fk_hostessa_personal
foreign key (num_empleat)
references personal(num_empleat)
on delete cascade
on update cascade;

alter table pilot
add constraint fk_pilot_personal
foreign key (num_empleat)
references personal(num_empleat)
on delete cascade
on update cascade;

alter table avio
add constraint fk_avio_companyia
foreign key (companyia)
references companyia(nom)
on delete restrict
on update cascade;

alter table mostrador
add constraint fk_mostrador_aeroport
foreign key (codi_aeroport)
references aeroport(codi)
on delete cascade
on update cascade;

alter table vol
add constraint fk_vol_aeroport_origen
foreign key (aeroport_origen)
references aeroport(codi)
on delete restrict
on update cascade;

alter table vol
add constraint fk_vol_aeroport_desti
foreign key (aeroport_desti)
references aeroport(codi)
on delete restrict
on update cascade;

alter table vol
add constraint fk_vol_avio
foreign key (avio)
references avio(num_serie)
on delete restrict
on update cascade;

alter table vol
add constraint fk_vol_hostessa
foreign key (hostessa)
references hostessa(num_empleat)
on delete restrict
on update cascade;

alter table vol
add constraint fk_vol_pilot
foreign key (pilot)
references pilot(num_empleat)
on delete restrict
on update cascade;

alter table volar
add constraint fk_volar_passatger
foreign key (passatger)
references passatger(passaport)
on delete restrict
on update cascade;

alter table volar
add constraint fk_volar_vol
foreign key (vol)
references vol(codi)
on delete restrict
on update cascade;