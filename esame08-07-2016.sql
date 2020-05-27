use master
use DB_08_07_2016
-----------------------------------------------------------------------
alter table Ciclista
add constraint chk_maggiorenne 
check (datediff(year, data_nascita, getdate()) >= 18)
-----------------------------------------------------------------------
alter table Iscritto
add constraint unique_iscrizione unique(nomeciclista, corsa, anno)
-----------------------------------------------------------------------
insert into GARA values ('Torneo Italiano', 2015, 'Modena', 'Sassuolo')
-- i cicli di cui so solo il nome non li inserisco
insert into CICLISTA values('Nicola Zecchi', 'italiano', '13-08-1991')

insert into ISCRITTO values ('Torneo Italiano', 2015, 'Nicola Zecchi', 1)
insert into ISCRITTO values ('Torneo Italiano', 2015, 'Mario Rossi', 2)
insert into ISCRITTO values ('Torneo Italiano', 2015, 'Ivan Basso', 3)
-- posizione = null perche non si sono presentati
INSERT INTO ISCRITTO VALUES('TORNEO ITALIANO','2015','NICOLAS ROCHE',NULL)
INSERT INTO ISCRITTO VALUES('TORNEO ITALIANO','2015','VINCENZO NIBALI',NULL) 
-----------------------------------------------------------------------
-- seleziono tutte le corse
SELECT distinct NOMECORSA
FROM GARA G1 
-- tolgo le corse dove trovo dei ritirati
WHERE NOT EXISTS ( SELECT *   
					FROM GARA G2   
					WHERE G1.NOMECORSA=G2.NOMECORSA 
--    join delle gare dove ci sono dei ritirati
	AND NOT EXISTS ( SELECT *       
					FROM ISCRITTO I      
					WHERE G2.NOMECORSA=I.CORSA      
							 AND G2.ANNOEDIZIONE=I.ANNO      
							 AND I.POSIZIONE='R'))
-----------------------------------------------------------------------
SELECT DISTINCT C.NOMECICLISTA 
FROM CICLISTA C 
WHERE C.NOMECICLISTA NOT IN (	SELECT I.NOMECICLISTA        
								FROM ISCRITTO I        
								WHERE I.CORSA = 'Giro' and 
									I.POSIZIONE <> 'R' AND 
									I.POSIZIONE IS NOT NULL) 
-----------------------------------------------------------------------
create view CARRIERA as
select c.NOMECICLISTA, 
		(select COUNT(*)
			from Iscritto i1
			where i1.NOMECICLISTA = c.NOMECICLISTA and
				POSIZIONE = 'R'
		) as num_ritirato,
		(select COUNT(*)
			from Iscritto i2
			where i2.NOMECICLISTA = c.NOMECICLISTA and
				POSIZIONE in ('PRIMO', 'SECONDO', 'TERZO')
		) as num_podi,
		(select COUNT(*)
			from Iscritto i3
			where i3.NOMECICLISTA = c.NOMECICLISTA and
				POSIZIONE is null
		) as num_non_presentazioni
from CICLISTA c 
-----------------------------------------------------------------------
ALTER TABLE ISCRITTO  
DROP CONSTRAINT FK__ISCRITTO__NOMECI__3B75D760

ALTER TABLE ISCRITTO  
ADD CONSTRAINT FK_CICLISTA 
FOREIGN KEY (NOMECICLISTA)  REFERENCES CICLISTA(NOMECICLISTA)  
on DELETE cascade 