--------------------VIEWS-----------------------------------------
------------------------------------------------------------------
----Porcentaje de las ventas hechas por personas con celulares inteligentes y sin celular inteligente-----
Create or replace view porcentajeConMAC as 
select (count("fkpersonamac")*100)/count(*) as conmac, 100- (count("fkpersonamac")*100)/count(*) as sinmac
from compra ;

select * from porcentajeConMAC;
------------------------------------------------------------------
----top 5 personas que más han estado en el centro comercial en el último mes
create or replace view masVisitas as
select count (e."macadd") as cantidad, s."nombre" 
from entradacc as e
inner join persona as s on s."macaddres"= e."macadd"
where s."nombre" is not null
group by s."nombre"
order by cantidad desc
limit 5;

select * from masVisitas

------------------------------------------------------------------
----top 3 tiendas con mayor cantdad de ventas
CREATE OR REPLACE VIEW toptiendas AS
SELECT count(c.id) AS ventas,s.nombre
FROM compra c
JOIN tienda s ON s.fkbeacon = c.fktienda
GROUP BY s.nombre
ORDER BY (count(c.id)) DESC
LIMIT 3;

select * from toptiendas;

------------------------------------------------------------------
----top 3 dias de mayor ventas

CREATE OR REPLACE VIEW mayordiaventas as
SELECT sum(s.total) AS ventas,
concat_ws('-'::text, date_part('day'::text, s.fecha), date_part('month'::text, s.fecha), date_part('year'::text, s.fecha)) AS fecha,
t.nombre
FROM compra s
JOIN tienda t ON s.fktienda = t.fkbeacon
GROUP BY s.fecha, t.nombre
ORDER BY ventas DESC
LIMIT 3;

select * from mayordiaventas;

------------------------------------------------------------------
----Top 10 de edades mas comunes en el centro comercial
CREATE OR REPLACE VIEW topedades as
SELECT count(e."edad") as cantidad , e."edad" FROM entradacc as e
where e."edad" is not null
group by e."edad"
order by cantidad desc
limit 10

select * from topedades;
------------------------------------------------------------------
----porcentaje de entrada por sexo
CREATE OR REPLACE VIEW porcentajeSexo as
select count(e."id")*100/(select count(*) from entradacc) as Cantidad, e."sexo" as Sexo
from entradacc as e
where e."sexo" is not null
group by e."sexo"

select * from porcentajeSexo;






