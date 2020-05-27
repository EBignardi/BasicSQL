use master
use DB29062017
-----------------------------------------------------------------------------------
 ALTER TABLE [Articolo]   
 ADD CONSTRAINT dft_dataALTER default getdate() for datainvio
 ----------------------------------------------------------------------------------
 alter table Articolo
 add constraint chk_presentazione check (not ((idconferenza is not null) and (idrivista is not null)))
 ----------------------------------------------------------------------------------
 select a.nome, a.cognome, a.idautore,
 COUNT(art.idarticolo) as articoli_scritti, 
 COUNT(artpubbl.idarticolo) as articoli_pubblicati, 
 ((COUNT(artpubbl.idarticolo) * 100) / COUNT(art.idarticolo)) as percentuale_successo 
 from Autore a left join Scrive s on s.idautore = a.idautore 
				left join Articolo art on art.idarticolo = s.idarticolo 
				left join Articolopubblicato artpubbl on artpubbl.idarticolo = art.idarticolo 
 group by a.nome, a.cognome, a.idautore
 order by percentuale_successo
------------------------------------------------------------------------------------
-- seleziono le istituzioni che NON hanno articoli pubblicati
SELECT afferenza 
FROM Autore AFF 
WHERE NOT EXISTS ( SELECT * 
					FROM Autore AU, SCRIVE S 
					WHERE S.idautore = AU.idautore AND AU.afferenza = AFF.afferenza 
					AND NOT EXISTS ( 
					SELECT * 
					FROM Articolopubblicato AP 
					WHERE AP.idarticolo = S.idarticolo))
------------------------------------------------------------------------------------
select c.titolo, c.nazione, COUNT(a.idarticolo) as num_articoli
from Conferenza c, Articolo a
where c.idconferenza = a.idconferenza and YEAR(c.datainizio) = 2017 
group by c.titolo, c.nazione
having COUNT(a.idarticolo) >= all (select COUNT(a.idarticolo)
									from Conferenza c, Articolo a
									where c.idconferenza = a.idconferenza and YEAR(c.datainizio) = 2017 
									group by c.titolo, c.nazione)
------------------------------------------------------------------------------------
SELECT DISTINCT AU1.* 
FROM Autore AU1, SCRIVE S1, Autore AU2, SCRIVE S2, Articolo AR
WHERE AR.idarticolo = S1.idarticolo AND S1.idautore = AU1.idautore AND 
		AR.idarticolo = S2.idarticolo AND S2.idautore = AU2.idautore AND 
		AU1.afferenza = AU2.afferenza AND AU1.idautore <> AU2.idautore 
ORDER BY AU1.cognome, AU1.nome
------------------------------------------------------------------------------------
create view STATISTICHE as

--conto gli articoli pubblicati nelle conferenze
select a.settore, Count(*) as articoli_in_conferenze
from Articolo a, Articolopubblicato ap
where a.idarticolo = ap.idarticolo and (a.idconferenza is not null)
group by a.settore
-- Unisco
union
--
--conto gli articoli pubblicati nelle riviste
select a1.settore, Count(*) as articoli_in_riviste
from Articolo a1, Articolopubblicato ap1
where a1.idarticolo = ap1.idarticolo and (a1.idrivista is not null)
group by a1.settore

-------------------------------------VERSIONE UNITA--------------------------------

CREATE VIEW STATISTICHE AS 
SELECT Settore, 
		COUNT(*) as Num_articoli,  
		(SELECT COUNT(*) 
			FROM Articolo AR1 JOIN Articolopubblicato AP1 ON (AR1.idarticolo=AP1.idarticolo) 
			WHERE AR1.idrivista is not null AND AR1.settore=S.settore) as Art_Publ_Riviste, 
		(SELECT COUNT(*) 
			FROM Articolo AR2 JOIN Articolopubblicato AP2 ON (AR2.idarticolo=AP2.idarticolo) 
			WHERE AR2.idconferenza is not null AND AR2.settore=S.settore) as Art_Publ_Conferenze 
FROM Articolo S 
GROUP BY Settore