SET NOCOUNT ON
SET DATEFORMAT dmy

USE master
GO
/*Creazione DB esercizio 9 del libro (pag. 305)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES9_LIBRO')  
	DROP DATABASE [DB_ES9_LIBRO]
GO

CREATE database [DB_ES9_LIBRO]
GO
USE [DB_ES9_LIBRO]
GO

/*Creo gli script delle tabelle
*/

CREATE TABLE FORNITORE (
CODF CHAR(10) NOT NULL PRIMARY KEY, 
NOMEFORNITORE VARCHAR(45) NOT NULL,
CITTA VARCHAR(45) NOT NULL)
GO

CREATE TABLE PRODOTTO (
CODP CHAR(10) NOT NULL PRIMARY KEY,
DESCRIZIONE VARCHAR(45) DEFAULT NULL,
PREZZO  MONEY DEFAULT NULL)
GO

CREATE TABLE FORNISCE (
ANNO INT NOT NULL,
CODP CHAR(10) NOT NULL FOREIGN KEY REFERENCES PRODOTTO,
CODF CHAR(10) NOT NULL FOREIGN KEY REFERENCES FORNITORE,
QTY INT NOT NULL,
PRIMARY KEY(ANNO,CODP,CODF))
GO

/*
Inserisco dei dati nelle tabelle
*/
INSERT INTO FORNITORE VALUES('01','PIPPO INZAGHI','MO')
INSERT INTO FORNITORE VALUES('02','ROBERTO BAGGIO','BO')
INSERT INTO FORNITORE VALUES('03','ENRICO CHIESA','MI')
INSERT INTO FORNITORE VALUES('04','FRANCESCO TOTTI','RO')
INSERT INTO FORNITORE VALUES('05','GIUSEPPE ROSSI','TR')
INSERT INTO FORNITORE VALUES('06','ROBERTO BENIGNI','BO')
INSERT INTO FORNITORE VALUES('07','ALESSANDRO SIANI','MO')
INSERT INTO FORNITORE VALUES('08','FRANCO ROSSI','CS')
GO

INSERT INTO PRODOTTO VALUES('001','COCA','25')
INSERT INTO PRODOTTO VALUES('002','FANTA','30')
INSERT INTO PRODOTTO VALUES('003','BIRRA','30')
INSERT INTO PRODOTTO VALUES('004','PASTA','10')
GO


INSERT INTO FORNISCE VALUES(1994,'001','02',19)
INSERT INTO FORNISCE VALUES(1994,'001','03',11)
INSERT INTO FORNISCE VALUES(1994,'001','04',8)
INSERT INTO FORNISCE VALUES(1995,'001','05',7)
INSERT INTO FORNISCE VALUES(1994,'002','04',5)
INSERT INTO FORNISCE VALUES(1995,'002','01',3)
INSERT INTO FORNISCE VALUES(1995,'002','03',1)
INSERT INTO FORNISCE VALUES(1994,'002','02',12)
INSERT INTO FORNISCE VALUES(1995,'002','07',10)
INSERT INTO FORNISCE VALUES(1995,'003','01',15)
INSERT INTO FORNISCE VALUES(1994,'004','01',9)
INSERT INTO FORNISCE VALUES(1994,'001','05',14)
INSERT INTO FORNISCE VALUES(1994,'001','08',7)
INSERT INTO FORNISCE VALUES(1994,'002','08',5)
INSERT INTO FORNISCE VALUES(1995,'003','08',3)
INSERT INTO FORNISCE VALUES(1995,'004','08',9)
GO

/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM PRODOTTO
SELECT * FROM FORNITORE
SELECT * FROM FORNISCE


/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/


/*
a) Selezionare i prodotti che nell'anno 1995 sono stati forniti
da almeno un fornitore di Modena */

/*soluzione presente sul libro*/

SELECT PRODOTTO.*
FROM PRODOTTO,FORNISCE,FORNITORE
WHERE PRODOTTO.CODP=FORNISCE.CODP
AND FORNISCE.CODF=FORNITORE.CODF
AND ANNO=1994
AND CITTA='MO'

/*soluzione alternativa*/
SELECT PRODOTTO.*
FROM PRODOTTO,FORNISCE
WHERE PRODOTTO.CODP=FORNISCE.CODP
AND ANNO=1994
AND FORNISCE.CODF IN (SELECT FORNITORE.CODF
						FROM FORNITORE 
						WHERE CITTA='MO')
						
/*nota: se voglio includere anche i fornitori per i quali non � nota la citt�*/

SELECT PRODOTTO.*
FROM PRODOTTO,FORNISCE,FORNITORE
WHERE PRODOTTO.CODP=FORNISCE.CODP
AND FORNISCE.CODF=FORNITORE.CODF
AND ANNO=1994
AND ( CITTA='MO' OR CITTA is null)

/* 
b) Selezionare i prodotti non forniti da nessun fornitore di Modena
*/

/*soluzione del libro*/

SELECT *
FROM PRODOTTO
WHERE CODP NOT IN ( SELECT CODP
					FROM FORNISCE,FORNITORE
					WHERE FORNISCE.CODF=FORNITORE.CODF
					AND CITTA='MO')

/*
c) Selezionare i prodotti che nell'anno 1994 sono stati forniti esclusivamente 
da fornitori di Modena 
*/

/*soluzione del libro*/

SELECT P.*
FROM PRODOTTO P, FORNISCE,FORNITORE
WHERE P.CODP=FORNISCE.CODP
AND FORNISCE.CODF=FORNITORE.CODF
AND ANNO=1994 AND CITTA='MO'
AND P.CODP NOT IN ( SELECT PRODOTTO.CODP
					FROM PRODOTTO,FORNISCE,FORNITORE
					WHERE PRODOTTO.CODP=FORNISCE.CODP
					AND FORNISCE.CODF=FORNITORE.CODF
					AND ANNO=1994
					AND CITTA<>'MO')

/* 
d) Selezionare per ogni anno, la quantit� totale dei prodotti forniti dai fornitori di Modena
*/

/*soluzione del libro*/

SELECT ANNO, SUM(QTY) as quantita_totale
FROM FORNISCE, fornitore
WHERE FORNISCE.CODF=FORNITORE.CODF
AND CITTA='MO'
GROUP BY ANNO

/*
e) Selezionare per ogni anno, il codice del fornitore che ha fornito in totale
la maggiore quantit� di prodotti
*/

/*soluzione del libro*/

SELECT ANNO, CODF
FROM FORNISCE FX
GROUP BY ANNO, CODF
HAVING SUM(QTY)>= ALL( SELECT SUM(QTY)
						FROM FORNISCE FY
						WHERE FY.ANNO=FX.ANNO
						GROUP BY CODF) 
						
				