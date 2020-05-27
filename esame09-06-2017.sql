use DB09062017

create table Persona (
	cf varchar(12) primary key,
	nome varchar(20) not null,
	cognome varchar(20) not null
)

insert into Persona
select d.cf, d.nome, d.cognome
from Dipendente d

insert into Persona
select c.cf, c.nome, c.cognome
from Cliente c
where c.cf not in (select p.cf
					from Persona p)

alter table Dipendente
add constraint FK_dipendente_persona foreign key (cf) references Persona(cf)

alter table Dipendente
drop column nome, cognome

alter table Cliente
add constraint FK_cliente_persona foreign key (cf) references Persona(cf)

alter table Cliente 
drop column nome, cognome


---------------------------------------------------------------------------


alter table Intervento
add ore_totali as ore_smontaggio + ore_riparazioni + ore_verniciatura


---------------------------------------------------------------------------


alter table Intervento
add constraint chk_smontaggio check (ore_smontaggio > 0)


---------------------------------------------------------------------------


CREATE VIEW LAVORI_DIPENDENTE as 
select d.cf, (select count(*)
				from Dipendente_Intervento di 
				where di.cf_dipendente = d.cf) as Numero_interventi, 
			(select count(distinct modello) 
				from Dipendente_Intervento di, Intervento i, Modello m 
				where d.cf = di.cf_dipendente and di.codice_intervento = i.codice and i.codice_auto = m.codice_infocar) as Numero_modelli 
from Dipendente d	


--------------------------------------------------------------------------

select c.cf, p.nome, p.cognome, (select count(*)
									from Intervento i
									where i.cf_cliente = c.cf) as numero_interventi_richiesti, 
								(select avg(datediff(day,data_inizio, data_fine)) as durata
									from Intervento i
									where i.cf_cliente = c.cf) as durata_media, 
								 isnull((select sum(numero) 
										 from Intervento i, Ricambio_Intervento r
										 where i.codice = r.codice_intervento and i.cf_cliente = c.cf),0) as numero_pezzi_ricambi 
from Cliente c, Persona p
where c.cf = p.cf

--------------------------------------------------------------------------

/*Selezionare i dati del cliente (cf, nome e cognome) che ha speso di più per un Intervento.
 Per calcolare il costo di un intervento sommare il prezzo delle parti di ricambio sostituite e supporre che ogni ora di lavoro costi 30 euro. (7 punti) */

 select c.cf, p.nome, p.cognome
 from Cliente c, Persona p, Intervento i, Ricambio_Intervento ri, Ricambio r
 where c.cf = p.cf and i.cf_cliente = c.cf and ri.codice_intervento = i.codice and r.cod_ricambio = ri.cod_ricambio
 group by c.cf, p.nome, p.cognome
 having sum((ri.numero * r.prezzo) + ((ore_smontaggio + ore_riparazioni + ore_verniciatura) * 30)) >= all (select sum((ri.numero * r.prezzo) + ((ore_smontaggio + ore_riparazioni + ore_verniciatura) * 30)) as totale_prezzo  
																											from Intervento i, Ricambio_Intervento ri, Ricambio r
																											where ri.codice_intervento = i.codice and r.cod_ricambio = ri.cod_ricambio
																											group by i.codice, (ore_smontaggio + ore_riparazioni + ore_verniciatura))

SELECT  p.cf, p.cognome, p.nome
FROM Intervento i join Ricambio_Intervento ri on ri.codice_intervento = i.codice  join Ricambio r on r.cod_ricambio = ri.cod_ricambio join Cliente c on c.cf = i.cf_cliente join Persona p on p.cf = c.cf 
GROUP BY i.codice, p.cf, p.cognome, p.nome, i.ore_totali  
having sum(r.prezzo*ri.numero) + (i.ore_totali * 30) >= all (SELECT sum(r.prezzo*ri.numero) + (i.ore_totali * 30) as totale_prezzo  
															FROM Intervento i join Ricambio_Intervento ri on ri.codice_intervento = i.codice join Ricambio r on r.cod_ricambio = ri.cod_ricambio  
															GROUP BY i.codice, i.ore_totali)