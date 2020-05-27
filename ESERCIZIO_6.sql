USE master
GO

/*
Creazione DB esercizio 6 del libro (pag. 304)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES6_LIBRO')  
	DROP DATABASE [DB_ES6_LIBRO]
GO

CREATE database [DB_ES6_LIBRO]
GO
USE [DB_ES6_LIBRO]
GO

/*
Creo gli script delle tabelle
*/

CREATE TABLE CAMPO(
NCAMPO CHAR(16) NOT NULL PRIMARY KEY,
TIPO VARCHAR(45) NOT NULL,
INDIRIZZO VARCHAR(45) NOT NULL)
GO

CREATE TABLE TENNISTA(
CF CHAR(10) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) NOT NULL,
NAZIONE VARCHAR(45) NOT NULL)
GO

CREATE TABLE INCONTRO(
CI CHAR(16) NOT NULL PRIMARY KEY,
NCAMPO CHAR(16) NOT NULL FOREIGN KEY REFERENCES CAMPO,
GIOC1 CHAR(10) NOT NULL FOREIGN KEY REFERENCES TENNISTA,
GIOC2 CHAR(10) NOT NULL FOREIGN KEY REFERENCES TENNISTA,
SET1 INT NOT NULL,
SET2 INT NOT NULL)
GO


/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO CAMPO VALUES('C01','erba','VIA VACIGLIO')
INSERT INTO CAMPO VALUES('C02','sintetico','VIA VERDI')
INSERT INTO CAMPO VALUES('C03','erba','VIA MORANE')
INSERT INTO CAMPO VALUES('C04','sintetico','VIA AMENDOLA')
INSERT INTO CAMPO VALUES('C05','erba','VIA CIRO MENOTTI')

INSERT INTO TENNISTA VALUES('T01','Rafael Nadal','Spagna')
INSERT INTO TENNISTA VALUES('T02','Rod Laver','Australia')
INSERT INTO TENNISTA VALUES('T03','Roger Federer','Svizzera')
INSERT INTO TENNISTA VALUES('T04','Mike Bryan','Stati Uniti')
INSERT INTO TENNISTA VALUES('T05','Bob Bryan','Stati Uniti')

INSERT INTO INCONTRO VALUES('I01','C01','T01','T02','3','1')
INSERT INTO INCONTRO VALUES('I02','C02','T03','T04','1','3')
INSERT INTO INCONTRO VALUES('I03','C03','T04','T05','3','1')
INSERT INTO INCONTRO VALUES('I04','C04','T01','T03','3','1')
INSERT INTO INCONTRO VALUES('I06','C01','T02','T03','1','3')
INSERT INTO INCONTRO VALUES('I07','C02','T01','T02','3','1')
INSERT INTO INCONTRO VALUES('I08','C03','T05','T04','3','1')
INSERT INTO INCONTRO VALUES('I09','C04','T03','T04','3','1')



/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM CAMPO

SELECT * FROM TENNISTA

SELECT * FROM INCONTRO

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare gli incontri disputati sull’erba (campo con tipo ’erba’);
*/

	/* Soluzione libro*/

	SELECT INCONTRO.*
	FROM INCONTRO,CAMPO
	WHERE INCONTRO.NCAMPO= CAMPO.NCAMPO
	AND TIPO='erba'
	
/*
b) selezionare i campi in erba sui quali non c’`e stato nessun incontro;
*/

	/* Soluzione libro*/

	SELECT *
	FROM CAMPO
	WHERE TIPO='erba'
	AND NCAMPO NOT IN
						( SELECT NCAMPO
						FROM INCONTRO)

/*
c) selezionare i dati dei tennisti vincitori di almeno una partita sull’erba;
*/

	/* Soluzione libro*/

	SELECT *
	FROM TENNISTA
	WHERE CF IN ( SELECT GIOC1
					FROM INCONTRO I,CAMPO C
					WHERE I.NCAMPO= C.NCAMPO
					AND TIPO='erba'
					AND SET1 > SET2)
					OR CF IN ( SELECT GIOC2
								FROM INCONTRO I, CAMPO C
								WHERE I.NCAMPO= C.NCAMPO
								AND TIPO='erba'
								AND SET1 < SET2)
	
/*
d) selezionare i dati delle nazioni in cui tutti i giocatori hanno sempre vinto
le partite disputate;
*/

	/* Soluzione libro*/

	SELECT DISTINCT NAZIONE
			FROM TENNISTA
			WHERE NAZIONE NOT IN ( SELECT NAZIONE
									FROM INCONTRO,TENNISTA
									WHERE GIOC1= CF
									AND SET1 < SET2)
									AND NAZIONE NOT IN ( SELECT NAZIONE
														FROM INCONTRO,TENNISTA
														WHERE GIOC2= CF
														AND SET1 > SET2)

/*
e) selezionare il campo in erba che ha ospitato il maggior numero di incontri
*/

	/* Soluzione libro*/
	
	SELECT CAMPO.NCAMPO
		FROM INCONTRO,CAMPO
		WHERE INCONTRO.NCAMPO= CAMPO.NCAMPO
		AND TIPO='erba'
		GROUP BY CAMPO.NCAMPO
		HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
									FROM INCONTRO I, CAMPO C
									WHERE I.NCAMPO=C.NCAMPO
									AND TIPO='erba'
									GROUP BY C.NCAMPO)