SET NOCOUNT ON
SET DATEFORMAT ymd
USE master
GO

/*
Creazione DB esercizio 7 del libro (pag. 304)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES7_LIBRO')  
	DROP DATABASE [DB_ES7_LIBRO]
GO

CREATE database [DB_ES7_LIBRO]
GO
USE [DB_ES7_LIBRO]
GO

/*
Creo gli script delle tabelle
*/


CREATE TABLE OPERATORE(
CODOP CHAR(16) NOT NULL PRIMARY KEY,
INDIRIZZO VARCHAR(45) NOT NULL,
QUALIFICA VARCHAR(45) NOT NULL,
COSTO_ORARIO INT NOT NULL)
GO

CREATE TABLE ARTICOLO(
CODART CHAR(10) NOT NULL PRIMARY KEY,
DESCRIZIONE VARCHAR(45) NOT NULL)
GO

CREATE TABLE LOTTO(
CODART CHAR(10) NOT NULL FOREIGN KEY REFERENCES ARTICOLO,
CODOP CHAR(16) NOT NULL FOREIGN KEY REFERENCES OPERATORE,
TOTESEM INT NOT NULL,
PRIMARY KEY (CODART,CODOP)
)
GO

CREATE TABLE RECLAMO(
CODART CHAR(10) NOT NULL,
CODOP CHAR(16) NOT NULL,
NESEMPLARE VARCHAR(45) NOT NULL,
NOMECL VARCHAR(45) NOT NULL,
FOREIGN KEY (CODART,CODOP) REFERENCES LOTTO,
PRIMARY KEY (CODART,CODOP,NESEMPLARE))
GO


/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO OPERATORE VALUES('OP01','Via Morane','Cassiere','10')
INSERT INTO OPERATORE VALUES('OP02','Via Vacilio','Addetto imballaggio','25')
INSERT INTO OPERATORE VALUES('OP03','Via Ciro Menotti','Assemblatore','20')
INSERT INTO OPERATORE VALUES('OP04','Via Verdi','Magazziniere','20')
INSERT INTO OPERATORE VALUES('OP05','Via Bellinzona','Corriere','20')
INSERT INTO OPERATORE VALUES('OP06','Via Bellinzona','Corriere','10')

INSERT INTO ARTICOLO VALUES('A01','Notebook')
INSERT INTO ARTICOLO VALUES('A02','Cellulari')
INSERT INTO ARTICOLO VALUES('A03','iPod')
INSERT INTO ARTICOLO VALUES('A04','Tablet')
INSERT INTO ARTICOLO VALUES('A05','Netbook')

INSERT INTO LOTTO VALUES('A01','OP01','100')
INSERT INTO LOTTO VALUES('A02','OP01','100')
INSERT INTO LOTTO VALUES('A02','OP02','200')
INSERT INTO LOTTO VALUES('A03','OP03','150')
INSERT INTO LOTTO VALUES('A04','OP04','120')
INSERT INTO LOTTO VALUES('A05','OP05','140')
INSERT INTO LOTTO VALUES('A05','OP06','100')


INSERT INTO RECLAMO VALUES('A01','OP01','10','Francesco Neri')
INSERT INTO RECLAMO VALUES('A01','OP01','11','Francesco Neri')

INSERT INTO RECLAMO VALUES('A02','OP02','10','Annalisa Bianchi')
INSERT INTO RECLAMO VALUES('A02','OP02','11','Francesco Neri')

INSERT INTO RECLAMO VALUES('A03','OP03','10','Francesco Neri')
INSERT INTO RECLAMO VALUES('A03','OP03','11','Alberto Rossi')

INSERT INTO RECLAMO VALUES('A05','OP05','10','Francesco Neri')


/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM OPERATORE

SELECT * FROM ARTICOLO

SELECT * FROM LOTTO

SELECT * FROM RECLAMO

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare il codice degli operatori per i quali non esiste alcun re-
clamo, cio`e per i quali nessun esemplare di nessun lotto da essi confezionato
ha ricevuto un reclamo;
*/

	/* Soluzione libro */

	SELECT CODOP
	FROM OPERATORE
	WHERE CODOP NOT IN (SELECT CODOP 
						FROM RECLAMO)

/*
b) selezionare il codice degli operatori per i quali ogni lotto da essi confezio-
nato contiene almeno un esemplare al quale si riferisce un reclamo;
*/
	/* Soluzione libro */

	SELECT LX.CODOP
	FROM LOTTO LX
	WHERE NOT EXISTS
							( SELECT *
							FROM LOTTO LY
							WHERE LX.CODOP = LY.CODOP
							AND NOT EXISTS
													( SELECT *
													FROM RECLAMO
													WHERE LY.CODOP = RECLAMO.CODOP
													AND LY.CODART = RECLAMO.CODART ))
 /* soluzione alernativa seleziono da operatore e non da lotto*/

SELECT OP.CODOP
	FROM OPERATORE OP 
	WHERE NOT EXISTS
						( SELECT *
							FROM LOTTO LY
							WHERE OP.CODOP = LY.CODOP
							AND NOT EXISTS
													( SELECT *
													FROM RECLAMO
													WHERE LY.CODOP = RECLAMO.CODOP
													AND LY.CODART = RECLAMO.CODART ))

/*
c) selezionare il nome del cliente che ha fatto reclami per tutti gli operatori;
*/

	/* Soluzione libro */
	
	SELECT DISTINCT NOMECL  /*abbiamo aggiunto il Distinct rispetto alla soluzione del libro*/
	FROM RECLAMO RX
	WHERE NOT EXISTS
					( SELECT *
					FROM OPERATORE
					WHERE NOT EXISTS
										( SELECT *
										FROM RECLAMO RY
										WHERE RX.NOMECL = RY.NOMECL
										AND OPERATORE.CODOP = RY.CODOP))
										
	/*NOTA: questa query non fornisce risultati perchè dalla query a) sappiamo che 
	ci sono degli operatori che non hanno ricevuto reclami
	Per far sì che tale query restituisca un valore, andiamo ad aggiungere due reclami 
	per i lotti 'A04','OP04'  e  'A05','OP06'*/									
				
	INSERT INTO RECLAMO VALUES('A04','OP04','12','Francesco Neri')
	INSERT INTO RECLAMO VALUES('A05','OP06','10','Francesco Neri')
	
/*
d) selezionare, per ogni articolo, il codice dell’operatore che ha confezionato
il lotto con il maggior numero di esemplari, senza considerare i lotti con
un numero di esemplari TOTESEM non specificato.
*/

	/* Soluzione libro */

	SELECT LX.CODART, LX.CODOP
				FROM LOTTO LX
				WHERE LX.TOTESEM IS NOT NULL
				AND LX.TOTESEM >= ALL ( SELECT LY.TOTESEM
											FROM LOTTO LY
											WHERE LY.TOTESEM is not null
											AND LX.CODART = LY.CODART)


/*
e) selezionare il lotto che ha ricevuto pi`u reclami
*/

	/* Soluzione libro */
	
	SELECT LOTTO.CODART, LOTTO.CODOP, LOTTO.TOTESEM
	FROM LOTTO,RECLAMO
	WHERE LOTTO.CODART = RECLAMO.CODART
	AND LOTTO.CODOP = RECLAMO.CODOP
	GROUP BY LOTTO.CODART, LOTTO.CODOP,LOTTO.TOTESEM
	HAVING COUNT(*) >= ALL ( SELECT COUNT(*)
								FROM RECLAMO
								GROUP BY CODART,CODOP)
								