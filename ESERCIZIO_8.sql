USE master
GO

/*
Creazione DB esercizio 8 del libro (pag. 305)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES8_LIBRO')  
	DROP DATABASE [DB_ES8_LIBRO]
GO

CREATE database [DB_ES8_LIBRO]
GO
USE [DB_ES8_LIBRO]
GO

/*
Creo gli script delle tabelle
*/

CREATE TABLE MANIFESTAZIONE(
CM CHAR(16) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) NOT NULL)
GO

CREATE TABLE LUOGO(
NOMELUOGO VARCHAR(45) NOT NULL PRIMARY KEY,
INDIRIZZO VARCHAR(45) NOT NULL,
CITTA VARCHAR(45) NOT NULL)
GO

CREATE TABLE SPETTACOLO(
CM CHAR(16) NOT NULL FOREIGN KEY REFERENCES MANIFESTAZIONE,
NUM CHAR(16) NOT NULL,
ORA_INIZIO INT NOT NULL,
NOMELUOGO VARCHAR(45) NOT NULL FOREIGN KEY REFERENCES LUOGO,
DATA DATETIME NOT NULL,  /*se si usa SQLServer 2008 il formato può essere anche DATE*/
PRIMARY KEY(CM,NUM))
GO

/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO MANIFESTAZIONE VALUES('CM01','Elettroexpo')
INSERT INTO MANIFESTAZIONE VALUES('CM02','Model Expo Italy')
INSERT INTO MANIFESTAZIONE VALUES('CM03','Transpotec & Logic')
INSERT INTO MANIFESTAZIONE VALUES('CM04','Motor Bike Expo')
INSERT INTO MANIFESTAZIONE VALUES('CM05','OperaWine')
INSERT INTO MANIFESTAZIONE VALUES('CM06','Vinitaly')

INSERT INTO LUOGO VALUES('Stadio','Via Pelusia','Modena')
INSERT INTO LUOGO VALUES('Palasport','Via Mascagni','Bologna')
INSERT INTO LUOGO VALUES('Piazza','Piazza Matteotti','Modena')
INSERT INTO LUOGO VALUES('Teatro','Via dello sport','Torino')
INSERT INTO LUOGO VALUES('Museo','Via dei Correggi','Roma')
INSERT INTO LUOGO VALUES('Centro Commerciale','Via Ciro Menotti','Milano')

SET DATEFORMAT ymd  /*utilizzo per le date il formato anno(y)-mese(m)-giorno(d)*/

INSERT INTO SPETTACOLO VALUES('CM01','2','21','Teatro','2013-05-12')
INSERT INTO SPETTACOLO VALUES('CM02','1','21','Teatro','2013-06-12')
INSERT INTO SPETTACOLO VALUES('CM03','3','21','Teatro','2013-05-01')
INSERT INTO SPETTACOLO VALUES('CM04','4','21','Teatro','2013-07-12')
INSERT INTO SPETTACOLO VALUES('CM05','2','21','Teatro','2013-08-12')
INSERT INTO SPETTACOLO VALUES('CM06','2','21','Teatro','2013-09-12')
INSERT INTO SPETTACOLO VALUES('CM02','1','19','Palasport','2013-05-11')
INSERT INTO SPETTACOLO VALUES('CM03','3','18','Centro Commerciale','2013-05-12')
INSERT INTO SPETTACOLO VALUES('CM04','4','12','Teatro','2013-05-15')
INSERT INTO SPETTACOLO VALUES('CM05','2','20','Centro Commerciale','2013-05-12')
INSERT INTO SPETTACOLO VALUES('CM06','4','17','Palasport','2013-05-21')
INSERT INTO SPETTACOLO VALUES('CM01','1','21','Centro Commerciale','2013-05-12')
INSERT INTO SPETTACOLO VALUES('CM02','4','20','Museo','2013-05-17')
INSERT INTO SPETTACOLO VALUES('CM03','3','22','Centro Commerciale','2013-05-12')
INSERT INTO SPETTACOLO VALUES('CM04','1','20','Stadio','2013-05-28')
INSERT INTO SPETTACOLO VALUES('CM05','2','19','Palasport','2013-05-29')
INSERT INTO SPETTACOLO VALUES('CM06','4','18','Stadio','2013-05-30')

/*
Visualizzo il contenuto delle tabelle
*/


SELECT * FROM MANIFESTAZIONE

SELECT * FROM LUOGO

SELECT * FROM SPETTACOLO

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare il codice e il nome delle manifestazioni che non hanno interes-
sato luoghi della citt`a di Modena;
*/

	/* Soluzione libro */
	
	SELECT *
	FROM MANIFESTAZIONE M
	WHERE  NOT EXISTS ( SELECT *
						FROM LUOGO L, SPETTACOLO S
						WHERE M.CM = S.CM
						AND L.NOMELUOGO=S.NOMELUOGO
						AND L.CITTA='Modena')

/*
b) selezionare i nomi dei luoghi che hanno ospitato tutte le manifestazioni
(hanno ospitato almeno uno spettacolo di ciascuna manifestazione);
*/

	/* Soluzione libro */
	
	SELECT DISTINCT NOMELUOGO
	FROM SPETTACOLO X
	WHERE NOT EXISTS
					( SELECT *
					FROM MANIFESTAZIONE M
					WHERE NOT EXISTS
									( SELECT *
									FROM SPETTACOLO Y
									WHERE X.NOMELUOGO = Y.NOMELUOGO
									AND M.CM=Y.CM))
	
/*
c) selezionare il nome dei luoghi che, in una certa data, ospitano pi`u di tre
spettacoli dopo le ore 15;
*/

	/* Soluzione libro */

	SELECT DISTINCT NOMELUOGO
	FROM SPETTACOLO SX
	WHERE ORA_INIZIO > 15
	AND 3 < ( SELECT COUNT(*)
					FROM SPETTACOLO SY
					WHERE ORA_INIZIO > 15
					AND SX.NOMELUOGO = SY.NOMELUOGO
					AND SX.DATA = SY.DATA)

/*
d) selezionare, per ogni luogo, il numero totale delle manifestazioni e il numero
totale degli spettacoli ospitati;
*/

	/* Soluzione libro */
	
	SELECT NOMELUOGO, COUNT(distinct CM) as NMANIFESTAZIONI, COUNT(*) as NSPETTACOLI
	FROM SPETTACOLO
	GROUP BY NOMELUOGO

/*
e) Seleziona i codici delle manifestazioni i cui spettacoli sono iniziati sempre
dopo le ore 15
*/

	/* Soluzione libro */

	SELECT DISTINCT X.CM
	FROM SPETTACOLO X
	WHERE NOT EXISTS ( SELECT *
						FROM SPETTACOLO Y
						WHERE X.CM = Y.CM
						AND (Y.ORA_INIZIO<=15) )