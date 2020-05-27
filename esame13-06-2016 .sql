use master
use DB13062016

alter table MerceOfferta
add constraint PK primary key(cod, promo)
---------------------------------------------------------------------------------
alter table Promozione
add constraint chk_data check ((datainizio < datafine) and 
								(year(datainizio) = year(datafine)) and 
								(month(datainizio) = month(datafine)))
---------------------------------------------------------------------------------
create view PromozioneMensile as
select p.nome, MONTH(datainizio) as mese, YEAR(datainizio) as anno, prod.cod 
from Promozione p, MerceOfferta mo, Prodotto prod
where p.nome = mo.promo and prod.cod = mo.cod
---------------------------------------------------------------------------------
-- creo una nuova promozione
insert into Promozione values(
	'luglio prezzi basi',  
	'1-07-2016', 
	'10-07-2016', 
	20
)

-- inserisco i prodotti che non appaiono in nessuna promozione
insert into MerceOfferta
	select p.cod, 2, 'luglio prezzi bassi'
	from Prodotto p
	where p.cod not in (select mo.cod 
						from MerceOfferta mo)
--------------------------------------------------------------------------------
create table Clienti_fidelizzati (  
	idCliente int foreign key references Cliente(idcliente), 
	tessera_fedelta nvarchar(20) NOT NULL,  
	tot_promozioni nvarchar(20) default 0, 
	primary key (idCliente) 
 )

insert into Clienti_fidelizzati   
	select C.idCliente, C.[tessera-fedelta], count(U.promo) as tot_promozioni  
	from Cliente as C left join Usufruisce as U on (C.idcliente=U.idcliente) 
	where C.[tessera-fedelta] is not null  
	group by C.idCliente, C.[tessera-fedelta]

alter table Cliente drop column [tessera-fedelta] 
---------------------------------------------------------------------------------
select c.idcliente, c.nome, u.promo, 
		SUM(prod.prezzo * mo.numpezzi) as CostoOriginario,
		SUM(prod.prezzo * mo.numpezzi * p.sconto / 100) as Risparmio
from Cliente c, Usufruisce u, Prodotto prod, MerceOfferta mo, Promozione p
where c.idcliente=u.idcliente and u.promo=p.nome and p.nome=mo.promo and prod.cod=mo.cod
group by c.idcliente, c.nome, u.promo
---------------------------------------------------------------------------------
create view promozione_parziale as  
select p.nome, 'scaduta' as Disponibile, isnull(count(distinct mo.cod), 0) as NumeroProdotti,  isnull(sum(mo.numpezzi), 0) as NumeroPezzi 
from Promozione p left join MerceOfferta mo on (p.nome = mo.promo) 
where p.datafine < getdate() 
group by p.nome 

union 

select p.nome, 'attiva' as Disponibile, isnull(count(distinct mo.cod), 0) as NumeroProdotti,  isnull(sum(mo.numpezzi), 0) as NumeroPezzi 
from Promozione p left join MerceOfferta mo on (p.nome = mo.promo) 
where p.datafine >= getdate() 
group by p.nome

--
select pp.nome, pp.Disponibile, pp.NumeroProdotti, pp.NumeroPezzi, isnull(count(u.idcliente), 0) as NumeroClienti 
from promozione_parziale pp left join Usufruisce u on (pp.nome = u.promo) 
group by pp.nome, pp.Disponibile, pp.NumeroProdotti, pp.NumeroPezzi