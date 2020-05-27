alter table Traversata
add constraint chk_porti 
check (portopartenza <> portoarrivo)
-------------------------------------------------------------------------------------------
alter table Biglietto
add constraint uniq_biglietto
unique (nome, cognome, codt, dataorapartenza)
-------------------------------------------------------------------------------------------
alter table Traversata
add durata_viaggio as DATEDIFF(HOUR, dataorapartenza, dataoraarrivo)
-------------------------------------------------------------------------------------------
select t.CODT,
		(tr.capienza - (select distinct COUNT(*)
						from BIGLIETTO
						where BIGLIETTO.DATAORAPARTENZA=t.DATAORAPARTENZA and
								BIGLIETTO.CODT=t.CODT )) as posti_rimanenti
from TRAVERSATA t, TRAGHETTO tr
where t.CODT = tr.CODT and 
		PORTOPARTENZA like 'OLB' and
		(tr.capienza - (select distinct COUNT(*)
						from BIGLIETTO
						where BIGLIETTO.DATAORAPARTENZA=t.DATAORAPARTENZA and
								BIGLIETTO.CODT=t.CODT )) > 0
-------------------------------------------------------------------------------------------
select distinct b.NOME, b.COGNOME
from BIGLIETTO b
where not exists (select *
					from TRAGHETTO t
					where not exists (select *
										from TRAGHETTO t1, BIGLIETTO b1, TRAVERSATA tr
										where t1.CODT=tr.CODT and
												tr.CODT = b1.CODT and 
												tr.DATAORAPARTENZA=b1.DATAORAPARTENZA and
												b1.NOME=b.NOME and b1.COGNOME=b.COGNOME and
												t1.TIPO=t.TIPO))
-------------------------------------------------------------------------------------------
create view PROFILO as
	select b.NOME, b.COGNOME, 
			COUNT(distinct p_arrivo.CITTA) as porti_arrivo,
			COUNT(distinct p_partenza.CITTA) as porti_partenza
	from BIGLIETTO b, TRAVERSATA t, PORTO p_arrivo, PORTO p_partenza
	where b.CODT=t.CODT and b.DATAORAPARTENZA=t.DATAORAPARTENZA and
			p_arrivo.CODP=t.PORTOARRIVO and p_partenza.CODP=t.PORTOPARTENZA	
	group by b.NOME, b.COGNOME
--------------------------------------------------------------------------------------------
alter table Biglietto
drop constraint FK__BIGLIETTO__403A8C7D

alter table Biglietto 
add constraint FK_biglietto
foreign key (codt, dataorapartenza) references Traversata(codt, dataorapartenza)
on delete cascade
