USE master
GO

/*
Creazione DB esercizio 3 del libro (pag. 302)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES3_LIBRO')  
	DROP DATABASE [DB_ES3_LIBRO]
GO

CREATE database [DB_ES3_LIBRO]
GO
USE [DB_ES3_LIBRO]
GO

/*
Creo gli script delle tabelle
*/

CREATE TABLE QUADRO(
CQ VARCHAR(10) NOT NULL PRIMARY KEY,
AUTORE VARCHAR(45) NOT NULL,
PERIODO VARCHAR(45) NOT NULL)

CREATE TABLE MOSTRA(
CM VARCHAR(10) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) NOT NULL,
ANNO INT NOT NULL,
ORGANIZZATORE VARCHAR(45) NOT NULL
)
GO

CREATE TABLE ESPONE(
CM VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES MOSTRA,
CQ VARCHAR(10) NOT NULL FOREIGN KEY REFERENCES QUADRO,
SALA VARCHAR(45) NOT NULL,
PRIMARY KEY(CM, CQ))
GO


/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO QUADRO VALUES('Q001','Picasso','null')
INSERT INTO QUADRO VALUES('Q002','Da Vinci','null')
INSERT INTO QUADRO VALUES('Q003','Giotto','null')
INSERT INTO QUADRO VALUES('Q004','Picasso','null')
INSERT INTO QUADRO VALUES('Q005','Caravaggio','null')
INSERT INTO QUADRO VALUES('Q006','Caravaggio','null')
INSERT INTO QUADRO VALUES('Q007','Picasso','null')
INSERT INTO QUADRO VALUES('Q008','Da Vinci','null')

INSERT INTO MOSTRA VALUES('M001','L Itale se desta','1997','Filippo Rossi')
INSERT INTO MOSTRA VALUES('M002','O patria mia','1996','Lucia Bianco')
INSERT INTO MOSTRA VALUES('M003','In nome della legge','1995','Franco Neri')
INSERT INTO MOSTRA VALUES('M004','Palladio','1997','Filippo Rossi')
INSERT INTO MOSTRA VALUES('M005','Il risveglio improvviso','1996','Roberto Bianchi')
INSERT INTO MOSTRA VALUES('M006','Fiori di primavera','1995','Anna Bruno')
INSERT INTO MOSTRA VALUES('M007','Le foglie d autunno','1997','Paolo Rossi')
INSERT INTO MOSTRA VALUES('M008','Sorrisi','1996','Filippo Neri')

INSERT INTO ESPONE VALUES('M001','Q001','Sala Uno')
INSERT INTO ESPONE VALUES('M002','Q002','Sala Uno')
INSERT INTO ESPONE VALUES('M003','Q003','Sala Due')
INSERT INTO ESPONE VALUES('M004','Q003','Sala Uno')
INSERT INTO ESPONE VALUES('M005','Q004','Sala Tre')
INSERT INTO ESPONE VALUES('M006','Q006','Sala Uno')
INSERT INTO ESPONE VALUES('M007','Q007','Sala Quattro')
INSERT INTO ESPONE VALUES('M008','Q008','Sala Due')
INSERT INTO ESPONE VALUES('M002','Q001','Sala Uno')
INSERT INTO ESPONE VALUES('M002','Q003','Sala Uno')
INSERT INTO ESPONE VALUES('M003','Q004','Sala Due')
INSERT INTO ESPONE VALUES('M004','Q005','Sala Uno')
INSERT INTO ESPONE VALUES('M005','Q006','Sala Tre')
INSERT INTO ESPONE VALUES('M006','Q007','Sala Uno')
INSERT INTO ESPONE VALUES('M007','Q008','Sala Quattro')
INSERT INTO ESPONE VALUES('M003','Q001','Sala Due')

/*
Visualizzo il contenuto delle tabelle
*/


SELECT * FROM QUADRO
SELECT * FROM MOSTRA
SELECT * FROM ESPONE



/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/


/*
a) selezionare le sale nelle quali `e stato esposto, nell’anno 1997, un quadro di
Picasso;
*/

/* Soluzione libro */

	SELECT SALA
	FROM MOSTRA, ESPONE, QUADRO
	WHERE MOSTRA.CM=ESPONE.CM
	AND ESPONE.CQ=QUADRO.CQ
	AND ANNO='1997'
	AND AUTORE='Picasso'

/*
b) selezionare tutti i dati dei quadri di Picasso che non sono mai stati esposti
nell’anno 1997;
*/

	/*Soluzione libro*/
	
	SELECT *
	FROM QUADRO
	WHERE AUTORE='Picasso'
	AND CQ NOT IN ( SELECT CQ
					FROM MOSTRA, ESPONE
					WHERE MOSTRA.CM=ESPONE.CM
					AND ANNO='1997')

/*
c) selezionare tutti i dati dei quadri che non sono mai stati esposti insieme
ad un quadro di Picasso, cio`e nella stessa mostra in cui compariva anche
un quadro di Picasso;
*/

		/* Soluzione libro */
			
		SELECT *
		FROM QUADRO
		WHERE CQ NOT IN ( SELECT E2.CQ
							FROM QUADRO, ESPONE E1, ESPONE E2
							WHERE QUADRO.CQ=E1.CQ
							AND E1.CM=E2.CM
							AND AUTORE='Picasso')


/*
d) selezionare tutti i dati delle mostre in cui sono stati esposti quadri di
almeno 5 autori distinti;
*/
		/* Soluzione libro */
		
		SELECT *
		FROM MOSTRA
		WHERE 5 >= ( SELECT COUNT(DISTINCT AUTORE)
					FROM QUADRO,ESPONE
					WHERE QUADRO.CQ=ESPONE.CQ
					AND MOSTRA.CM=ESPONE.CM)

/*
e) selezionare, per ogni mostra, l’autore di cui si esponevano il maggior nu-
mero di quadri.
*/
			/* Soluzione libro*/

			SELECT CM,AUTORE
			FROM QUADRO Q1,ESPONE E1
			WHERE Q1.CQ=E1.CQ
			GROUP BY CM,AUTORE
			HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
									FROM QUADRO Q2,ESPONE E2
									WHERE Q2.CQ=E2.CQ
									AND E2.CM=E1.CM
									GROUP BY AUTORE)