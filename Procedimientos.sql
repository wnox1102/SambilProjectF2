--------------------PROCEDURES------------------------------------
------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ventarechazadaP(n varchar(20), a varchar(20), c int , m real, f timestamp)
LANGUAGE plpgsql    
AS $$
BEGIN
    
 	INSERT INTO public.models_ventarechazadas(nombre, apellido, cedula, total, fecha)
	VALUES (n, a, c, m, f);
    
END;
$$;
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE updatePersona(mac varchar, n varchar, c int, a varchar)
LANGUAGE plpgsql    
AS $$
BEGIN
    
 		UPDATE public.models_persona 
		SET  nombre=n, cedula=c, apellido=a
		WHERE mac=models_persona."macadd";
    
END;
$$;

------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE MacEntrada(mac varchar, id int)
LANGUAGE plpgsql    
AS $$
declare
f int ;
BEGIN
    
 	if mac is not null then
	
	select e."id" into f from models_entradacc as e
	where  mac=e."macadd"
	ORDER BY e."registroe" DESC
	limit 1;
	
	INSERT INTO public.models_compraentrada( fkcompra, fkentrada) VALUES (id, f);
	
	end if;
    
END;
$$;
