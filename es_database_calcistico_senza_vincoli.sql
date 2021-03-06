use master;
CREATE DATABASE CALCIO_NOVINCOLI;
go

USE CALCIO_NOVINCOLI;
go
CREATE TABLE calciatore(
	CF varchar(20),
	nome varchar(100),
	squadra varchar(50),
	ruolo varchar(50)
); 

CREATE TABLE arbitro(
	COD int,
	CF varchar(20),
	nome varchar(100)
);

CREATE TABLE squadra(
	nome varchar(50), 
	anno_fondazione int
);

CREATE TABLE partita(
	nome_squadra_1 varchar(50),
	nome_squadra_2 varchar(50),
	arbitro varchar(50),
	data datetime,
	torneo varchar(50),
	punteggio varchar(20),
);
go

INSERT INTO calciatore (CF, nome, squadra, ruolo) 
VALUES ('123','Gonzalo Higuain', 'Napoli', 'attaccante');

INSERT INTO calciatore 
VALUES ('Fernando Llorente','324','Sevilla', 'centravanti');

Set dateformat dmy;

INSERT INTO partita (nome_squadra_1,nome_squadra_2,arbitro,data, torneo, punteggio)
VALUES('Real Madrid', 'sevilla','daniele orsato', '22-02-2015', 'supercoppa UEFA', '2-0');





