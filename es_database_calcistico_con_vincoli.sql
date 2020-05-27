use master;
create database CALCIO_VINCOLI;
go

use CALCIO_VINCOLI;
create table Calciatore (
CF varchar(16) PRIMARY KEY,
nome varchar (50),
squadra varchar(20),
ruolo varchar(20)
);

create table Arbitro(
COD int PRIMARY KEY,
CF varchar(16) NOT NULL UNIQUE,
nome varchar (50)
);


create table Squadra(
nome varchar (50),
anno int,
PRIMARY KEY(nome));


create table Partita(
nomeSQ1 varchar (50) REFERENCES Squadra(nome),
nomeSQ2 varchar (50) REFERENCES Squadra(nome),
COD_arbitro int REFERENCES Arbitro(COD) ,
data date,
torneo varchar(50) NOT NULL,
punteggio varchar(10),
PRIMARY KEY(nomeSQ1,nomeSQ2,data),
UNIQUE(nomeSQ1,nomeSQ2, torneo),
unique(COD_arbitro,DATA)
)
go

--posso aggiungere una FOREIGN KEY anche successivamente con il comando di Alter Table

ALTER TABLE Calciatore
ALTER COLUMN Squadra varchar (50) 
go

ALTER TABLE Calciatore
ADD CONSTRAINT FK1 FOREIGN Key (squadra) REFERENCES Squadra
go



insert into Squadra values('Napoli',1926)
insert into Squadra values('Sevilla',1905)
insert into Squadra values('Real Madrid',1902)


insert into Calciatore values('123','Gonzalo Higuain','Napoli', 'attaccante')
insert into Calciatore values('324','Fernando Llorente','Sevilla', 'attaccante')
insert into Calciatore values('962','Cristiano Ronaldo','Real Madrid', 'attaccante')



--posso aggiungere una CHECK anche successivamente ad aver popolato la tabella, se i valori sono in accordo con il vincolo

ALTER TABLE Calciatore
ADD CONSTRAINT CK1 CHECK (Ruolo IN ('attaccante','portiere','difensore','centrocampista'))


insert into Arbitro values(111,987,'Nicola Rizzoli'), 
(222,876, 'Daniele Orsato'),
(333,765,'Pauly')

SET DATEFORMAT dmy;

insert into partita values( 'Real Madrid','Sevilla', 222,
 '12/09/2015','Supercoppa UEFA','2-0') 
insert into partita values('Napoli', 'Real Madrid', 333,
 '30/09/1987','Coppa Campioni','1-1') 