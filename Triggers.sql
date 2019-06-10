--------------------TRIGGERS--------------------------------------
------------------------------------------------------------------
--Registro de persona cuando entra al centro comercial
CREATE OR REPLACE FUNCTION RegistroPersona()
RETURNS TRIGGER AS $$
declare
	n varchar(20);
BEGIN
		
		if new.macadd is not null then
			SELECT s."macaddres" into n 
			from Persona as s
			where s."macaddres"=new.macadd;
			
			if n is null then
			INSERT INTO public.persona( macaddres) VALUES (new.macadd);	
			end if;
			
		end if;
		return new;
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER RegistroPersonaT
BEFORE INSERT
ON EntradaCC
FOR EACH ROW
EXECUTE PROCEDURE RegistroPersona();



------------------------------------------------------------------
CREATE OR REPLACE FUNCTION CompraconMac()
RETURNS TRIGGER AS $$
declare
f int ;
BEGIN

	call macentrada(new.fkpersonamac,new.id);
	
	return null;
	
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER CompraconMacT
AFTER INSERT
ON Compra
FOR EACH ROW
EXECUTE PROCEDURE CompraconMac();


------------------------------------------------------------------

CREATE OR REPLACE FUNCTION RegistroDatosPersona()
RETURNS TRIGGER AS $$
declare
n varchar(20);
BEGIN
	if new.fkpersonamac is not null then
	
		select p."cedula" into n
		from persona as p
		where new.fkpersonamac=p."macaddres";
		
		if n is null then
		
		call updatepersona(new.fkpersonamac,new.nombre,new.cedula,new.apellido);
		
		end if;	
	end if;
	return null;
	
END
$$ LANGUAGE plpgSQL;


CREATE TRIGGER RegistroDatosPersona
AFTER INSERT
ON Compra
FOR EACH ROW
EXECUTE PROCEDURE RegistroDatosPersona();


------------------------------------------------------------------

CREATE OR REPLACE FUNCTION CompraRechazada()
RETURNS TRIGGER AS $$
declare
n timestamp;
s timestamp;
BEGIN

	select e."registroe" into n from entradacc as e
	inner join persona as p on p."macaddres"=e."macadd"
	where p."cedula"=new.cedula
	order by e."registroe" desc
	limit 1;
	
	select e."registros" into s from salidacc as e
	inner join persona as p on p."macaddres"=e."macadd"
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
ON Compra
FOR EACH ROW
EXECUTE PROCEDURE CompraRechazada();







