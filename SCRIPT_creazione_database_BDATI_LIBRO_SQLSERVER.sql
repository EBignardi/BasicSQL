--Script per la creazione del database del libro Basi di Dati pag.141

SET NOCOUNT ON
SET DATEFORMAT mdy
go
use master
go
Create database BDATI
go
use BDATI
go
create table S(
Matr char(2) PRIMARY KEY,
SNome varchar(20) not null,
Citta char(2) null,
ACorso int not null)
go
create table D(
CD char(2) PRIMARY KEY,
CNome varchar(20) not null,
Citta char(2) null)
go
create table C(
CC char(2) PRIMARY KEY,
CNome varchar(20) not null,
CD char(2) not null references D)
go
create table E(
Matr char(2) references S,
CC char(2) references C,
Data date not null,
Voto int not null check ((voto>=18 and voto <=30) or (voto=33)),
PRIMARY KEY (Matr,CC) )
go


--inserimento degli studenti
Insert into S (Matr,SNome,Citta,ACorso)
values ('M1','Lucia Quaranta','SA',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M2','Giacomo Tedesco','PA',2)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M3','Carla Longo','MO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M4','Ugo Rossi','MO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M5','Valeria Neri','MO',2)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M6','Giuseppe Verdi','BO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M7','Maria Rossi',null,1)

--inserimento dei docenti
insert into D (CD,CNome,Citta)
values ('D1','Paolo Rossi','MO')
insert into D (CD,CNome,Citta)
values ('D2','Maria Pastore','BO')
insert into D (CD,CNome,Citta)
values ('D3','Paola Caboni','FI')


--inserimento dei corsi
Insert into C(CC,CNome,CD)
values ('C1','Fisica 1','D1')
Insert into C(CC,CNome,CD)
values ('C2','Analisi Matematica 1','D2')
Insert into C(CC,CNome,CD)
values ('C3','Fisica 2','D1')
Insert into C(CC,CNome,CD)
values ('C4','Analisi Matematica 2','D3')


--inserimento degli esami
Insert into E (Matr,CC,Data,Voto)
values ('M1','C1','06-29-1995',24)
Insert into E (Matr,CC,Data,Voto)
values ('M1','C2','08-09-1996',33)
Insert into E (Matr,CC,Data,Voto)
values ('M1','C3','03-12-1996',30)
Insert into E (Matr,CC,Data,Voto)
values ('M2','C1','06-29-1995',28)
Insert into E (Matr,CC,Data,Voto)
values ('M2','C2','07-07-1996',24)
Insert into E (Matr,CC,Data,Voto)
values ('M3','C2','07-07-1996',27)
Insert into E (Matr,CC,Data,Voto)
values ('M3','C3','11-11-1996',25)
Insert into E (Matr,CC,Data,Voto)
values ('M4','C3','11-11-1996',33)
Insert into E (Matr,CC,Data,Voto)
values ('M6','C2','01-02-1996',28)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C1','06-29-1995',24)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C2','04-11-1996',26)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C3','06-23-1996',27)