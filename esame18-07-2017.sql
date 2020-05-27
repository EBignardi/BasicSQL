use DB18072017

alter table Campagna
add constraint chk_null_campagna
check ((mail is not null) and (sms is not null) and
		((mail <> 0) or (sms <> 0)))
-------------------------------------------------------------------
alter table Campagna
add constraint ak_max_campagna 
unique(data, piva)
-------------------------------------------------------------------
select *
from Persona p
where p.email not in (select distinct ls.email   
						from ListaSpedizione ls, Campagna c, Stato s
						where ls.email=s.email and ls.idcamp=c.idcamp and 
							c.sms=1 and s.stato='RICEVUTO')
-------------------------------------------------------------------
create view REPORT as 
select c.idcamp, c.body,
		(select count(ls.email)) as num_spedizioni_tot,
		(select count(s.email)
			from Stato s
			where s.idcamp=c.idcamp and stato ='INVIATO') as effettivi_inviati,
		(select count(s2.email)
			from Stato s2
			where s2.idcamp=c.idcamp and s2.stato ='RICEVUTO') as ricevuti,
		(select count(s3.email)
			from Stato s3
			where s3.idcamp=c.idcamp and s3.stato ='APERTO') as aperti
from Campagna c, ListaSpedizione ls
where c.idcamp = ls.idcamp 
group by c.idcamp, c.body
-------------------------------------------------------------------
-- TOT - (Persone di Bologna - Persone che hanno ricevuto il messaggio)
select *
from Azienda a
where not exists (select *
					from Persona p
					where p.citta ='Bologna'
					and not exists (select * 
									from Campagna c, ListaSpedizione ls, Stato s
									where c.idcamp=ls.idcamp and 
											s.email=ls.email and
											s.idcamp=ls.idcamp and
											c.piva=a.piva and 
											ls.email=p.email and
											s.stato=' RICEVUTO' and
											c.mail=1))
----------------------------------------------------------------------------------------------------------------------------------------------
select ls.idcamp,  successrate = (convert(real, count(st.email))/convert(real,count(*)))*100 
from ListaSpedizione ls left join (select s.email, s.idcamp 
									from Stato s 
									where s.stato = 'APERTO'  ) as st on ls.email=st.email and ls.idcamp=st.idcamp  
group by ls.idcamp 
having (convert(real, count(st.email))/convert(real, count(*)))*100 >= all (select successrate = (convert(real, count(st1.email))/convert(real, count(*)))*100  
																			from ListaSpedizione ls1 left join (select s.email, s.idcamp 
																												from Stato s 
																												where s.stato = 'APERTO'  ) as st1 on ls1.email=st1.email and ls1.idcamp=st1.idcamp  
																			group by ls1.idcamp) 
----------------------------------------------------------------------------------------------------------------------------------------------
select nome, cognome 
from Persona p, Stato s, Stato s2, Campagna c, Azienda a
where  a.piva=c.piva and c.idcamp=s.idcamp and p.email=s.email and s2.idcamp=c.idcamp and s2.email=p.email and
s.stato = 'APERTO' and s2.stato = 'RICEVUTO' and a.ragione_sociale='Buy-on-air' and 
-- persona che ci ha messo PIU' tempo 
(datediff(minute, s2.orario, s.orario) >=  all (select datediff(minute, s2.orario, s.orario)  
												from Persona p, Stato s, Stato s2, Campagna c, Azienda a
												where  a.piva=c.piva and c.idcamp=s.idcamp and p.email=s.email and s2.idcamp=c.idcamp and s2.email=p.email and
												s.stato = 'APERTO' and s2.stato = 'RICEVUTO' and a.ragione_sociale='Buy-on-air')
-- persona che ci ha messo MENO tempo 
or (datediff(minute, s2.orario, s.orario) <= all (select datediff(minute, s2.orario, s.orario) 
													from Persona p, Stato s, Stato s2, Campagna c, Azienda a
													where  a.piva=c.piva and c.idcamp=s.idcamp and p.email=s.email and s2.idcamp=c.idcamp and s2.email=p.email and
													s.stato = 'APERTO' and s2.stato = 'RICEVUTO' and a.ragione_sociale='Buy-on-air'))) 
 
 