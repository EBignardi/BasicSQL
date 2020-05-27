-- NON MODIFICARE NULLA NEL RESTO DI QUESTO FILE
-- SE NON ISTRUITO IN PROPOSITO DAL DOCENTE

SET NOCOUNT ON
SET DATEFORMAT dmy

USE master
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB29072014')  
	DROP DATABASE [DB29072014]
GO

CREATE DATABASE [DB29072014]
GO

USE [DB29072014]
GO

-- INIZIO CREAZIONE STRUTTURA

CREATE TABLE [dbo].[Ciclista] (
	[idCiclista] [int] NOT NULL PRIMARY KEY,
	[nome] [nvarchar] (100) NOT NULL,
	[datanascita] [datetime] NOT NULL,
	[nomecategoria] [nvarchar] (100) )
GO

INSERT INTO [Ciclista] values (1,'Andrea Trenti','16-05-1996',null)
INSERT INTO [Ciclista] values (2,'Luca Bianchi','09-10-1993',null)
INSERT INTO [Ciclista] values (3,'Giovanni Modena','01-04-1999',null)
INSERT INTO [Ciclista] values (4,'Enrico Verdi','01-07-1999',null)
INSERT INTO [Ciclista] values (5,'Paolo Bianchini','01-01-1998',null)
INSERT INTO [Ciclista] values (6,'Ruggero Montanari','01-01-1992',null)
INSERT INTO [Ciclista] values (7,'Carlo Neri','01-12-1993',null)
INSERT INTO [Ciclista] values (8,'Luca Mantovani','01-05-1992',null)
INSERT INTO [Ciclista] values (9,'Giovanni Sala','11-12-1999',null)
INSERT INTO [Ciclista] values (10,'Gennaro Alberti','11-12-1992',null)
INSERT INTO [Ciclista] values (11,'Lucio Serafini','11-12-1992',null)
GO

CREATE TABLE [dbo].[Gara] (
	[idgara] [int] NOT NULL PRIMARY KEY,
	[data] [datetime] NOT NULL,
	[nome] [varchar] (200) NOT NULL,
	[categoria] [varchar] (100) NOT NULL,
	[tipo] [varchar] (100) NOT NULL,
	[regione] [varchar] (100) NOT NULL,
	[partenza] [varchar] (100) NULL,
	[arrivo] [varchar] (100) NULL
	
	)
GO	

INSERT INTO [Gara] values (51965,'23/03/2014','5° G.P. COMUNE DI CORNAREDO','Juniores','strada','Lombardia','CORNAREDO','MILANO');
INSERT INTO [Gara] values (51899,'04/05/2014','48° CIRCUITO DEL PORTO - TROFEO ARVEDI','Under 23','strada','Lombardia','MILANO','CREMONA');
INSERT INTO [Gara] values (51919,'16/07/2014','51° GIRO CICLISTICO INTERNAZIONALE VALLE D''AOSTA','Under 23','a tappe','Valle d''Aosta',null,null);
INSERT INTO [Gara] values (51963,'18/09/2014','33° GIRO DI BASILICATA','Juniores','a tappe','Basilicata',null, null);
INSERT INTO [Gara] values (51894,'22/04/2014','53° GRAN PREMIO PALIO DEL RECIOTO','Under 23','strada','Veneto','NEGRAR','VERONA');
INSERT INTO [Gara] values (51945,'04/05/2014','31° G.P. LA PICCOLA SANREMO','Juniores','strada','Veneto','VERONA','MANTOVA');
INSERT INTO [Gara] values (51872,'05/10/2014','TROFEO TEAM ZANETTI','Under 23','strada','Emilia Romagna','PARMA','RIMINI');
GO

CREATE TABLE [dbo].[Partecipa] (
	[idCiclista] [int] NOT NULL REFERENCES [Ciclista],
	[idgara] [int] NOT NULL REFERENCES [Gara],
	[posizione] [int] NULL
	PRIMARY KEY ([idCiclista],[idgara])
	)
GO	

DELETE from [Partecipa]

INSERT INTO [Partecipa] values (1,51894,3)
INSERT INTO [Partecipa] values (3,51894,1)
INSERT INTO [Partecipa] values (4,51894,2)
INSERT INTO [Partecipa] values (9,51894,4)
                                          
INSERT INTO [Partecipa] values (1,51899,3)
INSERT INTO [Partecipa] values (5,51899,2)
INSERT INTO [Partecipa] values (9,51899,1)
                                          
INSERT INTO [Partecipa] values (1,51919,4)
INSERT INTO [Partecipa] values (3,51919,1)
INSERT INTO [Partecipa] values (4,51919,2)
INSERT INTO [Partecipa] values (9,51919,3)


INSERT INTO [Partecipa] values (1,51965,3) 
INSERT INTO [Partecipa] values (2,51965,1) 
INSERT INTO [Partecipa] values (3,51965,2) 
INSERT INTO [Partecipa] values (4,51965,4) 
INSERT INTO [Partecipa] values (6,51965,5) 
INSERT INTO [Partecipa] values (7,51965,7) 
INSERT INTO [Partecipa] values (8,51965,6) 
INSERT INTO [Partecipa] values (10,51965,8)
                                           
INSERT INTO [Partecipa] values (1,51945,1) 
INSERT INTO [Partecipa] values (2,51945,2) 
INSERT INTO [Partecipa] values (3,51945,3) 
INSERT INTO [Partecipa] values (4,51945,4) 
INSERT INTO [Partecipa] values (5,51945,5) 
INSERT INTO [Partecipa] values (6,51945,7) 
INSERT INTO [Partecipa] values (9,51945,6) 

GO
