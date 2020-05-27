-- NON MODIFICARE NULLA NEL RESTO DI QUESTO FILE
-- SE NON ISTRUITO IN PROPOSITO DAL DOCENTE

SET NOCOUNT ON
SET DATEFORMAT dmy

USE master
GO

IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = 'DB_CONCORSO_FOTOGRAFICO')  
	DROP DATABASE [DB_CONCORSO_FOTOGRAFICO]
GO

CREATE DATABASE [DB_CONCORSO_FOTOGRAFICO]
GO

USE [DB_CONCORSO_FOTOGRAFICO]
GO

-- INIZIO CREAZIONE STRUTTURA


CREATE TABLE [dbo].[Fotografo] (
	[idfotografo] [int] NOT NULL PRIMARY KEY,
	[nome] [nvarchar] (100) NOT NULL,
	[nazionalita] [nvarchar] (100)
	)
GO

INSERT INTO [Fotografo] values (1,'Henri Cartier-Bresson', 'francese')
INSERT INTO [Fotografo] values (2, 'Sebastiao Salgado','spagnolo')
INSERT INTO [Fotografo] values (3, 'Robert Doisneau',null)
INSERT INTO [Fotografo] values (4, 'Andrea Abati','italiano')
INSERT INTO [Fotografo] values (5, 'Araki Nobuyoshi','giapponese')
INSERT INTO [Fotografo] values (6, 'Helmut Newton','tedesco')
INSERT INTO [Fotografo] values (7, 'Edward Weston','americano')
INSERT INTO [Fotografo] values (8, 'David Seymour',null)
INSERT INTO [Fotografo] values (9, 'Marco Di Lauro','italiano')
GO 
	

CREATE TABLE [dbo].[Fotografia] (
	[idfotografia] [int] NOT NULL PRIMARY KEY,
	[tema] [nvarchar] (100) NOT NULL,
	[idfotografo] [int] NOT NULL REFERENCES [Fotografo]
	)
GO


INSERT INTO [Fotografia] values (1,'tramonto',1)
INSERT INTO [Fotografia] values (2,'tramonto',2)
INSERT INTO [Fotografia] values (3,'tramonto',3)
INSERT INTO [Fotografia] values (4,'tramonto',4)
INSERT INTO [Fotografia] values (5,'tramonto',5)
INSERT INTO [Fotografia] values (6,'tramonto',6)



INSERT INTO [Fotografia] values (9,'alba e tramonto',2)
INSERT INTO [Fotografia] values (10,'alba e tramonto',3)
INSERT INTO [Fotografia] values (11,'alba e tramonto',4)
INSERT INTO [Fotografia] values (12,'alba e tramonto',5)


INSERT INTO [Fotografia] values (13,'montagna',2)
INSERT INTO [Fotografia] values (14,'montagna',3)
INSERT INTO [Fotografia] values (15,'montagna',4)
INSERT INTO [Fotografia] values (16,'montagna',6)
INSERT INTO [Fotografia] values (17,'montagna',7)
INSERT INTO [Fotografia] values (18,'montagna',8)

INSERT INTO [Fotografia] values (19,'oceano',1)
INSERT INTO [Fotografia] values (20,'oceano',2)
INSERT INTO [Fotografia] values (21,'oceano',3)
INSERT INTO [Fotografia] values (22,'oceano',4)
INSERT INTO [Fotografia] values (23,'oceano',5)
INSERT INTO [Fotografia] values (24,'oceano',6)


INSERT INTO [Fotografia] values (25,'metropoli',1)
INSERT INTO [Fotografia] values (26,'metropoli',2)
INSERT INTO [Fotografia] values (27,'metropoli',3)
INSERT INTO [Fotografia] values (28,'metropoli',4)
INSERT INTO [Fotografia] values (29,'metropoli',5)
INSERT INTO [Fotografia] values (30,'metropoli',6)
INSERT INTO [Fotografia] values (31,'metropoli',7)
INSERT INTO [Fotografia] values (32,'metropoli',8)

INSERT INTO [Fotografia] values (33,'ritratto',2)
INSERT INTO [Fotografia] values (34,'ritratto',3)
INSERT INTO [Fotografia] values (35,'ritratto',4)
INSERT INTO [Fotografia] values (36,'ritratto',6)


INSERT INTO [Fotografia] values (37,'autoritratto',1)
INSERT INTO [Fotografia] values (38,'autoritratto',2)
INSERT INTO [Fotografia] values (39,'autoritratto',3)
INSERT INTO [Fotografia] values (40,'autoritratto',4)
INSERT INTO [Fotografia] values (41,'autoritratto',5)
INSERT INTO [Fotografia] values (42,'autoritratto',6)
INSERT INTO [Fotografia] values (43,'autoritratto',7)



INSERT INTO [Fotografia] values (7,'psiche',1)
INSERT INTO [Fotografia] values (8,'psiche',2)



INSERT INTO [Fotografia] values (44,'collina',2)
INSERT INTO [Fotografia] values (45,'collina',5)
INSERT INTO [Fotografia] values (46,'collina',6)
INSERT INTO [Fotografia] values (47,'collina',7)
INSERT INTO [Fotografia] values (48,'collina',8)

GO

CREATE TABLE [dbo].[Concorso] (
	[idconcorso] [int] NOT NULL PRIMARY KEY,
	[nome] [varchar] (200) NOT NULL,
	[annoedizione] [int] NOT NULL,
	[digitale] [bit] NOT NULL CHECK ([digitale]=0 OR [digitale]=1)
	--1 = concorso digitale 0= concorso analogico
	)
