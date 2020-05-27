USE master
GO

/*
Creazione DB esercizio 10 del libro (pag. 306)
*/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_ES10_LIBRO')  
	DROP DATABASE [DB_ES10_LIBRO]
GO

CREATE database [DB_ES10_LIBRO]
GO
USE [DB_ES10_LIBRO]
GO

/*
Creo gli script delle tabelle
*/

CREATE TABLE GARA (
CG CHAR(10) NOT NULL PRIMARY KEY, 
NOMECAMPO VARCHAR(45) NOT NULL,
LIVELLO VARCHAR(45) NOT NULL)
GO

CREATE TABLE GIOCATOREGOLF (
CF CHAR(10) NOT NULL PRIMARY KEY,
NOME VARCHAR(45) DEFAULT NULL,
NAZIONE VARCHAR(45) DEFAULT NULL)
GO

CREATE TABLE PARTECIPA (
CG CHAR(10) NOT NULL FOREIGN KEY REFERENCES GARA,
CF CHAR(10) NOT NULL FOREIGN KEY REFERENCES GIOCATOREGOLF,
PUNTEGGIO INT NOT NULL,
PRIMARY KEY(CG, CF))
GO

/*
Inserisco dei dati nelle tabelle
*/

INSERT INTO GARA VALUES('GA01','Golf Club Colonnella','nazionale')
INSERT INTO GARA VALUES('GA02','Golf Club Avezzano','internazionale')
INSERT INTO GARA VALUES('GA03','Golf Club Miglianico','nazionale')
INSERT INTO GARA VALUES('GA04','Golf Club Giulianova','nazionale')
INSERT INTO GARA VALUES('GA05','Golf Club Rivisondoli','internazionale')
INSERT INTO GARA VALUES('GA06','Golf Club San Donato','nazionale')
INSERT INTO GARA VALUES('GA07','Golf Club Promotion','internazionale')
INSERT INTO GARA VALUES('GA08','Golf Club Cervia','internazionale')

INSERT INTO GIOCATOREGOLF VALUES('GG01','Tiger Woods','Stati Uniti')
INSERT INTO GIOCATOREGOLF VALUES('GG02','Adam Scott','Australia')
INSERT INTO GIOCATOREGOLF VALUES('GG03','Phil Mickelson','Stati Uniti')
INSERT INTO GIOCATOREGOLF VALUES('GG04','Henrik Stenson','Svezia')
INSERT INTO GIOCATOREGOLF VALUES('GG05','Justin Rose','Inghilterra')
INSERT INTO GIOCATOREGOLF VALUES('GG06','Rory Mcllroy','Irlanda del Nord')
INSERT INTO GIOCATOREGOLF VALUES('GG07','Steve Stricker','Stati Uniti')
INSERT INTO GIOCATOREGOLF VALUES('GG08','Matt Kuchar','Stati Uniti')
INSERT INTO GIOCATOREGOLF VALUES('GG09','Brandt Snedeker','Stati Uniti')
INSERT INTO GIOCATOREGOLF VALUES('GG10','Jason Dufner','Stati Uniti')

INSERT INTO PARTECIPA VALUES('GA01','GG01','0')
INSERT INTO PARTECIPA VALUES('GA02','GG01','65')
INSERT INTO PARTECIPA VALUES('GA03','GG01','75')
INSERT INTO PARTECIPA VALUES('GA04','GG01','61')
INSERT INTO PARTECIPA VALUES('GA06','GG01','45')
INSERT INTO PARTECIPA VALUES('GA03','GG03','55')
INSERT INTO PARTECIPA VALUES('GA04','GG02','70')
INSERT INTO PARTECIPA VALUES('GA01','GG04','34')
INSERT INTO PARTECIPA VALUES('GA02','GG07','48')
INSERT INTO PARTECIPA VALUES('GA06','GG06','59')
INSERT INTO PARTECIPA VALUES('GA07','GG07','18')
INSERT INTO PARTECIPA VALUES('GA02','GG03','29')
INSERT INTO PARTECIPA VALUES('GA02','GG09','75')
INSERT INTO PARTECIPA VALUES('GA02','GG10','68')
INSERT INTO PARTECIPA VALUES('GA02','GG08','71')


/*
Visualizzo il contenuto delle tabelle
*/

SELECT * FROM GARA
SELECT * FROM GIOCATOREGOLF
SELECT * FROM PARTECIPA

/*
Nel seguito si riportano le soluzioni delle query numerate come sul libro
*/

/*
a) selezionare i dati dei giocatori di golf che hanno partecipato ad almeno una
gara disputata a livello ’nazionale’;
*/

	/* Soluzione libro */

	SELECT *
	FROM GIOCATOREGOLF G, PARTECIPA P, GARA GR
	WHERE G.CF=P.CF
	AND GR.CG=P.CG
	AND LIVELLO='nazionale'
/*
b) selezionare le nazioni in cui tutti i giocatori hanno ottenuto un punteggio
minore o uguale a 0 nelle gare disputate;
*/

	/* Soluzione libro */
	
	SELECT NAZIONE
	FROM GIOCATOREGOLF
	WHERE NAZIONE NOT IN
						( SELECT NAZIONE
						FROM GIOCATOREGOLF G, PARTECIPA P
						WHERE G.CF= P.CF AND PUNTEGGIO > 0 )

/*
c) selezionare i dati dei giocatori di golf che hanno partecipato a tutte le gare
disputate a livello ’nazionale’;
*/

	/* Soluzione libro */
		SELECT *
				FROM GIOCATOREGOLF G
				WHERE NOT EXISTS
								( SELECT *
								FROM GARA
								WHERE LIVELLO='nazionale'
								AND NOT EXISTS
													( SELECT *
													FROM PARTECIPA P
													WHERE GARA.CG=P.CG
													AND G.CF = P.CF))	
/*
d) selezionare i dati dei giocatori di golf che hanno vinto almeno una gara
disputata a livello ’internazionale’;
*/

	/* Soluzione libro */
	
	SELECT *
		FROM GIOCATOREGOLF G
		WHERE CF IN ( SELECT P.CF
						FROM GARA, PARTECIPA P
						WHERE GARA.CG=P.CG
						AND LIVELLO='internazionale'
						AND P.PUNTEGGIO =( SELECT MIN(P1.PUNTEGGIO)
											FROM PARTECIPA P1
											WHERE P1.CG=P.CG) )
/*
e) selezionare, per ogni nazione che nelle gare di livello ’internazionale’ ha
schierato pi`u di 5 giocatori distinti, il punteggio medio ottenuto dai gio-
catori in tali gare; si ordini il risultato in modo decrescente rispetto al
punteggio medio
*/

	/* Soluzione libro */
	
	SELECT G.NAZIONE, AVG(P.PUNTEGGIO) as PunteggioMedio
	FROM GIOCATOREGOLF G,GARA, PARTECIPA P
	WHERE G.CF= P.CF
	AND GARA.CG=P.CG
	AND LIVELLO='internazionale'
	GROUP BY G.NAZIONE
	HAVING COUNT(distinct P.CF) > 5
	ORDER BY 2 DESC