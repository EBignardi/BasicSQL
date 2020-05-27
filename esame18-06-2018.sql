use master
use DB_2018_06_18
---------------------------------------------------------------------------------------------
alter table Cantante
add constraint chk_maggiorenne check (datediff(year,data_nascita, getdate()) >= 18)
---------------------------------------------------------------------------------------------
alter table Iscritto
add constraint unique_iscrizione unique(numcomp, annoedizione, nomecantante)
---------------------------------------------------------------------------------------------
insert into COMPETIZIONE values ('eurovision', 2017, 'Modena', 'Paolo')

insert into CANTANTE values ('Calcutta', 'Rock', '06-04-1989')

insert into ISCRITTO values ('eurovision', 2017, 'Robert Plant', 1)
insert into ISCRITTO values ('eurovision', 2017, 'Calcutta', 2)
insert into ISCRITTO values ('eurovision', 2017, 'Freddie Mercury', 3)
insert into ISCRITTO values ('eurovision', 2017, 'Chef Ragoo', null)
insert into ISCRITTO values ('eurovision', 2017, 'Paul Rodgers', null)
---------------------------------------------------------------------------------------------
-- seleziono tutte le competizioni
select distinct C.numcomp
from Competizione C
--> Competizone - Competizione (con iscritti nulli) = risultato
--  tolgo le competizioni che rispettano la condizione
where not exists (select *
				from COMPETIZIONE CE
				where C.NUMCOMP=CE.NUMCOMP and 
				-- seleziono gli iscritti che si sono ritirati
				not exists (select *
							 from Iscritto I
							  where I.NUMCOMP=CE.NUMCOMP
							  and I.ANNOEDIZIONE=CE.ANNOEDIZIONE 
							   and I.POSIZIONE is null))
---------------------------------------------------------------------------------------------
select c.NOMECANTANTE
from CANTANTE c
where exists (-- seleziono quelli che hanno vinto a SANREMO
				select *
				from ISCRITTO i_sanremo
				where c.NOMECANTANTE = i_sanremo.NOMECANTANTE and
						i_sanremo.POSIZIONE = 1 and i_sanremo.NUMCOMP like 'SANREMO')
	and exists(-- seleziono quelli che hanno vinto a FESTIVALBAR
				select *
				from ISCRITTO i_festival
				where c.NOMECANTANTE = i_festival.NOMECANTANTE and 
						i_festival.POSIZIONE  = 1 and i_festival.NUMCOMP like 'FESTIVALBAR')
---------------------------------------------------------------------------------------------
create view CARRIERA as
	select *, 
			(select COUNT(*)
			from ISCRITTO i
			where i.NOMECANTANTE = c.NOMECANTANTE and POSIZIONE is null)  as num_ritirato,
			(select COUNT(*)
			from ISCRITTO i
			where i.NOMECANTANTE = c.NOMECANTANTE and
					POSIZIONE in (1,2,3))  as num_podio
	from CANTANTE c 
---------------------------------------------------------------------------------------------
alter table ISCRITTO 
drop constraint FK_ISCRITTO_NUMfk

alter table ISCRITTO
add constraint ES7
FOREIGN KEY (NOMECANTANTE) REFERENCES CANTANTE 
ON DELETE CASCADE