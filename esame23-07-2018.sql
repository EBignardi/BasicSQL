use master
use DB_2018_07_23
-----------------------------------------------------------------------
alter table Volo
add constraint chk_arrivo_partenza 
check (aereoportopartenza <> aereoportoarrivo)
-----------------------------------------------------------------------
alter table Biglietto
add constraint unique_passeggero
unique(nome, cognome, codv, dataora)
-----------------------------------------------------------------------
INSERT INTO AEROPORTO VALUES('CDG','Parigi')
INSERT INTO AEROPORTO VALUES('BLQ','Bologna')

INSERT INTO VOLO VALUES('AF0303','CDG','BLQ','25-07-2018','2', 5)

INSERT INTO BIGLIETTO VALUES('ROBERT','PLANT','AF0303','25-07-2018')
INSERT INTO BIGLIETTO VALUES('FREDDIE','MERCURY','AF0303','25-07-2018')
INSERT INTO BIGLIETTO VALUES('PAUL','RODGERS','AF0303','25-07-2018')
INSERT INTO BIGLIETTO VALUES('CHEF','RAGOO','AF0303','25-07-2018')
--------------------VERSIONE PROF---------------------------------------
select V.CODV, V.DATAORA
from Volo V, Biglietto B
where V.CODV = B.CODV and V.DATAORA = B.DATAORA
group by V.CODV, V.DATAORA
having count(B.CODB) > (select V2.CAPIENZA
						from Volo V2
						where V.CODV = V2.CODV and V.DATAORA = V2.DATAORA)
------------------------------------------------------------------------
select distinct P.nome, P.cognome
from Biglietto P
where not exists (  select *
					from Aeroporto A
					where A.CITTA = 'Roma'
					and not exists (	select *
										from volo V, biglietto B
										where P.nome = B.nome and 
												B.CODV = V.CODV and 
												P.cognome = B.cognome and
												A.CODA = V.AEROPORTOPARTENZA
									)
				 )
-----------------------------------------------------------------------
create view PROFILO as
select NOME, COGNOME, 
		COUNT(distinct a.CITTA) as citta_arrivo,
		COUNT(distinct a1.CITTA) as citta_partenza
from BIGLIETTO b, VOLO v, AEROPORTO a, AEROPORTO a1
where b.CODV =v.CODV  and b.DATAORA = v.DATAORA and 
		 a.CODA = v.AEROPORTOARRIVO and  a1.CODA = v.AEROPORTOPARTENZA 
GROUP BY NOME, COGNOME
-----------------------------------------------------------------------
alter table biglietto
add constraint fk_biglietto 
foreign key (codv, dataora) references volo(codv, dataora)
on delete cascade


