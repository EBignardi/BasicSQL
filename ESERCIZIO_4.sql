USE master
GO

/*
Creazione DB esercizio 4 del libro (pag. 303)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES4_LIBRO')  
	DROP DATABASE [DB_ES4_LIBRO]
GO

CREATE database [DB_ES4_LIBRO]
GO
USE [DB_ES4_LIBRO]
GO

/*
Creo gli script delle tabelle
*/
CREATE TABLE PRODOTTO(
CP char(16) NOT NULL primary key,
DESCRIZIONE varchar(45) NOT NULL)
GO

CREATE TABLE SOCIO(
CS CHAR(16) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) NOT NULL,
COGNOME VARCHAR(45) NOT NULL)
GO

CREATE TABLE OFFERTA(
CO CHAR(10) NOT NULL PRIMARY KEY,
VALIDITA VARCHAR(45) NOT NULL)
GO

CREATE TABLE COMPRENDE(
CO CHAR(10) NOT NULL FOREIGN KEY REFERENCES OFFERTA,
CP CHAR(16) NOT NULL FOREIGN KEY REFERENCES PRODOTTO,
QUANTITA INT NOT NULL,
PRIMARY KEY(CO,CP))
GO

CREATE TABLE RITIRA(
CO CHAR(10) NOT NULL FOREIGN KEY REFERENCES OFFERTA,
CS CHAR(16) NOT NULL FOREIGN KEY REFERENCES SOCIO,
DATA DATETIME NOT NULL,   /*se si usa SQLServer 2008 il formato pu� essere anche DATE*/
PRIMARY KEY(CO,CS))
GO

/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO PRODOTTO VALUES('P01','Uva')
INSERT INTO PRODOTTO VALUES('P02','Pere')
INSERT INTO PRODOTTO VALUES('P03','Mele')
INSERT INTO PRODOTTO VALUES('P04','Kiwy')
INSERT INTO PRODOTTO VALUES('P05','Susine')
INSERT INTO PRODOTTO VALUES('P06','Banane')

INSERT INTO SOCIO VALUES('S01','ALESSANDRO','CHARALAMBIS')
INSERT INTO SOCIO VALUES('S02','RAFFAELE','CONIGLIO')
INSERT INTO SOCIO VALUES('S03','MARIA VITTORIA','GRANDI')
INSERT INTO SOCIO VALUES('S04','GIOVANNI','CAMBI')
INSERT INTO SOCIO VALUES('S05','FABRIZIO','FERRARESI')
INSERT INTO SOCIO VALUES('S06','VITOALBERTO','BARLETTA')

INSERT INTO OFFERTA VALUES('O01','null')
INSERT INTO OFFERTA VALUES('O02','null')
INSERT INTO OFFERTA VALUES('O03','null')
INSERT INTO OFFERTA VALUES('O04','null')
INSERT INTO OFFERTA VALUES('O05','null')
INSERT INTO OFFERTA VALUES('O06','null')

INSERT INTO COMPRENDE VALUES('O01','P01','15')
INSERT INTO COMPRENDE VALUES('O02','P02','10')
INSERT INTO COMPRENDE VALUES('O03','P03','23')
INSERT INTO COMPRENDE VALUES('O04','P04','31')
INSERT INTO COMPRENDE VALUES('O05','P05','18')
INSERT INTO COMPRENDE VALUES('O06','P06','19')
INSERT INTO COMPRENDE VALUES('O01','P02','15')
INSERT INTO COMPRENDE VALUES('O02','P03','10')
INSERT INTO COMPRENDE VALUES('O03','P04','23')
INSERT INTO COMPRENDE VALUES('O04','P05','31')
INSERT INTO COMPRENDE VALUES('O05','P06','18')
INSERT INTO COMPRENDE VALUES('O06','P04','19')

SET DATEFORMAT ymd  /*utilizzo per le date il formato anno(y)-mese(m)-giorno(d)*/

INSERT INTO RITIRA VALUES('O01','S01','2013-05-12')
INSERT INTO RITIRA VALUES('O02','S02','2013-05-13')
INSERT INTO RITIRA VALUES('O03','S03','2013-05-21')
INSERT INTO RITIRA VALUES('O04','S04','2013-05-19')
INSERT INTO RITIRA VALUES('O05','S05','2013-05-23')
INSERT INTO RITIRA VALUES('O06','S06','2013-05-27')
INSERT INTO RITIRA VALUES('O01','S02','2013-05-11')
INSERT INTO RITIRA VALUES('O02','S03','2013-05-10')
INSERT INTO RITIRA VALUES('O03','S04','2013-05-22')
INSERT INTO RITIRA VALUES('O04','S05','2013-05-28')
INSERT INTO RITIRA VALUES('O05','S06','2013-05-29')
INSERT INTO RITIRA VALUES('O06','S04','2013-05-30')


/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM PRODOTTO

SELECT * FROM SOCIO

SELECT * FROM OFFERTA

SELECT * FROM COMPRENDE

SELECT *FROM RITIRA

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare il codice e la descrizione dei prodotti che non sono mai stati
offerti insieme ad un prodotto con descrizione =�Uva�;
*/

	/* Soluzione libro */
	
	SELECT *
	FROM PRODOTTO
	WHERE PRODOTTO.CP NOT IN
							( SELECT C2.CP
								FROM COMPRENDE C1, PRODOTTO, COMPRENDE C2
								WHERE C1.CP=PRODOTTO.CP
								AND C2.CO=C1.CO
								AND PRODOTTO.DESCRIZIONE='Uva')

/*
b) selezionare il codice, nome e cognome dei soci che non hanno ritirato alcuna
offerta che comprende un prodotto con descrizione �Uva�.
*/

	/* Soluzione libro */
	
		SELECT *
		FROM SOCIO
		WHERE SOCIO.CS NOT IN
							(SELECT RITIRA.CS
								FROM COMPRENDE, PRODOTTO, RITIRA
								WHERE COMPRENDE.CP=PRODOTTO.CP
								AND COMPRENDE.CO= RITIRA.CO
								AND PRODOTTO.DESCRIZIONE='Uva')
/*
c) selezionare il codice, nome e cognome dei soci che hanno ritirato tutte le
offerte che comprendono un prodotto con descrizione =�Uva�.
*/

	/* Soluzione libro */

		SELECT *
		FROM SOCIO
		WHERE NOT EXISTS
						( SELECT *
							FROM COMPRENDE,PRODOTTO
							WHERE COMPRENDE.CP=PRODOTTO.CP
							AND PRODOTTO.DESCRIZIONE ='Uva'
							AND NOT EXISTS
											( SELECT *
											FROM RITIRA
											WHERE SOCIO.CS= RITIRA.CS
											AND COMPRENDE.CO= RITIRA. CO))
	
/*
d) selezionare, per ogni socio, il numero delle offerte ritirate che comprendono
un prodotto con descrizione =�Uva�
*/

	/* Soluzione libro */
	
		SELECT RITIRA.CS, COUNT(*) as NUM_OFF_RITIRATE
		FROM COMPRENDE, PRODOTTO, RITIRA
		WHERE COMPRENDE.CP = PRODOTTO.CP
		AND COMPRENDE.CO = RITIRA. CO
		AND PRODOTTO.DESCRIZIONE ='Uva'
		GROUP BY RITIRA.CS