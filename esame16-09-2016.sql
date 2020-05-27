use DB_201609016

alter table Prenotazione
add constraint chk_intervallo check ((datediff(day, inizio, fine) = 0) and
									(datediff(hour, inizio, fine) <= 15))
--------------------------------------------------------------------------
 select p.username, inizio, fine, s.nome, numposti
 from Prenotazione p, Sala s
 where p.nome = s.nome and (evento like 'seminario' or evento is null)
 order by p.username, numposti
 -------------------------------------------------------------------------
 select s.*, p.*
 from Prenotazione p, Sala s
 where p.nome = s.nome and p.admin_conferma is not null and
		year(p.inizio) = year(getdate()) and month(p.inizio) = month(getdate())
 order by s.nome, p.inizio
 ------------------------------------------------------------------------
 select u.username, livello, password, count(*) as num_prenotazioni
 from Utente u, Prenotazione p
 where u.username = p.username and year(p.inizio) = '2016' and
		u.livello <> 'admin'
 group by u.username, livello, password
 having count(*) >= all (select count(*)
						from Utente u1, Prenotazione p1
						where u1.username = p1.username and year(p1.inizio) = '2016' and
							u1.livello <> 'admin'
						group by u1.username)
-------------------------------------------------------------------------
--  Utenti che NON hanno prenotazioni riguardanti sale che NON sono state prenotate
select *
from Utente u
where not exists (select *
					from sala s
					where not exists (select * 
										from prenotazione p
										where u.username = p.username and
												p.nome = s.nome))

-- trovo gli utenti che non hanno effettuato prenotazioni
select *
from Utente u
where not exists (select *
					from Prenotazione p
					where u.username = p.username)

-- trovo le sale che non sono mai state prenotate
select *
from Sala s
where not exists (select *
					from Prenotazione p
					where s.nome = p.nome)
-----------------------------------------------------------------------
create view REPORT_MENSILE as
select p.nome,
		month(inizio) as mese, 
		sum(datediff(hour, inizio, fine)) as ore_impiegate, 
		count(*) as num_prenotazioni	 
from Prenotazione p
group by p.nome, month(inizio)
-----------------------------------------------------------------------
create table prenotazioneConfermata (
	nome nvarchar(100) not null,
	inizio datetime not null, 
	primary key (nome, inizio),
	foreign key (nome, inizio) references Prenotazione(nome, inizio)
);

insert into prenotazioneConfermata 
select Prenotazione.nome, Prenotazione.inizio
from Prenotazione 
where Prenotazione.admin_conferma is not null 
