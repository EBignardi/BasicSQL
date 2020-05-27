USE master
GO

/*
Creazione DB esercizio 5 del libro (pag. 303)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES5_LIBRO')  
	DROP DATABASE [DB_ES5_LIBRO]
GO

CREATE database [DB_ES5_LIBRO]
GO
USE [DB_ES5_LIBRO]
GO

/*
Creo gli script delle tabelle
*/

CREATE TABLE VIA(
CV CHAR(10) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) NOT NULL, 
QUARTIERE VARCHAR(45) NOT NULL,
LUNGHEZZA INT NOT NULL)
GO

CREATE TABLE INC(
CVA CHAR(10) NOT NULL FOREIGN KEY REFERENCES VIA,
CVB CHAR(10) NOT NULL FOREIGN KEY REFERENCES VIA,
NVOLTE INT NOT NULL,
PRIMARY KEY (CVA,CVB))
GO

/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO VIA VALUES('V1','Marco Polo','Pastena','120')
INSERT INTO VIA VALUES('V2','Ludovico Ricci','Zafferana','320')
INSERT INTO VIA VALUES('V3','Ciro Menotti','Annunziata','180')
INSERT INTO VIA VALUES('V4','Giuseppe Verdi','Musicisti','220')
INSERT INTO VIA VALUES('V5','Emilia Est','Pastena','220')
INSERT INTO VIA VALUES('V6','Vignolese','Annunciata','100')
INSERT INTO VIA VALUES('V7','Crespellani','SAnna','110')
INSERT INTO VIA VALUES('V8','Trento Trieste','SAgnese','160')

INSERT INTO INC VALUES('V1','V2','3')
INSERT INTO INC VALUES('V2','V1','5')
INSERT INTO INC VALUES('V3','V4','2')
INSERT INTO INC VALUES('V4','V5','6')
INSERT INTO INC VALUES('V5','V1','2')
INSERT INTO INC VALUES('V6','V7','9')
INSERT INTO INC VALUES('V7','V8','1')
INSERT INTO INC VALUES('V8','V4','4')
INSERT INTO INC VALUES('V1','V3','3')
INSERT INTO INC VALUES('V2','V5','5')
INSERT INTO INC VALUES('V3','V5','2')
INSERT INTO INC VALUES('V4','V6','6')
INSERT INTO INC VALUES('V5','V7','2')
INSERT INTO INC VALUES('V6','V8','9')
INSERT INTO INC VALUES('V7','V1','1')
INSERT INTO INC VALUES('V8','V2','4')
INSERT INTO INC VALUES('V1','V5','4')
INSERT INTO INC VALUES('V1','V7','4')
INSERT INTO INC VALUES('V2','V7','4')
INSERT INTO INC VALUES('V7','V2','4')
INSERT INTO INC VALUES('V5','V2','4')

/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM VIA

SELECT * FROM INC

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare le vie che incrociano almeno una via del quartiere ’Pastena’;
*/

	/* Soluzione libro */
	
	SELECT *
	FROM VIA
	WHERE CV IN ( SELECT CVA
					FROM INC,VIA
					WHERE INC.CVB=VIA.CV
					AND QUARTIERE='Pastena'
					OR CV IN ( SELECT CVB
								FROM INC,VIA
								WHERE INC.CVA=VIA.CV
								AND QUARTIERE='Pastena'))

/*
b) selezionare le vie che non incrociano via ’Marco Polo’;
*/

	/* Soluzione libro */
	
		SELECT *
		FROM VIA
		WHERE CV NOT IN ( SELECT CVA
							FROM INC,VIA
							WHERE INC.CVB=VIA.CV
							AND NOME='MarcoPolo')
							AND CV NOT IN ( SELECT CVB
											FROM INC,VIA
											WHERE INC.CVA=VIA.CV
											AND NOME='MarcoPolo')
	
/*
c) selezionare le coppie (CODICE1, CODICE2) tali che le vie con codice CODICE1
e CODICE2 abbiano la stessa lunghezza;
*/

	/* Soluzione libro */
		
		SELECT V1.CV AS CODICE1, V2.CV AS CODICE2
		FROM VIA V1, VIA V2
		WHERE V1.LUNGHEZZA=V2.LUNGHEZZA
		AND V1.CV > V2.CV	

/*
d) selezionare il quartiere che ha il maggior numero di vie;
*/

	/* Soluzione libro */

	SELECT QUARTIERE
		FROM VIA
		GROUP BY QUARTIERE
		HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
									FROM VIA
									GROUP BY QUARTIERE)
	
/*
e) selezionare, per ogni quartiere, la via di lunghezza maggiore;
*/

	/* Soluzione libro */

	SELECT QUARTIERE,CV
	FROM VIA V1
	WHERE LUNGHEZZA = ( SELECT MAX(LUNGHEZZA)
						FROM VIA V2
						WHERE V1.QUARTIERE=V2.QUARTIERE)
	
/*
f) selezionare le vie che incrociano tutte le vie del quartiere ’Pastena’
*/

	/* Soluzione libro */
	
		SELECT *
		FROM VIA X
		WHERE NOT EXISTS
						( SELECT *
							FROM VIA Y
							WHERE QUARTIERE='Pastena'
							AND NOT EXISTS ( SELECT *
												FROM INC
												WHERE (X.CV=CVA AND Y.CV=CVB)
												OR (X.CV=CVB AND Y.CV=CVA)))