use master
use [20180625]
-----------------------------------------------------------------------
alter table Autore
add constraint chk_afferenza_not_null check (afferenza is not null)
-----------------------------------------------------------------------
alter table Autore
add ARTscritti int, ARTpub int

update Autore 
set ARTscritti =	(select COUNT(*)
					from Scrive s
					where s.idautore = Autore.idautore),
		ARTpub =	(select COUNT(*)
					from Scrive s, Articolopubblicato artpubbl
					where s.idautore = Autore.idautore and 
						s.idarticolo = artpubbl.idarticolo)
-----------------------------------------------------------------------
alter table Articolo
add constraint chk_settore check (settore in('Big Data Integration', 
			'Query Optimization', 'Uncertain Reasoning', 'Web 4.0'))
-----------------------------------------------------------------------
select *
from Autore a
where a.idautore not in (select s.idautore
						from Articolo art, Scrive s
						where art.idarticolo = s.idarticolo and
								settore = 'Uncertain Reasoning')
-----------------------------------------------------------------------
create view Anno2017 as
select c.titolo, 
		(select COUNT(*)
		from Articolo a
		where a.idconferenza = c.idconferenza) as num_art_ricevuti,
		(select COUNT(*)
		from Articolo a, Articolopubblicato ap
		where a.idarticolo = ap.idarticolo and
				 a.idconferenza = c.idconferenza) as num_art_pubbl
from Conferenza c
where YEAR(datainizio) = 2017
-----------------------------------------------------------------------
create table STAT(
	Anno int default 0,
	NCN int not null default 0, -- Numero di conferenze nazionali
	NCI int not null default 0, -- Numero di conferenze internazionali
	NAI int not null default 0, -- Numero totale articoli inviati
	NAA int not null default 0, -- Numero totale autori di articoli inviati
	primary key(Anno)
)
-----------------------------------------------------------------------
insert into STAT

	select YEAR(c.datainizio), 
			
	(select COUNT(*)
	from Conferenza c1
	where year(c.datainizio) = year(c1.datainizio) and
			nazione like 'Italia'),

	(select COUNT(*)
	from Conferenza c2
	where  year(c.datainizio) = year(c2.datainizio) and
			nazione not like 'Italia'),

	(select COUNT(*)
	from Conferenza c3, Articolo a
	where  c3.idconferenza = a.idconferenza and
			year(c.datainizio) = year(c3.datainizio)),

	(select COUNT(*)
	from Conferenza c4, Articolo a, Scrive s
	where  c4.idconferenza = a.idconferenza and
			year(c.datainizio) = year(c4.datainizio) and
			s.idarticolo = a.idarticolo)

	from Conferenza c
	group by YEAR(c.datainizio)
-----------------------------------------------------------------------

