--------------------PROCEDURES------------------------------------
------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ventarechazadaP(n varchar(20), a varchar(20), c int , m real, f timestamp)
LANGUAGE plpgsql    
AS $$
BEGIN
    
 	INSERT INTO public.ventarechazadas(nombre, apellido, cedula, monto, fecha)
	VALUES (n, a, c, m, f);
    
END;
$$;
------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE updatePersona(mac varchar, n varchar, c int, a varchar)
LANGUAGE plpgsql    
AS $$
BEGIN
    
 		UPDATE public.persona 
		SET  nombre=n, cedula=c, apellido=a
		WHERE mac=persona."macaddres";
    
END;
$$;

------------------------------------------------------------------


CREATE OR REPLACE PROCEDURE MacEntrada(mac varchar, id int)
LANGUAGE plpgsql    
AS $$
declare
f int ;--cambiar a timestamp
BEGIN
    
 	if mac is not null then
	
	select e."id" into f from EntradaCC as e
	where  mac=e."macadd"
	ORDER BY e."registroe" DESC
	limit 1;
	
	INSERT INTO public.compraentrada( fkcompra, fkentrada) VALUES (id, f);
	
	end if;
    
END;
$$;

------------------------------------------------------------------






