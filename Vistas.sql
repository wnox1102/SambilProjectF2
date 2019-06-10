--------------------VIEWS-----------------------------------------
------------------------------------------------------------------
----Porcentaje de las ventas hechas por personas con celulares inteligentes y sin celular inteligente-----
Create or replace view porcentajeConMAC as 
select (count("fkpersona_id")*100)/count(*) as conmac, 100- (count("fkpersona_id")*100)/count(*) as sinmac
from models_compra ;

select * from porcentajeConMAC;


create or replace view masVisitas as
select count (e."macadd") as cantidad, s."nombre" 
from models_entradacc as e
inner join models_persona as s on s."macadd"= e."macadd"
where s."nombre" is not null
group by s."nombre"
order by cantidad desc
limit 5;

select * from masVisitas;


CREATE OR REPLACE VIEW toptiendas AS
SELECT count(c.id) AS ventas,s.nombre
FROM models_compra AS c
JOIN models_tienda AS s ON s.fkbeacon_id = c.fktienda_id
GROUP BY s.nombre
ORDER BY (count(c.id)) DESC
LIMIT 3;

select * from toptiendas;


CREATE OR REPLACE VIEW mayordiaventas as
SELECT sum(s.total) AS ventas,
concat_ws('-'::text, date_part('day'::text, s.fecha), date_part('month'::text, s.fecha), date_part('year'::text, s.fecha)) AS fecha,
t.nombre
FROM models_compra as s
JOIN models_tienda t ON s.fktienda_id = t.fkbeacon_id
GROUP BY s.fecha, t.nombre
ORDER BY ventas DESC
LIMIT 3;

select * from mayordiaventas;


CREATE OR REPLACE VIEW topedades as
SELECT count(e."edad") as cantidad , e."edad" FROM models_entradacc as e
where e."edad" is not null
group by e."edad"
order by cantidad desc
limit 10;

select * from topedades;


CREATE OR REPLACE VIEW porcentajeSexo as
select count(e."id")*100/(select count(*) from models_entradacc) as Cantidad, e."sexo" as Sexo
from models_entradacc as e
where e."sexo" is not null
group by e."sexo";

select * from porcentajeSexo;
