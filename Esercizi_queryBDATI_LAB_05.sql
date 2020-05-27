Use BDATI
--seleziono tutti gli studenti che si chiamano Rossi

Select *
From S
where Snome like '%Rossi'


--creare una tabella citta con SIGLA e NOME (SIGLA stesso attributo come in tabella studente e docente)


create table CITTA(
sigla char(2) PRIMARY KEY,
nome varchar(50) null)

--popolare la tabella con tutte le citta di docenti o studenti

INSERT INTO CITTA (sigla)


select citta from S where  Citta is not null
UNION
select citta from D where  Citta is not null

--inserire il vincolo che citta in S e citta in D 
--facciano riferimento alla tabella CITTA

ALTER TABLE S
ADD CONSTRAINT FK_citta FOREIGN KEY (citta) REFERENCES CITTA


ALTER TABLE D
ADD CONSTRAINT FK_citta_D FOREIGN KEY (citta) REFERENCES CITTA

-- aggiungere 1 a tutti gli anni di corso degli studenti
UPDATE S
SET Acorso=acorso+1



-- aggiungere il corso 'C5' 'Fisica Tecnica' tenuto 
-- dal docente di MO


insert into  C values('c5','Fisica Tecnica', 'D1')

--oppure, in maniera più corretta

insert into  C  
select 'c5','Fisica Tecnica', CD
from D
where citta='MO'


--aggiungere l'esame di M1 per il corso C5 tenutosi oggi 
--con voto 18

insert into E values('m1', 'c6', getdate(),18)


