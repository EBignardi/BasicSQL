use master
use DB26072016
-----------------------------------------------------------------------
alter table Subacqueo
add numero_totale_immersioni int

update Subacqueo
set numero_totale_immersioni = (select COUNT(p.idimmersione)
								from Partecipa p
								where p.idsub = Subacqueo.idsub)
-----------------------------------------------------------------------
select si.*
from SitoImmersione si, Barca b
where si.idbarca = b.idbarca and tipo like 'gommone'
union
select si.*
from SitoImmersione si
where si.idbarca is null
-----------------------------------------------------------------------
alter table SitoImmersione 
add constraint unique_immersione unique(nomesito, profondita)
-----------------------------------------------------------------------
create view LOGBOOK as
select s.idsub, s.nome, s.brevetto, 
		(select COUNT(*)
		from Partecipa p
		where p.idsub = s.idsub) as num_immerisioni,
		(select max(profondita)
		from SitoImmersione si, Partecipa p
		where si.idimmersione = p.idimmersione and 
				p.idsub = s.idsub) as max_profondita
from Subacqueo s
-----------------------VERSIONE-PROF------------------------------------
select S.idsub, S.nome, S.brevetto, S.numero_totale_immersioni,
		 MAX(I.profondita) as prof_massima  
from ([Subacqueo] S join [Partecipa] P on S.idsub=P.idsub)  join 
		SitoImmersione I on I.idimmersione=P.idimmersione
 group by S.idsub, S.nome, S.brevetto, S.numero_totale_immersioni
-----------------------------------------------------------------------
select si.nomesito, si.profondita, b.nome, pr.data,
		ISNULL((B.n_posti- COUNT(pr.idsub)),(30- COUNT(pr.idsub))) as n_posti_disp 
from SitoImmersione si, Programma p, Barca b, Prenota pr
where si.idimmersione = p.idimmersione and b.idbarca = si.idbarca and  
		pr.data = p.data and pr.idimmersione = p.idimmersione
group by si.nomesito, si.profondita, b.nome, pr.data, b.idbarca, b.n_posti
		-- VERSIONE PROF --
Select I.nomesito, I.profondita, P.data, B.nome as nomebarca, 
		ISNULL((B.n_posti- COUNT(R.idsub)),(30- COUNT(R.idsub))) as n_posti_disp 
From ((SitoImmersione I join Programma P on P.idimmersione=I.idimmersione)  
		LEFT JOIN Prenota R on  (R.idimmersione=P.idimmersione and P.data=R.data) ) 
		LEFT JOIN Barca B on (I.idbarca=B.idbarca) 
GROUP BY I.profondita, I.nomesito, P.data, B.idbarca, B.n_posti, B.nome
-----------------------------------------------------------------------

 Create view RIEPILOGO_MENSILE as 
 Select YEAR(data) as anno, MONTH(data) as mese,  
		COUNT(DISTINCT(P.idimmersione)) as num_immersioni, 
		COUNT(P.idsub) as num_partecipanti 
 From Partecipa P 
 group by YEAR(data), MONTH(data) 
 ---------------------------------------------------------------------
 create table guidaSubacquea (
	idsub int primary key references Subacqueo
)

insert into guidaSubacquea 
	select s.idsub
	from Subacqueo s, Partecipa p
	where	s.idsub = p.idsub and
			s.brevetto = 'rescue' and 
			data >= '01-01-2014'
	group by s.idsub
	having COUNT(*) >= 6