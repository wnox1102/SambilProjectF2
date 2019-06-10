--------------------TRIGGERS--------------------------------------
------------------------------------------------------------------
--Registro de persona cuando entra al centro comercial
CREATE OR REPLACE FUNCTION RegistroPersona()
RETURNS TRIGGER AS $$
declare
	n varchar(20);
BEGIN
		
		if new.macadd is not null then
			SELECT s."macadd" into n 
			from models_persona as s
			where s."macadd"=new.macadd;
			
			if n is null then
			INSERT INTO public.models_persona( macadd) VALUES (new.macadd);	
			end if;
			
		end if;
		return new;
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER RegistroPersonaT
BEFORE INSERT
ON models_entradacc
FOR EACH ROW
EXECUTE PROCEDURE RegistroPersona();



------------------------------------------------------------------
CREATE OR REPLACE FUNCTION CompraconMac()
RETURNS TRIGGER AS $$
declare
f int ;
BEGIN

	call macentrada(new.fkpersona_id,new.id);
	
	return null;
	
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER CompraconMacT
AFTER INSERT
ON models_compra
FOR EACH ROW
EXECUTE PROCEDURE CompraconMac();


------------------------------------------------------------------

CREATE OR REPLACE FUNCTION RegistroDatosPersona()
RETURNS TRIGGER AS $$
declare
n varchar(20);
BEGIN
	if new.fkpersona_id is not null then
	
		select p."cedula" into n
		from models_persona as p
		where p."cedula" = new.cedula;
		
		if n is null then
		
		call updatepersona(new.fkpersona_id,new.nombre,new.cedula,new.apellido);
		
		end if;	
	end if;
	return null;
	
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER RegistroDatosPersona
AFTER INSERT
ON models_compra
FOR EACH ROW
EXECUTE PROCEDURE RegistroDatosPersona();


------------------------------------------------------------------

CREATE OR REPLACE FUNCTION CompraRechazada()
RETURNS TRIGGER AS $$
declare
n timestamp;
s timestamp;
BEGIN

	select e."registroe" into n from models_entradacc as e
	inner join models_persona as p on p."macadd"=e."macadd"
	where p."cedula"=new.cedula
	order by e."registroe" desc
	limit 1;
	
	select e."registros" into s from models_salidacc as e
	inner join models_persona as p on p."macadd"=e."macadd"
	where p."cedula"=new.cedula and e."registros" > n
	order by e."registros" desc 
	limit 1;
	
	if s is null then
	return new;
	
	else 
	
	call ventarechazadap(new.nombre, new.apellido, new.cedula, new.total, new.fecha);
	
	return null;
	
	end if;
	
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER CompraRechazadaT
BEFORE INSERT
ON models_compra
FOR EACH ROW
EXECUTE PROCEDURE CompraRechazada();