GO	

INSERT INTO [Concorso] values (1,'National Geographic International Photography Contest',2008,1)
INSERT INTO [Concorso] values (2,'National Geographic International Photography Contest',2009,1)
INSERT INTO [Concorso] values (3,'National Geographic International Photography Contest',2010,1)
INSERT INTO [Concorso] values (4,'National Wildlife Photo Contest',2008,0)
INSERT INTO [Concorso] values (5,'National Wildlife Photo Contest',2010,0)
INSERT INTO [Concorso] values (6,'Self-Searching Photography Exhibition',2006,0)
INSERT INTO [Concorso] values (7,'Self-Searching Photography Exhibition',2008,0)
INSERT INTO [Concorso] values (8,'Colors of Life Photography Contest',2006,1)
INSERT INTO [Concorso] values (9,'Colors of Life Photography Contest',2008,1)
INSERT INTO [Concorso] values (10,'Colors of Life Photography Contest',2010,1)

GO


CREATE TABLE [dbo].[Valutazione] (
	[idfotografia] [int] NOT NULL REFERENCES [Fotografia],
	[idconcorso] [int] NOT NULL REFERENCES [Concorso],
	[voto] [int] NOT NULL
	PRIMARY KEY ([idfotografia],[idconcorso])
	)
GO	

DELETE from [Valutazione]


--	[idconcorso] 1
INSERT INTO [Valutazione] values (1,1,6)
INSERT INTO [Valutazione] values (2,1,7)
INSERT INTO [Valutazione] values (3,1,8)
INSERT INTO [Valutazione] values (4,1,3)
INSERT INTO [Valutazione] values (5,1,4)
INSERT INTO [Valutazione] values (6,1,6)
INSERT INTO [Valutazione] values (17,1,7)
INSERT INTO [Valutazione] values (18,1,9)


--	[idconcorso] 2
INSERT INTO [Valutazione] values (1,2,7)
INSERT INTO [Valutazione] values (4,2,5)
INSERT INTO [Valutazione] values (9,2,9)
INSERT INTO [Valutazione] values (23,2,4)
INSERT INTO [Valutazione] values (10,2,7) 


--	[idconcorso] 3
INSERT INTO [Valutazione] values (19,3,9)
INSERT INTO [Valutazione] values (20,3,3)
INSERT INTO [Valutazione] values (21,3,7)
INSERT INTO [Valutazione] values (11,3,6)
INSERT INTO [Valutazione] values (12,3,5)
INSERT INTO [Valutazione] values (24,3,8)


--	[idconcorso] 4
INSERT INTO [Valutazione] values (1,4,7)
INSERT INTO [Valutazione] values (13,4,2)
INSERT INTO [Valutazione] values (14,4,6)
INSERT INTO [Valutazione] values (11,4,8)
INSERT INTO [Valutazione] values (12,4,5)
INSERT INTO [Valutazione] values (36,4,6)



--	[idconcorso] 5
INSERT INTO [Valutazione] values (21,5,6)
INSERT INTO [Valutazione] values (22,5,7)
INSERT INTO [Valutazione] values (44,5,3)
INSERT INTO [Valutazione] values (45,5,8)
INSERT INTO [Valutazione] values (46,5,3)
INSERT INTO [Valutazione] values (47,5,6)
INSERT INTO [Valutazione] values (48,5,6)



--	[idconcorso] 6
INSERT INTO [Valutazione] values (33,6,7)
INSERT INTO [Valutazione] values (7,6,6)
INSERT INTO [Valutazione] values (34,6,7)
INSERT INTO [Valutazione] values (40,6,9)
INSERT INTO [Valutazione] values (41,6,4)
INSERT INTO [Valutazione] values (42,6,6)
INSERT INTO [Valutazione] values (43,6,7)



--	[idconcorso] 7
INSERT INTO [Valutazione] values (35,7,5)
INSERT INTO [Valutazione] values (36,7,7)
INSERT INTO [Valutazione] values (8,7,4)
INSERT INTO [Valutazione] values (37,7,3)
INSERT INTO [Valutazione] values (39,7,4)



--	[idconcorso] 8
INSERT INTO [Valutazione] values (33,8,7)
INSERT INTO [Valutazione] values (7,8,6)
INSERT INTO [Valutazione] values (34,8,7)
INSERT INTO [Valutazione] values (41,8,4)
INSERT INTO [Valutazione] values (42,8,6)
INSERT INTO [Valutazione] values (43,8,8)



--	[idconcorso] 9
INSERT INTO [Valutazione] values (22,9,4)
INSERT INTO [Valutazione] values (23,9,5)
INSERT INTO [Valutazione] values (24,9,8)
INSERT INTO [Valutazione] values (25,9,6)
INSERT INTO [Valutazione] values (26,9,3)
INSERT INTO [Valutazione] values (27,9,6)
INSERT INTO [Valutazione] values (48,9,6)




--	[idconcorso] 10
INSERT INTO [Valutazione] values (25,10,6)
INSERT INTO [Valutazione] values (26,10,10)
INSERT INTO [Valutazione] values (27,10,3)
INSERT INTO [Valutazione] values (28,10,5)
INSERT INTO [Valutazione] values (41,10,9)
INSERT INTO [Valutazione] values (42,10,4)
INSERT INTO [Valutazione] values (48,10,6)

