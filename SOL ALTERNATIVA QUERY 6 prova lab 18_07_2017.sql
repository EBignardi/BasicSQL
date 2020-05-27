
create View StatoAperto as
select s.email, s.idcamp from Stato s where s.stato = 'APERTO' 

create View CampagnaSuccessRate as
select  C.piva, C.body,C.idcamp, count(st.email)*100/count(*) as successrate
from Campagna C join ListaSpedizione ls on (C.idcamp=Ls.idcamp) left join StatoAperto St on ls.email=st.email and ls.idcamp=st.idcamp
group by C.piva, C.body, C.idcamp


--Selezionare la campagna con il più alto success rate 
SELECT top 1 *
FROM CampagnaSuccessRate
order by successrate DESC

--OPPURE

SELECT *
FROM CampagnaSuccessRate c
WHERE c.successrate >= all (SELECT successrate FROM CampagnaSuccessRate)

