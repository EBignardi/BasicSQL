
--aziende per cui non esiste una persona di bologna a cui una loro 
--campagna non abbia inviato con successo (stato invio RICEVUTO) 
select *
from Azienda A
where not exists (select *
			from Persona p
			where P.citta = 'Bologna'
			and not exists (select *
						from Campagna C join ListaSpedizione L
						on L.idcamp = C.idcamp
						join Stato S on L.email = S.email and
						L.idcamp = S.idcamp
						where C.piva = A.piva
						and S.stato = 'RICEVUTO'
						and L.email = P.email
						and C.mail = 1 ))


--aziende per cui non esiste una loro campagna che non abbia inviato 
--con successo (stato invio RICEVUTO) mail a tutte le persone di Bologna

select *
from Azienda A
where not exists (select *
				from Campagna C
				where  C.piva = A.piva
				and not exists (select *
						from Persona P, ListaSpedizione L,Stato S
						where  L.idcamp = C.idcamp
						and L.email = S.email 
						and L.idcamp = S.idcamp
						and S.stato = 'RICEVUTO'
						and L.email = P.email
						and P.citta = 'Bologna'
							and C.mail = 1 
						))



select *
	from Campagna C, Persona P, ListaSpedizione L,Stato S
	where  L.idcamp = C.idcamp
	and L.email = S.email 
	and L.idcamp = S.idcamp
	and L.email = P.email
	and P.citta = 'Bologna'
