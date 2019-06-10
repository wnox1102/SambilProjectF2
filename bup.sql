PGDMP         ;        
        w            Sambil    11.2    11.2 �    k           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            l           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            m           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            n           1262    19659    Sambil    DATABASE     �   CREATE DATABASE "Sambil" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE "Sambil";
             postgres    false            �            1255    20096    compraconmac()    FUNCTION     �   CREATE FUNCTION public.compraconmac() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
f int ;
BEGIN

	call macentrada(new.fkpersona_id,new.id);
	
	return null;
	
END
$$;
 %   DROP FUNCTION public.compraconmac();
       public       postgres    false                       1255    20122    comprarechazada()    FUNCTION       CREATE FUNCTION public.comprarechazada() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
	
	INSERT INTO public.models_ventarechazada(
	 fecha, total, cedula, nombre, apellido, fktienda_id)
	VALUES ( new.fecha, new.total, new.cedula, new.nombre, new.apellido, new.fktienda_id);
	
	return null;
	
	end if;
	
END
$$;
 (   DROP FUNCTION public.comprarechazada();
       public       postgres    false            �            1255    20093 &   macentrada(character varying, integer) 	   PROCEDURE     u  CREATE PROCEDURE public.macentrada(mac character varying, id integer)
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
 E   DROP PROCEDURE public.macentrada(mac character varying, id integer);
       public       postgres    false                       1255    20113    registrodatospersona()    FUNCTION     �  CREATE FUNCTION public.registrodatospersona() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
n varchar(20);
BEGIN
	if new.fkpersona_id is not null then
	
		select p."cedula" into n
		from models_persona as p
		where p."cedula" = new.cedula;
		
		if n is null then
		
		
		UPDATE public.models_persona 
		SET  nombre=new.nombre, cedula=new.cedula, apellido=new.apellido
		WHERE new.fkpersona_id=models_persona."macadd";
		
		end if;	
	end if;
	return null;
	
END
$$;
 -   DROP FUNCTION public.registrodatospersona();
       public       postgres    false            �            1255    20094    registropersona()    FUNCTION       CREATE FUNCTION public.registropersona() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 (   DROP FUNCTION public.registropersona();
       public       postgres    false            �            1255    20092 O   updatepersona(character varying, character varying, integer, character varying) 	   PROCEDURE       CREATE PROCEDURE public.updatepersona(mac character varying, n character varying, c integer, a character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    
 		UPDATE public.models_persona 
		SET  nombre=n, cedula=c, apellido=a
		WHERE mac=models_persona."macadd";
    
END;
$$;
 q   DROP PROCEDURE public.updatepersona(mac character varying, n character varying, c integer, a character varying);
       public       postgres    false            �            1259    19691 
   auth_group    TABLE     f   CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);
    DROP TABLE public.auth_group;
       public         postgres    false            �            1259    19689    auth_group_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.auth_group_id_seq;
       public       postgres    false    203            o           0    0    auth_group_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;
            public       postgres    false    202            �            1259    19701    auth_group_permissions    TABLE     �   CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);
 *   DROP TABLE public.auth_group_permissions;
       public         postgres    false            �            1259    19699    auth_group_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.auth_group_permissions_id_seq;
       public       postgres    false    205            p           0    0    auth_group_permissions_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;
            public       postgres    false    204            �            1259    19683    auth_permission    TABLE     �   CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);
 #   DROP TABLE public.auth_permission;
       public         postgres    false            �            1259    19681    auth_permission_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.auth_permission_id_seq;
       public       postgres    false    201            q           0    0    auth_permission_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;
            public       postgres    false    200            �            1259    19709 	   auth_user    TABLE     �  CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);
    DROP TABLE public.auth_user;
       public         postgres    false            �            1259    19719    auth_user_groups    TABLE        CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 $   DROP TABLE public.auth_user_groups;
       public         postgres    false            �            1259    19717    auth_user_groups_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.auth_user_groups_id_seq;
       public       postgres    false    209            r           0    0    auth_user_groups_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;
            public       postgres    false    208            �            1259    19707    auth_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.auth_user_id_seq;
       public       postgres    false    207            s           0    0    auth_user_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;
            public       postgres    false    206            �            1259    19727    auth_user_user_permissions    TABLE     �   CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);
 .   DROP TABLE public.auth_user_user_permissions;
       public         postgres    false            �            1259    19725 !   auth_user_user_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.auth_user_user_permissions_id_seq;
       public       postgres    false    211            t           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;
            public       postgres    false    210            �            1259    19787    django_admin_log    TABLE     �  CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);
 $   DROP TABLE public.django_admin_log;
       public         postgres    false            �            1259    19785    django_admin_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.django_admin_log_id_seq;
       public       postgres    false    213            u           0    0    django_admin_log_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;
            public       postgres    false    212            �            1259    19673    django_content_type    TABLE     �   CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);
 '   DROP TABLE public.django_content_type;
       public         postgres    false            �            1259    19671    django_content_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.django_content_type_id_seq;
       public       postgres    false    199            v           0    0    django_content_type_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;
            public       postgres    false    198            �            1259    19662    django_migrations    TABLE     �   CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);
 %   DROP TABLE public.django_migrations;
       public         postgres    false            �            1259    19660    django_migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.django_migrations_id_seq;
       public       postgres    false    197            w           0    0    django_migrations_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;
            public       postgres    false    196            �            1259    20079    django_session    TABLE     �   CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);
 "   DROP TABLE public.django_session;
       public         postgres    false            �            1259    19852    models_entradacc    TABLE     �   CREATE TABLE public.models_entradacc (
    id integer NOT NULL,
    sexo character varying(10) NOT NULL,
    edad integer NOT NULL,
    macadd character varying(20),
    registroe timestamp with time zone,
    fkcamara_id integer NOT NULL
);
 $   DROP TABLE public.models_entradacc;
       public         postgres    false            �            1259    19900    models_persona    TABLE     �   CREATE TABLE public.models_persona (
    id integer NOT NULL,
    nombre character varying(20),
    apellido character varying(20),
    cedula integer,
    macadd character varying(20) NOT NULL
);
 "   DROP TABLE public.models_persona;
       public         postgres    false            �            1259    20142 
   masvisitas    VIEW     #  CREATE VIEW public.masvisitas AS
 SELECT count(e.macadd) AS cantidad,
    s.nombre
   FROM (public.models_entradacc e
     JOIN public.models_persona s ON (((s.macadd)::text = (e.macadd)::text)))
  WHERE (s.nombre IS NOT NULL)
  GROUP BY s.nombre
  ORDER BY (count(e.macadd)) DESC
 LIMIT 5;
    DROP VIEW public.masvisitas;
       public       postgres    false    235    235    223            �            1259    19836    models_compra    TABLE     P  CREATE TABLE public.models_compra (
    id integer NOT NULL,
    fecha timestamp with time zone NOT NULL,
    total double precision NOT NULL,
    cedula integer NOT NULL,
    fkpersona_id character varying(20),
    fktienda_id integer NOT NULL,
    apellido character varying(30) NOT NULL,
    nombre character varying(30) NOT NULL
);
 !   DROP TABLE public.models_compra;
       public         postgres    false            �            1259    19868    models_tienda    TABLE       CREATE TABLE public.models_tienda (
    id integer NOT NULL,
    nombre character varying(20) NOT NULL,
    "dueño" character varying(20) NOT NULL,
    "horaA" time without time zone NOT NULL,
    "horaC" time without time zone NOT NULL,
    fkbeacon_id integer NOT NULL
);
 !   DROP TABLE public.models_tienda;
       public         postgres    false            �            1259    20150    mayordiaventas    VIEW     �  CREATE VIEW public.mayordiaventas AS
 SELECT sum(s.total) AS ventas,
    concat_ws('-'::text, date_part('day'::text, s.fecha), date_part('month'::text, s.fecha), date_part('year'::text, s.fecha)) AS fecha,
    t.nombre
   FROM (public.models_compra s
     JOIN public.models_tienda t ON ((s.fktienda_id = t.fkbeacon_id)))
  GROUP BY s.fecha, t.nombre
  ORDER BY (sum(s.total)) DESC
 LIMIT 3;
 !   DROP VIEW public.mayordiaventas;
       public       postgres    false    227    219    219    219    227            �            1259    19820    models_beacon    TABLE     j   CREATE TABLE public.models_beacon (
    id integer NOT NULL,
    modelo character varying(20) NOT NULL
);
 !   DROP TABLE public.models_beacon;
       public         postgres    false            �            1259    19818    models_beacon_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_beacon_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.models_beacon_id_seq;
       public       postgres    false    215            x           0    0    models_beacon_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.models_beacon_id_seq OWNED BY public.models_beacon.id;
            public       postgres    false    214            �            1259    19828    models_camara    TABLE     �   CREATE TABLE public.models_camara (
    id integer NOT NULL,
    modelo character varying(20) NOT NULL,
    fkentrada_id integer NOT NULL
);
 !   DROP TABLE public.models_camara;
       public         postgres    false            �            1259    19826    models_camara_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_camara_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.models_camara_id_seq;
       public       postgres    false    217            y           0    0    models_camara_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.models_camara_id_seq OWNED BY public.models_camara.id;
            public       postgres    false    216            �            1259    19834    models_compra_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.models_compra_id_seq;
       public       postgres    false    219            z           0    0    models_compra_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.models_compra_id_seq OWNED BY public.models_compra.id;
            public       postgres    false    218            �            1259    19910    models_compraentrada    TABLE     s   CREATE TABLE public.models_compraentrada (
    id integer NOT NULL,
    fkcompra integer,
    fkentrada integer
);
 (   DROP TABLE public.models_compraentrada;
       public         postgres    false            �            1259    19908    models_compraentrada_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_compraentrada_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.models_compraentrada_id_seq;
       public       postgres    false    237            {           0    0    models_compraentrada_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.models_compraentrada_id_seq OWNED BY public.models_compraentrada.id;
            public       postgres    false    236            �            1259    19844    models_entrada    TABLE     k   CREATE TABLE public.models_entrada (
    id integer NOT NULL,
    nombre character varying(30) NOT NULL
);
 "   DROP TABLE public.models_entrada;
       public         postgres    false            �            1259    19842    models_entrada_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_entrada_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.models_entrada_id_seq;
       public       postgres    false    221            |           0    0    models_entrada_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.models_entrada_id_seq OWNED BY public.models_entrada.id;
            public       postgres    false    220            �            1259    20040    models_entradacarro    TABLE     �   CREATE TABLE public.models_entradacarro (
    id integer NOT NULL,
    macadd character varying(20),
    placa character varying(7),
    registroe timestamp with time zone NOT NULL
);
 '   DROP TABLE public.models_entradacarro;
       public         postgres    false            �            1259    20038    models_entradacarro_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_entradacarro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.models_entradacarro_id_seq;
       public       postgres    false    239            }           0    0    models_entradacarro_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.models_entradacarro_id_seq OWNED BY public.models_entradacarro.id;
            public       postgres    false    238            �            1259    19850    models_entradap_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_entradap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.models_entradap_id_seq;
       public       postgres    false    223            ~           0    0    models_entradap_id_seq    SEQUENCE OWNED BY     R   ALTER SEQUENCE public.models_entradap_id_seq OWNED BY public.models_entradacc.id;
            public       postgres    false    222            �            1259    19860    models_mesa    TABLE     }   CREATE TABLE public.models_mesa (
    id integer NOT NULL,
    puestos integer NOT NULL,
    fkbeacon_id integer NOT NULL
);
    DROP TABLE public.models_mesa;
       public         postgres    false            �            1259    19858    models_mesa_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_mesa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.models_mesa_id_seq;
       public       postgres    false    225                       0    0    models_mesa_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.models_mesa_id_seq OWNED BY public.models_mesa.id;
            public       postgres    false    224            �            1259    19898    models_persona_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_persona_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.models_persona_id_seq;
       public       postgres    false    235            �           0    0    models_persona_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.models_persona_id_seq OWNED BY public.models_persona.id;
            public       postgres    false    234            �            1259    19892    models_registrom    TABLE     �   CREATE TABLE public.models_registrom (
    id integer NOT NULL,
    mac character varying(20),
    fecha timestamp with time zone NOT NULL,
    io boolean NOT NULL,
    fkmesa_id integer NOT NULL
);
 $   DROP TABLE public.models_registrom;
       public         postgres    false            �            1259    19890    models_registrom_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_registrom_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.models_registrom_id_seq;
       public       postgres    false    233            �           0    0    models_registrom_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.models_registrom_id_seq OWNED BY public.models_registrom.id;
            public       postgres    false    232            �            1259    19884    models_registrot    TABLE     �   CREATE TABLE public.models_registrot (
    id integer NOT NULL,
    mac character varying(20),
    fecha timestamp with time zone NOT NULL,
    io boolean NOT NULL,
    fkbeacon_id integer NOT NULL
);
 $   DROP TABLE public.models_registrot;
       public         postgres    false            �            1259    19882    models_registrot_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_registrot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.models_registrot_id_seq;
       public       postgres    false    231            �           0    0    models_registrot_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.models_registrot_id_seq OWNED BY public.models_registrot.id;
            public       postgres    false    230            �            1259    20048    models_salidacarro    TABLE     �   CREATE TABLE public.models_salidacarro (
    id integer NOT NULL,
    macadd character varying(20),
    placa character varying(7),
    registros timestamp with time zone NOT NULL
);
 &   DROP TABLE public.models_salidacarro;
       public         postgres    false            �            1259    20046    models_salidacarro_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_salidacarro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.models_salidacarro_id_seq;
       public       postgres    false    241            �           0    0    models_salidacarro_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.models_salidacarro_id_seq OWNED BY public.models_salidacarro.id;
            public       postgres    false    240            �            1259    19876    models_salidacc    TABLE     �   CREATE TABLE public.models_salidacc (
    id integer NOT NULL,
    registros timestamp with time zone NOT NULL,
    macadd character varying(20),
    fkcamara_id integer NOT NULL
);
 #   DROP TABLE public.models_salidacc;
       public         postgres    false            �            1259    19874    models_salidap_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_salidap_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.models_salidap_id_seq;
       public       postgres    false    229            �           0    0    models_salidap_id_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.models_salidap_id_seq OWNED BY public.models_salidacc.id;
            public       postgres    false    228            �            1259    19866    models_tienda_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_tienda_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.models_tienda_id_seq;
       public       postgres    false    227            �           0    0    models_tienda_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.models_tienda_id_seq OWNED BY public.models_tienda.id;
            public       postgres    false    226            �            1259    20067    models_ventarechazada    TABLE     0  CREATE TABLE public.models_ventarechazada (
    id integer NOT NULL,
    fecha timestamp with time zone NOT NULL,
    total double precision NOT NULL,
    cedula integer NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    fktienda_id integer NOT NULL
);
 )   DROP TABLE public.models_ventarechazada;
       public         postgres    false            �            1259    20065    models_ventarechazada_id_seq    SEQUENCE     �   CREATE SEQUENCE public.models_ventarechazada_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.models_ventarechazada_id_seq;
       public       postgres    false    243            �           0    0    models_ventarechazada_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.models_ventarechazada_id_seq OWNED BY public.models_ventarechazada.id;
            public       postgres    false    242            �            1259    20138    porcentajeconmac    VIEW     �   CREATE VIEW public.porcentajeconmac AS
 SELECT ((count(models_compra.fkpersona_id) * 100) / count(*)) AS conmac,
    (100 - ((count(models_compra.fkpersona_id) * 100) / count(*))) AS sinmac
   FROM public.models_compra;
 #   DROP VIEW public.porcentajeconmac;
       public       postgres    false    219            �            1259    20159    porcentajesexo    VIEW     �   CREATE VIEW public.porcentajesexo AS
 SELECT ((count(e.id) * 100) / ( SELECT count(*) AS count
           FROM public.models_entradacc)) AS cantidad,
    e.sexo
   FROM public.models_entradacc e
  WHERE (e.sexo IS NOT NULL)
  GROUP BY e.sexo;
 !   DROP VIEW public.porcentajesexo;
       public       postgres    false    223    223            �            1259    20155 	   topedades    VIEW     �   CREATE VIEW public.topedades AS
 SELECT count(e.edad) AS cantidad,
    e.edad
   FROM public.models_entradacc e
  WHERE (e.edad IS NOT NULL)
  GROUP BY e.edad
  ORDER BY (count(e.edad)) DESC
 LIMIT 10;
    DROP VIEW public.topedades;
       public       postgres    false    223            �            1259    20146 
   toptiendas    VIEW     �   CREATE VIEW public.toptiendas AS
 SELECT count(c.id) AS ventas,
    s.nombre
   FROM (public.models_compra c
     JOIN public.models_tienda s ON ((s.fkbeacon_id = c.fktienda_id)))
  GROUP BY s.nombre
  ORDER BY (count(c.id)) DESC
 LIMIT 3;
    DROP VIEW public.toptiendas;
       public       postgres    false    219    219    227    227            0           2604    19694    auth_group id    DEFAULT     n   ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);
 <   ALTER TABLE public.auth_group ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    202    203    203            1           2604    19704    auth_group_permissions id    DEFAULT     �   ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);
 H   ALTER TABLE public.auth_group_permissions ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    205    204    205            /           2604    19686    auth_permission id    DEFAULT     x   ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);
 A   ALTER TABLE public.auth_permission ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    200    201            2           2604    19712    auth_user id    DEFAULT     l   ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);
 ;   ALTER TABLE public.auth_user ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    206    207    207            3           2604    19722    auth_user_groups id    DEFAULT     z   ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);
 B   ALTER TABLE public.auth_user_groups ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    209    208    209            4           2604    19730    auth_user_user_permissions id    DEFAULT     �   ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);
 L   ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    210    211    211            5           2604    19790    django_admin_log id    DEFAULT     z   ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);
 B   ALTER TABLE public.django_admin_log ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    213    213            .           2604    19676    django_content_type id    DEFAULT     �   ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);
 E   ALTER TABLE public.django_content_type ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    199    199            -           2604    19665    django_migrations id    DEFAULT     |   ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);
 C   ALTER TABLE public.django_migrations ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    196    197    197            7           2604    19823    models_beacon id    DEFAULT     t   ALTER TABLE ONLY public.models_beacon ALTER COLUMN id SET DEFAULT nextval('public.models_beacon_id_seq'::regclass);
 ?   ALTER TABLE public.models_beacon ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    214    215    215            8           2604    19831    models_camara id    DEFAULT     t   ALTER TABLE ONLY public.models_camara ALTER COLUMN id SET DEFAULT nextval('public.models_camara_id_seq'::regclass);
 ?   ALTER TABLE public.models_camara ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    216    217    217            9           2604    19839    models_compra id    DEFAULT     t   ALTER TABLE ONLY public.models_compra ALTER COLUMN id SET DEFAULT nextval('public.models_compra_id_seq'::regclass);
 ?   ALTER TABLE public.models_compra ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    219    218    219            B           2604    19913    models_compraentrada id    DEFAULT     �   ALTER TABLE ONLY public.models_compraentrada ALTER COLUMN id SET DEFAULT nextval('public.models_compraentrada_id_seq'::regclass);
 F   ALTER TABLE public.models_compraentrada ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    236    237    237            :           2604    19847    models_entrada id    DEFAULT     v   ALTER TABLE ONLY public.models_entrada ALTER COLUMN id SET DEFAULT nextval('public.models_entrada_id_seq'::regclass);
 @   ALTER TABLE public.models_entrada ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    220    221            C           2604    20043    models_entradacarro id    DEFAULT     �   ALTER TABLE ONLY public.models_entradacarro ALTER COLUMN id SET DEFAULT nextval('public.models_entradacarro_id_seq'::regclass);
 E   ALTER TABLE public.models_entradacarro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    239    238    239            ;           2604    19855    models_entradacc id    DEFAULT     y   ALTER TABLE ONLY public.models_entradacc ALTER COLUMN id SET DEFAULT nextval('public.models_entradap_id_seq'::regclass);
 B   ALTER TABLE public.models_entradacc ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    223    223            <           2604    19863    models_mesa id    DEFAULT     p   ALTER TABLE ONLY public.models_mesa ALTER COLUMN id SET DEFAULT nextval('public.models_mesa_id_seq'::regclass);
 =   ALTER TABLE public.models_mesa ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    225    224    225            A           2604    19903    models_persona id    DEFAULT     v   ALTER TABLE ONLY public.models_persona ALTER COLUMN id SET DEFAULT nextval('public.models_persona_id_seq'::regclass);
 @   ALTER TABLE public.models_persona ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    234    235    235            @           2604    19895    models_registrom id    DEFAULT     z   ALTER TABLE ONLY public.models_registrom ALTER COLUMN id SET DEFAULT nextval('public.models_registrom_id_seq'::regclass);
 B   ALTER TABLE public.models_registrom ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    232    233    233            ?           2604    19887    models_registrot id    DEFAULT     z   ALTER TABLE ONLY public.models_registrot ALTER COLUMN id SET DEFAULT nextval('public.models_registrot_id_seq'::regclass);
 B   ALTER TABLE public.models_registrot ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    230    231    231            D           2604    20051    models_salidacarro id    DEFAULT     ~   ALTER TABLE ONLY public.models_salidacarro ALTER COLUMN id SET DEFAULT nextval('public.models_salidacarro_id_seq'::regclass);
 D   ALTER TABLE public.models_salidacarro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    241    240    241            >           2604    19879    models_salidacc id    DEFAULT     w   ALTER TABLE ONLY public.models_salidacc ALTER COLUMN id SET DEFAULT nextval('public.models_salidap_id_seq'::regclass);
 A   ALTER TABLE public.models_salidacc ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    228    229    229            =           2604    19871    models_tienda id    DEFAULT     t   ALTER TABLE ONLY public.models_tienda ALTER COLUMN id SET DEFAULT nextval('public.models_tienda_id_seq'::regclass);
 ?   ALTER TABLE public.models_tienda ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    227    226    227            E           2604    20070    models_ventarechazada id    DEFAULT     �   ALTER TABLE ONLY public.models_ventarechazada ALTER COLUMN id SET DEFAULT nextval('public.models_ventarechazada_id_seq'::regclass);
 G   ALTER TABLE public.models_ventarechazada ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    243    242    243            ?          0    19691 
   auth_group 
   TABLE DATA               .   COPY public.auth_group (id, name) FROM stdin;
    public       postgres    false    203   |>      A          0    19701    auth_group_permissions 
   TABLE DATA               M   COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
    public       postgres    false    205   �>      =          0    19683    auth_permission 
   TABLE DATA               N   COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
    public       postgres    false    201   �>      C          0    19709 	   auth_user 
   TABLE DATA               �   COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
    public       postgres    false    207   �A      E          0    19719    auth_user_groups 
   TABLE DATA               A   COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
    public       postgres    false    209   �B      G          0    19727    auth_user_user_permissions 
   TABLE DATA               P   COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
    public       postgres    false    211   �B      I          0    19787    django_admin_log 
   TABLE DATA               �   COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
    public       postgres    false    213   �B      ;          0    19673    django_content_type 
   TABLE DATA               C   COPY public.django_content_type (id, app_label, model) FROM stdin;
    public       postgres    false    199   �B      9          0    19662    django_migrations 
   TABLE DATA               C   COPY public.django_migrations (id, app, name, applied) FROM stdin;
    public       postgres    false    197   �C      h          0    20079    django_session 
   TABLE DATA               P   COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
    public       postgres    false    244   �F      K          0    19820    models_beacon 
   TABLE DATA               3   COPY public.models_beacon (id, modelo) FROM stdin;
    public       postgres    false    215   H      M          0    19828    models_camara 
   TABLE DATA               A   COPY public.models_camara (id, modelo, fkentrada_id) FROM stdin;
    public       postgres    false    217   SH      O          0    19836    models_compra 
   TABLE DATA               n   COPY public.models_compra (id, fecha, total, cedula, fkpersona_id, fktienda_id, apellido, nombre) FROM stdin;
    public       postgres    false    219   �H      a          0    19910    models_compraentrada 
   TABLE DATA               G   COPY public.models_compraentrada (id, fkcompra, fkentrada) FROM stdin;
    public       postgres    false    237   V�      Q          0    19844    models_entrada 
   TABLE DATA               4   COPY public.models_entrada (id, nombre) FROM stdin;
    public       postgres    false    221   ��      c          0    20040    models_entradacarro 
   TABLE DATA               K   COPY public.models_entradacarro (id, macadd, placa, registroe) FROM stdin;
    public       postgres    false    239   Λ      S          0    19852    models_entradacc 
   TABLE DATA               Z   COPY public.models_entradacc (id, sexo, edad, macadd, registroe, fkcamara_id) FROM stdin;
    public       postgres    false    223   ��      U          0    19860    models_mesa 
   TABLE DATA               ?   COPY public.models_mesa (id, puestos, fkbeacon_id) FROM stdin;
    public       postgres    false    225   �|      _          0    19900    models_persona 
   TABLE DATA               N   COPY public.models_persona (id, nombre, apellido, cedula, macadd) FROM stdin;
    public       postgres    false    235   �|      ]          0    19892    models_registrom 
   TABLE DATA               I   COPY public.models_registrom (id, mac, fecha, io, fkmesa_id) FROM stdin;
    public       postgres    false    233   �      [          0    19884    models_registrot 
   TABLE DATA               K   COPY public.models_registrot (id, mac, fecha, io, fkbeacon_id) FROM stdin;
    public       postgres    false    231   g      e          0    20048    models_salidacarro 
   TABLE DATA               J   COPY public.models_salidacarro (id, macadd, placa, registros) FROM stdin;
    public       postgres    false    241   j      Y          0    19876    models_salidacc 
   TABLE DATA               M   COPY public.models_salidacc (id, registros, macadd, fkcamara_id) FROM stdin;
    public       postgres    false    229   |�      W          0    19868    models_tienda 
   TABLE DATA               \   COPY public.models_tienda (id, nombre, "dueño", "horaA", "horaC", fkbeacon_id) FROM stdin;
    public       postgres    false    227   �/      g          0    20067    models_ventarechazada 
   TABLE DATA               h   COPY public.models_ventarechazada (id, fecha, total, cedula, nombre, apellido, fktienda_id) FROM stdin;
    public       postgres    false    243   $0      �           0    0    auth_group_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);
            public       postgres    false    202            �           0    0    auth_group_permissions_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);
            public       postgres    false    204            �           0    0    auth_permission_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.auth_permission_id_seq', 84, true);
            public       postgres    false    200            �           0    0    auth_user_groups_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);
            public       postgres    false    208            �           0    0    auth_user_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);
            public       postgres    false    206            �           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);
            public       postgres    false    210            �           0    0    django_admin_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);
            public       postgres    false    212            �           0    0    django_content_type_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.django_content_type_id_seq', 21, true);
            public       postgres    false    198            �           0    0    django_migrations_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.django_migrations_id_seq', 44, true);
            public       postgres    false    196            �           0    0    models_beacon_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.models_beacon_id_seq', 6, true);
            public       postgres    false    214            �           0    0    models_camara_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.models_camara_id_seq', 4, true);
            public       postgres    false    216            �           0    0    models_compra_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.models_compra_id_seq', 1875, true);
            public       postgres    false    218            �           0    0    models_compraentrada_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.models_compraentrada_id_seq', 946, true);
            public       postgres    false    236            �           0    0    models_entrada_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.models_entrada_id_seq', 4, true);
            public       postgres    false    220            �           0    0    models_entradacarro_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.models_entradacarro_id_seq', 1990, true);
            public       postgres    false    238            �           0    0    models_entradap_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.models_entradap_id_seq', 4874, true);
            public       postgres    false    222            �           0    0    models_mesa_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.models_mesa_id_seq', 3, true);
            public       postgres    false    224            �           0    0    models_persona_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.models_persona_id_seq', 3282, true);
            public       postgres    false    234            �           0    0    models_registrom_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.models_registrom_id_seq', 3669, true);
            public       postgres    false    232            �           0    0    models_registrot_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.models_registrot_id_seq', 3811, true);
            public       postgres    false    230            �           0    0    models_salidacarro_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.models_salidacarro_id_seq', 1888, true);
            public       postgres    false    240            �           0    0    models_salidap_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.models_salidap_id_seq', 4615, true);
            public       postgres    false    228            �           0    0    models_tienda_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.models_tienda_id_seq', 3, true);
            public       postgres    false    226            �           0    0    models_ventarechazada_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.models_ventarechazada_id_seq', 646, true);
            public       postgres    false    242            S           2606    19816    auth_group auth_group_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_name_key;
       public         postgres    false    203            X           2606    19753 R   auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);
 |   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
       public         postgres    false    205    205            [           2606    19706 2   auth_group_permissions auth_group_permissions_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_pkey;
       public         postgres    false    205            U           2606    19696    auth_group auth_group_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_pkey;
       public         postgres    false    203            N           2606    19739 F   auth_permission auth_permission_content_type_id_codename_01ab375a_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);
 p   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq;
       public         postgres    false    201    201            P           2606    19688 $   auth_permission auth_permission_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_pkey;
       public         postgres    false    201            c           2606    19724 &   auth_user_groups auth_user_groups_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_pkey;
       public         postgres    false    209            f           2606    19768 @   auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);
 j   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq;
       public         postgres    false    209    209            ]           2606    19714    auth_user auth_user_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_pkey;
       public         postgres    false    207            i           2606    19732 :   auth_user_user_permissions auth_user_user_permissions_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_pkey;
       public         postgres    false    211            l           2606    19782 Y   auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
       public         postgres    false    211    211            `           2606    19810     auth_user auth_user_username_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_username_key;
       public         postgres    false    207            o           2606    19796 &   django_admin_log django_admin_log_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_pkey;
       public         postgres    false    213            I           2606    19680 E   django_content_type django_content_type_app_label_model_76bd3d3b_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);
 o   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq;
       public         postgres    false    199    199            K           2606    19678 ,   django_content_type django_content_type_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_pkey;
       public         postgres    false    199            G           2606    19670 (   django_migrations django_migrations_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.django_migrations DROP CONSTRAINT django_migrations_pkey;
       public         postgres    false    197            �           2606    20086 "   django_session django_session_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);
 L   ALTER TABLE ONLY public.django_session DROP CONSTRAINT django_session_pkey;
       public         postgres    false    244            r           2606    19825     models_beacon models_beacon_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.models_beacon
    ADD CONSTRAINT models_beacon_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.models_beacon DROP CONSTRAINT models_beacon_pkey;
       public         postgres    false    215            u           2606    19833     models_camara models_camara_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.models_camara
    ADD CONSTRAINT models_camara_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.models_camara DROP CONSTRAINT models_camara_pkey;
       public         postgres    false    217            y           2606    19841     models_compra models_compra_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.models_compra
    ADD CONSTRAINT models_compra_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.models_compra DROP CONSTRAINT models_compra_pkey;
       public         postgres    false    219            �           2606    19915 .   models_compraentrada models_compraentrada_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.models_compraentrada
    ADD CONSTRAINT models_compraentrada_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.models_compraentrada DROP CONSTRAINT models_compraentrada_pkey;
       public         postgres    false    237            {           2606    19849 "   models_entrada models_entrada_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.models_entrada
    ADD CONSTRAINT models_entrada_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.models_entrada DROP CONSTRAINT models_entrada_pkey;
       public         postgres    false    221            �           2606    20045 ,   models_entradacarro models_entradacarro_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.models_entradacarro
    ADD CONSTRAINT models_entradacarro_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.models_entradacarro DROP CONSTRAINT models_entradacarro_pkey;
       public         postgres    false    239            ~           2606    19857 %   models_entradacc models_entradap_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.models_entradacc
    ADD CONSTRAINT models_entradap_pkey PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.models_entradacc DROP CONSTRAINT models_entradap_pkey;
       public         postgres    false    223            �           2606    19865    models_mesa models_mesa_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.models_mesa
    ADD CONSTRAINT models_mesa_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.models_mesa DROP CONSTRAINT models_mesa_pkey;
       public         postgres    false    225            �           2606    19907 (   models_persona models_persona_cedula_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.models_persona
    ADD CONSTRAINT models_persona_cedula_key UNIQUE (cedula);
 R   ALTER TABLE ONLY public.models_persona DROP CONSTRAINT models_persona_cedula_key;
       public         postgres    false    235            �           2606    20004 2   models_persona models_persona_macadd_ade0e7c7_uniq 
   CONSTRAINT     o   ALTER TABLE ONLY public.models_persona
    ADD CONSTRAINT models_persona_macadd_ade0e7c7_uniq UNIQUE (macadd);
 \   ALTER TABLE ONLY public.models_persona DROP CONSTRAINT models_persona_macadd_ade0e7c7_uniq;
       public         postgres    false    235            �           2606    19905 "   models_persona models_persona_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.models_persona
    ADD CONSTRAINT models_persona_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.models_persona DROP CONSTRAINT models_persona_pkey;
       public         postgres    false    235            �           2606    19897 &   models_registrom models_registrom_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.models_registrom
    ADD CONSTRAINT models_registrom_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.models_registrom DROP CONSTRAINT models_registrom_pkey;
       public         postgres    false    233            �           2606    19889 &   models_registrot models_registrot_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.models_registrot
    ADD CONSTRAINT models_registrot_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.models_registrot DROP CONSTRAINT models_registrot_pkey;
       public         postgres    false    231            �           2606    20053 *   models_salidacarro models_salidacarro_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.models_salidacarro
    ADD CONSTRAINT models_salidacarro_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.models_salidacarro DROP CONSTRAINT models_salidacarro_pkey;
       public         postgres    false    241            �           2606    19881 #   models_salidacc models_salidap_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.models_salidacc
    ADD CONSTRAINT models_salidap_pkey PRIMARY KEY (id);
 M   ALTER TABLE ONLY public.models_salidacc DROP CONSTRAINT models_salidap_pkey;
       public         postgres    false    229            �           2606    19873     models_tienda models_tienda_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.models_tienda
    ADD CONSTRAINT models_tienda_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.models_tienda DROP CONSTRAINT models_tienda_pkey;
       public         postgres    false    227            �           2606    20072 0   models_ventarechazada models_ventarechazada_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.models_ventarechazada
    ADD CONSTRAINT models_ventarechazada_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.models_ventarechazada DROP CONSTRAINT models_ventarechazada_pkey;
       public         postgres    false    243            Q           1259    19817    auth_group_name_a6ea08ec_like    INDEX     h   CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);
 1   DROP INDEX public.auth_group_name_a6ea08ec_like;
       public         postgres    false    203            V           1259    19754 (   auth_group_permissions_group_id_b120cbf9    INDEX     o   CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);
 <   DROP INDEX public.auth_group_permissions_group_id_b120cbf9;
       public         postgres    false    205            Y           1259    19755 -   auth_group_permissions_permission_id_84c5c92e    INDEX     y   CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);
 A   DROP INDEX public.auth_group_permissions_permission_id_84c5c92e;
       public         postgres    false    205            L           1259    19740 (   auth_permission_content_type_id_2f476e4b    INDEX     o   CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);
 <   DROP INDEX public.auth_permission_content_type_id_2f476e4b;
       public         postgres    false    201            a           1259    19770 "   auth_user_groups_group_id_97559544    INDEX     c   CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);
 6   DROP INDEX public.auth_user_groups_group_id_97559544;
       public         postgres    false    209            d           1259    19769 !   auth_user_groups_user_id_6a12ed8b    INDEX     a   CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);
 5   DROP INDEX public.auth_user_groups_user_id_6a12ed8b;
       public         postgres    false    209            g           1259    19784 1   auth_user_user_permissions_permission_id_1fbb5f2c    INDEX     �   CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);
 E   DROP INDEX public.auth_user_user_permissions_permission_id_1fbb5f2c;
       public         postgres    false    211            j           1259    19783 +   auth_user_user_permissions_user_id_a95ead1b    INDEX     u   CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);
 ?   DROP INDEX public.auth_user_user_permissions_user_id_a95ead1b;
       public         postgres    false    211            ^           1259    19811     auth_user_username_6821ab7c_like    INDEX     n   CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);
 4   DROP INDEX public.auth_user_username_6821ab7c_like;
       public         postgres    false    207            m           1259    19807 )   django_admin_log_content_type_id_c4bce8eb    INDEX     q   CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);
 =   DROP INDEX public.django_admin_log_content_type_id_c4bce8eb;
       public         postgres    false    213            p           1259    19808 !   django_admin_log_user_id_c564eba6    INDEX     a   CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);
 5   DROP INDEX public.django_admin_log_user_id_c564eba6;
       public         postgres    false    213            �           1259    20088 #   django_session_expire_date_a5c62663    INDEX     e   CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);
 7   DROP INDEX public.django_session_expire_date_a5c62663;
       public         postgres    false    244            �           1259    20087 (   django_session_session_key_c0390e0f_like    INDEX     ~   CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);
 <   DROP INDEX public.django_session_session_key_c0390e0f_like;
       public         postgres    false    244            s           1259    19976 #   models_camara_fkentrada_id_39cb2238    INDEX     e   CREATE INDEX models_camara_fkentrada_id_39cb2238 ON public.models_camara USING btree (fkentrada_id);
 7   DROP INDEX public.models_camara_fkentrada_id_39cb2238;
       public         postgres    false    217            v           1259    20006 #   models_compra_fkpersona_id_84050817    INDEX     e   CREATE INDEX models_compra_fkpersona_id_84050817 ON public.models_compra USING btree (fkpersona_id);
 7   DROP INDEX public.models_compra_fkpersona_id_84050817;
       public         postgres    false    219            w           1259    19970 "   models_compra_fktienda_id_b31bf635    INDEX     c   CREATE INDEX models_compra_fktienda_id_b31bf635 ON public.models_compra USING btree (fktienda_id);
 6   DROP INDEX public.models_compra_fktienda_id_b31bf635;
       public         postgres    false    219            |           1259    19921 $   models_entradap_fkcamara_id_b4ec1a98    INDEX     h   CREATE INDEX models_entradap_fkcamara_id_b4ec1a98 ON public.models_entradacc USING btree (fkcamara_id);
 8   DROP INDEX public.models_entradap_fkcamara_id_b4ec1a98;
       public         postgres    false    223                       1259    19927     models_mesa_fkbeacon_id_1f8e283d    INDEX     _   CREATE INDEX models_mesa_fkbeacon_id_1f8e283d ON public.models_mesa USING btree (fkbeacon_id);
 4   DROP INDEX public.models_mesa_fkbeacon_id_1f8e283d;
       public         postgres    false    225            �           1259    20005 #   models_persona_macadd_ade0e7c7_like    INDEX     t   CREATE INDEX models_persona_macadd_ade0e7c7_like ON public.models_persona USING btree (macadd varchar_pattern_ops);
 7   DROP INDEX public.models_persona_macadd_ade0e7c7_like;
       public         postgres    false    235            �           1259    19951 #   models_registrom_fkmesa_id_48de68d1    INDEX     e   CREATE INDEX models_registrom_fkmesa_id_48de68d1 ON public.models_registrom USING btree (fkmesa_id);
 7   DROP INDEX public.models_registrom_fkmesa_id_48de68d1;
       public         postgres    false    233            �           1259    19945 %   models_registrot_fkbeacon_id_bd996ac8    INDEX     i   CREATE INDEX models_registrot_fkbeacon_id_bd996ac8 ON public.models_registrot USING btree (fkbeacon_id);
 9   DROP INDEX public.models_registrot_fkbeacon_id_bd996ac8;
       public         postgres    false    231            �           1259    19939 #   models_salidap_fkcamara_id_a2730edd    INDEX     f   CREATE INDEX models_salidap_fkcamara_id_a2730edd ON public.models_salidacc USING btree (fkcamara_id);
 7   DROP INDEX public.models_salidap_fkcamara_id_a2730edd;
       public         postgres    false    229            �           1259    19933 "   models_tienda_fkbeacon_id_e21736d7    INDEX     c   CREATE INDEX models_tienda_fkbeacon_id_e21736d7 ON public.models_tienda USING btree (fkbeacon_id);
 6   DROP INDEX public.models_tienda_fkbeacon_id_e21736d7;
       public         postgres    false    227            �           1259    20078 *   models_ventarechazada_fktienda_id_bce9c595    INDEX     s   CREATE INDEX models_ventarechazada_fktienda_id_bce9c595 ON public.models_ventarechazada USING btree (fktienda_id);
 >   DROP INDEX public.models_ventarechazada_fktienda_id_bce9c595;
       public         postgres    false    243            �           2620    20097    models_compra compraconmact    TRIGGER     x   CREATE TRIGGER compraconmact AFTER INSERT ON public.models_compra FOR EACH ROW EXECUTE PROCEDURE public.compraconmac();
 4   DROP TRIGGER compraconmact ON public.models_compra;
       public       postgres    false    253    219            �           2620    20123    models_compra comprarechazadat    TRIGGER        CREATE TRIGGER comprarechazadat BEFORE INSERT ON public.models_compra FOR EACH ROW EXECUTE PROCEDURE public.comprarechazada();
 7   DROP TRIGGER comprarechazadat ON public.models_compra;
       public       postgres    false    268    219            �           2620    20114 "   models_compra registrodatospersona    TRIGGER     �   CREATE TRIGGER registrodatospersona AFTER INSERT ON public.models_compra FOR EACH ROW EXECUTE PROCEDURE public.registrodatospersona();
 ;   DROP TRIGGER registrodatospersona ON public.models_compra;
       public       postgres    false    267    219            �           2620    20095 !   models_entradacc registropersonat    TRIGGER     �   CREATE TRIGGER registropersonat BEFORE INSERT ON public.models_entradacc FOR EACH ROW EXECUTE PROCEDURE public.registropersona();
 :   DROP TRIGGER registropersonat ON public.models_entradacc;
       public       postgres    false    252    223            �           2606    19747 O   auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 y   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
       public       postgres    false    205    201    2896            �           2606    19742 P   auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 z   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
       public       postgres    false    2901    205    203            �           2606    19733 E   auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 o   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co;
       public       postgres    false    201    199    2891            �           2606    19762 D   auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 n   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id;
       public       postgres    false    209    2901    203            �           2606    19757 B   auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
       public       postgres    false    209    2909    207            �           2606    19776 S   auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 }   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
       public       postgres    false    211    2896    201            �           2606    19771 V   auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
       public       postgres    false    2909    207    211            �           2606    19797 G   django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 q   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co;
       public       postgres    false    2891    213    199            �           2606    19802 B   django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id;
       public       postgres    false    213    207    2909            �           2606    19977 F   models_camara models_camara_fkentrada_id_39cb2238_fk_models_entrada_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_camara
    ADD CONSTRAINT models_camara_fkentrada_id_39cb2238_fk_models_entrada_id FOREIGN KEY (fkentrada_id) REFERENCES public.models_entrada(id) DEFERRABLE INITIALLY DEFERRED;
 p   ALTER TABLE ONLY public.models_camara DROP CONSTRAINT models_camara_fkentrada_id_39cb2238_fk_models_entrada_id;
       public       postgres    false    2939    221    217            �           2606    20033 J   models_compra models_compra_fkpersona_id_84050817_fk_models_persona_macadd    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_compra
    ADD CONSTRAINT models_compra_fkpersona_id_84050817_fk_models_persona_macadd FOREIGN KEY (fkpersona_id) REFERENCES public.models_persona(macadd) DEFERRABLE INITIALLY DEFERRED;
 t   ALTER TABLE ONLY public.models_compra DROP CONSTRAINT models_compra_fkpersona_id_84050817_fk_models_persona_macadd;
       public       postgres    false    2962    219    235            �           2606    19971 D   models_compra models_compra_fktienda_id_b31bf635_fk_models_tienda_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_compra
    ADD CONSTRAINT models_compra_fktienda_id_b31bf635_fk_models_tienda_id FOREIGN KEY (fktienda_id) REFERENCES public.models_tienda(id) DEFERRABLE INITIALLY DEFERRED;
 n   ALTER TABLE ONLY public.models_compra DROP CONSTRAINT models_compra_fktienda_id_b31bf635_fk_models_tienda_id;
       public       postgres    false    227    219    2948            �           2606    19916 I   models_entradacc models_entradap_fkcamara_id_b4ec1a98_fk_models_camara_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_entradacc
    ADD CONSTRAINT models_entradap_fkcamara_id_b4ec1a98_fk_models_camara_id FOREIGN KEY (fkcamara_id) REFERENCES public.models_camara(id) DEFERRABLE INITIALLY DEFERRED;
 s   ALTER TABLE ONLY public.models_entradacc DROP CONSTRAINT models_entradap_fkcamara_id_b4ec1a98_fk_models_camara_id;
       public       postgres    false    217    223    2933            �           2606    19922 @   models_mesa models_mesa_fkbeacon_id_1f8e283d_fk_models_beacon_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_mesa
    ADD CONSTRAINT models_mesa_fkbeacon_id_1f8e283d_fk_models_beacon_id FOREIGN KEY (fkbeacon_id) REFERENCES public.models_beacon(id) DEFERRABLE INITIALLY DEFERRED;
 j   ALTER TABLE ONLY public.models_mesa DROP CONSTRAINT models_mesa_fkbeacon_id_1f8e283d_fk_models_beacon_id;
       public       postgres    false    215    2930    225            �           2606    20018 H   models_registrom models_registrom_fkmesa_id_48de68d1_fk_models_beacon_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_registrom
    ADD CONSTRAINT models_registrom_fkmesa_id_48de68d1_fk_models_beacon_id FOREIGN KEY (fkmesa_id) REFERENCES public.models_beacon(id) DEFERRABLE INITIALLY DEFERRED;
 r   ALTER TABLE ONLY public.models_registrom DROP CONSTRAINT models_registrom_fkmesa_id_48de68d1_fk_models_beacon_id;
       public       postgres    false    215    2930    233            �           2606    19940 J   models_registrot models_registrot_fkbeacon_id_bd996ac8_fk_models_beacon_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_registrot
    ADD CONSTRAINT models_registrot_fkbeacon_id_bd996ac8_fk_models_beacon_id FOREIGN KEY (fkbeacon_id) REFERENCES public.models_beacon(id) DEFERRABLE INITIALLY DEFERRED;
 t   ALTER TABLE ONLY public.models_registrot DROP CONSTRAINT models_registrot_fkbeacon_id_bd996ac8_fk_models_beacon_id;
       public       postgres    false    231    2930    215            �           2606    19934 G   models_salidacc models_salidap_fkcamara_id_a2730edd_fk_models_camara_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_salidacc
    ADD CONSTRAINT models_salidap_fkcamara_id_a2730edd_fk_models_camara_id FOREIGN KEY (fkcamara_id) REFERENCES public.models_camara(id) DEFERRABLE INITIALLY DEFERRED;
 q   ALTER TABLE ONLY public.models_salidacc DROP CONSTRAINT models_salidap_fkcamara_id_a2730edd_fk_models_camara_id;
       public       postgres    false    2933    229    217            �           2606    19928 D   models_tienda models_tienda_fkbeacon_id_e21736d7_fk_models_beacon_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_tienda
    ADD CONSTRAINT models_tienda_fkbeacon_id_e21736d7_fk_models_beacon_id FOREIGN KEY (fkbeacon_id) REFERENCES public.models_beacon(id) DEFERRABLE INITIALLY DEFERRED;
 n   ALTER TABLE ONLY public.models_tienda DROP CONSTRAINT models_tienda_fkbeacon_id_e21736d7_fk_models_beacon_id;
       public       postgres    false    227    215    2930            �           2606    20073 T   models_ventarechazada models_ventarechazada_fktienda_id_bce9c595_fk_models_tienda_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.models_ventarechazada
    ADD CONSTRAINT models_ventarechazada_fktienda_id_bce9c595_fk_models_tienda_id FOREIGN KEY (fktienda_id) REFERENCES public.models_tienda(id) DEFERRABLE INITIALLY DEFERRED;
 ~   ALTER TABLE ONLY public.models_ventarechazada DROP CONSTRAINT models_ventarechazada_fktienda_id_bce9c595_fk_models_tienda_id;
       public       postgres    false    243    227    2948            ?      x������ � �      A      x������ � �      =      x�m�[�� ��aYAߝ�n�R�:(�tbG�ϩ���3�7�ȟ��P���r���������������O?����O��)
�� xw�� N%�����(,L$��fo�����\S�Z����S �	v�~�%A��IQ��(�[�|l���4 ϶�J9^'/B*���R'����h�ʹ m����*��N�� z9}z7-ëqq�o�����r�};ӁM�[�R$�IH�7���'���43t[E���_�A�F�VyOyFL�=a�1���UDR��ɻ��p`k�H�C*�"�D�#*�4��k�&3⿄�mT�#�?� ���_#Hd:"��hD�^o�~�T��mZ("b��t���A���!�B�@Jy�K�}2�\�F�[@�9�j��s�H��@*2)�/��u���ٶ*��L2H��2AH���:�jJ��tK��ƌ#۪�&��R�My0%B�pa"�vs��~l��0vb�9l�ҫI�J���O�"�M6gӗ�Ze��][423�pW483�p_0T�z0��_v���]���C۩�(ݻȩ�.ݹ��"�����*�
�|��=�!��s���]Ģ��5d�j��ͻ�,�$tyW�̳��X���}����K��B!X�� ��&C��3L�k�>��ὀ��R_�U'K�|uFT�+���漗Ӷ�����svh�;�|��X���K��Œ���\�6��� �W�͈���fZo6�J��zˡ`��w�q�����?i�]�;����J��8kGu&5�	y�:��2���L��B|NV�㛵�?�_      C   �   x�3�,H�NI3�/�H425S145 K�,��p�Ԫ�L�,���<�������l�������
�Ts?s�Ƞ�
}�\�m�0O[N#CK]3]CC+S+#K=c3CKcc]�Μ���\N (Bņ&zF�F�&@�\1z\\\ D~(�      E      x������ � �      G      x������ � �      I      x������ � �      ;   �   x�]���0F�ׇ1��w��������!Q�vξ�_��>�hF(&Y�28���H�W���� <O�l0+	��qLy,-�/��(}��<�j�4�y�(�
;(�����\�Z�ll1�4cU0y��]���5	'����mq�J�'/�����C����G���C��|Hnv���(��^��O �Q���      9   0  x����n�0���)�y���YV�,��H	a�P���;�ipkW��w2>s<��yi���~i�|w�.�;���~�K�3�g��4�H�W�q���c�:D�+!w�8t�G�j�B���;��O\���v_[��}8+�c�6��5�]�9K7���>���e��@U�i䪥����^��0�U) -Ut�l����N��NC7�kI+�����|�jR�Bcl�ݤ�M�:�G;���"Ac,�m**WY?b9�e�ۃJk���iP�чyY��xe׾�tV!�El����ݿ�n�썾�մ���Z�N�=��V�k�cX�i��o�i����s8}�x�@.�Lnr�����RD:*�M��H�,��1�)7��4^/?�qH�)����^ء�_���=d�%4�����N�D�H�� L�y%��_�lT��Α��w/��;aȩ8�Dƫ��D��`�$2�J���kI*֏���]�7� �?M`���e�~��K���h[ҦN;�l��2�<պg-4$\��5��qU�ߦ1t
f���~塾xc�lL=f�"|J��7��f�"|�۫�Eq��,|P����
H%>�#!�<����E�H����R����E���Yc��Y����P���Rz���E��GKw�O!�Y���A}�9aI$���a?���P.-?��_�I�1�I~��T�^Q���N�Ԅ,��9�������J.�,������ېp��*!��e��=����:k��,Xe��t<?T�A�h�.�]e�O�q��\�ynml�R����m�,��Ѱ��~���$Ӥ      h     x�=��n�0 F��)��RA�ɮDH�-�(��n(���E��~n�;'���|�ݷzTU[�Mol[=>����/��Z����ît�$.OK��ˈib�scq�M��'��r��x$�E6R+�l]΂emEO:���Q3��M�چ[�HsJn��2W-�AI�<��<d_LE_���ڇ�^=�D���C�8�[�N����?/����J���w3|~�A3?[�Ǣ�%$4�p�)�N�K�iaə�<���- �%�,a��]�`�Zo�(X/A཯<��r�iK      K   /   x�3�,,O-*��5�2�1���aLc.ӄ��4�2�1͸b���� ��      M   ,   x�3�L,NI�5�4�2�0�8���!LcNc.ӄӄ+F��� H
�      O      x���[�ǭ%�����<�V�=�橮�DQ�'���ߚ���dw��]<u����7���D$�F3��-_���l ��ƶ����7��y���Ykژ��[ߘ��\j��1٧�KS�<�y��2w���4��o�����5��J	#	en��Pܬ�C	J�u�f9��:�]�g3�"�x��y���O�WH�C	�΍�`[?�n(!56�?����\���������т~n���0˩��M����6%��r�U��8_,�����K׼������HB���&7�v��Ml���-��?���6�y{z=_�,�5��{����3��95�;�p⒮������|�������riΣ.�c+a��fb	)�f�Η��`��/�<�ܾ�>}�^Οv�C�G��(�(1N�up3��r2/ v���2��r���,��c8�N��ė���ÅR�H
�y��H;k�p�Mc�M6b[q��nn=�B&�����pƽٟ/���"�HD��VH����ce�M4>���l=�,y��_������;=6�S(��j��PL�8ڬ��j�K� 9���ww�k���|�A-��E4�ޘ��:!b�<����ޘ��N�w.�6�~�\8��"Q�l$��۟���;������vf�?����*���η�|��p��C��,O�G����F��gũ��'����~s�=ܽ6�:�>r��ԗݚY]vli���� ~����;7����q{M�ִ�G�k��k��B۬6s����s��<_,��\z�7���ˑW�-B�r��j+��]ici�t�<B�{�xCؖ�w/�����Q�U"���Xf�nL�A�좏��.�x�K|�v^Vs(a��r<��{����q=u�ՍqZNuP�ۈ��K�ÏXϓ��8_B����8�ޟ�v/��'����Τ�x}�·%%wfy��>������e�^�z�i�ŭ�8�f��'(��<��z5�n���<�_��{���V�и3;R���&&J1����/��^�Y!�g�j#z{��G*׌ߧ�5Kγ0��<~�~�k�^�ܬ�+;��9������c�,^�-{\9Ӣ��O1�K)�_�|Y�K�����ޯ�N������=հm��J�D�k9�,�@bv�g�񬡻�<m����~?�3�����D��2�W�2��x�q��ghʡ+`�ݼ��[�����{i��}cn�Q颔g~�Q���� ,�/l��`��xw���e�5�����YX�EL ��;��`���6D�A#��Vת�(<T��O��rQ;7?u��ڱyw�Җ��C��Fo�̎^3h,����7 �G���g�6.�F���	�6�����Cnܖ���
[���#,������X��j}[4���.U[� ��=����׀��3p7ϻ�W��þ{��)J��|��wB�5λд�y���G�bl��@�E.����ڑ�8o�25vfF8-�?�3��(!��� �ܡE�o�<C�v/����'(���J���d��h��`�3{;�5�Sa���Y|�p�N�?�<�g�p#��T�?3C��a�]�@xk���A��ZR��x�t<fy|�n��`õ����'L~�Ps��F��f(�e������xy�����
J��ǝ��k�+�`����ޮ���q��t���ڼ���FW�֏����th a�v5�xG+��o��X:����O�}݋����Ǚ~6
�	n�r��]�Z��y{�w��S��"W�'%"�;K�����>Y\��vĐIB���$�\1?�"������2�Rpa�4l�4;_�y�\�0�/{^���랏/ڡ 3�#�3;�؅[e4v;� ����b���k�z<�}y8������w�^���#q8\�Q؇U����e>�; 7K�����y�#)�H]9Np�FȞ=@�7�E5"�S^�q��O�g�o�a���FB���C
�������:x%��@�i����M}�a�~���u3[Ɨ��d'6)*	U */0⤩�q�����q������p��}�?!��ڮV**4�8�2���e��v/��	(�PCq����'�;�	e(��	�����3�p�5��8\����5���a����as������#8 疘ؤp��㲟�N���7h�}�D��6��;Sff���EW\]�N��0�a�9���{�7��^~?�=��^-i��㺸Bp6G���[�!~I��"�����Fy��S%�?-$i��*���/���� �x?K#_�agxm���|c�q	�w��ĝ�'s.���
���M�⃃^�ɀ���_�bb�Vؤ]O�'������DyƢ���mc�`a�#��y+ ���@M�$�����=����u��2�ۣ}�+�)��+
�@'���j�D���i3�=4�_��w����Χ�Q��xx;�MYЗ�Fz��e;��=ߝ��s�f��L)QI��m�K�%�����-:0ŐKNΥ�6��ڝ��|U���v�\|?aFl��t7=�y9���*K> %��q�l-EE��,_kJ-��~0��8�-�,?��{o��Z,g%�
��i`�p��e���zK@e�4"�G��:��y�|O!�Q��*r`r�s��=`����q�W��,2��B�?w�����m"(~��l��ȏ�ֻ{����;]������qK�
Z��ztr������-���z��6�u ���)V��#e�2�S�)f������@IvC=��?x��>$:L���"�ҙi <����N@����0J�����=�p^~��QP��"TL��Kx�f:�p_<�w�m>~��sm���z�e���T��s#9:��l%�[�E��^�@̷���f�{�wP��b�jp@��nʋy��|
K<;Sc���k����ӶJH�����q�#~�Ă��{� ���ԴV��/<`��`MdL�	�E�^
�����9)j3�z�|u-���p�e �+ǟ������e���ZO����P�6[�������������p|�U6�d���o��3�HI��ۥ��^m��8����x<�qӖ�#o�&C�8�`g�*i�m�Q�Ͳ�v�X:���L�[$�s�5?u����݁B�HH�By>���']`����A���m&b�f�	��	��������zxe��������A���VH�A�����@�#�X��*��U�P����։�Xh�fE��|9�.���;����;�\z������<�ł����&Q���@���|�ۿ�	'��J���<�lԉ�?W|�����w�ѝ/VO� �@c��`�'�0k�Y:�R��<y*�Cwi�i*L�ͫ%J�COQFT24(��rZ~�����o�����(d ��'��(oh/x��"��$q��X�y�_)��[�prVh��� �cÚ����fn$��XV�¸V��㮞��޷=�`6� yj���/L7�=�@�G�g]!�<�����Mǌ��m%��A��Ѧ~��E�kZ���7�����㤇���Y�.O�WtjE��jW�:1�?Zd�1�p*%����� �wĆG):%�b��G�C6�@��l�y��S[D,������\�zb��#�"A�/SB���&e:�b��
�J�e�;��N�݋X��ՖOdJ����*'m�� Q-��]��P��'w��R�Y��>J��#Ҳ�Q|�4�ݠn$e���8L���{��E�"{��hQW+z���4܀�M����E�%���8wם/p|�'��ޏ$�
�[S2���RC�p����kC�Jvq��u�����Gr���$���X}C�!C7~ŐdL�Պ���曎.��������'��HD�l-�9W�f�x�B��@�����`l��'�WO;`�}��i�p����������-���m�N�zf��J~��ˀ?������� �=���Id���sw:B�0D��2bi�7�j���K���1�Ȥ�?������(7�b�3�n� =9ҳk��Z{��9�����}nV��τ���H����    U�;D�+���?��^��z�4�_�z�E�%�opE�5 c� S���y�&#�l'f�kF�f���%M����B�z��%_ �2��H�͇���;7�ڝ��QFR2�{d�,)$�'��S��	Y� �a��0�`����Oj�� ��Ǘ�/n��P��tKN[-G�OJF�p�r��U��՜���^aћw��+�&�Z@�P�0������k���Ԡ��;v������x�[�5������7���5��P�L��J�G���B���xI�%nF|���=O/�,�Š�O4ƚ�g�	k�K��Ihcr��/@��P��_�Wb���g�9�Y �9�t�U^P���* �m���۝���bQ+V�ؚ׺��j�_�  �J͓М/��A��O����հ������\D5�^��LD�����Ց!Y}�x%t� ��R���_ό� �� @rM?Z�W�i�꘵K�mt6��	��A�9z�^�ʧ0M4����/��D��հ�a:�iڬ���ޗ�$XM���12B&��M�ꦤ4Z�T�k}��6'�8��+��Y$�l�������L@�Pyȵ�du�Ƅ��^a}���(j�:j�B�$�$@E��</h6K	�vgr:�b}p-���D� �U<�?!Ě�k�ه^���0��g\6�77���p����'��UKjGL2#�NӦ{��0�'����0�J$�����|d���]��Ւ��������u��� h�^(!d�Q�Z�1�G �[�tw=�J�߿��.O\5�U���&���L���Y��5٤�$�ۂ��6��L#�+�GXb_ bsy�Ń����}�u8Ą�ο$�lƿ�xiA(KU$K�|w�^���wvݡ<E_l1�%i�Kh���u�
?�vw<��O����i���*��]�F�z--0 ��qЫ���Ĩ�ْ' � ����#<^���+!��6����B��cH�����%���,��;�fp�Q�E#�Vx�1�:��Op��\>���}��W�jq]+A�����a���-?�?��5�OnKEK�0��K����].�Y�dd�����&�a�"M�oa&`}p���u�bL~��3�.���q�ܼ�'	��a�N� �Jg�P�Ƴ�����$�
,a�����w׻�n�ܓ�{�Ô�H��{2�|ˋN��Y_9)f(���p@��2$dщ�2�Q#��2m�'����P�T�i�bK��	*��_}�v�7IS%oLdjg
{���;�5�֖�}M����{97�_W�?�6�\T6�WV�+��\!|[:-�%8��+���nϬ������!M��v֎L=����F:)�@�m[Q5���7��p�Xv���|����T���J-`��J7~��4��僗G�:�<1a��𙙢ET��0���5�5kI��/HcY���h*N�[ֶJ@eƁ�4]�M�i�����([����̸:���%T�#*���]e��v�3��,� ��i�7�iߣk�R�0��	���(\6q�d��)6�6�tǇ#���0����*�*�z��K,k+)�ާy�����`*~1L�M���M�� 1��ߛ[:���&@��})�<\v�7��NDd%"h�M��e��T{˚>��o�E��%�w��/���$M�h��{`yMn+�,E\�Â41���Ƣ������o�r܆�a�&�^�����P����i���@��#`,Wt�����JD�ls�a�x��o�<�53ċ�6���H	^KЪ�舝.�h �uA;�7�"
8}w�e�{޿���D�F U�,��j6|��%�W�iz��L?b��$�n]�"*
��BͶd�H���-2b�uw�k`�Kj�*��	O� �9m�̚��z]�2�a�g�r._��`Y�>����!�,S�E8��5m𢭓LַZBe&MU�#�Z�K�H�-q��,.�(���'�W����NT�0ɒ'�2>T��2���H}ɊY.���.ȵ:�d��_�D]��ٱKHj�3� _�%�x6�yS�V\��˞�����w냒�_���<Jv�qѭ6�S�Ij-���m$����t�G9�`����2���e�[Ư34/0�� �%6?�H�+���Y�W�	/ua]k��}�^�o��,!*K�8����N>����GЯ�阥�������T�*K��h���gHh֯����फ�f�wd��Q�J]e����!1 Z�Hu�i�|�����Z�V��5�``��Rj�Z2�
�奲�S����I�7T������}�
M�eV�+P�/#��������w����������I���8��Fñ@�i��	0�8"�,ʞ�^�:��/O�	��q�;B
~:�C0]0�l�@��φ�_����|a����]�#�DL��c"e03���@�)�hY�*�����Q��v�����)R\5�b�>�&��60���R]�G?u��x�Ӆ; k�45��j	_?^7q�E�P�]W�^ᙵd�I���F�a?<�����?�%�VIpUyE�?>k�q�p�fC�sk8���j�^:�O�zǷ6 j�"4ߜLM�N!{g"6�����?Ԯz���Y��v�su�V�P#�P��(?�ܢ'[q�V�D�� �m�)�:l�ڴ@?Cm�gC����O��EW�)i	�ͬCPd����,6x�d��yo֤���y�S"thݴ�
���qF�|z)�dp3_E	K�y������ӯB��9(1�d�����!�*9g��f��yZ�/��?��YB��r���*Mz0��0%��=0�-�� ���|'�A��1+�p��;����/�ps`����8�%�j�4s:��#�j�J���RD�^�y������A ��K~��ffx�$��� ���ԡ�0���W̩ma��^��+%8�Po2ԇ��X��p�L��$�\/��T.�݂Uep�*��*8�f��� k �L�3
���X��O/��?���8aLuCJ��k�w��������0zǏ�/��ʋ��Ѫ�R*p"&�_�F��A��J�b�(��4���docUB���u�m~��d���t��\;��j o.�hW �԰�r��-�v������ܽ\�o����%%����!߉��hx�;zYQZ�/�&p�£��������v���$iM�=~�Ѽ}�5�k�h�R�n�!Zz��� �K�_7.i	}��=�=[��R@
��M$^nm�#�RjV-���
F�����7���xjV��������嫄�����}-�-K���1?_�O����NE	�r˦n�a�=�3���O/-�}2}	/�9�����?�����D%��IY��j�ȵp�`iŘ
������1����	gqa̳;=�x�F�V]��t@}v��"�x)V5�Hk�2,����v��&�7B���������'�ӲJ�)ɜ�߻�7�b\�uj�*`�P�1�:�z6 �$YIK���z���t�@'���w���'_UѶR�n��E��IM\d�(Vb��M�4��}m�	�uw�ޝ�^���9ɌT�.V����YZ�l[n�'����� ͌$WǨ�D(��Uŀ&V5Gl`�m6��8n���^As��Xn8��0i�նM&�<<Sw�S��Ȍ���g��׷��S��e!PP��I�!����VZ(1���I��$��X� VI!��C�7��1��� �T�]Хé3�`a$&�B��  �R�OYg�=Y;=�-�9�<<��F
e�p+��:���nJ��E��u�6%SZQP8m||����A����#`��_�Os�:Sb��k�`�n�/��j���H��,��%_��WB�3��٫�TJ$䱢������C��U���F��^^��0+�g���[����,�v\s/�!��1�㡇��%A?
��j���SLж$K�s� 6�M�����k � �g��	�iW�̍�Vf0w���'qv)� $�?^��{��8�oS� "�p,�MŢ�ʹ�F��~v�G�>>ɣx������HN�H�n&b�|%�g��[�<�$���^P������uQ40q���V[Rqxک�~`s�R�A�W�~�^>�B�#3    �2�b��1,�A��s$���)�^�7�x�w�J$(�e�3�ޝ��E݆�ؒ!�M� cnH-K�6��u^����Q3���c���f�o�����xz��q�F+���렑�JXl����u���'����a' i��檾‒Va���߬�$�6��&�W�o:���ڼ�;B�6`<S@�U���0
��OD��,���`6��z�7~�OV���x�-4��J�a�&m���Ѵ����ؑ����{����]����Pu�U,S?�d��U|q)�;�^w����C�����sqt[���Iuh�ygl\�dz��l#q��HlN�����U=v��Zx�5_���
��O݇\0�+�b�D����;�Lk�d�5���=h�'"������p�(!U�����[2����10L��}�շͥVI��@�(j�� �aq��ed�5O��8]}��O?��1�3��o.��C"�.���.�>�$G�,��k�g�;.���)M؁T��.'�Zߐ����js[ ���膿��*�q@��R|�I�,o�}I�K�5E������ݽ6�������ڑT�]5���ZF�ޥ��
����ǵ
n@�� n�.��շë��O	 �8@�V�?=�]Ϥ1�Bw<�6g
'f[ax7%p�Vk2K�y�%���.ҩ���t�62�)�`���-��g˖@��),⊯�P��۟���ݑ|u70��n��&
!A@��o4oqA8�E��	�Q"�Ti�+_�3ߍ��o[)H&.���Ju-�Z���yQ5#��&�6햵�pH�/�}i�q����݋ �բU�h�jX&d��	�[*�m�o��{}yٿ<���'��A{x�,�Z����64>�@GE��7����q�=�v�f�9��-��<R�lJ�u�f�����<`%%Z,"v�<YH1�qâ&�����0�%���0��+xn=	� 9��Iy���b�'�0D��;T ���� y��-��;H���]'K��S�6=�� ��Jc�a�ʁ9}&�N$��pA�Ъ�؉�M����/N�R��=�o�Z��Sj
�l�Vq%D>Ʀ��T��>	C�:ٷYKP;��Y��,�^�&Nr3��-xu0-�2�v�� f�(m�
,� ��h9�e���}��w�����=�BX���M����H�Բ;]$g��zZ����������y+a�%��j��PYڜY��7�Eڰ��5��S�f�X-��@�&�n-[#@'��rK��H��`��wL�}ם�v�2�K�FSX�.ݰ�\�&���Z�{H�$l��=�"�Xp����8	�R�ˌ�m%'O����b��m��ZԻ2�#�mp�,)�PlFrִ�-�}uA��VI�����d���g�lIk�	��j�� ���g��+�g�]�h����®�~����H)��|f�����ǀ��;_��Tj��x
~zM�f�lv"�O`�V�~�Ȱ9;��=��P_�;��,RLQb�̇d��V`��[ᑆ�~q�fT���ဆ�9��8y��\$P�d�w�L��fA%7�f"��w/�#S��a4l; h�(�&{#���ODb\�!�L Q1bR������_��\؃���wI���_'*�0�%֝+u��A<п�-K$�R ������vǗ�I�������C���A-�;��qC�(�I�;��~���7a��np9Πi9ȇ��ts.\�8�?�ϊ���3h,a�T�R<ޱ��쀝:�a�3O�ؾ_�N�`�yl��Vʄ�jΰq���d�5+<�0��8X^�8��7��L�8�'0�{���x�@�B�:RHQB4G�ن���ϭeu�v��(y��l9L��ia��̓X�a82OQ�H�jOj��U����>X�`�哱eVL�JN��k����%2[�
/����0�x���-�DEk��+w�O�0�����ЦСM(����d$�aO>����yO6��r�s�8Z�?oE��$�v���[�3��j�"�`?CʢU�1S+���-���ג=O�C�~�߼J���nɠYW�=�7���OGkBl����bA�t$�LR��{�� �$1I���XS��n/R��|TI$ҵI�0P��#
/�m�I�/��'
��veq/ٵuEx��$Q\x��~�>R@P�`O0uEh�_Slp��LF��H���)�EL$'[7 ��y�ό3@�S��-RF��~��/OͿλ;�^�A�2U�T���p=� �����n�9���J?���kH��C����5QR �CcP�|�RZ|a����}�J�vܙ1�C5AHl�M�ˉ�gv��GD<�ƛ_��K>F�G?2���G ��i�7jf��nS���4��f�$TW$��>��7���K��B�]�_����� fuPPՂ���u�ސ�g]��ߴ�V����=n����i���g�����D�4�֔�%ܭ�B9���,����ٝ_ضm}�(�`P4�d��n"OvHUm
o
��5�Â1�w�1���E�d�i��R'$y�	!��k�j�R��,Kd�#q��{�A�����:��)T�f���(3��d��4��e�3l-1�:+r�g����˾�x�9�7���(�9��q579 -'���*�~���ܒy�[��dO�g�����
z���+ƺ&�ܑ-��Go u�R>P��w�Z��1u��oc�
l� ~5�C�喱n�,2es0:ω$4����		���-o#�@�k	7����ʆ?B:�ﭑQ":] �$�t�I�Ml��X�5ټ�,��J��GT狌�+�� ��m�KoY>�s���G�_�T��LI��h�iDI�����W��j?�'"܄?�ļ��R��:����Y^7/5��%����
%dj^�?f���:ӑ\U�~�	�:^�O]��~G�N�#��e)�z\�3������?{��Zi��DL�k	J$� v~��ZҿKƚ8�zn�u�ORS����E��ϑ%aW%���5�a�0_�0t�6k	g]�����N5�V	Ѧ�o�4F����\�;��eC�Fڬ�K��t���R�r`��I7�@��œ�\qt�9�����P����Ȏq�V
ynA��w�;����e��K�{BUE�N�Gxfxa�4������I�%=��I�%%Л���z,N���e�������R��g8:B��������g�b�;�C٧�b&�O*0���οw�7׽t���P-F)e# �܇O&��R���7π�>����g��U�C[WgK�C���_�i�V���E��PpA�_�@su;c�t��5_Ry�/LɬY!G��^S�	�����l�'�Rj��@�횚Wf�}<?7��(!)	�Ȫ��P<��,��}��<�Yu$��>�.���ٚ��ZuaI����Y��Qnv�[�X!-w2�&��h�&J�8��؛���� �8�4�V/�~c����_֒�(C��Y�d,���V�!���$'H�zbxA�V�Ѷ��ߋ-��2�D�6d�v��$8I}��N��+ �A{)g����N�ߥ��������[i�S��B�&,6'7�C��E/[���?f?uuw��{Ƃ�C)qs2��P�j
�-aV��H�L�hX7K�ea�C�oƛz��H��m��8cH\��矮�)����YF+�j�5p��u��Q]n����aa�?w��Hw�
%�f$"T�(����O5%��1�]ˈ 6�1�D�Ʊ��h�	6 �~R��t"�ʦ� N���ݑ�_�M��Ĥ*��=�^�|Rf}��cy�!ݦdq���ׇ
�J@�������V$��h��9������>���STb�RQ�͇8�鯋?�Rw�5�,���qt�*�D���s���|���A\�I��W������,$�{>��v���R���m�w��H��ȉ�:z���{�!�Z�8zuS�8�\�=�f��A���k6�wB�T�C�ZDu��69/#��
�e{f��������k����;�x5��p��}�����ZR��Jը�*G�ѲV̲�8    �<(y����c���KG�O�Iㆉ>5~�a6�e^���	K6���]v�Ǯ�r�����ן(/eo�+��8I��-�/��OK!/?>J��%P�Cr#��G:�n\����!/���De����{�r�X*2�HF=%8b�F2�_���Gr�Q��ݾ�6��8G�Ҩh���+���w����Ki$��BkL�z��)�d)^g�^�ڏg�ݿ����]�v§PL����#�i�,l#V<�eb;2�;DN��я�Sf3�0QZ�,�Y�����~e�K*+�fo�lȏ86��,�![%�
�e_���q�+	��A�L�B�D1�3w�~`���<��v_8Wd-�������[W�ۜ����Sf�"�%g�-.NɛÑJoN��{������`m[�Y�P�����,��~-�5!���Վ�W���ֳ�seY����OKU�������Nš�J@=b�V�y�o9��6JJ`���W�䢯�/�E\�M}j��fsd�M6۾ZEm
e|�'M�PT�"���Hw�KG����CqZ@�J=��qf��c6���B\h�@dթ��ce9������Sj�:1��.}��޻3%�Ą:�Q\Շ�O�د�I#1�B�8��}��Ɨ��R�@�8� ���ef��IM�#)i��S7gr��Mk%���<b���Y�kʚ�㿩�KQ�kZ
�n%F��
�h7�e"�͍Z17ckF2J� �J�BF1�mˤ��ʼ�M?�x~��H�غ�r�=���t�&8�f!C���n�	���]e�()��z��5Rq� @q�̭�>���i��kx�\3�5�";]���@�����	���tC��K&�dũctY?O ���>�뭴�(R}/�-~᥻g�����q���%�br���_/=�u�Q���i��.a����)��y	Wv�O�:�/����d����I�(�n��܄N�f��&Bd�8
�ƿ�|L�"�o�����5�xB��s�c� ��Nr���
�J����T�*.�X �  z����k=��&Z�D�Ni�����i}o��`v��n&f�G�f��} �S�܆DbxYәH˹�b����Zd�v�E�X��,Q���9Z��V�5);9�>��|.�y�GI	Ф��U�?�ZNm`�v����f��(=.��v����<Z�UYQ�v)���[��8���YQG3���ƪ��='������+2U�U��r.������,R�W�RfKM� �Z���rG2�`�i�������B�+�����N�32Ń-�<DQ�A�'�~;fH�^/���T\�(G��	Z�n�~�v0352��m$,a��D�������eu��3(��R+�K��Ŗȅ�����扱)��$��,��~{8�%�¢��O�Y�Brh�,ǚE����5��Z�;sf����3�̇B��<9��T|(�$.�O���J��;b�~�s b���l�Y3a������$���Z��M3��Z���ge�u�h�����[	h�<�8�t��F�.�3e��晅�� WR��9ʚ���-q�3D%@�Y��oJ��dv�Y�B�,o=R����s=�W�'�~�����Yx8�ӣz��^RW,�q��ɲ� Y ��S��+�%��9��w��(��0�!e�U�@Aa.��&o�nI�e��/�Z�0e�9DP�ʩ4�U��h�4�Q��E��4���[�GZłZs��X$�����������>tq�_FB|�埨I���6�r� ���Vn�2_N��^b�a6�^���UGY���x%�|��w��;���t��kҁ�T1�h�0J^zac����;���#�؋��3���0 �~`��Y3����4�YB�}�؜FKk��h���M� s��?�s����� �p8Â�c͘����J;
�f��>�1Z��>ެ�h�?;]W��0B���L58̔$N����-3Dt0�{�\�zT�W6���!��&��Wa+\�;I��h�B�FLŘ���$��Iάo�/L�+~?A�t�4|ʿ@C��U�Zb�1%�J�1ID<&`^h"���Y�Y�������*���XQ%�"J*L@��B��s�w�����n�I&��X���Ժ�8H�Iֳ�����:�u����)E����xE8��h���d�Zr�Шy)�i1�{x`�肌	JZ��LNݔ=�� �H���oyܪe?�g{��?�k^w�]Da��dhg��:th��D?�%�N��Z�4,���:�|,�Ԅ"�QE.ں�< 3��`,�]/�(�������a@�U���,�O�%!>zPn#��Yn*��n$�.�I~�T�~r��(�(��^ى�v��i�Ibq�W����8b�-qb�&)����Y��v��ד��a=Ir��u[���3��~9E��� ;/H���<o�ww@����%��i���	�0l�9�I:MR�-�e�a��^�@�nK�b���7 nϨ���n�����q˦��I�ٝ���Ӈ=��_�0j�����D���Tw[B�͍�4�oʘ�o����/=)�kհ�TG������|]�)^���ɰ�د{�������7����/N�`��زЋ�Q��,po{��>6�D��0螦��
�Bcl@E^N��g�w��-s�8������?�qqq��1�4����\�ڵm��gj�m`�;蛰�Y ߿><�6��S/J@UD	š���m��[�wqz�]�oR����z�"�(��ɦ�7I��D&��s�;ʼP�Utws���}S�H�V�R��~����l �sp��p�6l�
d�2x�<�`ϥvp'����v|a�M��%[����s����+׌j�zҬ��Q4e���Lõ�"ԛ`irOm��ո��Ua)��8��l+m
V��~o��i6�7G�in�R��� ��9�26�R㕆��~�
3���?��/��a�Sv�4�d�4��穼>s{᯵MO�B��qR�՝a��_����Óe�����_97�5J&(	U ��k9,��62�6���,&���*ˎ����C1��PZ�>�J�K�h�\���(2�V	��gE'��S��,c�lahY.��S(�{�Ǭ@�S�QR��䚅G���9���]q���#�N��!�&���_(�w�b�d�W�N��p/�� �ۆ턷l>���uK�U9,:O6(՝�S�P�diG3Ȯ��[�;�,2O�v�:٨��;W�S2-�>�QR���j�R%q����NB���$Luz���RZ��a�t֬���^_�g&я�q��~�ILF���)S]-�	h!i$-�2��]$�a͌�ZD�Խ��ݓ7��,mX?,�NS����i����BqQ#G2%�~G����8R���L{ �xk~�����!S��Dl��{:��/�D��4WW�w� �nZ)f+�e*���C�nmܔFӹ�D��k��e��p2�:�OB����o�=tR��u�N6�-��ԗm��K�q�"
�b��q��f�2D,!��nw�����.i��W�%`i�����9���������/��5|d��ü����^@�l!�	�mf��[����r�}ƍ{Kf7�ES���u禁��X��6(�A+^��bg�l�*�N����n/�HB�l6:q9���=��v�2;��N���g�d5��֣?��j�ʙ������хv���*-ak�œ �3d��[J��%�e�I��S���⣻��U��8KC���*�o%q��[;Z������},ٙ�"F��+��jd�kYg%�YhT҆�T�*����=�,�wj��� ����5v�.���M=e 8�����`k2>k�Jko'Z�*S�jѺ���K&ֺ�1_�,T�5qkf���>��>@�BQ���*�I��t�`�d!��Y��Ҡ[-�*�I����0��?�0�$��\�������>���O�(�"��t^xS�@�Z�m�{�`~�w-��ݽ��Z�0Q]֖\Xe�tlE���C�ӹ}3���k�=�%������Uw�������`���P�s��z �  P:�~�k�+�W��W�G8�!���UD�������̂������d��|�ɱ&�jՆٻ��M�H䳷NQUS�4��#ָ��qU (e��5�i�7}-���1�����Xb�͇�tϟ:f�e4@JV��I6���zK��`%2;zr��|��c����/��Ҡ��H�wͥ2u����r����|!n�T?A�K�ח���A�����W��B���o�P�-�D������5�t�u	 ���Jh%��S�  Ԑ��g���������D�/�ݯW��<�-�)Zի�|�j���*2� z�/Y�d�	{�Ѱ�ǆ7�U�$d�N(g��f́�>y`��t�ĺ�#0A�m��7K�/��Q�?����E�f�'�ة��lX��ΉM=h��Gܖ��ً}�`�����o���Z��RRf^���Nї׏�<�~���I�� �`�JU��8�^�Z������A��e��asO�r&ÉakO��(e�RT����?}�w������4�)���hpѝ�$k��0l��b�`�s�J,9
A|���o?�b��P��">$@�a�c~��]N��r:2I����M0���j ��Ű!����o��4ښ���A��H٠�n@HU\�+-��U� /86�	����z��	�bp�����|n���կp�_aGRl_��c0���1�(�[�#x����u�L[��%w��M҉���e�^#K�=�02|�6�n�E�����eJ�JB�+���ŬJ��$t�q	�-8f���Ns�0�9m��Q�!4	6�Tf��FrFʍ�~�`1�QI�
@J=��\��֯�������qp�VFj�[�ɶ˾��0r�M�V׵�
�}����K������-y/�s�ӹ�;��=���k��S��	�o�~���'�~���!��Q�c��b�Q)�ȿ�p��ͺ�Eٌ���U[���m�=l-#��2󓺾���������l"z�dW��hu�G�16�J��q]b��hz.�4o�C	��6%��|h�:aM'�L�!�� �g8x)	k:j�Ә�A,�Hyk�%"�z�����6�x+8-�}N���zw�ѵϜ��a`#���.���H��4�3�������b��}%�V	(�$�!��hp���ER��<^.����ׁ�����G����h�*66������x��L$/�����k��OepǍ��<���N��p� !f#�*
|��}�t3+���G��+ıu���g��|<��l-=0� �l�de��Ȟ%)��0�b�J�ͧd�b�)d�M�Ege�H�T��o�ny��v2Tg.�E��ة���W�/x Y~���-iQ��^>��Ի�����
��n��z?69嶾��|<]���j�]Q�V3獛i��g��������]B����o�������1���nIO�iv����0Ϧ�WVR�Q�QR�%4�4u�)�lE�
є5�w�� ����7.o��0e���n��7��ײ�u���������HE#�2aO;1T<S�"�,&,���o� �}��P���alZ*_��KJ
��m�XV�s�-�.^�dg��>�R��A���o^���eTE�~����z!�I�k3g
�y�{�w{��䔏<���)�󫋻9�%������/��Q��0.������8�{�<��?�e*�$��0�-#��$���B!C��ptSd���~�ǻ���N�t�}ߚ-��1Q�b����Y�:P�������!���}�@6��.ekFWf�p�Q�K�V��fC�mt2s}��utϱUkjv��ぷ�G�;���fA�M�ы�e*�>>�*~w|=2����R�J��а��3��#/�[ ���ֻ����Ѫ�����Xi��v4�:*��,5`f���Gv:6op��h��ر�,K���Q�#�-7��[{x�_����'� ���w�� ס��9;�a�1y+x���"䈴q�8y�9�b-�mYCXXL#.i��q|3��g�]�-_,l*{�,�үj�*�����}���SѤV���&73CH��&+@�Et/"���(��Gq����s2Z��!Ϛ:���R�����f��,a���ίgI�N$�R�U2���Rr�4{K��W�ϻǮ��I/'�WՉ�v4|ݘ�	c2�1��J1���x,x��T��Xs͘������o�_���      a   7
  x�5�Qr�E���ܲ0����s��TeнA�E��{�;g�������3q'���+�w���~�^����S�z7vFjS��jP��^�_��M=ֽS%�*�5R�1�&U��>���a?)^�2���6�\������K�r]��K��u�}�r}�5s�r��.�����3��k|�h�k��,����o������G�2^߱�˰�I�TQ&/Yhf�������e��m��!�4�˔a�er�(^&gNw�r7s;���;/�	޼�y��L�r3[w�r�o�����������n^�E�����2X������w����)�����sc>�<b�f��|bR�<��v�/�<���e�v���^vꨳ��-�i��e���/�mf�]��2'�x��w��x��/ǹxW/��j+/oo�q�+/oo��fJ>�o�(3W�����羨C]�����Q{R��xW�M=1��ܼ\�(�x���}�"ϝ:���3s}xb>9;�T��W2�K%�2��Jv����JvT�)^��f���K�:^��ᥲLY��-C���⥲,ʕ����|�x�żV������+�N�R�}�=/^���/ם����󑏗G�+��e��.Û�e�1�K��x��V�xY�Ğ��K������Cl&�K�f��R�3��;�ֵ�}wĭ�5�;���zp�z��{�����6���uO'��������նFR�e۔mQŧ��q��^�U䃻W��x�d_�w�Ҍ&�x)͸&��%�0��76S��x\7�K���O��TU��n�)^�P�����J�H�2ep.�{���6���3��EEf!����#;/�u���^��Ru�{��^�/*r�,ܽT�f�"��Y��";�/��������nBc�w�aD��^�s����>���������n6V܍l�r����Q���R���^��cx��{�ȱ��e����n�^�wK�o�W�������'���4���ݡZ�.;�V�2��*rb�58U���(Qx�5�u��CEN���CE�A�"�燻���K��X�pw�����9c����23/����7w���v��C}N����m���;T�tf�;�uzpw`�T���w��;*��:y�H[���M��w~��,���+�K�PA�/�u�N���S�����/j�$�bv��xY�1yٜ���c�A1qw�b|L�"�S�����/��:^3"�x9\W�w�j}�w��칦6U�ތԡ&�Lܝ�:J�)Q:녻S}v^��̬�:Oܝ�Z��n�2f�C���pw�]�����X;��y}f�wg�G;M�Z;�/�3)^���~X�;����N5�f�qw��[ܝ���u������E�-�qw��U�.ܝ��c� �[ܝ��_�w��۽�wgpz����N��T�;-ܝ��1^���w��z��T�{R��}?Qpw�:���^D늉�s��w�{z{~�;1r/c�cǺ��ji�m�p����q�V!�����
�.ܽՄ�n�n�基�I�w}���\����y�Q6�|w}x5V��q5N7��]�S��
����P�T^���]�SEi�볨��w}��>}~��O�2��}{V1q��N�-��ؙ����>aR��]-�b⮏��gQ��bJ^n1���h��䥇�U��ئ�o�ϔ������|����\����;��G>g��>L��p���?[��#"�CM�w}64���q�gCt�S�tp��⥣j���tT��R�l1�1^:�O���Z�2���eX���we��}�L6�jܿ���YU�qW�>ߛ����PyѪ7�R7e�[����ٸ��.&�M��qn��,���]�rz;�]�qc�w5�SߺqW��L�x��s���������Z��ʇ��թ�ܸ�	��9�]mg�����,J1qW39��w5���w���,�jc6ŋ��&�j
��k㮦0%/*��(ŋ�2�V/UL����>�R���Z�/��������Qx	+��<�KXi�I��Ƞ�pW7��w5p���g�&������I+f�qW[6u�w�e)�xQ�]])^�nś�E��/jWϷqWc�L�x�Mu��1��	��hv��xQוO�u]�ʋ�u��]��n���tʰ��0?��Q��P�Ցm�՚4T�Ռ�����Z�v��Z��ʎ�Z���Nw�e7Ƌ*��w5Ei����hL>^���;`�V!�9�]�Bce�]�B�zF��9h����/yp�E�=�p��ݍ_>�u����U���E��Nw]�g1q�UZ��㮫t�#7�J��k�u�6F�oU���Ҕ(����ہ�.���ܸ뢛�σ�.���(^Tk�M�"CU����cR���1^Ԡ���Kb����kaVꩼ������]���]��~E=��Ť.J�c�r��<���1qާ_C��ԛ����σ�p;��R��:�x܅��7ǃ��8��yp�_'�B�w&/*�G��Ee-�q�*3xQY��)^�(v���V���o��_��USWyp���ʇ�P5��yp���(^�5�)^��v�$͔�U��<�$SWypHʐ3��^�;��#�E�>1��e}b�w!���������u]��      Q   !   x�3�L5�2�L5�2�L5�2�L5����� 8�      c      x�m}W�8��7gosAo�O6�����:^�Pu�H
hS<��8a��
�M+WѮF�
fe���>��Kh�������Oƕ+��O*�����QJE1ꕋ+�Vʯ�q��85)��#��Kp�;�W��b���j���R�*u��]5n�8�ʇ�8+��)�J�����UoW^���6h{�`[�5~��i����j���Zm�جT\�O�_��޽��O6�[<j=h�![M�\��vX=4��旭6+#��^�~���UW�[�$��`�{(����OoV)��F\w��}	^�������gZٕ�70	)W]X�����U��6I~Nحd��F�Q�ѥ�?���V+�5^I�+kW�������د���Z�7$��]5#d�;�R�	��4F��*�+ӯ|X��j��n��8�\�`���MZ�/Ig4U��H�Ju+�����H��W���>���sCt�^�I|�&��-�����ѴtLW�Y�
S���H�����n���F�AI������e`M���I4ae��`V�_�qeqz���'[���Aư}�]��뗴J��6�6��nWC��^�I��>����Z8�XҜ�?�sD?X#�LzIֿ��;�V�����?�x�B�g^xI+�c6+|�/�8���<N��guʬt�����"�'vc4����f�=�w�Q��l�]�^����1l6�j�W/W��y����X���9�I@,=ބd͒��b���K��Rsd��SP��� ڳ��y+���q
v3ҙlq,�n�X�9%wM���DD7PHQ�C��x2*n8�˖`�ne[ ;R��j�dx�������l��IP`�L�j��9�ޤW�{6�;��zoUp�g�za{�0l�:Ĥc[R��o�ԇ� �"悐�1+�B�$OfF���n������K�8F<���Lb|�`_�\��cNs�Y��m�ZW�=k��Y%W��ɁWlFoҺwvFI���<yf-�/����X]]o�3�S�_#�mI����[	������IoV!�d:H��8�`��_������Y,vw��Ж��Gy1��	�G�*����i?�\�<� ͆��<��۽��d`�5���P�ш�m���i����9xQU{��=E7�@^]��b�^�U��߮?]P�Jhb����H�[%���D3�Տ�"�NjP�ޭF:�Alߤ����Lt0���c���*V���h�Z�D�{�\��M�.��~�É�t"�!#)/'�g�U����d��9��m�z�w��"tc �h��ߥ2�L�IT%�dI��*;	�'�K�z����l!J%8	:A�� E�m{q��]6����dƈN6����u�����I����v�V��#� �L���}*�8У���W^xM�s���l�_��T�ݸ��쌂�?́��t�6��!nD�'"z>��D����Yn"��@\N<�.��%��Cd��{[Wٸ��(�h�yk{xC����D��FX/[Ƙ�S8G��4���W���杋��N�Z�������&�W��I��_��Q$tm���d��|3�Z����m�ʏ�buMj�Y����Ez��9�(�:6@"k��ݠcEnw׉aG���W��O�h0�a�x6�1���>/*����=d�\C?-�������O"4���|C>.TQ ��Z��[V��0�,ȹ���Xo�����S��dA~[����#������k)�,�4���K�rlěJu�f`S3t�kA�yb���Z��x}���@�����Q-Y���վ\]Yl-YӼ���u��/�0�4�;İ/WW���Z>_����m��T�t۬t����h�j3�V�ih��bg-���6V�y��,j-��~�@k��Ԟ���}�58	ٮI���3*0J���\1�� ����71�B�W���S�x�b{t|�[��"�Z�Ϭ��C��-��ފ�Ek���z�lie@��%	Ot�<��_�%�4��Qje�$߱��%��(@#>Ѫ��WҬ� ��Ti=��I�7���(ϛ�p@K0s��7��k���"�;�	�1�?���k�����Y�p�/�Nu�s�5M�ZW�h���wc�w(VW�Sk)ȗ��0r�6�k�=����f)�u:��6[��-Wk�?Iɷd�<��tb�幞���4�)�i"~���$��^p)��
"�d'�N�h�(J�k���� W�S�� oGI���&%b�[��%�t�$*)ўx��[Pj���k�=u�2OZ3��nL�]��^� ��}�mC[�v��$�ǌ��=�mD�G�_΄�)k0�l��|�+:�m����R��6�8�6J��؈�� g�6��)K0�n���+2��ˉ=|��f��_�A>29�d|F8��u�V^�����b���K��X]E��qB'�m���H�Z��s,�U�_��]�ѲG�'��B��Mv��ė���O'��i÷I�&�!_�hm�!����T#1�V2��� W�6I�C��ă~y/�|����CM����Ҧ�X]�0ڒ�=����H�!_����G��xɪZ���@縅��'�d��ִ��DH��!˜�tQ>��հm��Y+܀��5���ᔭ7օ&{I�t����t#j�Ŷ��?��J6i�D#�X�����{��~�>��b�CAЙ&R�OP/.?ܽ+��ۡ�p�t䤌�j[�N������e��5���/s�RTG;���U��O8�&�إ��c�I�S���#<�7���۝j���j�:�@,Q�VC��!�=I�n�\?��ɒ	!YD�Њご�k(�5w��6l�z�w��>#-ؖO��<M�)Q�k�ڼu��c�V�1�9	�}��6�.���"��eR�?D��JΣbn1��]D��qnh�|'^?��!�!ҽ��!��{��Tx�u�X�6��W�k��%�:a�ӧ�1D�ݣ1�C�w�4��&٨^"r��S�[�h��{��'��p�aZ_�c��?�����`��/n��ӫ�j�3"̀�a3+���ϫ ��;�}����.&~g��@��S�g��]�յ�F�G��m��%�O�������20�D�;�0r��m��J�����U�~g�b���CW��X�����t�R-V�7���1#�S�O`:�v��˳X]�@fl C�#zDt���F�g�2c�c�:��;�f��s��-�5?	d�z]ہ"�*����k��Hp��Fxf?�{�A����� �J\�@r?J�����ct`��Y�dןlu���:DA���h�E�9�&������[tHx�qD�5R[$��^9���j�G)�",�_=���:I=/apM1���K�~�GՁ���(�;G�%�� �����U��B4!*qb�8��7���z�L����}�d�M]���C$�D����(Y���+�����/$��c��!����r{,���l�'X��_&�g����E��^*�p:���)���X�g8�X	�4��+=����*j���&W:����e4Q��\{���G&���?�p�Ew��̳$��U�m����-���Wۑ�딼2p��:�AlN1�C_��j;t"M�9�A遭���4}��Z�Ҕ�^{#�]��V-ɃW�oEfp�ϖ4w���`�S@�h�*I,���.Eݾ
pU����6�%��X0FM�Xy�_2-P��D�`I��Dy�����}[�+�h�D�ص�W��-j��o(��0������{l֪�!#�0wP�䏴=c'^[i��fx��*i��A�}��K=����i^���(ɕ�V=H:�-�IO[Dw��ϓ��BF:�ȏFaB���z:��x!�eH�Hj�o������n&e[�I�·��	�!UBf��ɔ�\��F2&��F�6����;Ѩϵ W��
(���Ri P���4F�HI�_Ik���d��'��w��M-�F)�x(��eZ��"�B|�
pu��=�-yb�ٓ0C`��;��;�0['��2"��@!����l
�|���1R�y$���~��Z����X������&��C@�`F��)�MW�+sn�-    o�L��-O#�c���w�j�aT W��1��)Ԧ�WOn��;s���m4��X]�A��j��t��D���A��ខ8���N'�kp��0�ߣ�>>�y�?,�5���_��>��4���K-Wb��x�c����G�yT��5� ��h	L�m ��{(��g!{�������䞬_x���L%ȏ��r�a��Zgk��ݑ��H�WW���D�8+:2	Y�7.�n?��З���m�9��jU�N�k9�:�Q�:�;z7�lk*d��*�W��u�an�84Q�ӡ WT�%Ǝ rI.��Ķ�A�#��J�·>/J�۾X]keC�9@�� �%���|*���*��+ڑ�EqE�-��fG(.�V�q1�j�Sd�c����5�q1(L�DtSr�Gȕ�0��&i=�����	S�t���'([��Ԓ~$��!2�D��Z���>F{{�B�u�^�{���]��sd%!�"!"Ϛ���J�0��zXV2c�S�'jxu�z1VC�#��,7��g��T�j�'��z����#}���K��N24 �EbDg�5��{��w���rJ���5���_)�Ǧ W�Co�'��I�^T��L9h�@lV���� 4�����[�k�Q�};Z�}Z��mVu��$|�<X��P=�h�d���\39���$1���F��j�6c�R��)$��/0#��\�!Ʒt�|/��Ga����sΈ�Xq?J��Zv=�UB� G�	��!Gտ���/���f�m�ı�A�D9cri���
9'���E��R4�
�.����ӿ�Jz�e�S�7n*�iƾX]��D����:�:)g�a&T�é"�!�ӟ{�Z�y0�I9 �K#!���~ko�c�m�T���H��C�n�c�9�C��G�I�o���� �[�ُ��Q��ƴ���?%O�)�Y���v�*F`����>�4��նNF����zI�P|��R���Я`|a��>����V|�:�Y~~��3��_:�ى�VW-1�'A��ć�s$G%�1��S����	M߰��
9��:�p8g`� SA!1+�z��Q��m�U�u��~&0�9nc
�\]}�@~��e���'�j��!�.8,ض0�Um���\]?��*X.ӕ�"��΅���؁��Àv�f"�d[q�|s�O:=;���.��%�Z��@H��������M�R�uW���:Z�Z���ޛ^���~�m��ڤD)�54T�e�{/��U�k�J��*���2?S�Z=v�������J\ed�u����>d"���nGN?�wp���H⷏F>����)�|�$���bu�E����H�X���������GϢ/a��T͐H��2��)��*�K��s)edK��;��LJ3N8�kB�ʟ�&}�e��M�Iw$�*n�KQ<���GS�kU�$�K��S;A�;9�ou2�nF��+��P��QV0	`�V*͊b&pB �g��i�U�� mt��%�3,&�1����Ʈƈ�;�u��7��:#؈Q��ܟ�
c�aK������
�A�W��HE{��ڇN�Kك���C
�H�ש=d`� �)�N2��C#�B�O�� ��1��}[ȴ����:^l�3�9��bGZt�ӆ�@[����N�.[{
VJd&]���s䯐���u��\H\mA�T���-d�A(�}��_���;�rjű�i��Qo��t:~p�p�T�����<���۩��y�&]�/�sc�C~�sޜ��Э����\�d^��j�^�l�B�� $� ,gT��F���sS�+�neD(��	�+}�D�x��L�G&��&�s�.tDp���%����8/��$J>�ΠPԓ�rt2�f�k}�
�[.�÷��o�򞃗~�bz��ڤ��|�Z��F����C��}�{��U-�hm
����!Ί�4�,��	rm�9��q?ǐ��\�����w!�Z0�Օ��*�Η|��o�;�%_w�,^�\B;ŕ�Ja~d�b��N��ύL��*V�{��H,Y�7�����a�l���ЖL� R���6PDWǎ���^��-�&Xl~��Dz�o�j�L���� ֈ�F*�\2����\ѓ�m�N)�Q�ĵ⬖hW!���ȕ2d�GNđl�?
pE�\>=�vC��~��M����e�>��Uߒ�#�EG�\=�D��@����-�U�j��ݙ��.�б�=��#�S�)�B:/�����)��Ŷ��H�{�x$A�����3��ĺ5�������1mq=�h�9��hs#�1KL�k+k,
}#'d4tK�n�|fg���f��'���l+!b۝���)�U�Ģ�9 ہ�r��d'��L'�_���XSr���6��)����WĚ)euq����tQ��T ?pon�fp�48kf���~I+QiN�q�;&���Gpj~��b�Z%:�L����,g|�Q��� WsM�eM��Kc��aK��3r�G�'3H.гSZ�7s0[��,b'�lXۏ�C�-��\�kMcw`2c��)�0���jV������Y�fd�D����E��B��f�	\ː�Z�]��y�g�Q�ɨǳWR�h�ȇ��:�xu)�c�a�mkY����a,VW,�ұ���j�`c����d�_vu-�u
�T��T!E�U�sg��{�\�_E��c�SH]��V�nR<wo��V/$���-ڽ֭��ױ�'���U���wE$�{F�3�� ^���m]�kqu^tR���Q��)Tb�QQ�JpU'k]@�W��H�ȏK�|�?{!^d+��M$��)V�4�%����L<�h��	z �������*<��@3�P���5�N��(L����X��DL�i��[�[r,�c��v,�x�k�Jw��*�l���Jv�='� �1�>c@n�]�z�X)r=�ں_�e�!�Jp�������#<��Xq:z��� ��3�i~J��� �Nȓ��Ȓa��@GQ��I���	\p�'(��ҷ�]h��>Q��� W�v"�h�D���HO���6��4OM�MUʗ�9��gu��fB������Ntm��~+�U��N�-������:��C|��wb79t�^FN���.�6�a�9`��P�U��n��좄�1Z�Z���fyA����T���)����uQٺE
܏�`�4�dŷ�J=3)Y�IaC/���SJ�/:Gz��]]ug��F�TB�'���G�I�M�E���E\z�o����П3�_��qR-{�T�.VW
��sq���E�	N�x���N���Y����qiK��$ޒ�@4�%�Y{�c�����<�Ƚ}ۧ�Y�-��� ��DF�J��Fu?�*�i1��i��ļ<"�.����-�Ŏd��Fp�	b{
Z�#�j	-���v#��Z�#Wvޭ��bg�M$C�[�=:rz�	t�)�~�*�f/n!��H�� �?��)���>��@�D��#K��}�1��h����E9)����H��F�G%��Q�� �MN\��na�4zcD�Oɍ�9J�~��E!ހ`{������=f���2�a
�
�
�F�ijc���lY��[x�!�s*6'��� MÙ�ĚaS�����R����C���K;׍%���n*Zn�Ω�|T��N���"a�c%��Ȥ�'W_�I#�РF��v�2�k�~N���`�%-�0��!��sH���ǩw&�K��I����78�e���c���O�*��xq�*����k��d@�2��q&�Z5������dA|ʳGJ���Yu�p�H�LH���{|�%a:m�\�Ý�±G�c҃Z�-����k��ԽP=Y)�����#<am�}m
pE���(�8V�*��j�/�YB��7��xN���O�_I�Y���7LYЀ^!�OG�a��*�ټ�	\����W:����������[�-�"~�����Ǧ W�7�)<C�p����v���h��-U�9��J;n����o���)��tS y|���=�+U��46�N~�&�@��|tZ�?���    �P�`��E�}�&9�+K�F�,	���3J�_>>�U�Pf\,�rzr���ϦX]�g�y"�D�?�3����'�4��b�N;t��\�܍b{q���w\�p��V�H��\5�Ph�����T]I�(���@�����輞M���U���QXf;�C��J��dzv���vB�@Å���,�6X?��`�о�̟ѓF��)[m��3�g�Y����_��OI��X���87U)����u���5Yt� �F;8C�zd�n���v_�뷲��)m��r ��MG��>�R��r�������b���M&��\��a�uߣi�]���������j8󧸧��Ƙ���X��LD����GM	��'q�M��S)v�%�St���B\�}��A�����$_�$�.Dԣ؍I�͡ ׊�*�ɢҟ�������*��,� �5��OrC�� �#�CK-���#��,��C�^���r�%c#f9������i����9.�u���9��l��"���F��`p��sӠ��Mz��6եo�Ԯ#"��g�I��)5d������(���^����]�����i���Mq��"�|4���&N����0"ϐġ	J?�r��fxԅ�Г�c1�D�����W��܄sZ`�FX��*Ar���r�;d��F7�����~]��ͦ#G���Y���K��|�һk��Z�M��Ҽ�.q�����N��}܀��:�k���K�U���&=w�D����/��k2�Bֹ(�UXT��:� ����<@�G�;�����6�Ȥ\N��G�%��U6�K��x�")1�6��F���
pms�T)7���X����f����R;-NqS�������l��+"��!��r����ui�?�¤�&͢l���m Y��5a���O�s ������~�Ss�1� W�v�>���r\q��صR�c��~����Vݑ<�a@-�c0Ҝ�\ok���G=/�I�~	T�jQ��~���:^
pͱQ���C\�P��l�J�L#.e��T��o���[��v;��#џ��U0�8��7�\�*]�������KFz��^_JpM|����&%ϙ�^�>���0R؎��-ڋ��J?/=J��U.�H��kxwfH+֗d�';�K�I��5�9�nqQ����F�b�������BB֎���S��GT��40����(ʝ��(V��|�M�׾W24��د}H�X]�+#�x���oUz�:�|���@c6�Ge3�&�;q��g=��J���C�
�\�@��u���v8-���͟�0����A��9x�K�E��I?�gkq�Ig3�'p�x���<=�xqW��gLa�~�ZH��hy�z�g�}��:nĀ�6�`D�� ��O��F.[�$E�19-�ƈ�N�vz�w�,���X_r��!�*twH�������c�k�n�;q�eݣ W�D��_�� 0c�6��v��g`��J��9֡V�n��_eRŇ�uY��&g</J�{��Z&/�G��n��\'vWo��W���T�����Xv<�(��xa�"R�������Kħ��ܲ���㦨�v$�-WW[�1s�ſ �|��M�t8�J�z�W�LSs0�2,������������a>X���	zu�<R�}&:ܴ%����u/�����"` �F�]q�[ů��h!#�D^:���\oN�gD��?�tC[�+��ѩ˷��r�������������zp�QǷ��n2�]Pq8��wfg��*��Q-&���`�x��6��ć���M"1r�nΣJy@ V�$�C#N_���Z�+Y�=�#�!����ut*��H�+�bI�Wm��ׯi�tb{6�� ��м2�Q��u�!���7*���^��Ն\��eC�z)��4 S��d&~[�������ǘ���O�����z!c�UC�-�����IAn������
+x\�7�/�h<��b��q�ȹ WF�ӱ��ws�� R��[{�/I�\��z�m���wV�k�A?��W!�!�kk쿎�6�ϵ{�����V�:z��Ě?J���X]kD̼p�M�|�&��A+��4�	�����	R0��l"u���Z-�L���o�=b̀�|�1�W�Z���,���s���!��1�~��j����<�Cx��Q�)�˩ W�^'��ܬ�x��0��BO~�2�B���y��.9��Iќc�{��?���y��ԭ��w���ʤ�]��w6Z�b��:��Cט�������p-�SI�M&^�ꅐ�GIsE�r����(�C��߻q�������d����+�O���V������-|�O�Dܵm�4�{	�N��˰��4�G<�s�3��p}�M��oJ�<t�$o�p���5�^짉̷�t��(VW<�[����<�#8-�/r;�����xK��M���Z��/�`��Q���n:S#����������yF����gE.�l$�����I�o
p�*�v���+ ��n��í�T$G������*o���<捧��|�	ū�N�|��f؈R�F�`$W��C2혁m~�6��+&�@�qԈ���n�	��������&�gumU�B���e��/Q"��E����n�����8�.\�ɥr=:�qQ�R��Wj�A6���6�k_z-������}]X��e�&�ԅ�ˈ���o��w�5�.R�~W��%�yx�P�<9�D7�2#98,�2����=4S;����p��O���j�N� wg���UJѻ��wݎ�8\x#�w�3�ޅ�5O�>p)n"]��Q�p��;�BE��
�Ƶ��($�U����E-�w�z����X����7|}Ո@ird@���m��K5�h�H�D����7��x�Z*�y׭M�2S%f1���~j�ޑӄ�^��A������4�s��<�YlQ��X�k�#F' OH|j�:�_�\�)�|>H�9f�g�n�ۏ��ߡX]e��T�|����*h��X4ɇ��F��ٜ�s�l��=�׈�Z�-�s�����-�tJ-H3Y�!�=ܸ��2�R�_[�k2Św�|�s�za8��t�<{��Ѓ"/�]�)�5e��*�>�	����{]O�d��/�bSvc/��q��l[��H���y����~.\V�#�|�4�d�H|�Ƨ� ����`s<x�q�Rk���m�uq$^��E"̢F����)�eGaiVtcj]�c��d��S����b()}Ҟ��+�D{���\��HK8� �pT��3��6~�s0dun���h	硤�OOK.L�kD�W][ӯ_:�������Sm�<mp-S�y�	&ݻl������;y:�M����`��\���'��`f"�i�����J:nf/��{�B���K'�g��]���q��	r?]�����X��IK23��~tj8f߯3��Υ�3<���h��1����K�����"ON ��Xt�����~q^��xa �G�3����ãF��|�V5C�9L
�|��3�p@W����������?���Z���Ћ���敁.L�8%��5e�Ï�H��jw*���ҝt���E��%4
��ߟl�E����i��?K��_���4XR�r�M�a����e/�O�G�����C(�Ÿ
pUf$O%9����A��]_�+N��^p��x��r�b�%�py����^(�,T0Z�����I�_^(}2@�����.��+�����������p�f�C���f�`|�)ߒX� ������buu��t����;|��U	O�j��4k��n)+��$��e����:�h߇W��:p�Ga"q���䈊�g#e�s�	�	�4K�͞�%���ri���_�2m<��6(=�p�x����]���Q������︗�K������\z���-2����J�-��F@U4g�̦W�v���I'�Z�����_���i�5��FB��W���&����c�n9�ZJ����{�䅱���ԵW��h�z���?v�J��ه���rK��0�RޒG��u�:
�c��b�C:���x�Q��    � W1�@�*�9YEj��H2���1�p�:bN��r���^����-��iF�uQ��bu�F
t�3|���7�����iPS��"9��ú ��In��v�Us���0�D��X��`P�"���ٸ�Օ����k9y�0�`��u�ą��j S��|�Z��l�Y�O�@�Ef��Z��@��oIԿ��w�a| yT6�ֆ�-�_LDx�۳s ��4����.�����QBo�=Sx�p�N-_	y�3�M�~�����\��i����j
���w�J�Gg�wB�fD���mt�� W�g����1��X]kDD��^ď
�9�߽3�o�5"Y2�wXNaN�ߢ��G����r�`ɏb�w��cr\c�ˌe����BU��"-ţ7��ę��q��w�ʋK��3���ɠ�I4/e�7{g�0.$LUʛ���<�k��$t\�	 ��DJ�C�����*��(�����s��á߇�r�������8W��Z� S⠜���y&�/��Jy=*o��bu�읅���|i5�� ��L��g�T�z��P�bX;�y�R\C��S�kS�<�y�q�O;
F�6���kVK���'R�CX�S���|�R�w�����^�����D���R�3�MYչq	�9	�7Nw��k��� �'�����ȃ�:�h���^�JpUX�@2�2ۃ�&��3Nu�T(��F�%z����C��Vsݻ܄�c����7�P��u�1/\���ux,|6��D�����]��.R��M��5cTm9}��YU���H�8>av��t�*ٮ���u�#�[�E�HX��Lq��7c18�>o�9�p	��ߌ�m�>��+�1$��&R����%��K~Z����ŷ�QЩ��������Ū!(h<���	5�b|���p��Pz�줴���r+>M��8U��@G��kP�`�/��b��A�\U݄���6�3x�sJ?{�b�0Ť����#��\<:l��2Զ�#��M���ڝ���<��-H�����l_U�b�4XM71y�kϷ�̜q�ŋC`��p���	�d�0�~]�	#�<�=kQ����w1:�L���)!*�)��kW-��oI�{��s�D�eR�d��H��{?m�>^��*��D�#����uuY*,V	��-�Z�q_��21!Nu��y���Z!z��c�ލQw޻�� W����2��ġA=Y3|p�%/�T�t�
����בٺ�2�B�g��<n���������-��%��I��O��e�_�;���w���O���O�.��tF��m��U9$��� �|�x��O�J��\KI�"�D{�I�ٱ���-hğ���ސ�i@Չ�\��s�F}�6B�I���`@f+.[�:S�-����m\��o��ڄDD���L�酛�bt�{^b�D�IgL7ŐH�oi�x��K�}	.�Q1�6�M�V�f�q�0{��1;
zA�D����y8���:%.g�W�lK�@��,o;c®/VWq�(-\�>[�����eH�X��\Q:Yo�TlhwC�<<3�� O����M!��mߝ��󝃗Z2".������z�����`\�Z<ʈz;��n0:D����ߵ W�v�\.��@#�\#��9��=�Kp�ۊU��[L~j/�m�T���b�FT
%rSݘ�q�,����y.��H�Uh-�J���8|}C��J�Ee�ܨ@�#�A(�k����7'�����,�ޖ�v�<��8�e�u�^pE�r(�B:�=Tdؕx��X���R�q�u?J�uS�����ڷ��o؟��e�&��
p�_��̯��ꔉ���*!��#w�buZ���*"����
���E�gt!�s1p���G�"��&�9Ki�K��Ҩ5���h��8�~E��wQ����'��Eϓ�� k����Ի��.��8��7��Z��X��k�^mw��K� ��(�%J� |��*�:�J�}�LH�4���q^j:5�W"�#�c�N\%�;8�^�6/Ĥ��{���@sɉ��W�y-��K��@.����G:bȍ���7���b�k4j�.�ڮ��o�i����F��lu�����`FoXd�1�Mr����<�hx %��섑\���nV���1��t�k��g�i�Y�o����k���a�fB��m��4�l?����'�H�g�h7����8�x!�M��_���繷d�����Q�kkOj�%�i�r}�B`�;��\/+��I2�l�a.�[+�7�l�_�������y1ozg����kM󚏣��p)V׺��~I�/{��"bޝ���x!��E�-���:������������f5]��
�H��u9�*k%��@��j9aռ���!�:�-��9����U�8�����ĆՍ�J�f�N��k2���m���X]��G�������2O��+���qJt�>d�3K#N'��6�CKM~�iT�\5���;��l�\U�GG�� ���D��xǚK��ɢ��14��yj���{��]�\�P�s:�����(@��������q��os:͊q��U�1� ���)$�^�J�w���Q�k�9�k�R�a(V�r���x�R�󎫰���%��O<�����c�=�~f��:��B�da5LwJ����\��'��@3-7���}��&�N���`���Ϋ�����o
p���	t���|�f�zK�Hg��\��\�4�l�L�.W)�x,��)�,4��R��2Ž�U(3N㛯k���bump|�4\�F���k�2�K;#2W�g�в�"tA�����:��B���j+��𖺓Oi���j���Ġ��Y+�KC�-�Y�R�y�H&��\��ft�:q���o�\Em�4���W*].����a��Fe*�{�$I�nc�<�3�Yp��Cה����B��L��\��0M�x��k������$�\K�9��Yv���5�m���X�|�����X]%��T��x�g��R�����
&qO}����f�~�Kp�(n�<���ԧ�_�t���������N��=I	�gS�kG�����1� �~*����uet$��XGX�lĝ��q!pX�ZM��9��C�	'�B+�FGu��ya>s��b�G��5�/�!d���5k��%�ܦ�x�Z���p�m���~g���D,��L�\p�\�1!R5ӵ<b���z$�i|�Z�q��V%���K�H���L-M܌���i���	a��f���
p�J�)�GV<��눞�>%���z���&]�ꅢ�lQ@��+���S(�!�L�sk��G	��ң��B�9�\v�Ĺ�R�\0CWa���O�P-����}[�k�6MsX�����%�6��p���Fo��䇎L��\��B��\���L4�
�A�Y�gW�1I���m�7(4P�tn��{�*��f�%��?��:���8b��zW�+yIҠ�_r�d��am��m��x�g[D���ꎇ�{��]?�N�g^�w'��7��	�ǈ��aѡ/<��.�صo������E��3��ݨ��f�|��eD�{1��TS�O	�I����N\�4:�:Y|_2�µ����m��c�1�=�������T��Ed�/VWUmi*}�}�I�s���Ii�J���RW���S�x����i*}��l��X]��,h�f��}�`��\�+ݘP���a��[��oeJ�.��ړ��\�mp����vV��R���2�>����Q���v����F��̷$ԁ��x���,�4D��Z��z!-�J<�F�=3s괉�� WI��Y@N���/?p�ْ&������|cX#�_/��Wҥ��'�iF�#!!�up�u��r"ǃNa�S���hq{�6�\�7퐉mpp2���d��e��m2�����G�>nR�;���v^���k�ϟ�`!�{4��(1��r굴�_����8=rS:�K��4w��~���4A������X]����&��qDK��2<�� �  ׻� �j�(X�d�PS�,�!x�Q��)�p�H����pF�����%;뜙V�'�0��m�ξ�Y��OS��㔢����B���Q���|ϧ�mL�&��bya2����ہԈ��{)����m�(ly�I�[�r�ң�∆d�����7ѮS� W�G�+V'��ah�9Ȑ�g���*��F����4�&^E+N�\��bP�`=�6�B>;�;��7���9�Î� �Iz q����B\_Kp��Y����q6deZ]���4/�&"�(X�N�#j4�R���4a6�C���w���<�Ѷ�
D~���� �2d��i���s
V=1�ˡ Wa�d���H|�G�U�oi�B�i��q�ퟧbu��������'c�7Nӭ~�-n��g�
��3�+�_��L���c8}
p�Z����)'/��zqlp�� W�Pr�Bhj�����ј8�p͜�t���h)�Ɔ&�{��;W���.w��2݄����1?
��%��$�Arg8�Nǿ�٨?c��j�q���Z�Óq})�W�Y
&�`��u��+ąwE�J�~��p8�݋���tɔ��}~�k\���SJ����I�f>�]��OӔ����?�Օ�z��<^C�䛖�ݬ*m�,ӳ4OZkq� ��8�(y��'�w�n��2���}Jꛃ��2��'�' O�3b���l����&�wGGK��V�g��	�<��K�&�0w��܇+Q<��T��7�:"�\����x�1�[F�zeƶ �d'(�1��C�x�^|���?��0�(E�OT�Hљڜ���./��)��Z;�bu���B�Ā��|�����Dji:j
�;����ёJ�!�����H���_��
*��N).'}�d�`�C@���#3ݓb ���h�/=9b�֨pb��Vt{�eS��h|":�%'�{��h\kiև\���2��{�4_��p�����4��$��Y�'�E�}6~aZ]�����_���VǺ"8E#x
�I�ǻ����
p_O�	�x�*���:���ռ�j�N�T��}�g�Z��F��8͛#����Zr�"����t���ꚯ�(�]�Fk ���v:�9��N���)=r��gvIx���%;���d*a��l���ם�vީ� �y��������,.      S      x��}I��8��:��E�<��9�~����6U�I�/��RRR��A:�Mͥ�Ο`����^^>��}��㌭�1�?���)/c^�-ƚ��L���ǥT~���ş��\y��:�+�W(
k�����X�6 [彾�����_��/��p6�H�S��ۗI������G�0�Z�:7�(L~Qv�|���X�I��ί����#�^�!�l��ӫ��i^G�O}`����G�H[~N������o<_�(��/��L.�J�]���
ŗ�K���t=����a7����ݏ���_.�6��s"+��u�8�'�M��_k|�UAc�@q4��Fk�׌�XV=��J��U�׶���U����N��Y�������k���^��2�44���~�,�{���Y1/��6
�,���o��$�����k����s�]c��?Wo�\0#�Ÿ�}�^�OF>_����_��:��
�ו/J���B�-�	�eu�QX�^�,Źh����_�"`���ધ����J��&�%�ޫ����{m����Z���_����e��{+D����"��7�0
;;����lo�Θ�cEN�^a��n&��X_!-����ga�o��PX�m�Wl�}?��e��E<9��-�(��ʎ�ݣ�:?�� Ŭ?ҿ�lb������#yr���"�WL؈��R��,��b]��\Xh�d�;)y��o�E3�j#���h�W��_���zqdaE,�2r5^���q�/;*�lpTD4�y6a�6������l�VUH68������8�������� e��͏(�-��B�K�>%��e뒣�.]���d�V`wJo̣h���D���y�@A��W�
�Gi��J$}��%�����8Q�����ڼ���&�� ?�������n7��p,)N���?�~6D�b�S�O�����ͦ,)$�9��R����xe���+e������y@k��B�e��*������P�"��0ÞX��ZW��"��b��ײZ�1=D��ȩ�"K쪂�U�~���z-�M��g�W*8{�3��b���u�w��[I�`����bM�{bS3��c#��Q1����`�Q�.�p�u�۞��c$'U4����;*�GὊHzQ3��h���P���Z��	�rsH��\��D�k��n�~�NܫW�8r|���Z�$]d��髼�����:3]g��Ѷ���
d�����2y�orA��J������G���_LI�1\�ù��G�h8a��I>XL~��*���Նk��\�����^LI��u�ߛ��f;�Q�{a�اeƇq�E������H�#���gI�\w*,8��C(6�.�xx�=��sW�0:C�wkY���?r��1Y�Q�8���C �$ʕ��RmĎ�G��a��8
l��{� �qS�o^&$o�b���)~TXm��&�Z��R8^n��/+���A�f�rY�ǎ�J,��ωRt	�7V�#X�wi}OH��Y�Qq�Ĝ]�����?#�6M�J����P�ln���
��ת�=�&�Id��)���F8���r���rq���E����ɥ����Ł[2�����i/.�r�X�+V�_L�׆�2�ș�Wu�\�^�{O�74{����@s9���^)�=���>�'g�R�9`E��άȢ�VX;���M������o�V��Ė�&D2���]�.�VGM�V��P��r.�w7������{�i�/bV�<��R�����ȍ�O��X7��5��-Ժ�ِYc'�}�e�dpc�C"�̮��6���D�p"dQ�߯V��|ol�|��74�GaE���Ňϗ)q�D��JE�¹�d�UcG�6G�=�՛�� H���SS4��W�K�2"6������'oX�"�d��l�~�Dl&�0�HT|�2����ŗ��<����Z�b�k'bg}��(V�Y6Nnh�M𢡊��(�/��p	��u����0'�R�??5[tx���\J�\�Xb4���a�
�t�;�G-B\~B�@�Iv�W�
;s!�
;���U&���[Etw,6���o��sd\���Q!l����k����H�W�H�����;ѡٵh��/�I��E~{��4�@eƏ�%�o�`-�4�6�f^J��:)9�en+ަ��U�e��09�9�˽Ptb��UEB<N���&�{Ohv�␉�k�$��sn�W���],�
ᤰ��b}r���3���&�S���d��-Ӌ�h��"�	��C�3�ђ�L-��E��
+~��F�^ǡ�tJ�+��=-�\D��\]����� ��VӍ��5H��Y�K6"T.���Eʘ��bЌ�P�l���	d�"��%W[�u�
Ս��q,O���r���U�2����;XSz���>>^}�����x#;|	�B�j�����F�W����8�
�/�TB�tĐ��=��_媬�
}ca�L\'���*7f4p�*�M?����F̪�)�$=��o~�z�ED��Ňd��ژg�ðӒ��W�(�����V˿ê�b�� �c�SWq�� 'X��+N��IH����t3��X������� �cUX���)^�B��MiWdt伦�y��O|f��!%ƕH�UaEz�ű��ږ,#�zd�*F1H�2
��b}˦�� ۖ�1?b�n��.�����a�*&\s�E��,Q����
'�C5�'f�|�H��#���B��U�J��������.�~6ů�S���]1�E)���Ǝq�b��â����_T��6옼--@,Z0�N01���Ǝ���Xb��@�G1WDZ�Va�����ކJa�X�s��](	��	k�Þ�7>#Nn��d�XD��,D$8§詬��>�@�����ð�vf�Ƅ�F�Q<�|��rj�a�[b����tqI����4�ӋА��'��Ǝ�_iA�_���.��"j1�^;�U�P�'֡��XR�$�
�����<'r؎Y�R4vt���͆W�]�Qa�W�|�#����nӥ8�����Q�7�m\��ch��0�X[+��7���eS؉OZ\l�Y|X9ϰ��\�煥���B�r�\�y�p̦����.�p=�9�$�_���'9(���vx`�{����d1E�E�Ÿw��2��Z�����Q�3.�B�X�>rA�WX����ʆ���OG�D��A3l���Po�0�+��3 �i�"z?`'��0�HBA��O(�'c7�����-Wڸx�<���GP�(ظ�-j����dGZʖvb��gR�gIRUQAl3�}��e���	A����S˫Z���ŗ1t����y4~���K�1��b�ٱL�0p�{U ��t��$�͇g�
��=��=�����m���#f�xb�A��B�؉x��zc�G��EJ⭰rF�_l%��m��]��r��;�]���9�q�c%+)2��
&j!@�$�O��9f�D?��;	��Pڑ,�����<�~y`#\b��|���m�=)X�S�nw�z8�f�k!�cm�"���T�M������xq׋xR���閝O2(�����K���İ�GR���*��^��#�Y�!
;I�Od6�T)���y�\O�˘x�%JLMI�=� ��Lo��7%�?]tb'�G�Ef���+��(^�mlE.H��ޡ��>ޒ�������i�G�W(�x*�N��V1P+zk��I(���l��wx曁["W�<�3�a8;���1~b%���Ev��,����ߊ M���]9�Yհ�3���s���R^��gz"&[d�#�k~��*k�m�+�ח%�h�%
��Ų`�M���k��m�x��#�4�t�.	}@1i���k�������U�ⰲ�V�͍0�+����Yl�d�'�Óea,VD��4\$�(����4;��,�T_b��MɴѾ�,ĺ����x��,/ΕdTŨ��T��y��6�,3M�o0�St�����t��\�G����E�.�J?󫱒��Y�?5��6B��e��7^��Zl
���K�J�
%�.��U1d��;:��[]0j2�weY���ދ��g5U)�*�Nԁ��qI�N    �`���k��0^D��u>5vR$Q�/2�&wo�J�KnK}�I�Lzv�48�K�VD�)5ߡ��#��r��QL�u�؉��B��Gt��c>G�g�Va�y�73�+���aѳ�-�p�����V�.!�P/ㄑ\�� �I_��jvf/��׊u�^[�*,���;)�(�G�Oj��[DpV���.𽽺Sd�HNT;�����`�����Y1�;

?�Il
��tY�V�#��
�U*?2��;��(-��Sv���J�DOl�e|J�xK|X�x�E՘&��-h):�D�E��$�K�)]m���i�"8�q���ˇ���X2�	�E�n;j��
���R�>�S�Y�xe`��L?�:����V1�)�2��Ǝ���y�^���#�����܋��9�f���.s�M�F5u���I#	�$k���-�;��G�8gÕ���6�[�g= �O���Fc'�к��k��8���F��뜇�~~+�����������z�z�[�ɳ��ϜT�76u\N����u|^3����|M�Z��\��gY�U!�v��H�%xk��ͭ�-o���au�ۏ]a��Z#{TL���g�Ԇ��_���8�hO��L�[Xpg���^�3-�(�2�$ظ?�;����r������=/l�	�6����]/��X�"4�\(kv&	Y�;.NK5�%�tT�q���T�E�Ҭ,�E���*�Z̛�{'��q�8\���u�%*��UP��(d|��n,�$����ݡRv�I�=(�Cll�&��x3΋���SO�,o����*�y�r�iQ�o��p����\�y/7!V;bĺ�D�,[#*{�6��e1"v����}���%?Y��x��}�^Z�rbc��^k�r^�%�����|wx������,q�Ĺّl������#B�^���{�Q\{ <-:s]�Pb�i��øn��q�����^��b�"�z@�o����14R[�W<��K�߹�w�V쁡��؏x��~o�ͬ��H>�
+��xL�7����}!-�M\E���y���*ʝ�/r�C⡷�z��\�����:�c�D���GV(�h��+�RCj�͙��J�k����1��}^�u,%+�ډ+S�n'�(�Z��^��:*;�EGF���~T���Ŋ�}��T�uQ������]�7��X�TcO	VĂ��h�<'�ѱ����P��ދ$ǡ��ʈc%Z�J������\2���31آ�Fm�ܼ� W�A�7(�pޏ=����=4�יc�78�"v�����_���F	�_���jn�,��v��5����=��v"�c?*�+�
�����^*Џ�-md�����E�E�Q�+��Ȕc���'�-�k�T�E�2�er&����몮������\��߯�?����2UXD����׋�m�p4�,�T֭(�C}��a>7�����mGb�����˲?��q��������4�	@���ڌ�����՞D�����,��.E�N#�$��%Sm~��QT��#��!���5���M�I就�T؆Y99~/C������ .I|��,�f7v��YI8�2����3i�:��m-n�����6�����tl@I��0����`�Wn`	AB���j��N�I*�oE��V:h��T��[`��ԵpF͚<�*�>n�
s)��M)ݿ�>�!�I���d4v�
�:�c\ ��������a5Z�7��5��R���a��#.Pzy��}q�wv�U���:�'4?�+R��� ��4��"�Qa[����y�9����Nj=l}��,�ŉ�x����M<� �s3��V�كja󬿧2�+��`&C���PFaE�Z�����쥗j���Z�I`����~ڋ`��7��^{�u��`�eA���؉mQ� "���bƸ=�l���Q]q���g^SVf=��TwDSN0��3�;�1���`��b��)���YW�qe�^������u]��{bA���BYlw���|NY�D �
_%0EZ�^ag�Q-�E	�*Ql9z���83��,ލZ�4'�ԥ�M��]��u�n$v����d	V�J3-���`qp�v9 c##�5*��*������^uW�]#y��=),�xa�e���Z�ZyCf�7˦�Of��A��7��:�pʹ�O��.J�O�'� H����ݴO�X'�޴/�!8&�oD��"0+�kIb�]�egc��������n��r���F���6������2�rF��,�1xk�`?
ֶ�zQ����îզ{�7T*YT�}��;����,q"6̰�}o�Gً�U���me�VD�'��}��1�*b\W���=�,74�R썝�����2Q����֝,��D���1L-�O��VP�_y{ԝŞ5��xO�^Ie尰r�DD�-�Ca�3�S��������h����}��8+��a`X����
H8؈�Ơ��	k��"~�al<��tK�!�?%Ԃ�M|�M������JS�p$I���G�	���|ZJ��y�(���tQg?05��3�/�~E��Q3�k<~s�3Gg�PĖ���H�,']�ὣ#"��yR�v'�����Y|��_"���h&	�"k�#�|��5���ֶ���Zh�'Rp�o��K�f����sS��&�pMp�B\Rf��Maa�T1F��C��Oc+�
����E�+ �}v�y!�`;���Z�7&=?�M͔|����s��dm��|It並�e�%ew#˟�39�^���E|�x�"d��P]�a�I���1Cw�������|�w�SI+z�2Y+D(r-��N��k��cπ�\4�*�ҼVG��{J���+����U�4F-��J�G/�m�l���q%��F7�P*&X��T*�2�2�wvv[Cw��B�>YD�@ag�5t�N�w��T�G�&�qD���ň���V3\P!P�W�(磲�a���7���8k���\�]bW�ƓEY)),Bݰ�K���i����"1�G�+vT����/ۃ���3�;$��L僾/�s�Qر�M������퀜4Vc'�+N��#�׉i�"�䴊([����o
��ݥ���%�"S�v|QD�����@b�Y4>j�v���x�_����;�b[�F���,����u�ֶ��Xe�����g��X~6N���a�U�o��Ar+���
�L�_���:9��Y�@��l��{�q���FM�I��`�w��e�bo��=�y�A��Gmh#�(��h�b�+�4���'��^�	r"H���������3��
��b&�a�k���&1DT��̠R�6�3��B�C�X�'X7�D��-���+	#��o�d�};�E�H�
�mk�*)_���7��V�TK������֢|佁�98�D��`��8���[�;�:&^݈�M� �3�-o�Oܭ5+,l^\��R!�Vx�;�U��"�8Kzs�k���/J32k<�jc�χ-��h��ׯ/=%.���I����k+
;V�֍݇iFH����2��
<ԏG���YOt�'�����U������uY@,Nz%]`�H��������G�?�Qb\`���gΘؑ�I��U+���<C�'�WXϬ~�ު�t��l;O��߉���ɹ���ß�M�ڳ�G��;�N��?pl�lO��5?��u�i�m�5�$XS{��\��W�J�q�V{�W�d�r�U5�!l@����/1ҷk��PcŰ����cŀ<��. @��?���)b�ñrb���k\kX�t����˻ag�RZ�m�0%W�'"����;�	�a�AoāK�S1 �ִ��i�'C�$�TX0Yz���FZcgҫ��U��`�Wv��@�(�,�E�D������
�:�T��H���JАf�o���q�C�e��j���|~qI������xiÎBԲ`X$J&1���_�¢�L|�R\�7�3*��$g� U��r몱��d-d���r�A�u�w���Ģ?+.������x��~B^!�v���Hbǌ
m����� �-������� ���)�lO�����P�%�&��X����Kqֲ�cYD�_v����hL��s{�˵�b�g/?��e�Qa�!�����q�R�    -�.�(��,L���:uU�2{o~�������ah�h�=!O�+:ex����8�e���棕�U��%�blՒ�}T\�)L<��B�d�@bA���s	��tM�
jP=�GD��I��2�,G%�5�PN��CJ��g�l��7Dķٚznބ%�>���cn��0j��^�T���>&�ؾ�r]k��T�������G"]+{z��(�o���x�g�3�:tE�\��^.���O[�<ܩ�d�݆��T���#9e$�%�X.�ݶ@s�y�����3?��Ro�6��fU��z��p�Yk�:�_�����Ϥ�Cu�`Ss��;mK��4�Z��K�v����c�Ŷ#��jN��
w��:ٸ��������¶Vypl��oP�������(��|���'��.�"����}{C��:�O!V�Y�B����u-��өD6���6�=���S1�pY;ǫYT~�z� ���\f�mu��ҌT��ll���KN���H�
�L�kY����\�Bd�U+���3��f�
;�2	���iF@�ͮ�.��f`¸{��QU�%���%��^'PL�bn�H��6�d��
�ST��O�6���9�	���YVW�񽰝��|�G�����8>��/?*���n��a������P�fN�YW��đxS��4�cֹ@XQ\��+ic��1����X�5:P:;�LI�-�
2c���q-�&ӕ�$Qm�����J�k���1Ҩ6F���P&O����$��I���`�/��O5u`�Y0�I3�"��I�]n�&�8�t�8��j�Ell���U��oeK�ws�3�Ԉ���ͳ����@�/�;n�E�?��l��U�t�p_����]����DZ�"�1*��KV.��禰���=�1��r��~�D�$2i������c)��G�V�B�,�x{�^�L��H7,v!���r�3�ַ��<��^w>ZU
�]��l���
�q�OWE�`;���;e���ÁL�snD�<O{k2�t���d)�\�͕tn�O=4vrbs����	?n"���#�7T�sO�T�G!:��E,��/�*��0o�pTJ�x�t��^� o���:K�R�}��0��؉fk��	�i�fa�@�?�y�r�0Ϧ�ڸ�>Ϛ9�-S$ۀ��L.(����벘��1R>�Sd`6�a]̖����i`�t�|fu�[�s��G@"]�4--�(J�����T�:ӷ$�����L#���\��pJF�2�oA8�r���b*���W��2��C����ޤ����\�=�y��b'�5�s��z$*���:1[����j�Xz����jg���@/w_~��ؔ�hn�R���=�󌫎��ry+�x;E��6�T��b�нGyf�L(����k�����ZԢ�n�)��R>b�y��1��{}D�1�[`mkk�kc��iv���3@��t�7N$6˯�L�oO�;	%6�J7,�I\(�5?�Ąa���W�m'�_Z����)Ͻ]�]}�6��������\�b�a��H�������1�͇e�w���#kf�8k���iM�#'y#�����L�r���0���aa#�E�7�ΐ�V��xh��s;c��s�e��S�>`}�������|�*��$���Z��Y�*�Bʆ�l�#��g^'���*07�M�nvo��FvЁ �
�;;iͷ��\�K-\�+��'G�������)�����.s~u�>e˨Xh�~�y�6M���Ob�ԭc�X|�bX�a�g^�A�Ⱥs��}�h]bF�3�Z>5�e�lf�����ڠ��:x�7OGÎ��1�ϑ��ʁL���z*�$���$+ZfӠq�\�1`�G�5r���V���ڊ;��<��	�aGsѹn�3)6<��Ǵ4bG�p�2$hAz�#%p6�w,��:H��?����j$p,S�c�� �����w>�a��G�
�H��QK�e��^䛩�+�ZP�T؉o���Sb�P	tgd����;%Ə�M�:2ǝ�8�O��t�|�Jr�����߹þ��H��UPm@�տ ��3Q�'b�
����ʩzY���K�}4z��F�X-�L0����+���v,T���XVaX)���S�U&D�<{�a'��Z�Tu�G2�n+�a��v}=V���.6
ڵC���z���}�����ʉD!=��eV��ŉ���l�2�9��'����r���@D�ߊs}<7?/_i�Y�p�8���2El��Y��Ç�]��+,�a�޵Ps����'nm$!�:��u'��O�Ƶ�sS�@Zbp�D��Ma��/檬w�S.����J1��B���24�����Cӯ��'�x��ŷ��6�%�*w�{��_�f˝~:��1}ձ��D��G������gUP &6�!�e¥s�aԽ�U˟�g��~�6�`���~i���(�f��u�)BS��n��u
�XdM6W�c]2FY���z]��_�0����/"��މ�zr�	�׵�YRX-���Ќ֭��(���]�,l��f�b�.�����b`WٽK�Y�\q gvg��´U��^yq����pC�����y�	�!%~�8����S�0e��q>�z	$�%#Ep�	eE��V%�Ew�"ks˲V�����i����AA��]%X��oa��l)�"��B,�^�EA\{�2e�JDY�y� �Bc�*H�8�*�/��.��c�NGVd��{e������5v̐�6�� F��6�}8�L ��dS�-Cs��[��Xa��Lgb���~���yD�UX�-�a��|+	��-�D*#�YjKQ�'�;B�������!N�!?6�M��ޮ�V�*��ę�QS��CQ�b��&uŪv
�8�;���^�#YκŧE֜��zk��
 ���2��0J0���J�e^9yS�������96��Ow8�.��NǠ��&�;N�Jo$���%�q
i:4v����1.^�8E;��ܦ�0��R��:K�Gi��RW6p���1��n�B-RfSװ�-,�A���޾i�Z�7_b�WTڑKCt��6KO������t�_��OT����7c�AaQ�!�Tw%d�Ҳ."�A�}�no���ɨ�K����"#w~7�����2�\c������ȶe�rw��벒/��Cq6"�_ڴAQX�y���L�S¿n:f@A�o�⡓�{�����cڑTȒ��2 �foX�Q����p�a���"����{Ӈ����cGO���8����[�{�-�e�G�Z�moz�(8�R=1A l��M�ǂ{�����(�$��v�N-��C���?Yov���Ar_4���,p� ��7�)Ab���5hhC��n>~w�zyO��W|.�o�E�����!�r	/o{r]ܖ��ɡB�8�ud�.�^ɒfwvp=ޑ1>���ձ���i���/�F��aXeI�*^�G;�,*jd
��r:ZZ�5˲r������G�6�$�m��U��)C1R}|�G���8e�S����#	u�W�ScG�œ��Iw��C+�=��t���7☆�����pX�VH��Z4v���[�ΈƆw���Օ���h�4��I	�w=]Q�
��%��,1������=���-SX��ES�j/�y��?4�^X��;J�d�*�+���h��;�݉wu�On#�ZT\}����r_~����!� �u�� �_�ƿg�8�ld��j��F?�&�i�0LXq�׊�y�Z'�N��N�#<+��_?�x��c��2�*@�?
�V�E�%���ś�gE�lڙ����&�>�\C��> <��� fW��å�2oR9,��^a�D�T�M���G�4���껫o�7Z
΃	�Ih��!]PX��9Y���x��m�q�`]�VV��񒳬�[aG~vȱ�"v��`�E���*�S�ԇ0�e����+Al���>��u�D��.CVV���+�[���a�;io������>��{�������F�8��Ok�4����h�D�����2Ά���>�(23!���E|���f�	�SeJ��RF�OR=ߨV�7)W�/*,N;,�p�M�k�R$t�uԂ��    0���V,4��z&���F��+,8E�w�����s��˱<��b��������:(X7�b��۰�?V�t:u�]a=e�K)����>���ȫ���FO�`Zu��{TZ���k�R���U>٘olm�(�U.�(D�)k��,K��������m��l��+^s2�*����:��="���ު�l�]�|����e�ϡ&�a�bK1�c���¾���v�s��{�D�� �b��R��)y���1���'O��� �����6P}r�So�N���NA�*���`�.����� ����>�E�5�]��F�A�lW�~�/�+�ݰ�ԇo��	U������
��
9RΫ�>�!����^�>�ϝ����AS�������:+���3�{ED�L�oy�	o�:�;i�so^4I#��y\^���Kk޿�H���	�
����}�2a[��� �E����ݞw3�����m ^�7����5i�����ֿ�F:v"BK'']=��O��/[vd��m>�H��}�+&5>�����}�K�L�Z��G�S�Fc'��������
�L��+��5�
�s0 '�����p�a��j���ӯ	s�$�I����WlK[��m��G�m`����c�+�ذ>�f�U$`�
DN��ԙ��Bչ|���Yn��[�V�N�:7�lmIϣ�Y`j3L��*?�>��f�(��~/������v���E���{3�[��h�[J��3�J�c�x��'��ڣ/�R�| rb��>9�C/�G���X֭�`� �1&G?�a2D�����4�8�@��A�(�Y�˂�E�mj�N��ڋ�N6T�ďެ���ڍ��o�fbE�G���=��ņ���<C�pHU�� �w�;�7��Xl 9�����j�g�)���?1���X_��
۔�����`:�me�g/��#��ƶ;x ���S0cˌs�R��#'Q=><)%�y%��*�Y�ky�
;a$D����*��(���u�$'��Z��e0���3�v�&����8��k�}�6,����n	��*�8�jk�V���;�����`�͡���.��f��:q�����vb��6o��q�9��^�/[f};�$nز�x�Cq�J`��j�iª�o���r,�+�ԫ�HUa'���~\#֕v��w}NÂ.��.^nF�=l'�
�����CaƜ,A������	�~^9���V��h-b%�mub��U���c������w���!�~S 4줃<0��v���s���>��N���ﯔ3;�A	�w"�� � �$gl������p0B�L)�rP$��{�N';N��Ñ��b�Ȋ���&�����������ʤ�w�YÎ��g�L�N�5��aL*f���d%L����z��x(,&�ȟn�GU�	�R�}&ѿꝟe��{YX��e��F^�=ͥt)Œ~�G�3��D>�i_?s}�"h#�Ǉ'̦�bO.Ot=�6ƫy`�|��"�Ё�+D�W�&=h�I~94V�ߺ~Vly(���̕}F��c���60N]R�˗B����Z*~����t*����y��Ժo"6�g�x��V:���'���
q<�a!K1��;�	����I�40^���'�ئWh#��XĿ!w!d��p8����d0)��ѝXv�Q�o��;����Pk�ɥ��L~��&4���G�ʛE֢R�]a��k,;#�r�b!��}�T?�|�{}I`�Л��$������F�Q>�Q)�9|*,���s��E9O��9�!D�A��vF	��#���Png۩��٦��`��x��ѽ]��gR*�R��@�=|�6���h��$��=+ѠS�E��K1�o}�9���ņ�/.��>|���|�Fnd#��?�B�N�q���N����|�W������z@ì/�x� �B�L��ڋ35��WwQ��lMi�|�ƅ��SS� y�P���Q������u:�J�	j=�(6��e������P �e�;����҆m1B���Wh<I���b��ݎݡS3����DӮ���7�'�d>�ቦ�}<k���^�z��BFԼ]lq75UȽ?W��Ǝ�;fv�A*�ހP;�H��1G���C�nz�Nb���5��
8�-c�K���m~ds���hL^ί��C�h�r�����J����� ��P�M!I^,�3���+|� ����0��������#%�\��'̼�2���Q�����U��E��g��%����5�0N����tZ��];���#c������2������3�U:��p��P�������(�M����H4>�vұJ�ӒK��/��{�k5�m�"�a�[BY|����	�o����-�a��".R��b�s�R��qp�6��1��+�k�N��C�A�cG���j_9��S�����C!���ڻ��c�bRW�p��<��h�g�6��N��B���V�ڴ��٭������wk��ʝ����zݷ����EHO����{G� 2����/�*5���66�_������+����Q>7�����b�WgQ4�$���;v��P~ޡ��E<�(]�T:j�ŢI���%�BZQ޿�����%�e7���iL���D�Ġ� ���n�U/,J��R�\2�zQi��Emz;��1��Ҟ��-Ӄ�D2,jl�e[�g긏���h��Y��2EcGK#�r_�q²�=���λ�!�hi[l�w]qd�WT7�_� ��T �Fa���'8qv���	��s��x��zo3[��8/����>�l�/&ڞ�{�#vt�B������S���^D��ii��I�@d4X�(�hN�RD�_a'���_��(WVP�?��Ȟ��?����e(���<��Z]��Bq���Uz/l���[��h���۩��Ԛ��t�A,3GE��}b�������,�o͠CGLʕ�V��^v�|���Jpְ-]o0�A�m��0�w��k���zT�WUdq0Bﮗ���>�,\5vr�Z4�|,��L�b�o�Na'ٍ�h�\g�r7NJh������&kM��#�$���l:�M�OuVcG�=2,�pJm99���v��@��W{wiE��U��.ͮ��Mp��^��&��S�&�U�+ 8��pP[
�&#�G,��Pz��N��������mX����
���v�&�l�8}�����d�;2���;v"6Y[�8�C�p��٪Ӧ���O��OW!�*��Yj��Em
�Ą���$OA��'79=w0��c�D�'#i����
;3]X[,�[�	�2��~����-�<u��ö�=G� ���(W��n�	v�j�Ы�r�(�&L�P�I�)�N�6���"k���ٰ:���f�z�7%���S��s�m0��[�4f����r�,���K��ad�س��;��,qh��ǐu$��(�ȼ�F&�P������8��3@�h0��k:.�gG/-r���� u�V�8�ȸ�z�D�<�b����+,��YP��el8B%la\�ܢ��|1'-ML6�
�&-!��j���5Ch��h?|��GƆ�hmM&r�?�QX+t�F\��;"W�Ȕó6"�Д��Ǝ�����9ȷiB��N�`���:N�	���
�0�`�en��:z���F��<swc�ag b���*<B�a�-���{l<
�U�·�����1� �u3'M��G�o&V����|�
���f��
mLb��{C�`�@C�4ӋQ�	9t$Wį�vҏs?C����V�uq(�j,���q�b`C�?����c��YL�9_�7w&ڽ�����TJAc'z.�&�
yq�Ǣ��۳¢�.&�{�zo�A�W$m"Y��k�Ɖ�8�9��M� �`L��~Q?9��d4YJ���݋$-���X˫(��v-28,�̳�W�+�(�G<~���x�@z̝\ֶ�A@��1����|(�d�`[�p �I���c���v"6:�uXk�����E��no,ǒ��⣲��h]������U�j�7�D�06>��'��dU�?�zEL����FG���'U
�S<    <<�`���fo��	%�ǣ��X4_�Ŧ\���p�gǊ�X{���2
�{���4,�����?3�Dҡ�3���׼���ͩ(K�ՙk�#|�YT���
b���Z&@���ila��P��F-<yQ��Rq�/�M9�, �Z[�����˲�"��b���X�"���^���E��1+����8�ķ"q��0��weSؙ��_�Ce%A�_ị�̫�"6L�ڂ��c�sExZ�e.�X�Ԯ%ӓ����������ֆ�֕��m�P�|�LM�O7�͆)'Ӈ�A���`�@|`G?��L�;��$�Y��+��Ł�����6�hɒ��e.��5�ګ�N��dz�gE#&��*l�=),�~I쥫��m���rT#�
�gE�d��:�N��5�9�o�x��C됕�諓�o}��|��l{�6�{`�F��|��O� s�����1�0%�y��;9W�O�M����H&���Xp��:�q�:'6�	c><)3O�7s������F@k���z�B��
wɭ��X�t�(�-D�����#'Er�Q	��P\:Gn�->���|����*{�[Dc{4�;��%��--�\t.�N�����ՕW�Nr~��h�pr�fn>Q{�X'��:��S�����٧ Ɓ[5v4>+��
qp��<3�Y�,w_�!���o�����u��xI��j14��N��1��2������pɯa�~�Q��Z1��{ct��况��|զГC� �|�U��$�_�avr��$��0ܣ7�I�{䷈�၀��~o����6Q���56�����:�|�"V�h9��kܾ�4�$�w7.^up����{#�&I�ۘ�E��az��F !@��2�<C��UXM��M��/�=�a'���1_�pW؆�b����p��T��,N�u�Y,7 �{���fj�y��C�ߙ��UۖB��,,��u��2k5v4�냣���A)��	���%ӛ3R��"&�ŝ�4���8H�E��<�p�����go��(u�g0�k��
j��2
�z_`T�K�k#�'�L�^�g7���֠�Djc�]X�`�����(�fGi�Z� ���y~r�X��lTntA�H*��L�׌熝��H���WOZh����ZL�hVO�L8�9��D�L�L��+3'r�B�
����"�N�B��
��<�����1Ԝ�êO�R#����/oR����m$�_��\G#�?�-�?�މH#x�sw�q��[ac�d���d�U��	�^��>8vQW��zN)���er)���� ո�/J�||�)6��ɏы��I����.J�dF���3��V3Na=�b1W�"�>%UdB������6�}t���rI3=e�`�>x�]�<t��S��X%���K�7�1XG^a�����ta�F�W���YV�ko�{I�*�y��
";�Am�Jէl�M���d9�4K"#���tvjd�99�����n�>�g'��\�J"�����<w��1z�F�$4�l��ʬE{�w����\5j&��GG\|t����'u�	�����m�Xm��Ӳ��0����M���Ե���s`̉m���?mC��� rB�{�j���g�s�Ѕ�հ3��|H<Ge�݅mRؙ���bA�&7��.?!3و���e>�>[C�)�^H��,N��Щ%�|�{��+&�	S
��N*�Sc��ݞt��˨���|�U�@���}��F],��pIX�G)���~{��pn5'M���0�V��8�q�����|ӡN��97�L������~}dmq/�[�qx��P4v��koe9X�)�,�P��Ua��Ku���H,n�G&3�+�5k�XԐj/BUnvT��M�ؙ�R���I=>�(4�Y�}�����}�>���ޔw�ƖW�����AYm�#���[É�Ɓ#V�#{*,4��k�ߛ���9dX�C�)�$�>��P���Ɲ��P�a��]^���%�aǸ^f4p���eɳ��=h�h]d��A�w"����oj����!ގ�R����s��i�r�4�]c��ZfpYL�x�p:r�G|��ӌL���$�[$��D��Y�
�92e�3��o���ڀsK�Z{�J2��N��夕�}zR���[_����D(�kj�C�sP�I~=3�,����+ü]��c�3�Α���
������h�7���]��ٚ���}�N���hlf�L(憲�&�~Zvc�>�O�Ǧ-�B����}��J��Y	R@e�ɼ�ƎK��ealc�G_!��b�?����F����<��X3<<�
�3L���<���^a�V΋�(P�^�,�(��«P��i'8W��ٌ4�i��`01E��y9Yy���o�L�	��IL�#�R�;������-����E��re����Ȓ��@���1֚YO,�T�ӂ������K�Q�B���!��5w�V�������m��#���6��Rza1%A�`5w9�N�WIK(���8�ר��uff=�,����p"z��έ6��>7B�W>+;���E�ʭ��
�Va'	���h��&۰'�(D:�9;(�G��C4WK&��e�h�\�LU�:v�)���s�ڐ�?�eQC.WoHf��#�X��r�:V!�Ϙ��z�H/|���Lj�dԺ�����fg�(\���4���D2�!S�=�ȍ�o
;��6�.�(�Ml8�ϐC����o�\�|vƒeq@���1-��Z��1��K1��$�������Y�k�X2J��27Z��Q;)�ɡ�h��b��v���Z��96��X�چ�M60��z���(w
6_�v����u�ee}�7��̌�����V*4��������zʜ�1Pu[a|�*l�ؒ �������s�J�0Gq���1�Y.�{��d�{2ke�a�>9�[a�4ƞ0�����;=,��y1�lBp�}0�����hM�j�a��FEQ�#���7`���N�ߙ�e�Ґ��2Kj$����9v>u9�E��5M83��ؽ"2X4 ���Q�Yz5A����3���_".V�`�E}����˛z�G�B���q<XKo�~_��RiT`���t�+,�?.ޘ���@���G4�&�6�Ǝ���@�g���;r���F$��_�̸�jl/}ހ��%���p�Z SI{�<P�W@`�V
�6��D%%��a<�%e��Ȕ�Dl���,�FE��ͥ����)����
"��*;�C�L	��>��a������h]���>���5yg�3'ѡ����di�`}k�Dc~�(�2���Cyܩ�K�E|�r_�6�.��i�<~ۆF�PvR��s'�?��Gae�i���.�a��^�f'Hm�,�Uc'���Y��<�������In�=$�e/!j�ߏ-b9�e1��+<�sg�Q�?�7�3�b������FI�<��v�}��+g�2\uX�m� 5�;ۜ���u��Ȼ�P�q
;�6gơE<4�rȅ��߈qh��3�=Jx�d��R�#G�*!ͥ�@�NWvD��\�T4vr�K��y�̆7`�Kg$�cF2�[1��+�g�t)._��|O�6���~w�;����A�\��f;�0�4�fR���"�*2�4�p��3[��V�Μzr�:ٿvR ����K�4iqŔ+:Q�޺��b��B�5 ��v$�š�3;�g���p�ޛ��W�b�2��-Z��3P9��*,j+�cp�-�L,��p*K^{}��1n���	0mH����"s�&��=���P���$I?��J�V�l~v&�6γ��K���-XKY&۷gڜli�N��X��R��b�I�m�p���<O�_;�M1����_{Of�ٻ��0v���{���F�[4v�6�CF!/�mJ�4�
+R�o�6��>�ro�$hEU�U�I'Sa(ى� ��^��Ma'�E�6�늬@�y�1K�m��^g�Qt���7���h�Ĳ���{`�P����PS�)u�+�_+�{;qj�(ev�/Q�(�0�(��yՓ�UUo��Ư���5�߈^��<�    -�"/�b_6O�=��|Q���+�WE�;N��p��K��7���Du�f���G��.�b{���x#&dx���84�弾��������8[�v��~z.@��>괸n�"U�Ngv�G�j�j���u}Y�,F��y����ܜMa'���c��+��E�ϫ?a��)s=�hM��DXV��C>!�A��XW��z�@h�`���TX���%fT�\X���5j�r��ȶ����	ih���&V��Vק��U^9���룠�a�Xi��	�6 ��XÃ��΢@8u-X��C��ߞm��(�Zb|/aW?��1$ee������JK�����^4Z��b7�d�q�F/�41�g�d�
���K��ܻ���d~мI�"��)l+��U���c��i��p����K��	�Ya�1#v�Ȍ��u�
�B,���E;��"v7�_*+(��M��j#�[Z�T-�������<�I���8�%���N>����"���1b��OK�[{�]�*%tudx8D쮞)�Uc'G�Q{�fN��%��[?�qA��Z��D��Nl^���*���$rHm[/Y�ƎNu	�c7����(�ڞ������$�����^�����#d�rQ�IJ��N�&X�q��F��f)�݌�œE�sȁ�Ui��-�4�t�ġ����)�r��B�Vͱw>�-!�:������	�2���� �rKȋ@	X9!ee�oW���ӨD�Ҝ%� *�8oY~��Y��!0K*����C+�V?��^�Q�d-�~�B�Q�N3��M�����ш�O=\g�,���tM�U
��Y�Va�/į�Jpb�Xy���6��Tn����1���})k�����|s�D�M��*d�H����L=��W,jB�z̢�NҺ%����'���*���UA�eN�]�;���ѝ�[�
;!�,)��?��
�r"I��	3i=^t��9��:� {-4���Wh_�=�I��qp�l��1<QR'c������7��͝P�2G�y��)�$5RXy,GO���Ʊ�9��+��9��A�(	�,N+D�?+�!������kXҁ�e��E�\Z!����~o�"���p.{{x��Sr'�E�����p^a=]R����J�Sg�����`q}��؉��Rc41&�Ks8Vfol�܂,?��k�Ca�W�z�0�MaR���pii����C������;��Z��ɮw��y3(�EJڰ��Ha��`�q�pR����$X˹�~V�������������]�ٰ�6
@��^X�L/0W��JT�X�_�W���$�9�nX������/�H`Y��ŗ�s�!^�e�9dN5+��Cc����z������Y�xcFIw4
;)_+�>{j��(KZ�q�>H��|�t[�4J����k��s.Nm+�Tm��=��˒�����J�S\�����b���؉7T��Lk�\"�,�Ua'�W����͑��h��I���P�F��^v iZ�����ڰb�B�b�AcSc%������#bɾ�~0Z��S���Q;!-��
ĺX[�v��JEau�4�=��aI_���mX9���z纰����� a����mX���MtW�ka����&
���w��wP�65���A��x�����%/�5�j�fl�ώ�2@,j0b("�0vF	:��,Օ;WYk,Wyc��g�CV�u�p̵\m����-��`�8������Q��Ը��f���x,��phc8]�^_�ۢ���H��ڐ�Mc++x��W�le@�%�d�xm�wܧacj#-k��W5}r�%�BI�V��;v������`M3�$dX9ùW�Ke|�hJ���;j�J�b?�29�����d��aQ���۲���N�c';�).��ǈt���X�
��GI64\�kkdg`[f��C���>F������.pDb
�������1�]m'#��}w�h|4v�X��d(|�o	�A��cq3l��Kl��@���i�̽�Jbc;ܪ���.��;�ފ���n%����y%���8��Y�s�b���x0�c4W�GmL�|�$5�f֢���V.����i��2\,�5X�����R�1��Ҙ6~��\;�q�����9��Ԋ7��"UYy,���9�@�yqo��ξ��O��;���/��Y���%�\���Qť�
��=r���};d����F��"1�.���;W������/�]k;�4��ӓq��8S�U�V����@��?V��ɺ�>���s�vbyU��#b�J%!�0�)줈�6R�#G�7of�c?'#
����jai�{Q�)f{�&l�tO�E<�m��1�RYy,�ms�(3-u��8�X2;���s*�ځ�34�3x���+�����-�4MHT������m��RA5�q��v�aIv�w�M�ҙ���T4U]X��_O2��S`������&\��d:Im��	�bb=�h/���T��f��<<����<ݾ�VP
�V�����R��h�z�Ͽ��v�t�i	�����rBF�34�9�8{���a����|�y~�ѵ���fkc*�?�ÕV�A�[{U'~��H{e��XUC�_$G~�c7�mQ��9�N퉝�'���R>{�Ɩl�]BX[m���������]c'2%j���Ó8m���}e'�С�v�?�I����v�w�äq\�����U ^�����\�Qa��úKׂ��G��4T�(z'�?��T՚�4���﹍��� ��uSs1yU��y�͢3�ݼH5u����E'Qɿ�UcK���(�z���حON�qw����d^Dūܿ�>�PLLN�*��NL>�Q�1�BF�d�E]|�*��:���"��a�DQ]�*_�9�!0�(5
s��[�S��d�R�='�e���P��OON�qERu�L�sWX�
�dw�Ҥ&�1a����I_���y�^������>��O�F��|ٰ;2B�E��O�(|X��p�����6HŜu��I�.���ɟae,�*��a��N(j.*7�y80�\rW �~�Ǎ\�ؕ��o��|d���2
d���+[�8����>.�����^r��8��$�(��&/fN��v����)@J�Q��Vֈ���33�tKţq��(3��SNЮpA/�,j�S���vi��H?����
F��SXVL,!xs�S��6+KW��7��ꏜ�,*��֡�2���d��x
�)e��h	��,�n��ҿV�'I0��N��h���-w���_u�3�h��#��:��>8!��{�Y,�4�z�8-��%w�	��h��[��,����������b�u�� uh.�H�.���b��Z4����Ȕ�y�|�n���aQ���`'m�����`=���)s����vfH׳�ޯw�Յ-��)��Ɗ-����/��;��ڤ;�r��.����W���_XL��p��lL��7&*<��	]�0V,"�r,�U�P�WC�� =��5�"���s+���	�(� ���UW���V�����p'����2A��:�3�Wr��|?6��ĵ���.X�#�Zݹ�"����[0j��XͅJ ՕȞ��Ȳq�ب��o/آj��ä�7UA1�^��\4K;jc��	w@��C0-Z�@��F�<js�}�9�D�f6��<�? W=3�_���~�`|ֵTWj!!N��P�~�p5뛗)ʪb�{�� �
;�l�E���onEka�\��1�]�������[�I^�/�����`@)�]�6�Z�ݵ���|�:��*)�|��|��Ď~�`9f*�q-qU14�<N��>�V�����{L��gQw�Avl���]�����]��ɍ��2qa����;�E뺼"�H.�ܠտ�3�d�˵���L%1��Y��ˎ��c���zA)��t��k�w����,�j�ll�+�"�D2��n7�5���=�����M�{��"wP�d��:��o��|,��"��@;���FR�T�S��y+�:��{RG��XM���\q��A޴����hWq���7�*�C�x*J�e������*��(X����ո�<ĳ�q��T�Go�Nf
bT܉@��    p>�1��3:�g��`��ͭ1��f.�ɟv�-�N�&�y��H���>���$�^����z�<X����ǥ��x��'_K6�7;Mꪰ#�`k�Z�u*�e-!��C�M�ñ��A�v�nCw�0��%`��+,׺8'.�u~��=7ra�L��9�3�X��nꂆ��(��͹��h�Υ��`����f��<l9�F�ݥ~B�3�ٰ�C>K�KA'5�Na]l5�6�z���K��6�a?���ð���.�vQ�ݒ2Ɩ�٪.��6�N��ɽ�r�G���Uر+J�}N�#�SB�<N����`�8���l2�<��jHN��d~ݝno)�]��]�[�#����5v��[x1��C������V���,ɦ��D�i������s)��C|be�
Eh���f
������ �'3��<���u���}&�M,dE�^nVa������w(���p,B�
��#�����N{��pN�A��@������*�S�n��q� ��Tw�3����a��
���D�^lxô�p$RU4��Wr\������I��`��v�HNM �tL��D�=`���Y���	��š�H8��KW����W^�v����
<ћ��Aa#�c-���2y��c�W��r���xR�?�t:]��dk�}���XmH6$��/;�V���>���s7�Av�.lhfz#��W�����l(�rV���cϽ�] G�W!�a6;d��#��c��/�5��{:�	2�l������va'N)��r��GJ�����G"�1O~���M�����·D��ܶ�|
����J�N��)k�7�6�k�F�Cu�֏�?�<�iD��m�f=��u��X���R��qv�4Y���cC=�n$ז �z�d�)�c1qJw�E�R��8�z|5"�.�c��`�o����y�Sa;c���뽟މ�E�	ъ��hL���{ak�)jq8J
45%5��k�oq�Le������'�k���`5�v�d*�?cʂ���iS�,̏��ߑ;��E��v��E�]��~Q'�/�O+�����_)��ҕ���M��ǫ��U&*�^�%���!t ��<��N�j���a|V�}o��2�5Ђ��}p4<ޤ�����ڙ�d�]�H��bТX���~�7͚�SG*����b�B�V�h����%��Q[X��2��(��=���Y�aW�,9�����y���8E���3$q�*�Z|�R�$���ئ�s�Z��]�a���G;���3F.f����������Mv�ZG�\ϰ&�>���c��<��V��*8-dҗ�M�©��<���;F�z��W��Q��ag�z����c|h���G����(eZ�dN �ȭ��~�/<���l[�5��@d�2f�"ΑO2�^���w���bm�^�d�fr���L���4�`���P��Hڇ�:ݎ��z���Em֒~�|���,�����n�æ26ۜ:g�`XE�N9,�,��7X�, ��0����/�ZD<���&�� 8럵�>y��T����%��R]�h�mG���l��٨�+[��C��E�+����s�G��I׀�?,1~)6���S��di�'k���/�w�`6�H��pf�2��-8����gdd&����J)NȖ$s�hfc���̩$��SD��!�l�J%-8܀Ec.J�y������9(���*7~�Ύe�m����a,#�;#ַv��0ه ��HSv�YZ�6fqK�����
S�����Q�lJ_:�*g�2`�2|�з�(�'h�J�?ln�P$s�^syP�a�E��j����Աa]h��ō�#ie89�p�����{��>&���-�+�4<[0��\�;O	�jAN�wN�#���S���{ߗ[PE轱��]�+�֏�1���P�;zD���A�m�{��e�����psl�'��<�/E)㐞�)�{
m�����ze�#G�<�0*��.k�UE�vYc�����v��#����L���l��"^���!a1P>rΪ�ع�fI1��|sK��<��4t����+��3g�7�f�.�hV)ƅ���/�.G��
����?֌��)��qlc�d����1�����o��`Ӝ��bT�@%��Xr�S��I�٦S`�
H9F���;����.�$v��lU��F�1�W �1��K��`Y$�T����n/K���θMM[I�rt�7|�{_�T,��0�e��"���P�b]^�]��|�`���ɨ�a8f�)3\RNO�AB�<��W���Bz㳚I�Z&�â�̇��F��+I
�8k�9_��R�HwH	�П�,��a�w��
����]^<6�scML���rq�����8�aovXL�F̚ػ�`�8�y_�x�,�B�;��Xո���?Ǔz-D��n������������bY��V��ɭ%rx�#�aH!~B�1=�mN0_�}��+;>��̀IPXH�GG'O�|)����E�|��h�ޑr��H�Q�ABWz��n)�*�U��6h,u���)!2��ݾ�-��T89( *K��NW�$�"XRGjՅF80�]%�}���`$|ێdl��c�4�����������JKy��vъ�Z^P+>���5J�UE�!PM����}Ӝ;�b0n兺��O�4���������j�Ag=X�6�Ⱥ�r!��,@��L�l�?�?�H�u�#e �?:��*�'(��ȥj;��k)@";
xLa�z��\now�Zm�CC�H�t���,,�L�?WU,��c���x��}P�hU�Hzx����ޙx�{����-���P,��,hMHRY����Ǵc ��;^�ڪ�y�?����Bl��SbuO�S�Ÿ�Ʌ�_68PH����rV��d�l�d�5b��'�&m]�����'|����t?�����U�Lc�N�F7r��O>=���c�7L!��|��&�;Iq��P~��Sh�x���v���?����b�/�S��-��ⴌ=X�@Z��8S���q�c:�$�^��ޱ��#v�l���p�ʶ.��N~���Mࠪ_�ދ��x���.��t�0ԆzT�$F���Ο���JH� )d=I�ۻ~uh�c>%{s������VR<�M3����5�F����4���<7���/���NU��W8�HS>��DS����x�9�7jN�扜��5�m�znPNvB��Ȣl5(���p�liĮ�`���a&ہ��A��v$���g]W��E�ԫ� ��o��I�W_߂k.ؗ*Kpp����
��x�m�̓���vl���w�&�n���G�F.n���{����9*r�;k�6j-���4_>�����n_Y��s_.���8i|�7��w{$69�2o�σm�6�rܝ*���5`Ǒ<�f��9KlZp^��X�M�p��'�O�s����{gwz��1��l��&��?:�Z�2�r��>�Yr�����RHBB"�R$�����T�)�Q��HxY�W�$ؒ��4S�3umUbmF���\�B_t��T�bU�[����X��y1�A�).�ެrq#�*QC��QA��E���� ŋ���jL�Nʜo��85h\gŐ[�#vq�i]�@�2
�A׀E|aa�O�#2������z�i�)lW����V�u�>��P�ێ9u$�Ue3D2g�β�;W>\h�-R z�{W5�M���>�I��ui~'��-D}�_��;�D�o�u��E$P��IX��C�N/�3E�:.H0���ʼ���;`�_�=4��H($� ����UL��D�Ł��1��,�b>�7"k�`/�|;V�B�SlL��d��H��:,G����]}�@����7�� �b�nQ�Z�m����E��>����s?�:d�l���������ǚP�g��W�E`C��@aW6lC޽l�KK�<`�2ka�;���M6R7Z�[B��#1@�)'9e�G'ȏ�ŧ��_?���{����V�Q8Bb��&�_���:b�C��,A�}(�_�n�yS��Lֈ]�*J    `�!�%9]�	���Qt��a�]��Ɂ^�5#vx��+���������/����r�hx|�C�q�Hl�3)��ʟ/n�l��K��xF�K.g�,�pW \js*�ֶ�2��L�Â�m?��`��:G�ZFd4�Q�]� 6	:47�T�?���g&��³M}�0�Ȱ8`�<m�\_1���I�j4_<�\n<;P�d;nj�1`4+>���$�Uċ���������X�<������w�9-B�ˏ���Ъ��oJ&���uK��s߬��㢎���m]:��yqd�ۋ� C&�-/%?�wq
RW�VM�Z�Ԩ���y2�-m�[މ����������*O�MJ��^J�p����$ʙ�+-���#i$I�svA)v,�@�̫"Ɛt��o�����Œ��)� �����cǀ]�����C�J���܂�x߹����"�5����8:���3@��G���&]i^ �x\_q��9�LM�@{�"�������'�7���'%k�Q�U�Ow�ʱ!i��������5�.����d�Ů`6�}�$%z�b�9��h�D�R7�^mL|����{M%��|m4N�>�/�X��5�cs�Ød)剮H�uc2�����r�6y:Z���;�s}P6��!���U�� !���؛ IR�k���3|SlSc��?�S:
�;RO�kR�-eC�"�����H�u�!��^��s��N�#{��cxv��vXOYe[s��x��t��^d:l��{����"t���?�die��6	 �@��{�I�PRpg��Mo�̍d����<��|�����C�ݦ�-[��i����J��ͼ��R���#[�T�VT��E��3�wޝ=�Ǒ��v�(��tO��}�`.P��ߎ��.��o���*�G��9#���#��y�µ�~�I��(X���]���.�V�%�Kdz�MJ������t�	��	zi�0���Z��N.�Z��pv'WZy��7��mA(����H���aZ5�����>@E n�&��y���Qiv�J�HZcҀu|V^���Q��,����YB��7p1@�\?x���� �pN�	HVG�|Dx*�g�<���w� �6`�!�"�u�ک����+޶wm�	�dO^�(�G,,����lx5����Nw�iY���TtK�u�ӲNg����a�L���|w�����/�6׎�-ծ��~B��''�yV�#��#���e�!���H1&�[�a��t� ��U��9��۟��_^v����}�L��L�U73����z�g�����Sw�}�R�F��g(��&:�iU��$˾��fG�'R��֣����'�$I^� u{�%�NZ�0.�X�����܏��\��G �>'S�]�x�f����(��1�ϩ�E)�|b5OO��:�z��B��7�B���iy��JY����u>8#�0;̀%���B~Z����Yp���#� �>�wq(���*Q8L�Pkxl�~X��[}�ʽk����4u��Dr���sj�Yh�wݓ����j�$v����bq�f�'�S�qQ7]#Ϲ�{�ǳ��9j�a����k�.�sՂ��6�Ch}�-0Xr�?��sf-Y����oVA��vb4i����U�0�N�F����p���ӹ�d��#j��}ں�E�.�����;�Ѯ[��r�k����Nj�m�ũu�6�Jv���u��-7�SAި�3^��Tb[�Lؓ,Gb��qᷝgGW�b?NM�1$<�] U�삈��_��P菏X~�����W݈B��O�S�e�F�b�M�B�8�#cR���ߛ�Bb�,&;U���!��w=�܄�M�H�*����H�-�/���j����M�����Qr�3�+��e��;��Ћzg��Z>Дxr	֖���Jfx}Q�~OL;�F
��Y�z��)_����oFP�?w���=%�s_�Ћ)7��w�q�"�7ZL<{֖�SnG�c�#��AU��V��$��.P,��B@���G�s���G���)��{Q�R��+<F{7v�B)#!��gٲ���ڻ��[wV�[�Mᎂrk|ʚ��fQ��^f^q�sc����������!6�O��6=ϪhIE�Q�U!Z��vi�.6�ܬ���`9�kܧ�P�������&nF.��n�y���/��:u�K�͑5&��˘���Y%������M7Z���OB�{9+� �������q��*Ϲ_�]���W严���]��I;t-�ڀ��t׈]� =��r
P5�����s���K�߿Jm;[�
�)����0�u�;���E���ò���@��]�+s,;As"���sm�Ki�_��m�.F�|ms������8*�oJO�[�k5yZH^=*>��|�?|J�CM�g+�O���z8Qw`C}m�acs{���F��gy8�y8L�+�,%�xC��tX*�A(��h��R���j�Z��>;pm�XX7oU�Xu�#5�@�G���f4r��<��`̜ie�v��-����/m�3VhH�p@n"t��:Wo��`Z��3�p	a���~�H�P�fy��~X�9�O�Lٖ��M�O~��Ah�ˎ�F���1�翔���-Z�d�����q��z`5���r��Ͽ�U����M���V�ٿ"NJ:9�%A�)�A���y�VYw�H���;���^��;ge��cQS$M�עr����r���Un�pv��C^1���H������!ذܭ2�`o�T�m��{�çY+4aG�\�
�J�� H-�ad�b��k�r�Y�;#��9a�D�?�F�����9�i��ly�����҃�:K 9&o��0�w�X@���^46��O����E�X@NS�Cں���ӂ���{�ѧ��=q�.Za��c���F�A��]{7�C�B;��T����C�g�c��بl!K�\�q3鶦â<g���y��s����Op��'��e�gF��;��5�#X��8~k����,��$ۄ<�B�y����bo_%'�	tft��!�Q�bN5x�
ė��r����*(��'t1����%�*��;K	�1A�6x����#v�`��n �rtMk17�(�(1k�'}d��2`�@�q�+2��������ݸ�&��������'Y�DK��Sq�1`�.������u01����uos�.����#E%NDƠ���Gb�@�q�O^�|��>���by�&'�� 5;���G�w�(9ݡg��D,8�M-w�b�����1E@/��ţ{G#3���Vl�l�C����
�����&��	#u������>��pO톐5�M5�_!7_�ܩ���B�k�e�΋�:ɦt���V׎�a�r�ǟ�c�*2�P�#X�/��dA��A?;Z*GYKn�.��!6�L�fy,'��u�/��R�O�M��`KiJI8m�k6(v�����(�pp�4U�,(t�S�}���&�v��5B,�:(�:�j�]��)�gZqȿ�Vv�.6�(��b��'B�~��\ҽPs��}�reQl-.Ve��X��I����`%�F����nvH�m�H츷ۺ����4_D�D?`A��s��F��Ttul��Z���6�d|���GHM��3���^ﮫ�)v���b)�@�]�y���g	)�|Ӄ�Ϙ<��4�7vP!w;b�zT`�Y��Ȧ+&�)�e�߼ ���İ3��/i��� 9������!�so؟��//�H,vS*�*$WɔU�V��b�┿��������l����& ��)��.<�Lf94K��HS�~:��:�|_��H��f�X?�w�����*6r��7�\4��/�T�=;#vq���,��y��wZ{�BbǷ����c���qn#�Q���G	�BM7�2�\{��8(�a�.|!7�q�"^س�[�5}K��HJ�,���V�Y��(���K	u�����,�%�/���&��TY���vXER�ϗg�����B�.|�ˏBN`iZ��6R	{%j��Ǫ�\��l�}�XH�:�y�Xt���p�Ƃl��f���]t    �Ci��Ѥ.!��Lgd��ꮎ�Domٲ���}���%q���2�eCGK++26�޶����4y�������/:��l��*g�2-�F��9�Jڰ�oi2T�H�q��Z�.0���\��Ԯ�V�°�L�w�W���p�ώ[[����,�u���H�B|%(ϙB&v'ٕ�g�_�K����InMRW��A��>j��J&��-g>�
��4����ɚu�.�����$����KI~��j�X9�h<�g�ڊ,ECੀ
�|
{��RX�ب��1�wL48�u����hPB|>��L������4�C����T��D��8#��od�Y�!��&�w]t���f��~jM�>?2�(q
_/4=�m��]��G���/�<1����e�\���v�-����i�]/��-�1d�^9��b.[Ӽ�$��}�9ƣi2K0�(��񗾼a�8�#KϞ,h��o�'`��.��H݋~�P/^ԩ�u��a(�t�!�\eIP�W�~%�rכ��L�U�Ӎ(��*:s�s��e�N`��cUH�1�;��W\�u�٣�+�U�PIN����&|2�.]F��P�����IN�3���6A�	�Jv�DxF�����^�bW{�3�;��5-@�ʾ��awܗBpD`߯Г�k���Zs�q���Q[}G|������Ǜw]��#�XD�$s]ۈ��?��fIb=O"�P9�~�B�&����\d���p���S/*9"a�2v�J������%���l��Fn�]S�C��^�/<����OL5=۵�~��A*�mby����-�Ѕ���{�}�)1�s�"��9�O�B�5��,���[�Uw|��ݞ����^?��t�I���;*[`���-�ʼҗ�O�����r��G�o4ҨJ�|��þ�B�?�f�:<���~,f��f��@���	��������V�m�}�b�"�[p��m�9ۋ*t�����ײ�}�2�S�b�,����������܆�-K�Wx#�#�#�.?�Qk��	��E=���BQ{�T����5��#�j��������E���L&w'�oOrL����4���g�4Ҡ l��FIG �:����fĮ�k�c��Q��^���BB=���]�8a�䮂]X�m��g�ȼq��m�[6Q��ӧ�X���Y��2�#+�D �����]R�*<��q�4-�A0,����}GYlMs���̕V�=eŢ��3�nnk���Y�3y�c�]�*jr� �g�$) ˬ?��<n�'���FU�� �@�E��l�;Y>/���y�	9V���S.�x4��:�r�fVjb�\�E��!�x��+)���q�q��e�w	O���B�l�O���(�w����I>�{��4r���s��,d�g��q�vis��x[nrvL3q�]���X V<4�I�Cw�XO�,	�MH�,ˍ0���S<�����U\���I/��\��v/��"b�SA`[���]|��2�׊0���Pt��	vd
�G2yJ����"8�#v��&�Pʙ/{�׼U|�p�yβ����V���u+9�98��+�P�������������� �p<i=,�H���~
9J�H��#v�:�@���"_��Iv�FX��>��$��G�ҿ��Y���Q��s� �;����R������̮�'�����=,k���Շ���-��>�0z ���]U,����'�+M.��a�l�q��(
��p��[.��:T�d�]y�a�id�K?�ְ
;jC�a1x��]<��t� V�H�mzq����2T긏	l��-�ʥ��g,��3]<~����.�=B���,J��J��H��-�v�`��6I��ɽ אÅ7V�Y���oբ����|��!���ؑF���� {�M��x9�{NN����>���vج2��i�}t�X��v���^��F�;ޅg`�2�m�l̬;�l��n!+V�\Y��}��_=�0ˆ,�w[T�-���C��z�C�ˈ]���Z��i.؃����ǀu+�`��A�g.�΅��W,ҝ���nя�R�]�җu�p���ү�۳Z�E}��08Km ��yE1 �x��Ⱥ�mz�v~�IE1���!?�Z�u�n*%֋��m�x�|%�b�ñ��!��aG�T��o;;�h�&�ڍ�<������`�I>��ßHU�] 27l*��D��x�9"H&��۲w�B��}�������]��t6�.�2�
#{�nm?����H6H'����m8�����#v�S�H��~�P/^�F�m��t1�[��H^r�'�X9���>���6�%9|������WL�d���ԋ�m���ɶ[���Ʀ��@�E�uf�蒹i�l�$-��߻�JZ2�6���>H����-��X|���p�s��:�%Ol}x(��O�L�D"���M�Z�	!�I�r	vL��JX�t��ŉ�x���$���Iu�%���r�;��Q�m]��ȧ$� +IC�@�99�9B+d�����*�c���T�K���� h���A�=
}�y�cJ�k���8V ���7L����z���='׆!�ϟT��f�=�z0)�p�U���M{����?�����0��6�R̀�ݷl���oT�����J:�j<,I;,�1��z'%ժ����a����ϗ/	F���m
��~�kF(i��A+{&�k�.����ɾc��/�$�s�B��B2ع{�Q�"M{�f�FQCP;@K�҅��C7��蒯wt��U*�WjD.q	Q���Z��tf�>���LF�c�gۨ��,�����-ڞ~�v"�8��/G��;�.Sh�(�'p7P��%$Ŭ+���mʕ�T쑾���0="7b��6���ϞFx���5^�0;���_���v��@�%����Ͳn5��}�F�/v46I��{>%i5�\	I��p��#vN����#!�i#�Ʉn"֓�}x�)�Ų��(�엒�|�,6�v�c���V����/��F���/3��]�g�-����DK��8��E�:ŦG��+��A�tX�̧���J��o6�s���L�ހC/vd9fS��CJ�,�p0��d����;��SlP�#��"M(��3�.�f�Hɉ��׳۟\St�S���b�-����0���$H�.>A����=o>ɪY��� bEN�]�W��}X(��k���.�AEE����m�&�a��;�N�K ��,uCV��K�O���������wLRƟ���]ПS�s�V�y����H��M����b�t��q[w��S��5��;s�����u/��%�t�:��;�9?V IE�Ɉ���Tv� X�b�C����9�w++w���t���)p>���FQ���>I�Þ��:��Eu�F�"��p����ӆ��d G�p87gd�I�t�Rn�U��h�E�|�+����˷�]b�XBq��7N���է��TH%���Z���֯h���bG*�7!ׯ�}��QhH����m=Y��E���3�#v�$-�q1���|)E�L��\e��byK�(v�ܐrb�����`�c�b�(�D�OOmd��t�-q��%��V�w�>�Hre��l\Sx=��8X�s3q�b�j����]=X��l`��X_��{�jp�/��Hnk��@��
�rE����ꈝ���4#փ�B��De�bM�\��@�����T\) �e^���c�.��ҚS�dל=_�uT�*��R�����E�<�=N�����L����Hk���0I�H�lR,��c̫�l�p
����o�WŮbiխ��ۙ/���Ǹ��#�a���&-�?{�ǤcnyƢ�+gH����6X�c���f���/N�	K�k��g��:��]=�<3t\5��\N�|
���M/�����}�P�'U�2���|g����̞��� >��=�а3%'��.�FH�M��a�~�b�+�F峠��p�Ȟ�REb1��?���'��ix6�h1r�ӝ+d�8�������ҵ�Xz��\Ꝅeu��e���'�����)\KY�����L�	&H��.�l�FDr�� �  �@�ѿEY��J����}KcW^��ck�t�ʊ]Db�B�u��d����:�uuFd���uB��"�kG�Ӈ�Z��ݪb�����;LEKY�g�q��;Jٶ�_��d d e��P�q�ܾ4Y-����M���	���c�D�ҍs5ۭ���h�<���@��q��>`D�l[��v��uK�m&��_=��P=ά���	�&�:��ja�u&�:���X*k�8"]ElA��=w� bQ�.�d��B�,Knu(���!�6b?��$�~$"i�'�ή�dƈv�� [�!�vt4��k4��\���7�+�U�y�����Iyɚj Aɪ�����Ʊ�G)+W�]\��3߳#����$u)��;h�U*�QY!�bǱ%b�Ǉ?��"0`r��uS�",.f�������C�����zOF�}�U�m�F��s�.e��Q�i,�9�������S�	ŬJ��1�D����}��C��w�4ٷTh��M�L��<W��#�.v]?`���g�7fy�7J]��o�Bp��ޗ�\;,jd�a�<���mؕ��Y�(��/�xF�9`���Gs�j��:�K�Z�O94�����g@���݆��ņ�Y�If�W���z 6�2�#�\�g�rh�'Mj��nw����d2�a�Ķ��iR���f���۾)���Ia&���v1��C�����"�����g���a9&w��H�X;"�_u��mb[��r\-t7��C�����[۩^�\���E���k$x��h4����!�i��"S��p�!o(>�h-�.���kdֆ��t�����u}~��B��'�N3�h��T�8�7C��W�o+D���#Z�UX"����$FW����a�X�{�O��`	t��ݩ��U�9b��',Q9�-I�94�,�@�IN��I65�b%�gb&%�8kY��Tg58P�F*����=l\�}�Զ��d%l�'���9`W���"V�L=&h��ھh�'���WE�TВ�:~%�Ol�Z�e���}�]�L�bT9+o؂�Un>���{����ӛ9�Y��7��"���T~���� �8�01�B��x߹���8,�Z���y��a�bL?�c�����ԂEnl�B�+g3���{���.ݎљ����@�1Au;�7_BF:Wrn���{b�)�q���<j�g����v���̗���i/��I���1;������:٤�q�0bo;�ل�Y4ه��{7�F�������#�Oӧ�b��؋��@�;����zm#v�α�+�a����aֲ���<ƒ\�5e2��vZsn��Q�Tȡw9�;/�3�:�W��o�O�TDE���ٸ%ގ�E�[~��d����8`���$����khuU%��nx}��\ h�'c�X�'�/E����+��L�u����1`~J��(z.�Z|��7�� �F�"�)��C��/���  ya�C�o(��U�@G�	 .2�߄#b�#�+�t��e���h&��7�6��q��̘�;1���<��q�ʓ�,M>�B�1צL�)�Q�H4W�j���	�	CU[z��]p��������D�P��#V����{��?k����c>�!���p߅M�]��6�σ�b�iE��%�o.ڶ�$���\����t���s��h����t��G�%�Č�E]�/N�x�Q�;����9h-�)��]S��!�vy�Ou��ۑ���G��I�$߂��4E���MwA޾M��E�����I8 x�hqG��I�I(��~��d�'��T��çZg�s߬qJ%/���L��5`�}�-����i-���EN�	a�;���b�:�w�|8p��X�Eu&��1�Hk3�_V���
�����yζ�/e����dq>Yj&N�#Y�����6Жz�C
Y�1�7ZDm���a0E/^��Q��Z��:P����֢fl��C��/9:����#��߬	�bc�S�b�~H�.����u�m���m)��E�ر���׶i����݌#vĎ����l�Z��7/8�֮J��5�V��N�s����!e��Vq��q'2���^��9�!�a���aZQ����,{*>�c��srxT��a�o[,n׌��|BJ��ed�/���Rq��n)h�"{8��BE�����d�~�K�Gu��	5��5����y�3����(v�:�Yum���c*����?p��%P���Ő2�3%�S�~��^�+�m}�c������Qv�SU֒���I'�`>P ��ۊ�N���[�Ω}a�92Ŗ3Xr����g�bW�u�4�tkټB&��HV��q��\�TK"��}I���Z�9�!~`1�f�BW�m�⍛^�4L�4@�i�l��6�!���ɋJ�W���Uy��&�]������Jhן J0���1�~���:|Y)�ėN���x'���.���q���[��a�*,���������\�I�"��t�>`#{?%�g���8Gq�/���d�Uh�w��yI�13�������#��*M��a×�,^�A_� ){㟐OE'�x��b�_�x�;n����O�V3���PF���[��	C��eG윁-O_3�=��xz�تz�#�t�i��rY9b7��Qw��N��Z��x����]�M� F��vtyVhn���䞊`!WXV�A�cyDj�Pӈ��K���Gȋ1�l�h����������?��+����F�,W,��d�6=��ڐp��Jt8�LY�s��F+/?��gyn�4`W��փ�LM��˯��f%5u��bgV|���v�#�X�9BJݼI�˼IQ:���u	j,�d�;��x߬%29B+��Q��~�u�u�[t=K�"[��'*��V�?ᓬډ�4G�qY��X��\����,���gc������IXK�?�|��uK��e��2�ύ�y�ݜ9�._P�:�\*��O�	�]5�z�jh*6|J����TY�!p��t����+�������.W��      U      x�3�4�4�2��\�@Ҍ+F��� "~�      _      x�m�]�G�$���#�t�dd|c��)u�TkEM��=�V�,�/�J�ү�fд'�gu�: 3������ݕ>v����?S�eW�nM��w�|�J�������O��1�ƕ�{�p<w��������9WB��v��v}�-u��]���򯯛�.�]vk��G�����a�.���W����z��]���t��������}����.�wK���+n�sn����'�~W��<�Ƹ+���_����e�-x�~�����]��&��n]v~�z��z^w�~7.�1��~W�Xz��n?�j����:x��^�]�viٕe7�ݢ�/����tw||���������]�;�?��%�Ɖ_g�-�a���ؔy��8fwӴ��n��;?��<l����vn݅��=���N7����z�:����:~�v&��ݏ8�ӱ����������|��j̹vc��"o�wӰ���0@�ﮗ���O���zᙗ\+D�י�n�L;�vn䏘3���9!X�1o6)e
g*��%bC��}7�OOχӵ���r~��j��+�?�q����]7^�~8\��8>�?^?v>��B�].;vòs�?�yH�l6���Le^��C*Y�;r�qQtE��)�?	{�ŷT~0�8N��]?�&���]�usH+wy���:��L#��&�=��;��B�����������_h���6,iׯ�\7�=����'�׽;��~;b�}�})��G^阩v�SV
㐺���x�v��;u.%Ws�y�ŝ��Ղ���݂�<�7���#�W��>Վg���{<ŀ������~����ݯ���xG��� �
�w�s��7:��6����Э�����΅c�C����vS��y�$����Խ;~��1���ݴ�e�lλ�Jv(���|y<�q�|_�O�����\���s�.��g\p^:�н9�����WH��˹j�8��'������[.����|x�ク�}����4p��@�4�Y��>�"Oחǧ��c�]
>���x�D��JOB=?}>\O�����O�'}{�`]�^t��ˮ�'��ш8ܶ�=�W~]6"�xޢq��9Dܪ�}���)C�ںQ��P�{���
�@��
`?��a�&>bH\w����|<v?��8�KW�U�s���.���9sc�H��;$�W����b%U�~��nR-'s��`eh�#�u��&��r����L�����l.����e�5B2χ�q\3f���VcU^��c�G>_�0\`����|���
*9��'Y�24I�b��� IY([��@틏���G���!�O���=<l\Ԃ���K|�l6oX�ng�18˞����;�	d_sγ�֦y��9򁡺38P�?��ݯx�g�烏v �ԯ^[=�e#9y������x�يB�C��{{�lݭ�B>0���w6�G��y#�Bװ��|1�A���B��/L�P�n�3w�����!#*�d��9��[y�������n���|�v.C������@MG
JN�[�E�s5�g���]�8������
[��+f���!ٸ?k���,T�1C����]���8B�X��->��5~t��YA��JO��y�s�~=��ڽ�r��z����ؕ=~:�u�zL���a�/_^�!�
��w|�D)����&�\���\����u�}�e��<L|2lJ�j��Tst
(X��cjv��������-�^yj�j���������;X��oS�Y��� �pW��z>��V>_�4	8���]��®����u�;����|ȭ/:<_��I�{{��/0A�/���z�Ë_�m�f���_O��)`�_�(�8~�\�����GG5��*3x(��?�߸�!�<@q�x_YO�PY?�o����w��(�p����dt���L���7�G|����3�����H�ә���T����Յ.@D�����ﯧO��y9�^������pip١n���n����SC�Ħ�����S\i���u�!N����25��nw�8��Lh����4��d����|8h�������x�W�7*��u��P�#h(�������+�b,�1��T�p4P p,K䁆��� �<&��(ӳp`��.߹��p~z8|�r�
�j�x�h儖��f�n��M��T`N���<�.��4���n�K�qf^j���o;��t���-E�X�C�+�6V��pl�7����7�O�W8���O�Jja����lm�Ϗ[�ä@ٶ�48�?�ʰPv����*~0����a-p��Z�)��m6�D��7�{
�]�2�lVtҭI��a���[�&p��Mڌ���T��_���� /�Ѩ@��.�����_fvoB���ͩm��>,�(��;�fY �,ԟsϋ�����}��˟�ʿ��ig?�̓��V�T�.�3��i��.����k�x���[�k�۾ۻ�cP�������?^�O�XC�p��S���)����������������R9����V�~��ëA;8���}������_/�@:�4S��c��e�#���P��W����~���~lBP4�~��5C�?Rj ������.�'?Sj��f��# �l5 p�y�X��Bd��=<�B�`{�.W� �!� �8��t�y���n?�v����r���wp_qG{�9�?8�=U����z��3u?�$�����A^x�n�!h�ԠF�g�3P�Z�;�7�)#<S�Q6�$�|JxnPٌyT��a�!d�@ҡ����7�p�o����bv脅�M�:�O�n��#|��.A�f~�t�Y��������h�3~�fdO�D��>\\9��}���Z7������� <j�,����4��G�RX���K�R��"8�yrp���7ژFO���Co1�\��g��UZ�ȳ��[����1��[�����p�fŃ�y)-£�,4m� ���$��P�����S��'�ԓÍ�݅�6�����
�/N)���\������q�Ks��aEF�°��0pX�y~��(�u�*t�,�¶�H�	*��업U�*��T ��SP�V�B��!x��
�f����y,l�JǓA}����b�g��.#�&m���*�V����.�_��zh������}�}��q!����K����I�� �pS������ż?Ė���N��Oݻ�#lR��듢�-R��j���"a�{*�9wo���=��O��e�;�
�G�91��^���tG�m�\��J�)���9*~�?�pr��\�a�O9��`Gh]8oq����\�{s<}���@�r�q@ |#�~L"<������OǏ�3�8��A����Z� ha�ح���ϴ�ow�_d{���.%���!�mI}�?�c���|��(��C�*�����O�ҍ�F�9��6�Y���	�����3̔�x���!� }Ï��C�%�>�sf-tk��Q�n]3B ���?�EAH�nO1��!?b:j�����ndN.HKgЭҺ�A�E#��I�Q�gޏڵg �_�z��p5p�0�pc!������%����@��3�m�E�v��E(��U�c�ϗ���>b`�eRPi���_g_�2:9P���źy�4جDK�0�nT<����~�n����L��6$�[��0��H��R�nM~�������G����.H��D�W��9�����V�����h,�_g���e��������������ݱ�J��M=]>(H�dy���V%�����=��B�\�\�st�-��M-���n忧���U1J���P�,#?�?��v>��6�=d��	�>(���Ǹ���\"!�<+M{\s> {F��Ri-�����{����g!=�u�K	�M���f;!3�%���E�7�mO{����v�mЙ'2�[�/�?頮 ��~<���n�{w���|=<�>|  }��8�U>4��s��C������	����.'�j��v2�{q��4E@�����|"�n��e�Jj$+�    �fP����0 Qtz���/t���t==>2U1��p�!�e��So�U�]����w.�@�籷NɥQ�&И|�9|>^����|�2�ʀaR�J:`�脇������||~�0	5T��ă�	� �s�j���Ҵ+�4�؇���������%�T#F�ř�i�6AB$�����n��/� h$(݁ri�NX�͐Ȩ�y��[�̍��,4��M�1SA0h�Е��[�x�X�J���Vo�F���ڿ�n]A��pgpp�{���*�kѩ%%���T���d�6Peҥ���DY��������z<>=����l4V�S��o�A�^񵅷��	�V�3S����W%�\,8����	\��{oa�pF_}���&t?<��*8�=@5Ă�DT��($��;Z�.͡���f�a��y
800EQ�y1��{A.�O��nU�2f����\7��{��EP�d��ۼ��=&��+���� ��.㻻��"�i(�d�V�@%1p�+�@� �	7����y�lQ�B���Wz�׿��P��zo������`�W�Jp��μ�ͨ����z�3t�D�۟�3RAu����m�)�Խ���pg��EbE셬x3Y��E"L�� N����L,��c�K�D�4�3E���SUg�����������+�q%�pn!��^2z�2�����?O��������Ƞy�����veqU�"Q�g������<~<2T� Z���爴�|Z�����S���#,�G\�� 	�\� ���p]>w��p}�%�q�M����V��_A�2uYkķߟ������?.ݐ��|�a�@�K�����|��� s��_Л2���M���;V�u�}�¶�� �X�7� ��Ň����BdHb/�w����B�y�����E9�e�� *>���׉�����������(�� �NT�)1��cH�I܉�^	���^�.
)x��H�����PT^�{{��r<w�L/4J���wJ�1�w�z�Ob��񟐁�{R�p/���+0����Y�?҅f�^�n�Z�?JM�gxPo�}��D�cP)���M����E�y�6���]R�ͅ!�
�y�Q�f��|:�7��,W�q�!�m"H��U�P�4�aq#vj"M���糸(aU��70��u{����V�Hgq#.8~>T ����_-��z�IX	����mJ��B"+��-n��F�ͅ�7�����'�:���):�[��S���2Qc�~{��Y
�drrԝťԢ�V�d�^��,��-Y_y>�z�۸��Y�a�ݝf�[+�t�2k2H��s6��	t���#��b��MG�ی�˅�.�	��Yi��Ɲ��ٴ�(^� ��[�rd��:�bzj��^�	�4�B��-K�E�����u�{����B�i��;�"��gc����X�	���7Ei5�F�n�~$E�{��:�$B&�r���p=S�Mԉ���n�\��&
f-|R&�<?t����T]��#MH�)���������p<ӆ�|y~a�%}Pڂܕ,^m��D����r=��}��&L�p�K�5���R�G兡����=���a��#�~.���EA{«�? |�h�`�i��]ym�s��E�p\�=ޅ��O����E�Tp%��+��a�.Wµ����3�~ 7b�d�@��a� :��I����Uy����Խr��,����`��3䵧� VSN���/������n(������DX�����]Db�Ф�Ѕ��� w(�Rh�w$�QyAy��X�o�� #\Llie��f�[>����9���u��*��x��y�]O�2DZ#Γ;h� ��O�afb�as�XaV���8q�mb+%��բ܍~'5���y��(�u����Z��%�zR�`%F��Mb���!���Y4���[��`z��o�E���x}��I6iT�(������������r|$S>�b�Ad�~O,�xE��Ew͙��בԡ߲I�S�z�y`� ��ȷs�eZ4F��k��E�w�^����~�p���P��@��Ps�1$�͊ȉ�!��>��/)#	�r�g��͋MZ������y1�B��$!��V�V�>�J��;ؼ��,�����s2+���k���6[����ɍPLq.B���>zn|亅�Y�6�A��n�W#��H��y喗n9�}"��+��H�%R�	0��|G3�8v+\��n��}�2�	9�JX.�1�@|�w/d`��Hz2�I�fpAfp�2���|i*�� �LBʳ�ˢ�'�OO�_�����
T���kSIDa�>=�C�I�t��>N�W�����v>�j��}�,�m� +��W������WN=�Sزc�
����h�Fj`�{�Hz��B#|���,����)�4_e�כ�ݰ,Z<���\z9� �rJ�Ca}�U��Qx��b�������6w�c��m��^�L�<4@��0>�EV���x�&��ٰ�v�+���\e6�����D"�|����x�vՑ$;�K�.2F��2;���h�����Y�Qň�B��L��6\�Yɝ��w	���qPg��DX��pW��"/�W�YL�8�|���a0�?�[�m�V~��"NtpV��h׭^kL����������G���7�JN�g=������`�O%Ӭ+��=�3T��"c0�p�&�­V���6y�à���cɅ�_eN���S����,��+�a8�~>~9��?�]!|�O��m���WQ~Bjj�O�x:|>=��_`�J=y�d���Ou�"<F�{8A�?�Z�c���x�8���{���{�nk���� ����_b�K�����������z�p���s���Y�`/Vn����~��V�z�2O���o��d�r2��I��ߏ׏�s���>���YI��x+Y�Z�;aC�����t9��l���� !�+,Q���SEW�!���������끉xیo�+��V���zx�·{%6|z��~�Ȓ��RÅ�Tp䅝�P'����?g���&�0�p�B��@��޾� ��OwƆR���O���T�PVkN�Ai�J� �la6�Y@��0*R� ������ӳ(�0◙v�/N�)O���[@�2	�]��g]5�j����}S(0�m���cQ��̨us���&��a��������"c!)q�n�rTH�if2	��uk|z:����r�p�yF�F<��[J_�'�*���AA�ܞ��,�����t��r�Э�Y<�^K;�JO!A?�I��2�ڳ�W6(_�F��F�2��_.� ����Cf��2QG����K[y,��J�������,P��ۋ�A�T�jӯ��,�� l�(/ʫ_Y��4��� fN�'�oձ��o����H��烸�5%c+KY������4�:E:��E�dg�����G�j�;�
Y�$K2��k0a'q�F���f6�Y�/b�=�}����qUQf3+3 d���e$�W1p�7L7kGc����ŁX�cADKa��a�����V�"�G)�Y��<�)��Q������������z�2�7]/_N�?�91|��%_����q���[��@���q�%�a�G���Ù/s>+�;X0H���x	�a�s�`���{�I��rC-��;߬�#4[��m!��� }V����-X�+�̄S�^�o�#�*O  ��������Ks��~|�f�/�RBl��0��\��C�V&O���uiG=���^�&�H�A�x��V��ܱ��\ˤ]c}+?�cV��P��6n50���xܛ��� 2A�`���}{xTR��p����T�{�m����M�[Bڠs��/�n~8>=�f-��W����̼[�
���`#��������Ι����$}����	�������#k��ʎ���� ��(�9��p�/Xy�
�*�-��� A�%�8<�7qf�P�Uhy"{kzU3�" ���    �Y�r=܉*^I�J"([L��STt ����w>�|x����!'@�H]P�Z|���pM_�p��j)%�\���Wep�����(~��|N}%_"���1��[H4<x�@/�R�+��
O�N���qT)����3��W�լ8���� ^ ���V]��[�<�E1�}�#��j��hj*p`�w�Ezx��N}�5	�L��>�����U�HCT�ԇM��r�Iq-��h!5�4f�V�ka���R{��Eq�'r�n��^f��/7w�BfVPF�E���~�*b��\��B�31���+�s��[xӡث�ud�r'�w�>B�C�=��(��������?���ʥ�Ec��ַ�/�J\��S�[X��AU���!��~���@{HN��y/y�@"72&���!{�b��>���$q��r}�~�\�O����2y�k#'��?U�7p����>�1+���t}�{�+��3�e@5B�e�IG��
��M��Ԩ�v�"�~K$ܷ2^��d6z�Y3�� t�z�i��F�v�N��ʰࠇ(�K��ċ��3�@Q7
��}�5L�+��G�^&m2�����^�Wo��dM��*�Ӟ/c�~PB��a��V�"}R]�⼈�F?׻me�&��^�S��ۋ6*���Q`�o��"-��l����)��]�
�z� 0�����#[A�t����-�ǲfBZ�+@������F���ET�鷙7���{�{`ςu-��w�����(}��w�J�G���+U��������L޳s
<w�o$O���Cٿ9I��b Vd�L��7��P �����^�8~�B���x� O�;V�iy�н;�>����Xȶs�*�F�&��(7��X\ �[�zd)r�W�.o+SE�؅���z�X���
��4 ��"RФp�S�O��[�n�
�:.�A�o�*V(~ߩP6h��Oh6*K�+3+<�\'�e��+x ��E��LD�����@CH��l���e��R����#o��-����c@�,t���a��oh�#e�������T5:������;���tE��Qr�F>=;���}�@/�g	�Q�x_-Ы��,V�Jl���n�0���ѢAo�Qj΋�B��﷕rx&�Fn��E{�u��#����tkv)����UT3�����F=��Z�]�7�&�[���"�{aA!@�*��
��Ȟ��+�O��g�H�
�����j
��Ck�"Q��j'�������˙^�?����̕/I/���.<��܌�u�^�(����<�Va�Uu�.������i� �����|z��O�C=xv�ȸ4����EuO#3븱ݧ��_����~|���f�T,��
��3��-��k7_����L,��N-+׋@=�ޗ̀קg�ˏ�/��Sa��*�<<w~Y��۰u+��Tc>�[P<���x9�D�<�W����$e{����Jp��/��Lu+]7H�'
��c�U{О���,hf䪲�H�0��m]�f��b}�v{�ޗ��`1�j�T��+
=OR��~.�q0�|&Q�T/~5+8�5��j~�׏�K���]��%�[�^(O�z��+P���������c/�4��wV�0=��i���	O~j���}5��l~�b�J[�]�C���� �*w�&}I.�E�R�?��ߴ�a&?sX������wQ�CI��%y�,a^��S��� D�^Vq�k5ocD�JS�q���c �hRx	���}l��2<���������L�r�A`��[h8GS�.���]o�+I��5�(S~��T��6���X�+�c�
�ν��2��J���:�b9�~���
� �7=k�j���P�A_�>�'ֳ��P�.���,�4�K�C ���\*�>�Τ�!Hd�z����,�yO¦�J�3��D���y��Z�.
��?�i��)���2e���նcU�h��p����%�,rR�<Q!Ł��߷߳@�ňe�r����k�r��n��{�欛"O+~��{U�B�b���¹ɤ�72�o4U
$�N�_���
Uy�%������ʹ&�CK���L*�����
�*Hp��%>	�1���3D�i�=׷�UbO��*=,~[��Md�j���m`^}R�V�꼇�'2��'���z������ke�E�� 7!��_��Ͽ�Y'o;#�砮>�����ؽ{x�~e��/��p�~�rmR�H��w����1� �ʍ��PCs���Vq� ���MS�T",�*G84������W�*�����*�^%%� ^�W	�Ů�%Hf�Oq��������Y���lXl�]�Rf����
H�-�r@�k�`�^1�Dř����6�FO�U�Nw#'���ᬾ}9���%Æ^T���;j��X�I��7��	�8��DP�_%�]E�o���j���|���Q]^�x��e��֬b�ȇV����ؚ'�|)���  ���+�x�X�z�Wt:�5�#����7�}'��ֆ�����'2:Ϋ�ZO�i�:�;���6-��-�/�Lz�m���O�1*.��.�M��N���(;s���΁�n����)
��h�N�p^�� W~S������	bǶ�se}2����Q�['�"�`� �j��PM,��E{�?�k���bݢ���i�X�������� ��mhO��蒇2��6�P��q�JU�n� ��|n"�YE�!|}����T?a��"q��6~\�ń@��j/&������G3�/+���|?�6�m�Zd
{���Q��7��X���=]�Ԫe����<\/0������.E��֣�� ����ߓ�0ߟT�T���4�n˰�/� �~��&�3��$D��B>+����"K[��C�}�=�L��UARڵYA��k���O�ju9��\���$�`�`�*[����������G�ׂ�"w>�@^Q�$�3��Rk=f�l�Ԗ�!�`� ���(VM�{�ά�H��G�`o/z;}��G}�9[X�J����~��eg
L��虅Li�
V�޶�^�_f�[��f��ͰFN�J�A��6Ţu��X�vK�YX�������[�k����hhQ��� ~�\?�EԶDw��X�,>fR�߉w`���c��}��Zɱ?�B�o�~��0�_��ދN���:J�R�|)��$��|Q����p��"*��5���6m���YQ�^u7����u�k7�v�����;�vv���Q���APS v���p����Y�I<�:m( ���Kcþ{>�>w��D��6a����
��ߟ���j�<=�D�.�fh�,B;c�*6��u3 NO������O��]�V�T��
��8��~�;u+����q��2Ni�^m����t�	c#tVs�:�Aѫ$�Y� 6HD8������Z��^Iv�I\gE}�賵��Š� N��3��آj��>|�;r��A��in�(0x�6\^�	���|�?�˫Z����s�V&х��2�̓.[��o`�F�Z��S���^��n��ϴ���จ���]d�� c�^����|/���xOF�47���M<*��"b��m�ś����r��1�bX�T^0�/j��u��Z��>Lj�w�'e���Yv΋��#�p���~9��q,�-�W=���Eل ���"���_>1 ���Ut�&�8��ݍ��OO�����vt`���ִ�f
/S)���F� �)��4��BWI
 ;�����-Z�[���"�6W��9'�ůFP��6�/�O�S�G7~|���]+i�U砀hU��_ns����K颅�Pj���6.\�zb\K���<1�7Й�Ln�S��כ�P�Z���gTyQ�MUD�"*j�٘����,�cPƐxC�o���f��b1�+;��f�#�޽�z��٢c��N��(a?�a�kPItJm�H�@H�*��Ų�h�&uk��t����mձ��j<'�J��M3z���"q��n�^���    �����.�W���~7��o�ɡE9�"w�.Zp��tQ�[h%�E
�^/Ĩ�֊�TQ.���7އ�m�\͘�
����D�Ri�s*r�y{ԉ��l�Ŵ<j�\jE��J.�I↭TܩĦku8�ѓ���xar�����2�J��oR���ʪ4Y�(rP(=�e4����M��nݙ�Md�_��Wa��)�-�cҳ(R�[?0�[�ߠ���窘v����%���UV;Z��s��3�H)k�)0���*�v��I��;(?�����ʌFD�Z�1F��ʦ�6��������ص�^0vxxv]��;Ɯ��G�3أ����DZ�8vDҜ�U���0�'� ���靹(�-��.�M�s�y&�:.�¨q���V�>�!k����c7^�ȃ���l?L�*['���2n��#�������њ�T9&2Ǫ�hzp�2O7r&�т�,�3��_>l����ݏ��i"�~{6��	@v{�C��(�C�*@�K��"�<�x"�2�Es��Rȕ�˾g��2����4�:5���9d�ߞ�_.�p�\����B�cƭ��Z��������g�	��R�)�VAQ��X�Baܤ�>���"s��f�~�� ���p�x6�!��/�<�4�_$�,GZ�gSYhea��dw�"ͬ� {�)�C�H�M�Z���o�fPNT&`�m���~>�o9~>1^KQ�h�4�>��E��"
9kFUnE�J���zR��6ɰ�(DK�oF�� g5��S�1.����;A���|�H�y��K��ܿB��$��h|SAII��X�T�j�ۦ�ʹ�����4�ph*�V���S�����s.0������I�h�Ǩk��L�l{�M�ʐ�R���X�ѭ��+���fcz5h��Ҫ����0��J���:Xd�}�����M�f,jY��,<���\�&[$E�e�7�u�:Q�rj6,�ǖ�o[�YN��xd�mf����
!��T�a"pR`6������S������j�a��W[u��ƽh��V�P�Q��9.�<�U���a7ثZ�j��VO#��b��@�&������n���]3�;���wL�J50r-��6Z��X��6ʨV���Z�{�#*��"��H$؈@�=�j�,p(���9�S����a�U}�b��E@�<��P��MG�������s٫][�ͺ���� 2��^�tɄ<~��=2_7ȤQo�z�R���|���v́�΄/��Ո�h��Z��r�5��xӀ
���p�@�?�/>���J]���t���'|�����#���ë�Օ�Sb<o	2�qؗgf�~<>���ާ�z�I^��P�2�������-�3s������4\CgV���nqA��fm&�7u��ଧ�Qwm~�B,lQS�;��	���}��z�q����2םF�>���0}3�A��e�"��/�p~�|�~�|��8�I3\���N�ٴ��}�n-㭎��'+�6��U�1���Uq%��X=So��"��n�=�|Q��m��n}�Y�	������2f�gf^��ܢ��d��Q��U����6��Q��NV�a��R���}��u$̪K���E����֛ǨQI�o�GTG��c�B�o=�U�R9O�,v@��/�Z/Op�~z~�?��^f��F��߲��^�5��7�[\Ko���Hg����8����.��%�e_TE�h��t����e=5N� �A�0/���e�pm�0oPy|�5�r.O���U�-Ωhe�i��S$���G�BK�%�h�z=�w$��k}/6]T+�I!�n���j�&����۲Ÿ���	3��i�,t�g��gale
i�>F}Y�5ٌ��l�INǨ�E�Ӧ}�zobs���M�o-�H�Q��8G��Y����;���q���n����3߳=aQ��I%%L��義2$�Q��Q�)Y(ٷ�;�u3��ױP�!r51c���m�E��R�f�pSǰN����+�$�Z����Qjn��L)�M�5�+�3���&����t'q���M��޽W,z���⬽�� 7�TA��$�TpV��o\�dq���}E�零����´��`� nc�d.h��#��T|Vu��gv-YL�"�z�f^[W�������I�|yR��F�*�� Z�xآ$m�y�\��6	S��d9�k#����0( �,�Ǜ{Z�ff�:Y�ˍ�3��^F��i�H�Q���"E����m4Ŭ޺-��Hd��"�����������}fFg��_��?ƪ�*=Y7�
#9�T����$����V)�YOhi������w*�MK�TF5�cS/�M�,��n�����7���F�z\Ҫ��ď���F@f���rdQ8���|���l/��oS~�mJU�Mq�2���{r�-Qqh�35����d�Z���^� ���Mq�s�S�F/ē��9'�qQ��U�%��XY� zR��!�T��,�Qw�J�$��h4&.F5�df:�o_���/'V��k,R`�B���,N�@*�ͬ�h�!�[�G���Ӆ`<YH�ޝ�,E�j��l�Q)�"lU)]R�� ٪���-[H���^��06O3�nfQϤ��'��.[N�{"C��K� �ӏŝy�~>A���`��:�<8�F�HJ���}ǁ����z��*!��g��C��b��F�t����&�ҁ8Ž�4v9�>�����+'��q�ڪD��Q���s�<�����V9�=D�U3��Ⱡ�)�3��1_����H�|R�MXn�	�_/���X�g4{��^F�y��X苪.8Y5�g�c���#v�E*�lq,;:I"F����m�+����N`
�=�0�%�Q�SV!��z��>Ȍ��~L�i�N>&2��AAM�`��Y#�@�����
����ر()��ϬB���J�,B+�m��[C�l3W�wp��F����A���p�	��"(�Nu�M�	����!L��KG����U�D淪��y3���B��:��T�=�a79>���mR%��(1�����G��w���33�P��"^����k��(l3�+.��lW��e����#o �H9�ȹ��p-�7�������&�xuj�٦U:nG����bOQ���T�0���g�ވ��āY�,�$U{�o5>��f�my�a��]!%jR����_^���½���ی/����ͳrld�d�z���f� ��o��3��%���y�ת��
E���҂�A�7Y
�n�^��>��'�&��4��o�y�^Y� ��ɱ���	���G�͠xͷ�+E��*?o���,��mV�b�����[޳�[�Px�}szzb����� x?Z�BW�l�R~�
��m���g8��/Wڃ �M���T�I���1��3��[w��0[5r-<KB:A�%M�uo������p�^���S��m�og�����Z�6k���z$��n�{�����.G8Μ4��}bF��%��y�4C/�����gR�6$��	Z���@�ڹS���>hr/��e� z�Ҡ����~�wYEx<~:�(&�'[#�U5ۚ+�gd��u��s����?�d���5IJ�7�^�g���G���~���������omT�
I��6	)�7!9��{��y��ƫADr���������	Q
���
�N����R����"1��g�3y�U5�m�������U��J�f[��+ɟM�j����o��^}I���ZX�9��^T�U�:)�y3��Q)؉��I��O������|�x���{�M�p�Qt&u𒉶رh�e��e
�?g�cuN��0�� �0�^Ś+MUQ��m�aPp~n(y�y[�Ĩ�'Ė��c�ڭ%�k�\/ ���|CVL�X�wf�3x<����Ύ\�{�&^�z6��jm���ǫb:�.n���C�������[~U�n�f ���hROF���]*��I�6'F��z���P�{�t����03[ԇ��3i����镏`{D�Ŏ�-��8I� e�d����\`�ް�*�q,��k��m[{�EϷ�V�s��1���F+T�E�m�oߌ    <�w�\F�[l��&���0�<��֖Z�9k� sp�y�}7�`�4���������E��b���f�Y��D��b[N�8T}RƂ��ji�@9� D�`�Ou��Y��?�}*��)*��:���IZn%;x����mfH;�~�l`o��>�K랡f1�kv��6)ʹ˳�u	X�܋T���tM]�lV��A���4t;M���d�t�u�o2�{���fة�����Ud���n��Hj�@w��@������̗+�D�Ț�aE�oUS�l��mPk��!^�d�h�ŷ�N�WÖbAݾ�E)�X,k���	_��ʑ��nhV�Sk&�{�[g@m���1���/6�g��M�EmY6�M�Smh���7[*U'�>�F���:�������q#�M�QW�[�����9A-?��
�N8��pm���&��$l;��B��_ɬ�3�+ �p8�ׁs�i��O��U(¨wt؞��>l5��-f�m2�H�:�� e�*�g�eh�l&����u�(Q -��ׅ�}�~�\+C
�����Ss��v�5#��I�P�fؾ��f��"^p�B{�[ֆ&�9�F붍��e1T46�Ϟد���'Q�*+6��6)��\T��2rm%��Ȓ̕�Z���j��^�pk�4C�#��n#	��c�0�R6pKp��D���uK`Q�kцy� ƺ��V5�g���|~�a��,�����s������m�Y�co�7�����_)�wL;w.&_�q SB%;U���UJ_��!����p����(r.r�*$���j�@�1�?﻿����$�����t�2�#����ɛ/!UH���h�\u�����^_���Gz8���J��>������Y��6��V�F�Q���GH�-	N���i��-�E���� �U��V���ꪱ��k����a+-�fi ��F7*z��K#2-�xAddJ��҇o.V ��3�_4է|��s�t��k��7�+��Q�JY���-�o��{r��D��q���m5@p���$/�Xa��:�&�D�Uul�U,`�~�Աg�k��}��xyTߩ�����
<�u����G�BSd�g�/i�`u��%��^��1hTO�"!]���Q�U��X	�#���^><�v�m����UӜ�X���z��&E.q���2\��1���Ô��M�bw����{�µ�������V�
�T�"�cn�XJd�5��w�Ͽ)�Sy�آQY�b����܆��Kl����n������G!F?T��4�RYX�-I�(ѵ��Q}�Ķ�M��C'�p�4�HOdi5^�x����bܬV�Nee̿Ro���r�I�T�7e`�+��l����f�� 9JA�m�f�"���XR��[v^��l�ŋ3�WYw�-eKB�j�=�_#s��|V7�k��7#���?QUȞ�p���9vo/�a+8��3ݫ,�ŋ9��΂5��UG�/ݣMG�>ϚH9�fX�&߰}F��$X�5�^P�(ſ���]�1E��&�ҼW��]�+R5dL�9p��亿}Ѩ`�Xd�*�=j2G��<δ:��1�x�]�l�wr�/���*���<?�3��X���b�^����\�zI!��o��\^�x�8p`��6��[���R�\ؾ���&S	Aļ��$M5Jm�P�qo��4���]�?6+
�}�̔U�̳�͐��z�&q�V�d �������Y��W
?��m-
��䥵�S��j |V'���ç��,�;�eZ���7����tQt�:ʔM�ޢ�jL$�d~ݴ��j�ii���m�
Zs�И�u�M�6�0k\]�jA[����*��h��MJi�9�-q}K& iR�U���-H���'����Y�jA;�6&��׵u+UC�x���������=#E�QU�8z*������YY�V3�Pm�m�R{6%\�=��KP���Ȍ,qq\�4PQʧF�m�&�4�*���I\����*b/����6�Ջ�NP�L�ַ?��U�����
�o��ش2���b��uw�װ�tV{�Y�9<;��:��a�Hp^�fٴ����ob��'�jCً#�S�lY�D*�|J֪2�u���ɽ�_���6�Ms��([p����g�˿>������|d�k�=�dz~���j8	�s0$��H�{ ���Ad5�`��=5{y*�B��T�{U�[����i �2�z�BV�[��)���s\�d�<���D�>���G��W��]N���H3���c���jSa����=�^O�	�����y�gr��Q��Y��{x��er��gXݵ֔r��tD��]�����;�e3��1� ���~'�����`�5(LH��L|�w֕"��pzV����Je�s*&=Oc�Y=��P*���F�ɑ�A|�'�{�#�k����n��-���{vN`�$��iu Jp�q{���O��]�ǻO����iikk�6n�X�[��Tݻ/�c�|�˨d;Cc��A<�z�5���ԛ��@C䓢������[mV4�6���䤀�Y_��~8��*7�Rhx5D����$
QYu����BuS.�}�7x�~�Rn��J�6{iɯj���6�cUQ2Fع�8�i��ËJ@Y`Um�=.[=|��T6�6���m؁��mHx�v\9��R4�G���t�6.&kX~O���_�⼰z��Q-\�'��)�%Ĕ{����b�����4��űy�^�嶭��Z���Z�]��q��iF�нd����&����^��^�e�TJ�T�эI4Y�V�;���"1˓��1h�ڋ&�W��Zp�&m�7�x����b�]��¢9�5o��C$��C����}�R��8$N�W�r=�����s��&��xQ�3I7��fԵ�;�#��¶1wJ+ACӹ���j����Yκ�m�棪�Oj�a�M��e{��_a��ZX�5��T�>����u��)����mv�w�����^y���� (�;�!����yt�$r}�(
�Q[I� �"�Z�q*�}�i\��*��?�T�ln���T�i2�=Vԥ��Z���2KS���"a��o���m޾��j٢d�i�<��p�9p�5�ysxl��H|�����`V��}�H_�VRgq�g�Ʊ�?������ӡ{�������2iQml�hbi�6�ـ���r��?hJH�$�&MU��6�����G������������8��3l�x!i��,�-�p���r>=�ލ<���۳�~3C��C��������bPgU��\j�N�U�_�eS�G��6����فH�k�վ+)O_SV���+����v��aZ5C�9�U���Z�n(,��ny��V�D�ؒF|3$usc-͢Q�iff����D�p���onf�UÎU�?`iw�BDI�Y9r�f=��'U�Τ)����uߒ7�Xས��=׷-7�RBE]���u���Z����봾A8��IQ=_�������H2�W����VV��r�?�85?�E�O�����A���,l��$��b�������{�i��k��'�Lq�Z��_��gΝ�P�C<�iȦ�=b=m�;�E��	�O���������tdC����o��=��j՜2|9BTYB�WJ����+ �Q������	
@9��ۛ�o�e9�{C�'S��ES���?��[Z�*\;��7ֿ���T��&N��۳'yA!(�3�ns��e��g<{�������9���|�ek�WF����nq��@Y!֤`�o�ط		jp������*C�J�F�#c��M1�q��*\�6ǭ�sNlx�Hz�[�2��l/�&�X��\�Fv�R��I���Wʹ���U���qw.D�ߟ��{O�9�S�-0ze����AMr,�9oIq��)��a!ypO�6c��)��d��@��s?,$�խ��՛9n�떆��]QMr�ơb���3wjdpT���I]FF>�j)8�\���N�%M�xM�}7|;풭C{	�
�0�/���x�i����A�ӑ�5V߳'`� �$��������r��=ǃhz�n�����D��A���v04�X��6N:P�֋(q   �Q���x���0B��Sw�,�vz��gW��WJ��:��)���ԭ��[�u��4��_�1F֙r݆��VQ��s#Eц���&��X8X��u�>KM�y���l�MWi�PQ���Y�<����ƞ�
O�ogWS�j05|}������JBS���BQ��{��*����}ޤ�OA�{n�&O)��\[$�Ϸ��LO���R53�?��_�GV��9�ZH�·r�r�Q�3>�{
�꤯NW\�����J���?f��$\�w��=������S���[��iz�Cd���m��Wwƪ��$�RX6-;�y��;����v�ѪaFY��׭]�7��.�<l��Q��~>|d�mRU=+�fi�%��f*ِ�ߎ���c��O{�>w ��]
u�$�K��V=�M2�z0� ��)�ڑ{��e>�ő{e��RM�ʡM2���.i,�0r}v���^����mԲ�P�U>�{�!u�o��(2�A\�!^�d�^Vw�y@�{�55D*��tͨ���o����&��֜�0�%�m�Nk������nm�:w��+�C�Q�g7�nNP��"_W5b��-j$ ?wS���}�)4@bԺ��S�qH]��Je�J���4JkQ�,�\n
�݉D��]+�4H�"�AAPF�����C���ˣᯇ�g5���5@l�Q�_i�y�m.����-�Y�2�3e������P�:�߿\�8�G���=�����d�g_�L&�H�7��� �(�Mb�N/tyb������{��XI���fN2�iL�y5q��c�qTĠ�H��<���]���uJ����W�r^�����O������Y�o$�1O���}�IcI�d:Pz,
l>�T4Hia ��z�^Ӊ�3����zq��aݹnˤ��[�Hk���M�q�y��gn��7TIR��qj��&��k�b�́�U&"
���&.S�6�Hݻ��G^�]��֠ڳ������rݢL�콸ì��\�4�����F��=�m�A��Hs3*�u[��>�mN��\����J��$̫4�Qo����ח/���ε"���۠rٵ�	�(�eLre�����#[���%�/&�F���r��:K���LgP ꜍�i��n{*F��T��f�����z�?���mV9����$�F�1��ة_5lJt�^q�.Y���j��d!)V�,ދ�\A-!�Q��5>쾯a�NAd�6E������\�Rd� �Dm�ҹ�E��A\n���z���R�`�f*�~��^U'5S������B#{�N����_]oݲ�:�,�b���z�����zy�?_�sM��WO�*2K��B�7������p� ���t\�$kDz����[4�N����, �eH����J��s���2�A���p����ޱgEkT�IJ,�����?���<7RX-�$�JaJ�a::�M#U �*s�I�`��#]2���co����p��̃
�Iw���tW���樱+%�m�Xx�*��}�6�O�:~<��̖P�NmWa$��>�o�R���B�~T��Y �T�'d�/��02�[�ա5⺍�����4&Ώ溝ԆT�Ȁ��X^ĪG`	<׭V�a�^��U����URu�n��Y 6�������Ժ����/[��x;�FQ89�V3�f��6�՜�*8�������ݗӧ������
Q}D�3�*���-���$m�m�U��4@b�ұ�����ex�-�[e�G��&s�nyn�u���
8}��ǿ�^ �̢\+m�.�=;N�L�+&s�xZ׽{�CT�w�织��l6W���֥�����P�ۤ'5/���W̋������v�����6����J�5Ȍ�E���Y�/
B�����k�H�rK�(y�l>��Y�)����	x�!��*<�T��K�u;�F�x�E��m�&uV��*6���q��Sgq����4ϕ��!{�K�b�i�uKd��y�\5��]%}�����8����`K��¨�6�;��&���x��y�BYP�'��@!�Ȑ��IPYM���"�^�sV��#��tb�����;��t���UN�L.\�FH��������n���۞A��)T�ҋfq���_�_/�//�@���X6�b�
�Lj)F���)�3��Ӻ�Y�#������l������n������B�F���-�[ת��&߽y�;iK[�˧��g�^.,\�%�$�VѐV�"�.R��F:Ï"�f����z�z�8��& �D˹!�^���I���U��(�o8 ��xd�)�s�L�IM��؏�"�g���=���χ�<��5Ty��oإj��Hi�Jw�Bպ��"?g?�g�MgQ�,r?��y����7Ԋ�W08�.�f(�&zF�(�����^Q��h	���qՍ��O|���%U�L�`" *I�ڈJ����͛����F�90����u&T�
�9��r���Td �X��X��N��-k����������R����/bݺ��$P](9�B����k�cO=���Yn��T�]G�[oTMw����ex������8� ��٤�`Ot8�feD��1 �'��iU�E�,�Wbh��k�~:��uk�9��7�h�HԺ�,ȥ\ğQ�HNJ
,N���)� Q+�eME�u�"���(F���i����X���{׆�c}������� ��M�6�2ߋ}3x~�v�yV�Iف����'�X5庸�u�.����0u�A��k��o%v�^/I���=��~�%ND8�z�����|=}b��O�n�<?_���>P��_��W,
"a껿��N�cjw�Ӈǎ	�'�v��p�U!��b�� ^Z�CŹM,����,�&��a3�/���W/j�a���_ѝ�B�o�yT̚V^sPe�B��4��L)��J���9�5�C*X��u�����`.���m2��i�${��- "5G���N8���zdA��܊ex�� 4]I�i+����2GF�߰���ϗ��C�d,r;����[�_����i��1`7��X+��VR�c*`��۩��&�w{�= �[��s���������Cm�r�E���P�AD~@�u�Gl1\�D�YM�Y���[���(���/��ݲ���8X�����08Gem7��ׄqD�jz}k�"��wbC�Kw���ϼSZ�[�ѪR�<!�庅"��rZ�g�B8����s����l�Ɩo��D�z-�`�XV��$&శK��w��c���Զ�uD�F��d����+�n���@̾e��x�A���jA���&�z��b�������D�2�d�M���<l��z�hkZ���MX�畳��mBݩ�̷�Bܮ�%�1:o6�=�~�TZ�^	�ES��n�OԒA��8Q�pê$YCnp��vZ���07�c1���u.�&�}2����zRþ��gͥr='=x꠆X��n�cu�&P1T!���g3�-� �򩨦���С!Kx'N	�
�M�Uu0���|��i1Tl�82_)����{������dzx��׫�1~�):��ð�թ"��N���r�5�������n�����R�5���J��aqP�T'�T�{���x>>�.lڋ��oe8a�JG�d � ����S���{~��r)��Q��]��Dꑯ��i�U`�98�(�:�7�@���}9 _��ˇ6I#�ʠ!�5#�+�����&�?�o����k�!=��a�i��9͊��j�G�z䈲��W��9��鮋�������,�;}<=w?>�ʖ�ʚ ����	�Is*۟��
o{�I������ekD�v�4]���>w��U)9�`�{5��P����������w����d�$      ]      x��}I�:��Zu��@�qb'EH�>A������P���$�,--�=@� ��Ii;�˕W	�+����9c�M��5�e��Ɨs�m�I9�ۄ��m�_N�c�2޾Lz}�����
�& �������u��+�W�/+���L��T�f����i�K��1�nY>8���e��/4@7�[ �s]�Q
�۵�ly�U�W}��㣬�*�j�������y��u�W9`�q�FF����b��� u�y.c�6�)sd������۾����0�-G�l}�g�<?�d�C� _����`N�[Ţ���z<����N8�������W̯=c_\��n��o�S��J��U�k���2s�bX]��]�]���*|��se�{�:��n@�I��1/����)�ғ��~~mG�n2���No�W�Ӯv;�ק�N��{�|n��%���%Q��~��7��,�]��5jS���*�Г�5����HQŎ�L��J���7U�t�U��4Ͽ��J�l���}9/dD|]����j���U���þ��e��J�FVнdY/���N�� =�_��%�h�7Z�@KԝR�����~nJ"l���?�|ZmIP5e��9���*���O�jJ�k�ÅǦ;n���f,s�@��V3Б��5i��ږ��|�J_a���@��0?��[�1��zr̍��!�=�#�ܠ�M̧��1��kapn����s~�߇���2	J�Vq&�����P�:U����W>��
ÿ?C�K��gy�S}� ����b�DE�$���_W|�� �SL�e��+�|���-*��qM`ǟ�>/�mf���V�-�%���:?��`a��B�ȅJhɟ�9vty1/>��kDS}`��u��3��
cم�z��&B_� {�G�q	�A���ɪ��?r��r.�/�@vi�>/�!"Й�JQ��#L���"�� :r4+P.�j���(��� =�j0-���0
+���V��xp���lw/S�_|�\v�jh?*�,��m����Vr�����`�OP`� r�+ȝ���b������,����X��V�n�;aH	�v�s_X�߯��xU� [	�EQ�W;��V/��0wg���0�#K;a����^)�#̗8%�|K��ʼE�_�Uӫ�`!:M)�M�˷��%:��B��Kc,��������e�b��b
��@ʜ��F[�.>�v��/	ד�C��V���[��%?��1ϛÖ.ـ�[q"����tnq�Q�m�.��
/{���/�K���e����� ��amZ��r�Mu���]PSE��ܧZ���[��Ő��l���@'���(�݇����(�#�bM��8�})�i!~C`^H*��S�s{Ȝb{s4U�ʦ��p�������5&�~��=5�F���R�oF�o���;&Q�6̐b5����'����2�;��U)��(t��&\uۡw���B¼��h.;�����w��.�8��oI��SG�sӑ�٪��W�~d��e��v�%���,v�������j��z�j�D�������Du�H�Θm�����|ï^�@ǽ�2d.'x-b�k��;7����˩���e�K��;6@zf9�ǜ��aJ1.$ӓ%֏J` ֝;و�	���9M�8D��o���t�.��5��(�G.Xߔ_r<�;m����Uj!Q"��I� �� v����%�s�Q����l!9��{9M>��i����*�i�D�OI����鍉~'�߂E�o{�����w�z��	Nc�v�ۧ�� ⅃�:��K�ƂU��� ��k�<H�[�����п#����[l\آ�F+	�4]�}T�Ƶ���!v�r.m�`��N���� �ùv�;&�D�oL�E�u��n�Xs�,>������z7��c���b
�P�0?
��N6�#�\1�?*��wF�|i��;��%Q�Zkf�R(�v��(%æ:|���Z���������i�!K��/\�.�����G�����w�	�ԫ�.\}_��vj�5H?|Uq��#{�ՑnC�G������|�a?�3:���,�	�g�_��C��E��N�r�������*0nY���K/�.8�rϩ��y�&lzW(U�øw�`�p�(�����5EI��?�+P4�ǩ��}�z~c��8.�%�7 Lb3���D�D��;��Iv���}��M	��˘Rt�F�IS���?����R�E{?^rv�C]���O�o�˩F*�)-����ڥ��j�D�˜�rk3�f�㕁�-�MDZ�l!qY�z>O�� $D��e,sw��n�{'� r@�G���:U�E�x<PV�`|\����9����:�8�*5w�b�>����,ևL��F)�T�#ͧZ��	�=%�\�X��&X��S-v.rc�n~ʌ�ɡ@0���S��tL�Sf�sd�e�iD�Rl���l�-7��͠�ձ0�OHc�L3χ�������Hn���$������M��72�����sB�Q�+m�׈\+�H#�\�۩��m����� ��#eNj�hQ�����\���TY{πέ.>�u�o�"o�V�KY���GÌ��sg�GT�����CC�`�>������w��k��{�7�04���C�����?pe��Rg�G��|�[_��}�-��\T�I��N8�߸���:��ci�3�o���hB®D�7�v���]�0U�I���~`�Z~?�������+���	�S뭣�Tc��A\����������dv�����P�,���>��pN��$=����U`�s`��j�Pn7���H�M?��1p��)�r킎Gv:�L^�t,�bt�ڄJ�^����r�.���@��������{ۏlo���t�H�Qj�-u$͞�>�#mw�y��6�5�b�5���ދ�YF7�O��������oܕ:��\6_�H�ӃYL;��G,,R��)k4��z7���H)�%�ϤS���ȯ�l�ܗ���|`|Y*�a%qp@��0D��C^{M�rA�ܒ�8����1`"qY�P�[T��^����r�'��jDMV�@��9�>����[���1�÷@f����5���j���=�r����"}�)8��$9S�ث&eN\p��T��l��@���6��KaT�}��Y�6�V��ZB)�P�� '�n�Ԝ��{D9��y�8�ػ�Lf{_�o����~�xg�SM�!��U&*��e��_�3a>�h��A�'?{�R`��]ӵv��<�g����7�.�k�k:�m���zn��s��7
0�i�U��:�Qh��f��Ah��v�⣩f���!E?��1p�U�����i�9�ˑ�s\h7���puN7��𾘹t,�	K�U�H%��G��Z��OK5��曺�vdo{3m{A�\W��Y������@�"R+Z�,~�)�Oc���ȏDfFDn$l>��`$M��FE5k u�4��:����*���xL�w�_�L�4�͋��RC�]'���Oz����S6:��U�q�<^C� ;#9�6�'1fJq!* R�Y����	��ji��W��JəR+�L@��&�cz��-�NyLבrj�����%���p�@f5���a��c���pX�Q_�5�^�&t}m���]�1�Ω��&�LޒGVNy#T&�G]��:�23Y�Dh���Lm��3���NT�\��#z/��n$�17������O�1!�z�Oa�����Ondn��"6��ƅ���N�$����J���`3����Z̼$�/���&zɽanE�t�k�|��N6�@����$����Bn9b��Ml�t��W����4@�����P�{#�< ��	nq��>�J��P#��Y�Rpi��Ք �nG��'4��?�\�K�4!��YFr��N�3���Ϧ��6������_��1��5��e|�F�$�|o�?%ù忞[YH�����z���W����f�s�������xn~nэ)��2g�x�in6��y~P��e~�ױ���x�C��$�Z�    &"TG�o+`xt����C����%Q]�0Vθj�a�����M���BԤ!��;M�C��H�0BL��p/��K��G@X��摿��*Ԇ�Z��siU����`���e����ܣDl~�0�����_�A<��P��� ��;�wK$�락� {sW�n�ZT�,���9U���!�-%l|a�lF�{�I
�±�.�1�~$M)� O<��r�����d������M�2&�P�r��M|��Dd�̅|jd��@��R�24����� �p	�,����q�[Ѯ�����
���yA�� ��g�ĺ���@~��a���:�F��/l�.���\��B�-Rԧ{���0!���z�K��Rݗ1����/<�*�������-5�-�~�2#Yo4���[��ji�|�L��dm����&Þp��$ch��P)0"C�hu�U�O= ߪe!r�!
��MPE��Q�@~�>��K���{��{�B{�̩��Zr� X(F���wS�w(@����K����(�OT��+gIIʕv�ΔcN8��H�ơ��>^j\��������R��t^�j�d��n�ߧ��B1�V�Б#[Ku<��M��WD��?���9�j��1�4����B���������q4u��F@�����B�9�(̱~n���a� �S]�Gc椹�>�!7�jA�n���;|��ǧ]��Ǳ�}|d�bDj�=�R3ь�� ���-G�x/�B���^X�s�y����U2E�̐�N~_3V.5C���U $�.lգ����Ã�����"
w�[�+�D���Fߘ�b�Q>C8ݧa^���56y�E���}$���[H����@b�y5@j�GWy�q�f��HJ@��_�
�9W�n.�6�d��<�'�p9��7��R�����ZD`�t�3��O�g�P}^�?��W��y>B�'vJ��Ҏ��b��ܯ@�r��*��e�a8�ǫv5̈�/����(0,���j�1�+7��=�ߏ0��o:��/Md�3Ql$Y!{=�H;w�Ъ���(���T�52���Y�Z gcEq3��� MO��,�\�]p��g����q�}��!��l��q�������L����̽�b����N�lb��CeN�ě?&�Ӯ:��uZ��Ԕ1���ٻmLf����j����1��0���<\�b}�� �=:"�~17�H�) �X��~��O�w��aW���|�$���g$���{�ϓ$�H���؈�����9���ߡ�(�� ���,j$"J�j�D��$�/\ne�fG�H���'(p��
�H�θPǫ��@����F�'r����!����l��>J"Or���y�
,-��*_�����/��O��w$+W�]|��EK����e�)�vn�\p op��T
-����b*{u���^ � ��[���	_y}U�8�ҎB?ɰ7�K&bMEk|����^O��.�R�*u!�?P�'���]uسi�rj<��<�f��{�Z��an��F�� �8���O6����X�b���ɱ��Qe����.4�>N��Yq�1�#�_�7�)�|����d�3�k%CgG�X�?&c|���]H#F ]�6R��*��d�Bކ�8ی�5��I��v ԏ�3)�Q,��]a��T��M�r��jQ`]i��d5�2魤hv����k�]�����4d7=k�bd��e����~d�֑��d��d��+�k���-Ŗ����H����αl�/+4�c��y{n �ߒ3=	���d/�H��a_��� ���]L,[�ABDr~	�Y�ɵ��%;Β��`�Ǭ[J]�ܴ��l����ܲ��v�Ln�aس�m�f��^+ތ�v	��«�Rk�L���g�����`����a1���'�������� ƕ��X�Wn��R�y	�/�ɗ���rp$8~������呙m�|]p��G0�5�=��`X+�;!��<`_����3O@Nrz�)f��I!hي�gVh��7���l��,��:f~�M!-)RG_
+���5��l�DZ��P1F������nR����>J�;bX�Qi�$hMf����=.�{� i�i�u���y�����Jwi3儴�)�ri�33����mt{�D~�j{�A�ʄh��S �=��st�L�.��Z���a�<7 �Q���ۅ'���)�Yp�� @��O�~�om�Q�� ��҃�/z���P)�M�#���j���΍&+%��j�;r�n4�{ ()�%���,��a==��b��}�RnW�� ��"�f��8�d�������2�t�g�XSO
���Y�O�S�����~Ky�@� ��6�;9:(D�D�� �'?e�N*�B�#���<�,S����@ns:ռ��H�S�y�X�u;��iI�����T]P�7h�{SY����SnS��*���]�B��7��d���)��@�P�Nܫj���g^K0={�#���~~�G��G��-����"\x�d<{�%��M�9���GD��O��H��ڞ��[Gv�]yE�T����<�(��]��%2��w��� i��8$��,�'U���h�
a�y��;�̒/�v���~E�ܣ��T�� �1�Sr�s��g��9��8&�[�a���M����L�m2&�b3����۷�ё'#��e��s}~����ށ�Y��5���Q1&����Xt)B�p�wՠHm�l�r��]�y+E�y�z-L����'���̺�6.IPs.۴�(V#K��U�r�m��'3�n�T[ـ��� ��O���3v�6���4�?��l�|���%����ΡY��s�|k��D�8-��;���[n�e��(��g�/��
0Ocvq;/��8��Xy�/0-��R�������������(7��e	�SG��BK���*�p�,{�[��G.�a��˿��X�{D\��@IY� i����b���i�7�NTm����b9e:�� �7���<��g��=�V�^�d�]�,?���	�֣
�k�T���玒�?j����& �^.�fC� ��B���\Ijҽ��5� ]won�����FG3����oh҄8��C+"����#[ap�l��,s};ֹ��qq�P �������}0�@7�� �%�~�S���ޠ#�q�5P?*!Hf�ȍ�hO��p�;�tnyR=��"99>���LS�3ܕ9JH^bP������̍��.�L��d�{uY��S���;)��%�g�u���9yt�K�<��!��OŒؿ�*0 ����7���1{�7��Ϗ('M(�5��KR3�eNa��(=
Sn���(�v��d��y�4�Ȑ��&M���n����9k"��q�O6Bq�`��<9�MԂlA}N���h-���G�^QzF^E���J���_�+�H��ʱ�"E��I=�9��>�s���鄡p��u{sW9f>�\�Ҕ �k�P5�}4@�ߊ�����[��[!L�Z {�˥�}����|n��ͷg�Nw�
��M.f�CR~����gi����J�3�>4K�xhƷ�!$�?ݶC+��xh6�ڞ��ԅ*��N�.���D����]���D�� c����Uc�չ�u,�FH�+g1 m?��H����]'��z��|�?Ќ�& ���.��^1��[6x���G�Z_Wz Y�
���@�]|�O3�.��ί�8$Oёu;�6�5�#���7@Zs� 3=B�
��Fv|�mZD��ڕ&2���w�p�HjZ��H^o��Zq"h�J�Q.��Xo =�˳�����H��b+0o� k��-����r�,��؂�h/L�Ї�ϓ"���ܨ(K�ђgb���An��)Lqf��휲��W��L��!?��p���G�V�n}�9�A{��� ������O�}�n �-.,�ih��F������S[V��>���H����bn�����
ځ�������6@��Z\]������.G���I�-��P�]Hc��@�wz�{Ե����Ó�x�#|������[�ӼU��NO�Tq����Sǌ��ń�ځԠ��{���)�lI    S��`A�U�{����+���H;q��jj�+	7?���/�!v�T�,����Y	�V�L�Cmd����:vL�iod$kp&ԙ� A"������hg�gt��{�3�h�I��F��~���xrZŅz�J�xdygHԥ�ӫ����մ�H��g7H|�'i�Tx{�������l�{����J7��\+Q���"�� ���¹_ 58w�]�j�d7��)��Q۬D� i�SII����:���/����_�~�Q��X�Y�u��9<��
{��R�xI�d��Z0*?���V�1m�j�Oм���F7�����ᬐ�!���G���W6XN�"3;J6@3_��˻��8�,��y���Z�I�[ȄX����Wv���>87�{9ex�r���{S�P�Uq�ؗ�W`\[S�K1͵^��1���#wt��O��";�H���-��VN]�Q�+�A�̼�o)fA�oZw�
\�Z[�d�:\�O�� �E���r���ߩ��:*����7�`!�jl��/d�%!�ጵΧ�19Oi7�ު�W�a�(Jy���M�Ѣ:��K;����RQ�(k��S{��É5~�A��lch�n�����ʁ�jQ)N�~������`S��ɣ���U�� �7��@���0��c`��8*W�|����g��]�f>��1�:�8#�Tc���h�ͭ�����_��g8��52��Ǒ�+	�<7�d7�j�+�T[kdH�I1$a���Sts�wLqa�P �oU�ॠ��_���<[_�q�a��V�Nu֚����ő���U[�@z�V$�π�o�zO!��o�/h�@�U��B�j�;��}���HS��� "w�x~<������b������kf���1g� i���&g���!޸6@ZǬ���k�&��_�4@��P�����̫V]�pm�p ��hZ {���V��H��>[�#i��
�k���jD�׿ -*[� ��s����*�r���r�?Ixn�W[�d��Ȅ���U�V����)p�y��JY���e����q��.6Q�{uo�`ߘxװ� ϩjJ���1��^ȼ�X�ld��!,I�[dE��T�Xh������|�a�����9Q_���S�ac��\�ѧ c�Hm��H���&6CN�}�_P�E1*�_����Q��zc�����L�Gm�j��^�=�j�62��X���mUc����h�>�bC��=D+K��o�7����r���7C�wE���xό��Hzh>;�#iHX���c��}�8}�+������#~k*[ٵC��P�����eB��������d��2�ɢ��܄�CJ��\�p�����,1L5�I�Hc!*اYr�R�[,z(�a��W�� �W�Q�(:�������@n��8_G���j������D!���V���h��Ƌn�h��n�\ �l�J@xZ�o%oXL���B�"	�EQ�h�R!����������M>P�w{�\~ a��A��<��4��4n�>����I��ɔ�}v��J�Ul���Y~�nq/�3c��b��mG5�co��A�m�/m���=?��/��j���^����/}5ޑG�?
�@��V��S�G�2��%�ϩT`{������#|4�yRU8����I����Za Q
�0�<��������Թ�x�lK4�����HVH'a��k�A�����i��>q}�/�8W}c`��D4�J�ڪ:RI���<&Q���ƚ�]4$a{L�-�����m�F�uL1Ώ�Ab� ��qB�ώm����oc��$:\�?��Di��Ҏ��}'S����g������V��O����9d�Y�O|4iY.w��_���nth������@�n�S���BRJ1,(�u�̉s�%~ &}M��LQ<K�`/:ռ �t�+�4uˈ�ǟ��70�TD�F�h�'���^�3�u�ޓ�v������O��}�/	�l'��@i���� Ym@�%�/P`h?*R/��\	C�/�L-�L;b�ȼ]�dd?�X�?A�7�Œ)�VQP;PG�-kG�/��g��ty��g�e����F�r%2�!���.x�O5*:��BN��Q �b�fW�q��`j�5z����ho��z����ʜ���Foy�6�@~j��*p���|�R �1��AG���.�1�[ts�u��K�/�ȀJQ��7⩮�7�<s��k��۫ #
&$-��k��T�}y�{�M2����:�%�E	����p5���?PU�R}���HE�d61�ud ��O��?@V�Z�v�3�
�u"��O�����7�,�[��_Y�
�%�ZR`\|�#:Մ�'B4�N��k$�6�%��m���XGGK-	�η�+����Jƍ^6e��d/�ĴWVd�l�������/E�!��B����c�,`_��K1���V����O���T�#^tA��XNK��Q�����Ŀ�*�`����2Լ)Z2Ed	��C�O����Y��/7ܳ�R�{�2V�R�zJ�o��Ff��"@��������<�`�L�Ty� ��H�q���������ϣ���sU�Y[TxV����_gl�� K+c��#�fO4�uINnL�x �67��ŊWҾ
ܨ��P�F�f�_�:���:r��� �\��%���6u��S��w,�N5ι:�	`�����\[QD��Ⱥ�ƀ�5�3i�z�Bo����S���ﳔb�kc
T����Tg��22#S~�s�����2�Xz�p���K����ִ$x� i���k��[T_�Ee��jv��,��H�Z
@�n`o�*ŀ�`fG���� �lb�bK�ڍ��h�{��v�I����܏d�H2�]n�pL�Y[���=��t!�`H��������N�h���N�؏;� 56����i�J�=eP6�ң����G~��.l�l���]K�� Y�wƖD��s22-D1�+�~~�ܑ�J�,�	kb�����[~i��������֛-i8�:l���x�f6���ާ5t��GR�z��/"�O�T��|S���a;U,㩞8@^�N�q�%*�F`ZY*v��W���(K��f�iȡ=��6"|�� ͮ�6ؽ�nY�'�> �i�[�k9�F�h�}��R�&�b��r˵Z���7@�
c��䆕�c#�D��A�� ��$]���.������Gd!�L�G3�(t5[ ��ې7aˮa��7��(����%]Fֹ����h�[�9�\���5*E���!�/�Ȁ`N~c\�!ŕ����*cD6_�R#�ɤ��1�g�x��i�χos������T#6�8��u\��G����֠8� �^����^�~,��� s��T���㽎�lF�;/����ߨ@�Z��ٗW7l��h���@� �uo�f��U�Y�?!�5>����RK N`�3������*�o�V��_��'�%E~��V	�v�2��#Y�)o�B6p`/_V�]n�Hq=�d)��U&�k���0�H��N�!��O������f�ݧ5x��%nI��#w2"'�|�)sJ�TS�Q}y�/��I	�%����e�H/� 1ө;K����	Կ���A�uA1�R0�XM�Q}��[�U��|>b�_�F�Z �<�NXh�������p/�_P���$���4@~k��'�=��`?T����{{gT��-W"�r"���EZX�FU���O(+zh滹 US�,41�Ud�|ێ��qs	�|�G�΄s�Ĺ��)��b<2��H��2�Z��������F��l��#�ߌ�WX7?P�_a�� z��� �[����q�v���q�Q�����
LK }sq6/����L�]ߤ�B'�`�z҅�����\��5�@���螲q�g�sqVW��(1oq ���[59גp4�QF�v���f22,&�I��N&"VA�	a祉د� ���vn����m�H��"#�b2����{�����6J������w��'��$�    ]HT���^D�X�έ��������!�5��:��!�#��ƶE���F��ow)~N"m��'��A�ó�(�3z��q����� �����em��~����� YE&j���B��@��GaO�˗����DN{���C�!j�������	P��#�d��dx��-��m�s�����Fs�8�N��B���,�;%6@j����̡�Hʜ��ؿ��Z�� +�=W�P�Hf�;83g��$�i�Ηx��-@7?��@?�q�dv�jdLb�F�����B�P��1/���~�e��Q��O��6$��G��#����Ө������=dgw@�� �;&@������'����>��IQ�Q5 ���?I[
D�)sJ����{$�u)b�ʎ��7Z�>"�Ҩ+� �bn}�R)/�}�����X�� ��I��YkK���[^��;t)� W+\I����_�o�pf~�.B/Ji��7������)Eϳ?���TƬ瑊.�5�JN��С-�;�H��h��4�&a��R��x:��y�Z~E�
b���T����TW�y���u�4f���7FZZ_��ݹ�����U�e��Z�#������
���$��ɕN��=�5-�I����2�aԠ��y y6f�+��XGQ��sW�7�Q����ץ��sϕ�}���p'�z��ȭ�*_��F��.�u����빫��;K�J�H�����-�
^{��Ǉ���L��j+C�Um�a�M�i.�c`�/�xne�4C`���Fyc�jj�Q�ع�;ϯ	޸���@�j�
F�5o����<R�gg��KU�i�O����C`�?j0��O�!К��H�XSk����(䤓}��nǟj�����ԝ�~��Y�� ��'jb�	��/s27�Pٸ�¡LK`,����o��R,��ș=EҮHÓ���EhqԂ" ����� ޙ�И��U�� ܟS���h-)G��ؿ3*E�R�w�����*��%���ؾ �-��Ϟ4cH_I�뱭�:i�T�B �T�/s2�I�x|4	��i�wO%����έn(p]��]��q-��颞�r(]�����6@�I���[ {s��jY����54@����?�8�E^�a!��ֵ`��h�� p�����\lߤ��#��y!�4�W'�g�xvl��/���X7���a,�B�A�Y�A9b#��럮R� ��	v�2O���m�X�6b����8���Yb>d�&;�}�aQvhL� i
��Y8����&�3wj���2��ske���*�<?کJ���<��u�G4>��Ҍrv|�s3��R�s};���|��#����\���?�̏?
T�u�����m�FJFZ��b�V�tQ��̇���I��Q2�oY�ۋ9�Գ����v�D���;cz^k��K�B�R�#D����M����#��#fC��(���[,1��Oyso-�c��|�hy	�J�o俿���V�� :��.�HJ �^x+VA��WS�J5��7F^��#��`��'G0"yl��^ԝW'�;#mG�ӌ^�r@�OV���ԥw�)u>�F�1�y�|���~`N�eER }��9#�Sa���^G�H
,`&�gX��J�8ZE<#�{Ѿ)"�}d~Q��E+y}︲���U藄߬�_JE��b�$��>�����L�-�En1;")�Z�h��= ���M��deEed�k<�s��2W�$��VΥ",D����Q7Z��>Zy�?�qCK���V�ۜ��ɸ#7@�0竛�J��.�R��G�;^���%��l[���s�=��&Q�'���g0f�GyL���I=�ؚ�E�<)���В�<�"���>����Z���f�\������?�[F�������ޟ��
,k s7SS���|F��#i�j�w��f<eM��1w�'����j8�h$Ii7��>��֙��o�!�;�E��Hc �sn��
��e�������XS�f�	��.�'V��ҷ��Q�󂫮{ݾ�ږ�7�0[��i�YR�ޏ�6�{����~�c�����hmm���p{��Qp~;�>��Pa� Y3����H�+��.m9菫�1�Y\X*\�H�m� F�0�Ѥ�HV�^F�~$�\Y0<�S[t��"�Nt�7@���o[�7�oiC(kr������3��o|&��#i8GxF��#�3�M`���p�� x �b�_`\�-����Wz�� 6>/䭏���bO� Z�jդfɩt}�+̒"gϒ�����L��҈��t���
��[��_|T��[��JQΧ���Xy<C"*�����ga��ƨd�kj��O��C�� �����탅���ULƢA�)�+eu�F��H�TC�s�����Ě�P;)�4|�?}Bo`�q�K��*���<�
ԣ�>�����4.%D-�vj�L�%.J��b�+U�r/J�N�:��p�΄s��&2��0���N5�Z���%ߑ�!Tr���10��O
Tną�1͍�1��F�#�bS{��Q��R�@�1���Q(N�v~p��-	d��@״�2V���t���H]j!�-ȣIڗ�|�:��4�6da�&����{�OQVkY��[����ץ��~���tP`�6�o�X�7������O�˜"m~����4@��b�9W�G?Z��Q�^�K{Q�>��@bd���7�|͌?o�{��i�o�����K`x=TO��w$5K��m�Z��|�F&�@Z�"����>)�ˍ�]w��Dn+.4�>eS�Ou*�a�G�v+҄"�8DD��>���F�N�ڿ��2V��9}���TC�p��A�������L�%��6S�%Qx�P�bk��$��P�Y�Z�u����|{�� �16��w���O��8(�]P�D�)E�Qs.>xD��Oj�40)?�?\��Q�1������(���H��Ѵz���_6��A*0��=���F+0�djO��њ�����F�ǝ���o }ш�,{;n������N���͆1�0�Zc��f��{��y��!��NJux�͟?=��>�h�H�;�Ӣ�b���T�Mm�4�,:���%:�~d�B�v{i�� �l0��%����蝔�Q�b͚��A��F�o��o���ǳ��y��n,	�	r�9�H���.�G��/���D� ޠ��q_Z����Hӥ�3��ލ-�%�[��+1~�~��,�N?*,����(���q�Q4Q�?����>i�@���si��� i%��E�t��Z7Fؽ?��utU������j��,A/�^�)E�B'*�{cp������������z��~G2�d���4�7e�H��7��DB�9���dR?���3J1�s�C��<,�L�� �bn�GA�h���nD�`#-V`��,
܈��^\1�n�Y�n�͸����,�K4V��Bn��܎�BQ�(��`�U`�NM[NZ�^�o�i�_eTA�8l5����;������<z����lr��
�B Q^gn��Nv�Q�X�����z�����`@�j�/ܘbl��fIj�:R�U�e�4�Gr�ԭ�hd6������7��s�k��>�F�N�C[��K����M�������8�b�!�~���#ª/����A9�H�2Ŭ��^� ]�e��7�����I�ɗ���ש��˷�H�QD��"�τ.'�?���(�*{m>U���b���w��!;8[��ϲ�e)`���������� }����^P�.�_�O`�A�8�䊢���X-j1�]�(R�O� ixd|�0�Z矦�D<cM??�|��,�y���"��z�-|�UtxK�֩��-�y���Td�o1ր�z���-����-V;a�<+�Kщ�j�>����~ ��c͋�Ϣ��bY|{R`]L����2�d�:�ªŠ������
�a0�+R��|��G�;���܆�0W�c`���(�)�4��c�y�q�[�1�*J���(�)�Vo�Gv�0��u�a�,:1Yߓ��8ـB����8��۴��T�_��.[a� 5  ,�|�)w!wf`��]yWng�d3�b ���£�"u7����lit��9�$�0Ѭ�^r��� {����=��iԑV�oX�ǒ�iy�;X-#O��$�A5>hzc�k���V%Jb��5y����/���
�TÜ�z1�;9Mp��wX�T�f6@�-LNT�>FM��i]W�l
���B�Q�}����+���w��eN���� i vBT�-��G��݅�	��/,uxnyׇ���Nρ��1X����-�ֻ�n]��ȹ��$Q��
�	DB[O�(�� ���z����qj.��Hۖ%?KF�aU�|YL5�G���"m9�PAt*�,��b�gr1Q�[R�q�qf^�U?*�#�e'�؎d��udZl��v��{sO���P�<]�|�G���&��!��L����>�!x�e>��&z�}b7��KԻs��>�oeG7LY~��a`�H;t��.��^hB�)	T�	1*4�b�+�1��O�1�Ώ��G�N�#��f�s����NG����\���-͏0
�����é.L��T�ܠu��{����������D�<r      [      x��}I�:��Zu��@58����^�	���n.��i"�D"��E��}p&���>������O��3��Ǥ�X�oS>�~��cM��?&,���9�R�'ۏI��~���-��f
��	����^?9}��|�� �ǙvF���Q�����¯�����G~$��~�=cX�������#�b���6��L�H��ڎ������fiG�n�{+���o��~��)�n�9��dƛ`�
�E����V>)~��ԣ���\�(�1�N�����vli
K:>9|b�����j�>F�q1�|��c�1����ti��r��5Iy|���Ne	B�{~�=o���v]c]��������>e��� F�C��l����峅O�~��)�Z:�\��|6�B���}rl��b������mrG�������TG�%�N��،��[�w!�e??A.�lT���Y��_pv� aϚ�귕ɖ�n��F�e;?Yh����9���� �EaF9�����!�Wɦ� X�I�ʭ��}j!'�O-n����O�~�c�S�,X�a>�|~�o��oN�|��)�����N���>[�l�N�m���o��lŽu���p��di���j�'.��t��Dg ��Xm�����m-��H��a|�!@�*�d���mi�`����X��gl5
�� ���OA��5v|� d'e�K4a�=�)�O�'����0
R�&��$ ��X�C��'
���[�U��ֈF�~�W6搟�6@ߩ[��
��C�:|V���� {3Z�6-(5;�VcM��~�@7V�!��֏?&C'S�z@ۖs�q�W��@҇|���P�o���֦��B�8��#��/Pi�GnN����*K+E$��Y#ԏ�6����o���|3�����7�@Iřɢ|g�]d��d}��\kt��O����c�����4����B�F��}CD���n��Y4�VoT�l]ZN6Z+��0��>�/��uy򩩳��5�ɉ'Bc
��5�Z���Y���,�yD�twJu�h��~v�QU�dP	�=�ks����=�И�Kٱ����;U��J�{ưDQ��z�z�;r����	��Y�&�*ҁ�ϓ]�kK	��HF��-�W�S�`0��ذط`����x�ip����=D�F�Wǃ7BL3����*=�!��c�&�j�+�q�VQ'��#ݨ�~���u���S0����Lq�٥�����T��	� ��1��탾�gle
F�EE?&i��tg�5�O'��:�1-"���b��(��C��v�/*�y
lm�{Qe
l�x�)6F�'��L��#�k�$6����N�����BQ��9�9�**ɏLz�'�pw�w�K� 5�~W(��>_�1	E�>�h�Ѧ'�F2O��_t���MP������sQ��,�=�(��(^"�md�&+&s�m�.�)�iG:��7ŀ=�Ϛ�;�?�����8|Q��
^�����ha������9��a�QT '6�pߩ"��i����O�?����N}��Kos��j��{�2�nWu�ur�⋇�L�ѷ�O-����1�k7��L�:w�X�����fEm_|M���d��� -sE�2��\�����J�LQQ)�,rˌ���r���LuQu�E닁Y����N��҆c�qu�o WwŸ���)
����G�= ������dQ����)�>�*l�])��nU����V`K2�z�m͓�p/>��Mz��:����6��n
:���dSȐ��s���t��R��q��q�&T�:Ǡҭ3q,Š�����޿ts�����6B�k�ou,��^��3d�� Hg�vr���Y�.��L�)�XܨV��͆�΅u���|?�ϙzUřF'J��G�ܟ������'1�������E�%׏�G�� ���D|3�S��2��x�x�XK���mN�����������1���7�>s�E�����ן�>��S~��:�'��+��8}^WxΙp��g�<���8��AgLK�!��HN��8l��m�)�w(�44��Lku��#���k��,I~Ŷ�����Fy9o�@1?�pؠ����ʧ�d���b���<����t`�wm��e��'��N%~�O�'mD�J弰��z����`�������D�_w��p53���2��D�&
����A
��X1 ӽ�m��KV��j@�4�޾ÌAe
�Q����'K�c�Q��1"�[�&�B�͌���Nl+BmHԈ �'W�4P`h��%`Å،�&��O]�b�T��
n��W-�/?��-������3 Ђ�B��_�W�܅�%r��M;�E�i���g�c��߂7\�7��P`s-ځ�q,|ih��ز��X����X������P`����̘���lc�c�B#=tF7f�4�C�~,�h��~j��b�]Mq���Ez�ԑ�Kh��h�������g�
�c��<4r���E����/���Nh����}������P֔�ȗ߄��H�Ნ~�K�q��ߝP{�:CN�o��s.�Ԉ~K��v� ֎P/���d��i����v7*9v�4#�us�p㽼F�C,nA��z��ǫtI��
��"L��d�*�݋H��FɇE���J{�o�*��'~���� �t���X����|
t|�tFn�:�p��O�1G���'�	�#}���������P�l����rxx'���q�����6jG_ͦ�˺~.����.5@��І�|�'X��AS[ �3�*�A�䂋��� {^��X�E�WC�b0�#iW �����#Ǽ1�q��c��֘`r�"�J�|_?�:��� =�ɧf�"S�_d:'��1��� �q����~�F�$6����qrp�p����ǋ�^ߖ'7�=s+� �K�H8�YDot�o듭����+V���['�7�mV�Lՙ�v|�85��}��ԑ��[ߏ��f�X���bz��q�H���Mc��=�z�Ǣ@J~�����S�#�sx����׷93&?�WtQn�7 �3��L�yE���������Z�{�E�y�\@��4�i����r�m�h��������n`�^����{9��0��*��� �}�g�/���X1s�bv-߇E�xSK�r�?�/���C��S  �>M�� )0O�} ��Hi��F|}��M�f|}��M�fdɼ��׏�����)�䊛%������ҷi|2kB�̾�T��|	1�A@�
gnꓷ؇��NNfQ�F�1��@���k��/�Q�2!h� ����.�����?�)�d1NXc4����v2c��� ��@��� zK���0�1?��h�Qx���Ȳ�r�Q�T�b$��x;�,��1�d���@�i ����rbYVUKvQiv�(5����u�:�j��e#o�>ul�K�H�U����|E4���uO!�!��0���Z �q) �8�$��[��%ݧ�ȱbߔ����a��>�ac��_d����"Zn��E�@j�}���d���?]c�J����_����)��������p��8U���Ms4���aW���|$T�7 ��ُ"�#K�?5,��e����z�hyp��#)?�^79��hh�ww��0�lN��n�'}[ ߜ<Y#N��\�P�c�:c�����Y̘9��lc���xI��e�dޒ#<ܤ��@�#t��ݍ�l������:E3@��3Nt���/bbL�/��Աp�� V3�F�����v��M�'Ԉ�or�u$��5��|q��<���5M��F1��ܸ���e�� �g�c]���3�����L����`l?��7u�kF�����f���~v��a��:G��Գ�z&�ĥlpv���M4�H*�8�@��Єq&f�܋*�HG��f�G��� J�0%�nز�A�[��`�v��@�
�FԞ�݇��ӴC��bA�Gl���-�0�1pV�(���e���f�/����c�득���yA"U���< �~yo�;��"&<�g[�؟��XGY�
�c    ,�9Όj��ח��Z΀��('*DA�����$��m���E��E�1���h#s2���	��b��I�M6���a���;�PL(�.W`A���&J�H�_1�^m����V��Ǧ�-x7i�t��L��(��;�`�p:E'5�:�Ȗ�K� ϧ���R\��?��f��)z���Lc~�Ϡ	^�v�'�F2xp?���|AZ�(3[��y�<�@~��̷���`���� �VI@z�>��y��Q���'!��;��'�Єb&���9I�H�H�\)
�V@_y�c������P����'D3���G�vB���G���O�~,��(*��5ao@:cw�٣��Lc�>��b3p����V@߀t7Z�]��c.�_�/�	��/�ה��<y_G�~$�D)��;X��or@�<�/f!�)��	IS�w�5�*�����>���1�g��X���,�;���Pɖ}K�}נ�T�x`�e��7��a3f3�!��qd;�T�#Cv�]�/�w��O�#����ʱoB$�����Ө��i�{�3����E �Lf|I��Nfd��X�"\+~!#����6@Z� 4a�Y�;�����`U�ᐬ0�6�]�ԳRK�qHf}�ޒa0"Al�/��� ��%M�\�,y9*Ɉ#2BH�og5��.WoKD��y@���-�!���U�\�H��C�2����_Y��_�&�B�*�boHW_���_�8�C��U�~�j�4�ޚV�_�ڏkS��"���s�����%�j������A4�1q���z3ܜ���Լj� �eE�� �yj�*n]��7��H���
C��+*��>�,�H�hx#���E����?�: [�BM���h,�a|s�����G���4��o1o������?�L�̛5M�܋5���7k("�}$��B�"
{*;8ihe��E;#�g���|�בaYQ�K˿<��^�wވJ��&Ѿ䪊������
�D� ` ��{$X)��I���.��z�	�ԑTq��.k��)g�&�)5@U��<�b���,��X2֙ĉr�'n|�5"hg7-�����bE�ZQ�B.�y�U\��-1�=DP�Z.�|�ך�)lE5Uz�nBDἮ�K���kf��V�<���`oT޻Q&���@�u?�	�&�nHۼ�n׌� Mo���yaȿϬ
�	�����~k�'����p��U��y@�u��>CG�[�G$I�������~l��eC\G���ݐ_ 3-��6'���}^J�"�Y��1LZ �_&��ܧ}]���qu��鿹�E���G���9t1�P߾Оh8x}��J��
�����m�a)_@f(E$,W\jQ?v��--��T(l�J,=P�\��oѿ����1xU���]dW6@jFEa��SS68����� i,k����g9�&+�]�O�Y�'�B��
���N�'�r���o���1N��[*zD��q�Tt�j����T��Xƽ���ز���S�1s���
L���@�Cs�u�2V*��
�X���=ǌ�L��%�<&;�Ɨ.1����{�3g�{�kcvDS��*�[���:Ra��:2O�=�o�����3�	�e����lƢ���׌(�9�#��c�(�9�\ ҃�~Ĝ뿅2{��O#����H�R 'NtG�p�3Z;���ݽ���9/¾�c��r����\�3҇���V�T%����Y�޻��bѷDs�(gϿ$w�:Z�d�J2@�p���nw:ҏ����@*%,Qg��0���o �Ш3���`Q������k�U,�IKTE�X2ר�(@�S����b�|-�ZO���vXk��]�j�e�hQ��U�6@�>c>�{�XDÙ�*�B$��NA]��z�.�=]�J���w�Ȣ��35�]��X,S���n�z$,W,Vn� �1R��O/tR�d��$��TMcD,�hP���kw�sO�A8AR ������d��ק�]���ث���
/ ����rhAI��um�4z*=C@������h���-����G�*"$�Q��PO�= �D��DLX� ���t���*�QŽm��S���\_����."��k�����E ��V�W�Y5�}���i�\�b��:�����Mz��O���p}$��m~�4�35@~�6L�Կ�l+&h!_��C/����hH�`l3�<&��
�I8���XA`ֱ&@c�𚎤����
�V897�8�>���Ǌ���0�o����cvD�+0M.���Vߠ��q���HV�#�:�۴>0��f,�i}`��[�Bc��c� ��f+D�* '��) ���!ӏϘ�R�yB`��<֯\_O�>�2���N�Nx�'���/z��S<S�U��[p#5�Rv��FP ��g��=��"�#9CC��>%aM)�v�/'t�/����4�����. m��B�{����3l����5�VZK�J���Ê�g��5�&ԧ8r;�@Vh+=��N��а���m��ym��{y���%�4��.�#y�e�/�މ���
@�!1�z��O���L���L����'���_���HC�R�N�w�]�Hi���`�5���5�^�R
�a�N��P6X|�t��-n �F��&�V�ڪ�3�秾<,��4|9��Wne���@f/�T&�,t]��3�	�������k��ܲX����v�����&'y�Ԕg��ڵ+�c/��S�8b�T���������4�!�49��}��JQ�T�nޔK�(�Z�St���Y��b&SxS�T� 2�O�GPl�(X���;�^�>��A��t�ٝ?����g����vPK`�O�6@Z�!]�<���'��|��Si�Ԅn�bO���kҼ7�6���ԫY@8���A)�FˤR������(o�,w�XǗ��*TՌw�t޹ȸڥ8To^�i{�� m��Ж� NR&�V��� �O����u����&���"��N�b��8y���A�����X��=�ڲ��#����=g3Q?苰��U#��M��ˋp6~,�鋰0L���E8�8�co/���!��a��<��EXg�H�y6u��^��竰�	�V�<#�s�*_��g�́�z���im�<I�=�B]��r����(��نE>2^���^X� �^Fd���^�lɿ��/ :�puNf�I�f��BcnWۅZ~�0��ƛm�*	��ϱj�� �vn�*�H�zvf��c����V�I�|.<<���<��*3��"<M�ٔ0�7��&� S�(Y����ƙ_�^��� B�i��N:�4&9<�Q��2j٫���S��Z {�����+|�r�H��?��?d�eD���z����L��H�1d�����1� ���{�!kTB�җ���ds
���}����B�E��~:�_@Z�;���a���Rc_ �be���xD���s��h�}�Θѐb?����y����l�:��
a! ���m��7Sf���&s��ʛB��S5^И}�E7��Hۤ�w$G�\|�cl�4� ��mx�	ZYo���!#�z�󘭽EZ�P�ׁ�ٺ�:��T�ƌь��[�e�v|���n|�z et��Kfn��/M��������́���myB�/M2����M͎u,��/s�JX�ڻ��F�?�������&@Z'67�ڗ1:ңhj�j9Ho<�oW��r�&>�v�������/�4�����6��ߖ��\Jy�
�T�S�)z��Ҋm�(6M�D �� {�ߖ�"�J��z1B[�������Y��bQ0ɨ��ɒ`/�����`�u��)���D8�?�꫗_Tw���H̹;}���!挂?��U�������J��4�p_|�"�\'3���X��u���p�S���H]>Z4G��k����7��{�M�/��8�����Cel�I[���RS~���<���VםE_���n����I�5 8L�̭�ߖ���"����`����1�>#�>���B�;5k�����b�J�p�����)4`,W    ��Z@�k�����7Ѝ��t���X[F�=�d�X�1B�]!�]l���a��F��o�ǭhZ �05��ߛS7�<�boN�\˘���|r��ʛ�Y�5B�����8Y�s�7o1~|7���3�1��)��ѥ~�8YL��؋�Y�E]x�6�)c.���SL�\���j������:��6j��^bF�}T8�^�h=\?Gy _ܘ�	����w���7%iA���@�D�)h>����U`ӘL/x^}�eeuF�D��o4e=����������ԣRl]d"b%�8�J�� �ï�qf�9}��5#��Of����S6�0�5�����$uA�h��D44�.�b ��Sw�f?{�DC���cc�͉�� �V�s�ϫ�=G��	 �����^�8uwDԓ�����Zh;����5�)�����8��7���}�> =��S��G"�gtF�	z�'%h��>2��}�+2y)Б.5Y��gx��� �rR|��\�*0-��U�~շl��Q�!���{�M�?����,B�rgK�Z��7y�]}((U{1x���L��0
��Z���ӫ�sb�0�8$�������H�	��'N�;���P�]����d���☌�|�q��_|�%������%�1qRu���^"��[C&��-юy��/�D7�Go�Ђ~�#��j�:�Su��������V���l����17@��W����c�ud^�ŋ����s6@j���}�J�i7y���OՔ4A�:������Pf�,<����э���� i����ȅ�@�ZXЕ��
$'���9#�V��jO��j�E�Eda��RV�kE&��M�M���W%l9��@�-�@�z%���/�F�k�ʒ
��j��y<�k� �P��ЍV�(*�^�����6XAH,��b�IK��<#�7�a���4��Ѿ�]����"�Lt��Z�A>�j���6@�_r�ш�^N��A��� ��Ԗ�V��������o��2����)�N�T�jJ�!�p�"�dݱ�"�F:�� ���"��}�/��>����X<���ꮐ�{4]��4ڡ��6
0+M��U�y�Ki�c�\tv�DӅC���X�[��%D���5=�+�5�@Jo�.�#��������F�M�~a8�6x�Ji�4L�Ԗ3��9-K�<^@�m^-Ae�x"�b��tưT���6�����@��Pj3�7og�m0}R�-ON�M��e�'_��:oo�՘����������ո�}�h�Ə9̛>Y�C=������z����&�E�[Dkmܤ�{;u7��R�x;�i�K�֌93a��k;4�U�n,}h+�����M��a��5�h�4�hQ#�1M��K��j��kQ���M�2�b�#�H�e^���L?'?�տ�i�O���4,j�Q�Y�U���4��)������5���E�����T�q2�v'�.M��cu�3KD�lҢ��i��+S �2Y]]ΨOT��\�<[ ��7��_r�`�¯�����	ק6Y�WY�T�&�b�&�v
�$׏i����QIV�&[�7��������@�~�|[|^@�bR�=�b��EED��k�o@	� �I��N����@�L1�Ć96}wv�/��E�+�O/����=�����95�
�E��v�u�>Sym�VE��]n�i����z�e΍�����'r:N� i��亱����e�9���5�	�= �dl��+�oj��j�`�;2%�v,��c��Zy���ds*�^��Zj�B��z� l�4��?��T��nn�Pɵ����������D��2>:E�?-㣻�rZ�ߖ���Ӻ=
���V�������nOM���z��&l�POMq|S�
�ԔP�2_9��:��X_cjR�Ȱ_�j���W��\�'M�W�l�X�� i�������%"�|���?�f3h!`�A��EG@��v�Ђ�����A�m��ơ��h��Ϟ�(�q��H��Ps����)D����T����ˌ�Y�joͤ�k��k��_5��^�\X�6xְ��[ e��LN�5Uǌ�Nv�]U��^u�+b�P7�4@N��8��T��q�*�/�V ��%���Oּ��49�@���y�@l�r�q�#+���H��c��+<���N�5V���hh�j����H�j�5Ց��E��>Y�@�95)f{ S'��)����,���N47�^�!i�LDx���<��C}*�����
߉r^?U�/ -nSkZ��c��GaSm�\�
�Ȟ��b)��H�TT�w5��Ijm�W\�m�4Ѥ�k�:�N�f�q�t��*4
H�1	r���wn8�
�����B�� �	��{��H�TMe`���>��� �(lD+��b6��'�X1+��<�U��3�eU69���|dO!li�>�`��솥���cG�v�n�Ti�.�qB*�i��Ƽ�6�R`l��u���4f��K���t���6X�.��:�ƴKvÙ1S�]�0�kE�cM�u
GF�}{�l�H֕XGN�ڕX?;�Y:mR��Hc��ҤX�y�aX�b]cY��)�@S��
�7o�f�)���{��yZ{�U��ȜZ��\a�����4 ��#@7�������é��z���g�@z�^[�ʍVs:}7� KX�����z�Br�Fkhڝ ��~�-��`&�].�dm�0j�V�g!�2R;�Y����ǯ����&��#(�d!	pB*/�>�@�H�C"��l�̨�i�vjX�ɖ��Ao���0��h���L�H�'#�"����%A�Nl��`G���:��#Y�Fo��^C�P1�#y�' ӿ��Y�+�Ӱ�F�,=��u�@�:ɧ&���n�u[y����E��r&׭z�xQ�چU3���Bs�
M��fD��^�R~�o �Q�O�RW�	����[`� �d�����+܆V��!��p ��M2�v@@���ؿ�F��)Kv�9�^�um��:�R����R�C�-�@���� ��d	2��#	�q�4����!�1�|I�`��K� �9���M�F��%�H�v|_�%����K� ;R�!C22L蟇	pT �� ���z)�'�<V^�%XƲ�:� ���"x���!�n�t�����c�TP1Z~̖F?��t�)X�� =�,J�Z�-���O�`�l��
���wR'S�5��}KS`�(�6J��ʢ
,���G���i&��|A�r��� Y�o�Aq��Yp!���h���ע�*��6�\��ֿ5v��tE:t���3�7V�MG�m�S}���)1�0]T_�Y�-�SXR�B?&�#Y�����H�$#��~�1(#��/]Kx�����l����3�9�e�S��o�t�Y!.�r�� ��l���Tq`{�i���M����B�̛-��C���Ϫ��[&�Ϫ�wXk���Y�>���[ =}k�@���h�4<�Hwе���fu���F�^�N?��+�".W����v�lʵ���p��<xm{�T���~>��ދ�Ifn�[�����'N���� {��3jfb�ryA�ӆ3d�3�3���#c!�slh?�o¿#r6����m�{��}w3F��.�'��ی��{m<c�����ͩ��U�	��7<f�/�4�����^T�2�+�48����uF���4��j�����u�U���}��-��Vz++Z����e��'�WM�3|�ǋ^��ݘ�]_a��ɮ�u$n`�����t����\�{�4� �M���9����L��k:R* �k�v}�k$7���	o���#G���
 ��S��%,/z4bYE��k��SL��#=���n���6��z��|^ݝ�#���1��gYK9 ��6�����_�(�,w�?���� �H�y�8�<Ҏ��2��	��|�?�k[���_�D�Og�?@����Z�� s���3�k��8H`�̋lȡAB�h`?u Y�1���8
�
_tE���o_��g�\3&����Q�H�]2*�wJ�e��o    �\��J����O���Ma���G�4�)W!jŤ�H������|4�^��؋�)��%,���G:]3f3ٜ̟�m��O-/\=�)�Es	�O�,�X���W�F
^[li�,_F��	�[�o�y0RZqQgL�����y:#����"�蟲"�ݤH=��J5-E�-aM_��I��,-�yI��5��U���%�f7�"�,j�N���@� 5���,f�I�u ��8�K'3��K��n���I�4�p,�<>b����2Y�J�E��6�� �>ً�
��zD��Ja��h��#k"�z�}�`%F���Ɍ��PS�e%�	�ߊ�>`���0�T�[��q�9���;L9�ش5@VP��V�ũ�Î��HC_,zEhJrZuGA��a^����=c�|j��x��N6���g�d��W� �!��S%�����d�`��@Z^�3�ҋ�$Z�#;o-�)��h�iI��3���o�~j��Ⱥ�
0-���B̈́Y���xD:�z�)��L_�D�6�2s��S��z�Y�����Na-"?Ei[�ha��6"�ւ}��X(�
���:�LY�g��������3�m�2ބ~��Y9���'��q6�&����V�	Q%��svF*�f�
�N>5��_�f���^���kD�?@RwE��%b� YzV"�wmh��6. kܣ�W�߂�͉Ȅ�#M�W+�>gd]���C�b��p:O�Ҡq���Z՗�����
zEM����wތ�c5"�F?�G��h���+�����c�� {�}�HiQ&��Tp>�#�p#��4�1ޢ��Z����O��KO�1���U����K�Re]���F�:SF:2��"t�����0/��؝>��.#Әk����<�-�5ؗ�<��:�Po
^4�u���u�i��U�6¸���������<��/���#iT���5�,��}S��i�\݊q����u�O$��*�W�mi�|j5��fQ���e9N-��-���Ȃ�L+�哄���a~h�
d*�KB_�� sx?�6��q�.M���ޛZb��E���4ū�ێ��ߧ���{lx
BC5�X���ȵ�Q`Yv2m<��3����u���u_�i{�0�M����$4�5,g �w�L�?Ҧ�1��Dߒ?�� 0��9ٌo�M��@۞x�D���Mv#�r��EeR�Agh��V��
�*e�H]j.��H_��1��Q���yBT�8���
Z*G-ږUD� ���W}M�΁j�-�j�E,���3��B�� �/�;>8��^�RT�<�1��o6� �E-�����#����CM�&�TG�`$W�z��('{�W<� �>_Ҙ�ѐ�1�9�[H�k�K�k�+�I�\5d$��j�����S�[���~��Р]TJ���8�7��klZ�)�Xm�1:Ew�,hA��H���/���.���R�-X�tc�@�.鍟�O�0�� ���_�7/��P0���o���+v��5f��B���\��D݉=��j��Fm�_���[3��po�R�V;)(ty
�����Om"Q��uJ{뛑�I"����MG^��4�\X:����C�����q4Ȟ�<��{��g
 ���Lg�+W茵ݍ�_q�3�Ⱦ���
g��}����l���]w�}!��,\w܁�߉U֏�
�(��UtBy�f�c��?� 5�eV 	S�� Y�=��Գ!�`2cߑ�:�w_��"!��[�>�=k4�o��Y9q���-���Y$�~vwܙ�y�w�ڋ�r����N�������)��͡.�/cV��F�}i�����)��xD-	�kOa� Yq'�'3�6�����/~rD��~����@(�o���f�Uw��v��ȶ�ޘ��5���������iW�]; ����&3�r">�	p�J�ݗ����VǇ��*��;&� �]�P!E�
_0LQ�׳Rϼ-���m0���o{)n�E��8+n��n��������ֺ̇Q`wZ�F�q�h�����Ժ�C2��6��e�ފ�xy/�u`�X��u��mGV�Cpf�f�~G����(���*�ρT��0z8��AQ���ȹhJ(5�r2]n�o�]z����D~lc����ҞZ�V�"�� i&�GT����+殒����l�9Bp�ItH��MjH�W�5cnIŲV&:ҡ�Qq�y�[���u$�����!��� aFb9-Ƶ=���zpj�lc�|g�L�S��my���"�r駠A\>W2���b�CC��R����� 2;�X��CY����0Ѳ��Ҏ���5t�O9`�~�@!���ju�=�����RQ	hs TW4�A��`D�
!!�Q�>��*uoNZҊn�g�)�������%Oȏ�vT`Y̆Z��F=֧�K<�P�uٕo�~�߲9�r^��j�@vAZيn�"�P"ck�\����
߬;�R5�-�qY�'�����
^���6y5�Β���@j��(��]߄⺏�e#ɂ(|��)��c����	/,��A�����W�k]V-=#2b%��*� ����� Ӆ�:��ũ�@�`�d�_����{D]�@?�U���'�:�u�؞��c?�4f�Ա�ߖ�|�ͱPtx�/��`�X���}�5c����ȣR5��+Ѝ�ћ�?X?+����0�������Qon�`�X�xK]6����+@�e,�+��W�W l�3K�DNT5����6�E��q�f�ꙐN���B�rk}�P(��B�M�ߪ���EI�kl���apa:#M�.�w��������`9�:2Oei5i�v��Sq	W��4�2��R�#Z�4�%@ϽX=���l�=��	R�4�'4~Ѭ���C�Ց4N/4~Ѭ>j���
�f�0~6���~���>��8�~�k����K= ��M����w)��>��fm ��Y���%xaz(Y�*�)-��b/uƢ���H�̼*#�:V����S���cJ�à�����UX\� ���O�?���̼���7�CH	P�w�:��� Y�\�vY�\���7"�����+R�4� ��3�o�ם��t���6��H����X��?��n�o$����RJ��H"^��-6@��&)�~Q���9���Fa#NH��8�ci�4�8�<��F�1��)���u��hJ#fLf|�hJ�혪i�%�	�FK8�Ԋ�hI�cnL-��C-a�S�Q`$�"�>tx�zR�Б�&G�>�?���"����l�h5swT=���� ��g� u�l���aT�"ws_ ����,������u��A�@��T�@+�����
��r�=l��-S����d��@˫�$��	_��"[��`)�l�L����WL0�Z��|9�<n���57@���^��r���������\Fx��
=i��v�u�3����P,���H����� ����j���r��d���2 ^�������H��C	2�6x	�V�������������9����"G�Հ�C���7@J^DJ�څD~A��`X���V_mm��W�zk�㨐\ۉ(9}��ۓ��;�A�ZAp�E�o��(�چ��H,�������]r�z|[ֶ\"�D>J��\����:�q������v7�����exخ�_�m3�s������n
W{zde��H�}2�ʳ��1J]�O������ iߥh,j���EW�o �hO���P��0��`G4�\���豌��	c��X@�1�u�'�~[�׷���̋�r�Mr
�V��-�2�h�dY��X��&?bF;Q]ޒ��c9���S5M~���8i.$6GxȐ���H��8V$h��'譂zD����VA=�	�yK����EM�Čn���<J�(�=�oy�ѹ�"��p�����ta�������S�gL��'�3�E��"o��e�ػ���=ck �{��Û����H�������B��V�ﴹ!�@?�_��j��ޕ�3�) y  �>�ħ��Icl�3��n-�o&��6��~4�҂?��f
�)��*�H!��G��T�A�H�*	J'�oìȚ�(жSX7����Hj����{h_R~bZ�Ĩ{d��O`������h�qۡ�z~��d��҂lǊw���,��&�� 3��uח��)�R�lm��{x��D���Rwh1xS�����7��N*v�x�s������Dլ�-�Fu�',�2�.��:#h�0���Dî��G -��'��(����F����H���qȧ��^��i�\i��eO��A���&��L�pMЎs�rN� ip]Lv�����1u��ד�h/�	#�Ľ�S���*�4��m�4*)�8a}ٟkß~�kd�tQo//zW��բ5X�(ok���c�"�R5���~@?�7��3���}ѡ�hrw��P��;�qص���#�wO����A��>Q-\���c��X�	�v ֓�-�9Ecn�2����S�> ����v��	���%i(|QT1�}{˞���94o�ӱ���s�-���okY�[�UDK��{K��%��	��R`ˈ���X�X%x��������Ռ�����X�XF�Շ�Ս%�[}�X[F�dkG,�
�V[���Q�g�ܿ
�m�e����+�<�Oi
|r����B=�"��;�<ݬ}-ݓ���$c�p������ �&��ǜx ]?2I��Ab+D�/��:C�0�dB;�K�_2��o�����B�G�/G����jߢ���Fe0�������ץpi�Y2�q��!%��,�y���ݓ5贘��)Jg �����d턢"OsNh�>��ģ�3��IK�%&���I^�fc;��בi!+7��6�{�Mx�	gҋA�_P&Z�㴈(
���US`E�7��C�쿾�HCڒ3�iz]rvB�6u�dW+����5� ��]-��3FTGS*�1��7Nglśr�\�GRq�\���4Mtȴ�ړo�U�t��l�K@{Bvk+h�m�,��>)��x�~
��u�hS�TTUG���ϯQ`� ���{�'1�HN6��OGR�s�e��>I�b�'��Üo)2��r��D	��p�.b�V�@�L���H�/��7@�⤝G~��\@ڲ-����r��j~~��k�ac`��xM�*U����ܖ���ݻglOR�� ιk0[=?im�/'�-P�{T5�Ֆ�^����uxĞ$�c�h'�I�������Ȫ�F�]��D�"��q��~[���M� S�c���oc��mL��M�eo#)vĐx���8������C�ѻ�����L���ELDU����P�Ӓ�'�V��ϟW�HS��\O$��x�)O��jICI:��_
:�Q���߸m���v�_� �Ee�C��wZ�9����{ꈡ�J)ձ�O���R6`>�i������������^�q'�	ڛ��~�o����<H��|��P�o�3�^]rsF�Ľ�k��Ou���ӘqO��5
}�*]|�ԩ�\Δ��SiNz�uL��uYT|*f,�#>���9�����n|� ��Q�ds�hV`�1 )s.qr�}�9-W�H>E�\�x�TZ��y��)Z�!�a�D�p}i��c�^������X6��m��я�-���O�����A6�ҳ���U��]j��>���gM�1��������~d��ԑ�I�zY�A$ ���}@˻��g��k$�*�����(Fkܹ߬�H��f�#j����aM`o�ߋ
p��>�ƾH2j��ᣟ�3�֫Ψaq����JJ�Z���&��L�➟�g����D����S�E�I��W��9ur�'�d;#������ՠ�S�&��W�~9-�
a1n��h�4�4��D���m����m�G"U�us2��-��`��gdi��X&����џ}H���O1�f�Ն;��VFX�����	U#f,?��jP��|�K'��,�y��oLٵR���^�vqr7�L?f�F^^��ˋߴ��I���-uh�Ռ��K9x�C�{6@�-�]]�/�],n(�ƫ�[4������x;��Kg�Wa��t�w@�O��Og�Rշ���/�0�>.�h��/�0!U�2�$�4�17�2��GW�T\���L�������d��`&k|i��C���T�������Ì6X
*v#t��rNu�m�T�"��MAU�D��T��m��T�q��ЌT�͘���z�x�c�s��jt�ve�DOZ��8��P��3z�c�ӹ�n��端eM���W�9Fr����j:\���\�H��9��H��{s�m���u[/��5��)�xQ$��&3ҢY�}1B��{?�@��ؽ���;'-܊.�b<���K
�)�&�&��&�)�g��wNi�S��Ӂ̈��g�o�ԭC� �	����I\7��sn_m�����'�j������f~����	���H�B~������y�����GB�c���ށ�,�^5W ��ȨƩ�v�	����*V�����j��<v"��榏#;B��Z��W��E%�.�E��qY��ăsr΋�YT�*�o� �HՆ\ɀT5��َ��AX���P�B��\.ԉ�@����Z��_s��o�%��ig|�Ľnq�^�k3 �w�_̰���U`�E��+�,:�8xӃ��6S�/iL�oU�s��}9�R`7mڏc��2 MIȥ�Pb��X���@�B)����ui���L�GR����*X�r��O���Py�a|�h�r�B�2y�i,herR�G��2y�e|�ier��:!xV�\��7G��*� v��*�[�tc�D+������Ʋ���Z��q��dWL\����yr7Y�K���Sc1](����7�LtdG�V�����׿����ԩ      e      x�l�Yr*��5�wg�,���lA���8�Z�$�ζ��}�hܗ�F����2êt��]5a��ڵ&��QYm������?cV&��}�������g�������F��i�]�
����h��I���������Ǖ�jߔ��~�����U�o&�l+q�T�l��y��� Hoɸ��<�(,��~��Uԫ����z��*�7_�.n"ƪrZq�4��WŮ��~�����'b��v��Hr�i��=;c��`SVμ%�s������V��S�u\��=c�_��]vy��T�V~\n�ǕW�Q�kJi��Jl�9���^��#�~��u��;?��Ė�61��G��8�c�J�N���vx"v+�B0o��h�;c�j�UjW�_Ŵ��8���y�.�V��b	q>W�+����y��Z������%16̾�蓯�UV�[��rq�O�E�.����$�=-o>d_��(\%܆W-nL��E��ɗ��~׼9����rwk���ј�����AN��pȮ�w���s9z3��
�
�
��{�t�վM��?��~�5�3iS�r2U�}l����ʺ��mt�8�ڲ�y��j���p�q�����=(o�xgڠ�^u�x0,�]�vkW��~I���o֚P�7Fմ�J+ݬZCzݪ�W��~�����C*3q�7������v:��������U3��N���c���u28���dc��>v:���b0��soƙ0��
�I����V1��GJ���D�+�ss|�>ۙب!��w�O��V�=D���O�`q���c�a�DoɆ3�A˭l�U��f��h��3(����]��v�6+���V����|�ɛ�qY�Dƪc��mo�N�m��W"�Z� h�iɔ�<�8��W���r�|��P}����1$�rN�J�q+;����N�ǘ��~,���ޘ|e�>)\Z��{;�n5����3�Yy0������y�`�/4s�`^���]�bp��\�Yד�u<����O�-���NT.�
���?��}��1�o���;��3�0��s�v�.GS,�e�T�}}7)\���ye1��Pyg.�u36�7���q���߰��Y~�į��o'
z쮯�"^��Z+�#�qu��B߶�Sὖbl�;&�e��9m��= |���<Z��7x��i �x��]��|�AA�U������NO�`j����뙑����"ol/�0{5t!���?�i)lb�Q�͹MA��Tz�
N�BfmT ʉd@ ]=�!0����^�Q`\��##8I�E�ԯ
|��z����?b�?�U|�P�+��r+n�@C���������&�4��U1d�|~�"@ N�'mܥ{"v��������k�}�0M��֨����Y���/3�R��J�8=qP�;�W��dҺ[͓�,�.[��zj���x��w�wֳ�
� Ȋ����
����h!a u��	��ygp��0��<��ι�������r�����'�3W̡Y�Ʊ;�\���W�~o����xa�{���і\?��8�ՈEu8�h����[����������7���Q�ָt�\Cd���Xl>��hm�6����|�2�Σ�8�jH����ٗG&ogl�S�O���~5B�� ���i�;���_ �P�f�4i������[��9܀�a!� �� ��q���}��ג8N��T��D��O G��
g �s���`&��=y�Y����7b����P6׏h��	��#C�~֡����ٷd��'���B���8z��W�[����$��@����,l��^�y�������q�/�'�ű7�@��˒���%���;�UQ
6������@�̣�*`����l�hH��
�uھN��2�s%�K�~��b4�:�sq�X�Agѕ?N1ڡ]�� |+Z���rQVTd0�H��޷$��W�%�ۺ�E+��ޭ�#uGf��s0ɽw���-���A�������A�ߋ��|�Q"`���oE�E0H�39����@h����9��/N+O�,���!���l�$v���:�|�EX�xŉ,F���y�|�%�ԑ�t�@�F��9�2l�����������@��Kr��^���Ju8��&� z=9$aP�~��#trµ���A��ϽdJ�4�x ���wꆻ��OIV��_uz&.
p�;�r����l���fI�:��O"�h7�7����[���h���I�S������ 6o�p��q�
��ntć��Q���;��`L����-w��T8���ǆr�.�X�|�L�Uo��Py�05ʹ��u�����Mvu��X�o���u4n'Dd�ut�H��*�L�@t5x����X _Q����P��ҽ �~b`��r.q&�
�).��Bռ�j�xm1�#�v�;��	;���<�P���۽���l�3���C�&>�]c��c��}I������H��⡌�[��kU��y�-i�X��R�y3qtӒ_e�J��c���?�=D ������C�&�X����ݻ�/���i��Λm�	]�������:�q�u�$ͪo��	=?��{6~����u����P
�Kţ���b�+v���D�)��\�흉���c;��,������5O�4��m�e&ƍ��g��;�@�w��y��׈��0Gݡ������ɜp�Z���Y<�,U�����#ɛ%� >�ۘ�6�'�"V���) 晭QCC��?=���
5��D��	ޱ�c�
������,����>�����%-��b��a�)Z�[�E�x3�~������К3SQ��l=-�6����nXw��=*+~�>�A��@��Y��1�t���l��">��L�3G��_R	4��7>�f�b���	a��V���ϲ�Z�N�7�(�z6Y�@jX?[��6vm,�<.��h�*d�
`n>B���%+���f>���{=��Q��/�χ;ߝ��_\����O(�Ϻ��8K�3^y�y���~A��:,���l�h[����z3iT��_�z���@����O'Lg41o^�)�����q'��������ު�-j�h����z#��v3qTq%���
���{��_��$��h>d�h���l�U7RH�Q��Zǟ��.CI�|�Mp��|9�/GG
gp7_Ň��_V�'��>��{� 7����!��V�^+��
|�q�]�%�ϩ<Y��G������~һ��y�:�	6�*�Ƌq&t�����[�J�ۼh�`���՟ �nÿ�g�&4��i�DK"o�qly]�h�� �O�5�(���Va����F�}Od�;��w�Đ���.Q���a���^h:<ME��)����o�O�N#K��L��U��M���D��H�k��x�\�� )i,��?Tw�F?�E�TV(��|�|�@��SRtj�I�Oą�]`��������D@����K�A�{��nA��M��s�̬c6��Ao��zMsh��#��,u���� ��CV�);��[WA�6TP�³6%M?�ږ����|&���[�c��5x�o�����y��D���$N\v����
�gМ�^�����G��x�ه7�7���dn���]����Q׏L
|�;˿��Eu��)��1�lء`M�ۋ����O�����o|���XL���W� k�B֑������)��~1s=��D扣V�pA^���G��}�����νAV���d ��:t�F|Vͨ�!���rb1����X�B�&a����������k]Ɲ��4:�l�JS��������l��t�Sq󱊼�yHyX5��K�c�gα��qv�T�4�7$�Otb���5���qI�/6IZ׽��5ԥ��_���˒8�5���%b��Pʑ���_հ�~%vZ6���
耶�J�w����� Ʋ������@b�m'b��1�4.����.WE�I�X; S��V}� l//3���\�*^9�	`p��0�(�xul���4�R�)��%�ug0���    ���ۋ�#��q ��u��-n�f7������]�y��R��%�
�RP�n@Ð���@w���d���8߬��g��IQ����Q01}�Iݾ����� #��
4��Ă�׺����h��@�au�Iea!_�?P*��O�a%��-Ca���TY2�u43�4j�����ABL7$�5�f�����#5C��cv�΍H�L�O���7,2��
�oh\m;�؅��ql�s\�R�L�d<E]���k��߷�ēr� ����v��A�c�@Q��Uu%���h�<��y�>�%K�+�ݕ[��� � ��}��
�^�;�*#fk��!k������˚E�]����c1z�����!�DA=��9��W1��-��`Eˮ�"g�5���Y��U�2�Y3�����hT�_\�G��}�y�K��N����x�	[z��w�O����S�N�>Q��u���n9:Q�	��*�&k��.&{ܼ����C}`��d�`��>�ç��]gK��j��+`p��Y��]���t�̐�#�^)��X��jFq^��-�=YE���?2�լ��k
������_�q� ���ʄ�.��>�[������f��� n5L�jaP!��8B`��A��1�-)�.W�^-mw��h?�hB�<wF\�r'��i�Vk�7�{;P�@����Z�.g�o3D1�H��VCO��c��`Iu_Ј}!�}Nj�|�V[F�Y����6ս�`�?�! h����5�Ď�juLe*7j}�*���D,aqP�]�5
�#ypaz���3��c�d�m�4��5b5�N��7��o��C����8�B�DձG:��S�@+�N]�Kq��X��� ��2'�aB��no� ;u�6�G���s�3�:��㴰�	�=��7f���H����9��>�/�؊Zg;�5b�ُ����?Fc7\�-�R���Pȵ͌~�{�Zq�F��gj!�Z٥^��UFm����%�aP�3�%�8�/;'!��ހ~P�1��w]k������X�ߍ&%Dh�i4����$NI
XU것2��cZG���� ��N� �o�����Q�B�.H;`���
���$f�T��fۧ��9S�_�V}�m�_�������aC?c��T��V]��دݒ�S�����(�{Y������]��3C0a�K���4!ɠw0���#����Ӽ=��L�����l�=�����(v�G׶j��z��<���`�b�n6�X+2�gm�Qݔ��F�j����i������1�0��F�=�a	����
�9!⿷O�3ᚣt�UYT;�� �Nˍ����ӝ�b����W)&ΓQ��(���	9tO3�) ����P�)RllbI�vW�=0 pb�8�Y���D�������ߟ�'�3��Տ,����lC�/j}�݌Kb�;Z��l�N�Q��q��Z�W���:3��M1�W�D����z�N	����}��b����9��BS;��h>f豾S�-���˲3�z4��:�S�m�P��J�%H&>���7�)�Tj|�u^ņwz�){ީ��LX-�%�@ݦ��@AD�^��n��)>�_�Y0���Z����w��!N�Q�/0�c\`�f�qI�ɕ8���}��$�%���@��<������ey	�mD#�#{0@3\�AL�^f%.
,l��	�u>oO�XL}�uüV��MX$2j�ֆ�{��P���{N���I�����h��l�Un�,���䟟�l�o����F�eq6~6�X����I��J�6��IoK�BD,�+��^�whW��2�]�u��^'�d�RZT�Jh�H>��Ѩ�O\��iI	�Ͷ���M~��9`�aT_�b�#��ĐM9H֙�h�<�]�N�������L�7�n��5Y��|�_�1U��:���ᆞ�q�7�~o�з�l����:�3-#�%��	��:u�CUl��H�)1�x�t�a���b��Xhfc8# �J(�fA<9�S�B�L�$XU`v�EBm������(����4����y.�=��Y�;�F��wý^��q`�`#�4��:m~�%r���H�q��6����4:I4�yˎ��証d9�{��ի�'^]{{"&˖�ϴ��x�r����G���u�'����6#=f���{Y��v�Gb��� =��� ����t�F؃ml>標4�'?
G�:(��/;�k���lۂ
��K�s$��Ĳ	��[u���o��7H�����1��������tJ�͒6M:z�:$P;�&��^]�= ���6��ܜp���\��1�^^�Q�5Ԟ��%q�X�&����J������j�C���X|�!犪b$Z��<���q��o�;v~�-OU�w`
T�|�%�q.�Y��:Z<�;S���4�ID�c8S�\8NF���^�6!B4������"��o	���G��T�<�S�pa�p1ڴh�۽~A��Y2ϙ����[ƺ�-���H�������	EX4�im69�6a&(����h�$�Ӈ+c�g�@e���7��B����W��7�:1�dP�!�J�Y�LTjO�њ���{�D%L�Q������}�T�a���۩�}�^�%�}r���u�-)�[���!5�B'�.h�ۍN���J�O��L*W�gt8^^w 	H����6��~<S���; ��쮰Y�u� �^��fPߛ��m���4����`��)cq�(`������'�<V�{��b#I� �`[��bq��+q`(��-�`���t�~`���W�~���)�B�q��9j�� '�)e��~>�N�����A������SbH�dٔ�~��6~�Gb#P�̰����,��e����h	{J:+��W�d
���9n�:p�w݂�9r���u�8ͅv��1��=:���=8����x�1�� �*8)S��	���i�����F���P���z��U��miwO�F^�}%�Pg�a���hf���٤�Y�0|h��;zfCGf0M�Vw�%~�b��ZMrST��K�r|^�$[�ߊ�1����@
�H�S�2�/�Aߟ��(�`�i���I*$i���3
]֯��ܭ���ȱ�ӡ��"1A��@���%�� @�j/�E$����!I�>-���(q[��HfE�pv�Z7����u��@�.i�p�WԺ��u����*��=�͈����a0�ss$p+���tKZq��x�F8`_�``hȐFl���^��ϒ�������$�1T���>� �v�;-3�X7{�%�B�@�'�6���mA̼,�oj���s��/v��'���K]�<�BWs������I�ވ�وӉ�qFGG�lL���Bڜ�Wb���<+�NgƏӍϸAF0���o)��Ûqd~LO5 sw3����7_�W�4�Y�K/l�:�U���nz�N���C��'�����ٔ�a� �K��&��`����7I��n���i��= �m�J�ڡG�g�b#^�g;Z�C��� ���6���4�'�"����a馠�n���Ώ���@<O�8nf#�ȕ�8��>�����x�P#Hm��.���)ө��t�Ll$- �%V^�����6<�(�{��{�	'S����%W
Zվ�X~�^�!=���B�c�����r���������{AL�Ј�[vVծ7%=��it��>eS1���j��\ב�M�	N��SA���^��������^�B������̬�]��n�&o�q@��y4��p�k.�c\�&<�i3��}�>KZ2D��Xtݑ�P�"()F �@�A���/�TVa��ɀ�������h��?���%���M���2��m�@2H�:դC�R*���Ѵ'yu�х7�H�ߘ%�uPW���!@羝JJ�ϑ�i��~J���Y}��/����ƿ%+\vS�����-_ጧqŹ:Z7�%L�ș��X�� ���1�8*�Y	ů(FI�٠�3��m>c���P`�3    {f< �4�����jw�w��SD������X�	[�0=�F�Rn�A��$	n&�<Hr_Oo��~ �x+�^ �����Q�I
��T�Ԃ>��Cq���D,�ftܙ\�n�\�Cp��^23&�&���un�O�~�q�����o������n��GI��q� ���'� �	�[�����$��f��1����u^�ħ��^0k+�Xz�q�ڑ@�x_����8�.����gk�|�	uD#��꾡,>��X��o�3ԙ=��b+C�S�?_ľ��:��͓���>�.��Y��:�I��2z^&a$u��R�׏�V*9 *hgj֥c ��\��L�qou|H���2���s1����ti���a\�v�w��ng��k�Y�H-�A��\����=ED�rs]&�C�Q5�c4�G���٘�/�%�P��y�n
\^�@���rt� ̦7����u���YX�&�ю��F�Z���������~ϳs�M�)>o�i����0�ևR>�aB���q��z�h��s�.�l�z+o�I�����4��\������h�z��*W�,St�ؼ��&�T l��ӉIA��W�F��19�ԩ
3���;�m��R3s�]���A���L#��������$�S�2���qQ.�鳤ҵ�ьp�L�
�hED�Kk$��S]��9=<� `^R��W��T�Br�|�6�9􇻜�<}�zIr�?�2�V��h���Xā��{4��AY���f	��Cm��دg�@�	�>�f����i��%F	�ݨ��'�x��d�I``W�ܓ5uz��ThpgF\�~n9���T� 9�F��oΊr�g�bۆ����؊�)t�_�]e��?�5�NV�f�}�BGb#!��f_7��.i����7�~%�U����\?O��b�J��8:Ch0��I�P�G����h���H	�2�T�E�s�Ϧ
�B��1{��3�[��މ�"��\��ɻ�}��}���ˆޅ�8�hhN*�YZ���}Q�gk�|o��1r �ݥ��;@�'�a�.����u�L�ϞM*.Eb%�KBpfԖ�B��!�3��jkM���y����\_w�B���u�L�:�B�b��:����_>R��V�Ɇ��~�1�%<�tg�Y+̀�=���ܨn��ľL�y ����S6�/^�y�iR�t.��v��I����(IK&�:x�J�{d�FOÜj����u�B��z\��	 @�ݬ~���3�ҍK�$!�:אv�E4}�a/���x·����+1���^Z���l�"��Ա����>;,�0�xBK�Y.��:H��-
�AM��U�L�}1J�@��.�>�L��g�]�d(��ң�-�xj��~
׷%���C�wf�ۘ�{��NF�Y@�y�b�:��Fzu�A���Ld�lGPL?��)>�9!=��%'�J(�c2��ʊ�'��
�Tw�c����TAL���_n���jRɌ�q���m ��1CE����,�YzC�J�pϺ���)������v)��n*~1����>G�r.~V��;^�3�=Ɉ�����r9�>Oн�'PU͒� ��L�׌Ah�g�R¸[K����zE͹f2-�hN/�ۇl�����hp��Iz��-��B����j�_��g�HK�F�u����əl�Z��g���+��&��Me��r���n�,G3R�%j]"\��=x���C�S�8���K���
�nT���m:��ksz��/�EM�w�����(u�Nr���ب������$܅��3��,�1�4�LgF�9zY��Њ�V7�׉hnJT+BUۥ�//�%.�p���z@4+e!�x;G��Q�@�p��~i�(��GS� 5��Y~wx�7_�#���E�3���i8��i�����ձ�����13�1��ڽ1<*�=^���S�K1�!y�>�������7r��C6��r���e8�:zB�7B��m��Ic�_%z����\�Yh�V0׌�4*��z��)�V���H|'f_�s3���%��-3�E�_7�����$�DrL�81/5ԩ�~�H��^p\^8f$��̲ݛL��gN���w}u4�婋���3�����M�<��<������m����1(���CT��b��0��q�j@�z�V�q�u�㦽:���5[&b� о<�H%�*I-7�Q=!�4�smݓP���E(A�H������4#U0���Gߡۍ�Gb#���Z��[/�<��#N��Z�~<}���Ŀ�juف���d�$��^��@2��ųb�&g���E�̖��קђD�%W��dz���	^0JUE(��m���kI,ü��~df�H�F�UF�!vm�O,Db���䚭�,t�O����0���"K޷�
�>ռ�4���*2�d�=�=���"}q���	�����]t�w�4�Lu޼�aV���u���oO����wK�wN1�j` �\"�1�I}��7hU5��)3�v@)W��u�㰆ݒXjnxVǭ�*��L?F��Uә�/ĂIu���]wq*��t��/G;����M:�����=H���XLܼL%���D��CYQ+�`'�7(�>���1 �+o)�ٜ�]���8Ii�}͡�o��S�<�Se^��Sfלw4f�����+1t�D��|4^P�c�[����ԩ�-p�g���bn���~y;9m��~9Z^MF�N�h��=�q2>Vl�ٹ�}]���=;���q�Z���� ��L����?Tgv��>�4!�&��`�8�Q*��=�V���z%��Y,`�BS]����c%y[����!�[�x%��wy�PQ�){�{$�f"�/�Pf���Y�*����K����dB�vOČh�-��ۺN�;xQ"�3c���_���y"�d�ukS�&h%�O��x��`��&'�PB��n.��5�yy��Ry������oL�����
���=��"c��&��v�Qb���j����<o�ԡ�SEʪ���ة��%t�ޒ1��q����.��G�AI�����?����y~�%֬^"y8�G/�X���m4�n�Z��cv!��j$�
��X���x$�z6�B�����Cfx+Ŏ�zKt��@���)Z)F�Z� q�?���A� H ���7�z�� �V� Գo�GM�:�sd�\p�͇�������/L�5� i(�$i�f ��+΍��&M�B�@<Em1�p{��y������c��� �b�0���qA�,�H�V��#���A�W���.B6�Bj<*Sev��u�J-Q<Z�K��1�kM ���R��Q���$�؜����h�-�k���+Ê�ap�H�l�aQ�&����ueY��:3���z����G�M�|z�s.79��+�H���땁,�"�Q��[3q���d���C��z��/����xR������=�-���ڠ�Z<���u*@��\_�T��8�����%��Qg�J]4�ſq98�ǧ��� ML� ���L�,��۫���c��D̀WH��Xx
�1HG�_~pgcS�>�V,}ږT�9���b�^�m
������2S�Z�X�����3n���LN��Pբ)Y�*,R���}����'��Asu�221��`���E8��k�3��>v@��'b)�Î0>ߡ+_4s�U�Dմ�q���\a�
�i�ɲ��Fg�y��SL	����T��.X�@�7���p9^NO�b�c�}H����V�7V��~�\��L�6LA¡i��3��:���tR�S�=,�_8S3�|
)z��H�!۩�������d�J�%SLf�F)��:��q߫��	�w|$�z;и��F��
�����e7:�N�6�v�Dl�*��~6�{V��3v?0�J���qh�Ą]��V!POYy�f>���4�O�8�Ą]x�Q�z��T	j%�4g��^�'����E�\𵿌/�Z#V�U���.>�ɸ3�͔{e%?١7�>���S�S���H������yP�6����C�����[�g�@�Q	b��F��_�ɲiL������vD"�'�    �|�꽋属��s�sMm�Ƥ0��7JK�
.����\���R�4��0b�����)��y�j�C�?4�����A���3g5I�, �.�Z���eK#�T��W��e�pǄ+�<�����y�Yz��Xso��>6J^���c��w�S�~^'f	"��6�9�[��v9z�ʹ&�mY㵛lO�����q����\Kxk+�4����>OWu'�\?�%�Dye�aJ3���GH��� ŏ���T�~�?��CT��iK ����0e�uL����R*�3�.ϣ�'��
/|�!�֕�տ��Mt59&�L��^��-k��PZ��+�qoN��(,�|��z�'�#H���� ul���H��(�'�F���Mbd4%n������FbڻQ:S�Hn;��K>�������T|�G�,O1X#s��`OH���'�)�ſA���_.��r�+�T	�����w��{y��XI�Br�H��´�Q��Ъ�������8G�P��TS��	4���7�D0�q��>/���U�rmqL�2�Iƌ�����-��d,B���Ss�w����q0C������R���޶�D9�.F;1�e(���v!�b� m ����'�/���o��V�)@�zv!�-vu�D�����`�)�P@J�w���q5��O{?��r}�����_c�z�:�Q1T�g G�CpT��8} ���]I������8��O&�y^5�P ��:��C.�u,��JM	��Z�>�y^����v¨>����?�%�$f_�#��Ǝ������%'��,��T�H)�l��0�V�O���g�n^�%�V�~�z�re.{�ܽ(��TlsϽ
��>Vi��G�T�x�6�, *f�&,}!%�����p��|�nCj R扝QC�%���!7P���Llh�Iw���*����R��� ���0��[������o��b֕�8��M��}��(I�!G�����n�����;ɼd<)D��\m4wA�p��Ņ\��U��a'�K��"�;��_{�JK�e�R����ɞ�q`M�6���q��~�`;[��y������Vp�T���L�����=O�e�������a�)t=�فӘ�3�T��c��9�%0n�R)��<���g�K�^�h���7�A]%6R+P
�����CCz��$t7݁�0�`��;#�yp��ih�����1&���6֓N,g�H�ͤ~N��l"��0���v7��a���������M2��GXt����Xb�op�G�8eFNՆj�
>��2��FK���>���͂X��N��Y�L�->����c1���  B�f|:鳔�f����>v)����֪؇0���w��V�p}::;)�|�&���^p#�1�pՅ�b��1�ob��Z�+f���X٩Q�!��r�&��G��X�^u�o�0В���Nm>Sq��$����y��R�Z�m�mŐ�L�c��U�h���:�H^�����nI̸r��r_g��O���Ne��_��<�e.��%[���fV��C,�3\�����P@�X��#)>o��̢Kf��V��'VB���l��i�~��B��G
��')������N���F� F�%�c���^�H7�����33uȔ�]��/k�N��u�����e��(�̼_Qr�1y'�{���	���e��X0MN�.{j�������%����,'SG�9�{� $�QK��wT�4ُ�#Ԏ����I�1=��
���+�1h/�Y��W��d��cA��ɼ�s��~��)�4��(�4�T4fƜ'qx6��l4�c	��q/}�Y�թ���ЎR�\J���.�|Ĵ$��)�!i��Q�E�UD�Y�����q�%b��/��)N��Q���K�1����)N���i�b!ieQ�x�
��K�t+�_�����}>O�p�i��������5[���P�f\�
�U�g.����K�YZz�jw���%��m�����l�*��k�P��O˙���3%o��lnią�l��7�h�oO���o�~V9IJ�gd���H�Z�J��Һ��X�yjv��3gz��MQ���r�� q��%q�ɚ�+�c�� }إ� C?�ۆ����W����o���|g����h��	��%C6�G1J�p>a��@�j6�;�VhCe�6���,�r5Z ����| �R��n/a-Gc>�>X����>],�����H�]BL����ɇ�n9Z�D@^��:���&WN�?����C���d�:�&�#;o�����hY��r<pm�L,���^�^?����-�u2�(կ�43�Rxxg�j����'	M�N5�ZB�B����`¬%ҿ� �g�$ĩ݇���@���>H+8��wj���y��L!��2���bm� �F�:�b���D�7���df�*�|f��R�:��q�eAk����YW�_Dt���^f���$���A(�A��ʹ����h��`	��G�)C]lɕ�1��
�4��^VG������m�7Zf��ϲˣ�Cl��ԣ�{���Ӳ�L�c�L,����%�-��ha�l*^���o*wqJ�?��h=��w��2�:�|g�]1���h���'Z7W+�Ԇ���
_��ˌM����eI���U���md3�2����=��(m�J̆�����/�)GA��W���aAj����L]���f /9��a��W�4�*k3�o]�UI�GoC?�N%V�R�-N��c�t�2�߱}�l������lk��-\�v�P�oJ4��>��c���H�0"��(�L6��$g�a�6�Wb�Yy?�w$j����<E :��:`���ଽ�d/���Y�D@��2�o�V�Z�������]{�Ϟ4�f��7vq����80�#��Kb��["�i���b�N�s7J�!��w����uf�ᬫ.�h<���f�_a���$�^�@�Cc��Ti��T�@�p�ךh\�$�zz�>�X?9�"%�I��Y�������x����f��ŉ�)�r��EQ'\���.ns~�� ���\�B��pܼ�~����2eg���=��J[F�g���A]����� �n�V`��؊�mT$��y�V}|�K����R���r�������x񋯊sݼ!4'dEkYt�K&/!,�cY���8L"X?�;j_P��T�l�Zu9Fޯ'b	l	�%�jǴ8�M��Pd.���P&�`�Em��A�O��4��D���	[I�O;���[|M괋N>�9�Iu��Q"�(`&��~���Y�z���L�L,w���n���SF=k|i���O�½g�cG#��\��;bkӨl��ez���'��a:۠Z�s�>v�Kb6492/�&��O��"a����p6/�R��`^=3,I����C���0�G����$�S;av:��K�g)�JW��p�}�n��JL5�ZI�dO�L?�8Z �nO�Λ��J����ͪktr��z��uc�&c���z�]�+	N�mX��������b�������A	�-��I����m�T�b��?,���*ˊ�u]Ez�Dr���e����tz�(	V�P��p��5}���)b�q�k��}/�	��P��(}Ǡ�����4��(�}�D;�:Ua�-9�jfS�n����?�G��ÝX
�Bi��Y�:?��0�K[ƣ�0;%����$)�c>?J���~y�z[�0ĩ�E�><q���v7�8�@B)�����h�݀��ٽ�A:6����b ќ�`Kl��W~:��$�cB�Ȭz	 $s*en�%Z/�\+��	���N��
��4bul��r�����һl�7?砩y�,����n1����Q�Zm#��v���`X��D۰�*�����>=[� Pk=�H���xn܇qj���_k�=�O��K�F���ai`j,R�9K许ʺz�n|"n#��^�:��}W��Rd�e��f�={I�to�ܓ8p��l&�B-P�;\�_g���$�S�}����!Y�Dd�Tr �^�v�'� 7,�����b
T֒�ްG(cտ�����dj`��T��3g���P��[z}�:�v�D,uk�ua��L,E�\)}z+Y�����=B,r��1�    Z�-�J4���5C7 R7ןO�l��#���B��D�z�|�y-V�����b�Jr�i_deMɿ?cȭ[g�&qZ�֤�t-�0t�&9}��v�K��7�`ʼC��&I��dkT�;��9��d<��կ#�&K�Ve-Ċ�o�]^iY�٥�-!�)Wb�_Gk��d7G�F�(+�0HU���~ y.r*O\��Me�����u��aي��C��X�s
�)`3�
��pCK˄flu ͷ�:>_�if��c.ԼCI�8�f1����N]~q�����΁-�f&��8�՚F"�^�~k�Y�x�K�W�$�
���i�i[�^r����=VOL�%�Fɡb<+/�:�n�%-���5�l�»'S�R����|�����l/	�ιP�+�9�������6f�45�#����#?9d�B� �j����X<�!D��)��vܒo8J�����!���#:��a���SҬv���8��k}LE�: �Q�!������%�t"+�,�V�fZG���ճ�`���:���8J��r�l�a�r��(ۋt[ߝ�V~�_�hЈ�=}��g;hF�Ϧ���=22��S������>����#�m�b�JK#�$�@�3�W`��zz�	x��Sݑ@�/���#/�: >?_�B��ʦsd`��&��Ӟ1k�+��Gly�;�\�{	�8�87&�Ggwz�45�/f�$���o^�*'h�K5�L-�>7������pP����]4Ú�tc�*�����}�7�6�zϑ�d�/��K�A��X�dR�= ���[Q ��r����	m�����N��檑M��Ͻ5q|��(֪l}�"O�Ո>?H\m˃��[�Ď�j%�NX$	�!��8�\鯃���[���2^�����Q��2���p�,!^��8U�����lȎ�B��jg��w]ނɜ�XgΓ:�\����F��Y]m7P��9
a�� ��g��~�/�h�r�y�$v�X���g���dD�txA٤��&m+� ����Z5��sx%f�f�gb��F�|L"�f"��.&?�(�$"�����XDY��ILH����_�������2S�d*�g[g-�G/�Zp��0���q��
̾ܿ9�����ֹ���� H����8 |x�v&�L��@aM�;�^���ꋶ��M�l�}�u~���nI$ p~�_vҙ�o K-%�]Ѩˁ�bF4g�שׂ;TX��HT(����o�����xj�����~�4٠/����c1�H��_g2�ο�H���S��h��k9���	Z״�,��D:�w���U�|���)k��HSi���g�?�c":&r���<������c����^�=��́f%k;#��~}L*��aV��� C�qI,�}�M&2�s��=�����Y·Wbl��Qz2��utj����f�~в�,ۿ�d��2J��y�5Ƭ��h'I��n�����̆%3����ox8�K�e&r�?�j�ޟN
�h�)�Z}A\�G�I%t�j�La6s�'kޓY�˻)�5h}X6;���g�:YK{&�^#�^Kè:��v?:�7Ѭ8�#�3
k�&�&u�yg�岃�9���7p�2���0�ص�^�CJ��������M�az�+�)�_�F��w5F7�0-������9�j�����H�(P5z۬�4�
%
y�0���^g1c��Y*�� I���I�v�Ϡi�t^�����M�k��bI� �} O<}=3k��^),�P-���ն��5�O�S���̠491;fy�~
��N����'b7�|3�Z��%�l��6F��O�t�2�އ;C�B�?�s��~1:�e<xVO�/K��(��W�=�r�>�ک'��{�n<��Č���tY��'b3��,�Y�qj"*���T;\��~~�NZy���撓@�L�>�-]^�:���'b+�N�sg�,�3ZPG;�Q��k�^�Z�|Is�`��1�֟��TE�d�5o�ת�l/���6�y�[g��P����>�O&�K����O�T��Xtp�h���-R�`�44�;��I�����w
�%	S	yB��zwl�;4e��J��7�5�P�v/S��=@v��=Y�7�ԇ`����FeyI>2d��Q��AmϸV��U��W�ڀ��r�i�c����~9Z�-Ϛdu�4��jj��l�9��A��R�^�D�x���CW��t�:���Xs�R�bQ�T#Ǹ4�k�$v�뢩R�P��`X������Sk�� �؝au�J<�j�a9Zr����u�T#�|G4ڊs��B��|!f+U��\�T�y����h)�Y�m6ӯ�&iZ�[�ړ�y�en�ap�'P
�h̪}�2�v:^]	��rb	���³m �Dc�:wS�U�,��zy�T%
0��Æ���g`����jx���wb��`�Ԯ�r(1w������R�x�
�Ќ�F�{3��r-1�d������p�H��� �Q&�):��ߣ�s�H,���W��S�s��)��U���u?�^��3�� ��S�e� �={*qc�>6.����Xv�3�T[�'HS�6���6����~"�B��a��
b`tM��.'!sP�o�y�D,�?�E��9��S�j��N0!�>$��Kwl���0!��L�Jj�B�o[c���4ZRD��L�stu��&�(��,:�P��09=d/I.��ք>�{�E\�G� ��������b�C�_���MI�թ���P� D)���i�V�>A���AN�b.w�l򠾾���ߟ�'XG�F�$յT*���J����� ��-!@R�v�Ć~��(I]�Ea��ӄ�/�Wb�E�Ķԙ�+mw�<A����l�f��S��o���z�m��P�oId���3�p�����rzY��w�=�����$��L�T�x�Y�s(Kg��:��FK#G�'��P���6?d�~'�αK�6Ĕ�l��Ы���~X/��p��-�hl␒:�K����s�$��u�qN��'�9��{0��UW��o���R ��c%��D��Y��
o���|��Kghh��X&������<�9"�~�	�`ȓ�Iz�j6�7����u&��ͽ�_�B��P����u&�a�(�x�\m����If���ͥS��Qf��y��ze�_�-��W �o���,��ȩv�R�S�bu�a�,-�����B��RB�GW���!���y*�|�O����y��r�pň|�t�P�`~�����X�ыw�M����Cb�V{c�>w�������49��q�F��,3hɂ��ݘ��?��f�̦� �N�YR:Pq��<%m��1ː� �V�Uc�Y�A� c�V�l�<[�c�L�!T؅�7��1HTC�tf�ɒ_�1�y��i�+k�zq�$C��T��Q����eKh��u��J*W�� 6�:e�Kp�@���m�
��~'
ͥ�^�����5z�?�����X
���a��(e��a��j@A�\L{ZK�v��p�T"c; ӝ�ϕ�o�,�SApE�	u|2�_�n���?.�Y~�F��g3�6'1�4��FԨ�[�v���R<�^���J�Y�ċhr��^]~��1mH�P�ԐV ն�|)�22k�<�~$�S������,<�c����=���V��:��S���LQ�\f�)�	�H��Bp�"{��ls����;<��>�"E���(�[���i��]��;,���1�m�pΓz�/E��_��1��XGF�c�oM���� ��rF�{q��%B^K.i���[�y���-?�!���bu����>[�׷�h�#ᓙ/P���m.ܓEz�:\p��7���d/3q�I`�I=�6lP�y��b։�jq6�5yGI�e��D�9��~I�\�R���c�$+�ZI}�c{ץ|�_wG�Ċ%���H��"=ř��ɸ�k����fv��9�n�L�tפ`iEG9����.4�@;���Ռ�#u�B�i5u��\�8��ٙ�v��S4���sڎ��vr����S�a�u��`��s���<��� O  �iWn��h)�V���9�O�x'j-��:����W��+,�4_�g\ �VJ�Q�A}_|J���7����6��0f����\�������eCwÜ_���o�^��ui��'')=h��?NE�`���V��L��F;��,5oY��2WY֒�`x���:n�Gb���Q+���̲F�e&��Rf�]i=x�H,u|h�2�%n��b�~C�y/FځR�����`�l��wv��>��І��X7�Mu��5��� �P�sU�����2cB��MQ�W����#�D�qY����9���d�����T��zz��d�X%�Ԟ�xZ���������}"��\ M5E=3��.��u\��k��T�+t;�����.��|1:�ׯSA ҭ`��E��m�(E���*,2[�ln�T�䭁��H��7��zI<UW�,�:��[Չ�K�3�q�K�p�-���;�'WgW�$��V0�뚴/��S�X����/1xZ�},��}|k�
B�{K��f���btb�<'y�^}}�X���#.�8�E�q��b���.�0RXu���vIl��E��a�Ne�>�;'wV��������m �p'Ό�a��^�]K��q�����K�5�2O50~א?��n�^ػysYc�
Ν�_��Q�/w���-���9�R+Ϸ�bK@�����'Jog�������L��0�@�f��?��H���}��m�ҿ��d*����~�O�h�>k��c���3����������0B��� ��l簍<�øu!����� 4�X0��^Ĭ[j��[��� ��wI\�}kt�m�ԋ�Is�/FS��2�b� =��G�%�f��=%���Z�$k��Y��%��q�:�φ�
ϯ봙�j3��N~�.�J��b̟�ɹ}��^��)��v�<pI�I��U�g[��m���o���_-�`npR��`8���񙸆12%�ށ(�BY+�L��H��u)��I�p���aLf-xI���9$��:]�v�����u���*N��g�I�Z��t��V���ef�T*�C���<-w@�Ǐ�h'Qy�ձ�c��4F���T��q��MĄx�>i� %;;Mr�r����c1z�W�5R8��r?�;�05�r�y)2ScRI������*�Sh��B�잠6<Ǉ�׉8Hg$H�j�R�Gr1�>���_�d��a�E�-3��ɗӲ������]�A���m�4��T%��������ݒX�/j͔͙�3�y���8��D�����]���[˪��N<��1���``��T%)E%%�6��-�����!G�NliS�S���D�O�M��{�c3.���wd��z�=f��1�ւ�м���/����g�¼$m%��9�8E�UV�����Fb�e��j23�E��1���}�b1����@Z�|op��Z��l���SK��0ܱ�JHba��L].θ�]�JS��b��������j�]�[�mm��͂8���eQg�̪�řc�g��7g���\�N<���K��>Ir��@�`��o��ð$��v���y��_����4�͍6��	-�廴t?�q����3�t�236���ڗm?���F9�����']5dV���[���� �Y:�      Y      x���K�庮,
�O��tউr��-�d�ۑp���x�faa{��I���y���0��R�OX�w�?%����]�R[�?K����lj�Y��z�O��ļ�',��Pް����g�?�������',,������!���i��[�h`e�~���^����_�?U>���O\�_����ϗ׸���ۯ��&h���g�?M�V����d�V2_�J��I�O]���i���yZo?g�Yן�F�9��^���(8n8���������֟�NQ�����չ�����?��t�碰��c�Y���ϟ~�4�?���Xt`��@�ǏHC�>m�����ϱ���V}Z�^r��Ӎy*��V�~�l��8!�vaJ���������v�>�90�z����l�|(�����|����?���V�&���p�{�?��7K�O��~��c�)��
�[
��FRtƭ���0���ٻ�g<%V�$S'�֟��Hف��-��r�d�1Ł�'6�=Yȣ�B֩�l;����?���RXs`׊.;��1پ�n}�;0�0a��eY&"먛L���-�}�&Q6�&��8u������-���"4��liaa��.�R�ʗ}�)벥��e=/��=əZdK؏~�U��]6ݛ�������?��f,�~*�����{d��gm�/ii�!(�����1�Y*���b���{<�p
�Ԅ�.;fPA�7}��H� }d[�QĪ0�؇�O�`P����x<�O��	�w�'� t�X�Gƹ��N]<Ic���q?���I�ğm�l2Q'�^.J�x���O��ۢ���s	S��l�UO�"8�2��2rH�TO��&��g�m  �l
�/;���k�Nݢ�ұ�A��	^�
������C�F�T��WO������������н�^�
WE8�7��������2{�u������د �����i�
��5፯�ӂ�Y���_�2N���6Oњ��\��[2�b4}���e�ˉ�oU����!�#�7�kK+/X�f�޳^R#ќ���>�؇:���u�����8�d��m.��ނ�?y޳���Kֺ�1�o5�ɴ]�[���8�j"w6<��y0��(O"���
�������D���D����5,D�z��h`������l�e�HKJ֞,̬���xʱ����ޱC¥f/���T����h!;QL�+�W3��e���M�*ǁҧ7��	�n`ż�L�"V�4�2���_�������\�$j�pjˤ�Xn��B[���U���������rչFt`Ќt;Qw��#+�OKl>�����d��Һ���o[T)Ł��S0�MT��|�du`7�FsƝ�4�ǁ�؆�|���{<�M�,��� �[��-����e�/�K�(�-c&��'e�$-�A�E�#7C�;o
���������dc�O��C.߻������%�;"C�)���0���O>`��|��%��-L��FE>�zR7}���]4�ָ�J�K��d�<�09OE�҉��8�YX�h^��k��%c�	��,>�q�v\�i|4lrз��=�g�LwY�?���\Z�xZ�y8���0��l
-�<��������y�Ί��O��r��UaV��N����soP쎕���-L�U�҆;���CR����	�E��<"v�{�.�J��dI�4���
u�~�����N���E����yշ����U�K�ܳU��[Y��㭒�';���aPX+좄YX�|���\��������<���{$hH���4�N��W\ΰSU\lJԧy��hR�s]κU�ȃ�I<�y���!Ɏ�Bm%�����E:���V�Fׂ�Qr����i�ؘW��H0�	�,=X�F@²y��B�a':W�]�O#`�U�^�n�>�~2.Mo%��)d�[RX2��Ky��"�~����Q�<�|�ɔXuz筠P�;����ͮ(���}BfL0r�ق~L�0�4ѧD�#���P؋�ߖ�=�/���e�G�*����u�M�����~�����e��2VS'a����nɔh�������-��9��HX��m��;�l`�
:��{	>����VՌ�\�	����Y�$��%H����4����na�^�R^������%���N�y�-u1�h�w�����%����/I�8H�Esb�kJ&�.�R��	R�3n�C�5;0�B�F�MU��Z�|	<��ˎK�~Lu`ǆ��%]��ڼ��|�|Zw`��>B<Y����;���@�ˀh1���K[|A���l�r�W��v�YúLǫ�W�f�q*�fiaa"9�K��a���5K��i�]�s`iaar�@���6x�w}����a/��YOXW������}��K����� F�������o� ��'���%I.x��-�<{�EV&�
	5��]���v���rm����فm6�a�#i�+@/�p\��`����!�����yo�[<���vJ�;0y�B��ٸOU��gv�����|��8������2l�>��ǃߟ�/S�h�Q'���6	~f;X<&I��1I��&���Yp��Ή��hO,c��� ܘdiƭ�a�.�}-V�I���Q�I�%[�<�b���e��Eyk5w��]��&I�s1��J�[�J�]?�����A��yO�rs�)>�+�O�M�����?$�p��p��u�k�|�4է�����@��E#Z牟TXx��B��̿���q\��j�>�p�u8��d`��Y�������'��>�אK��i�K�}N18�ba��zq��O��'L��ڜ(Z;>T��������K��X{��}�y��o��^����3<�Ɨ�E��Լ�ۈ,K�z������`a�W��79���y��N֚�iLf����'��B-D�9�o��l�5�%�&�L~�[�����S�-'�uÚ�%{rbN��37��j|~����AvnP+|��[�9]�00{��� �/���Ȩ)�q�ֲ�jZֆLZ�վ�����0����)X��\�dX�dׁixՏy	�	�4�
����4��/Y�Ɨ�l�ZT�d�?v}���D�>v( %B�T�hM݁�
t�q�ğ�p�ĸ�2ʬ�Ł��#ꭼ�ܛ#�`�EL�Et�����X��J�(E� '�N�,5�Q SGR����-%��\pd���,->fR�����wd�YZX�-����G��%-/V,�W����mZ�!��nkק��5�`6��rX�N��?�eq`�iɵ�CC�%We�d	l6���,!,9��^���ր�'������%���CR�+���z�����w95���X�L3�q)D�@H�fY2MI���D�2�3cS�Ē9��Do�������m��iY`�]�K��c���.�o����%�i3�d� ���['�اqc�1��i��KN,�A5	F�c�՗Eub��a۸���`�K��&���#�U�G��3�N,�����-l��ZpQ$lb��VU=Z��G�2��6��>���f�8z]�ͣŭ�4���?/7�N�/����}}h��kG���*ɩq�f�<����'�[�o�hE��Zh��oD|m�h/��1�ޏ�(̓��V��h��	{�Ŝ�k�Ȟf�̫���P����F)#�f>�l���!���5��/�^�Y��obE&Pe�ʸ��4��q��[��89���DtS��(>r��}�T��i���ZZX��9hf�0o^=�z�7>{�;�r�^���:�Ӯ�y��^ƭt܋�>�xz��2]�ר"hH��@�q*,X0�F9���ڱ3�-J�\�����2]`��O2 �]ao����	/!P��`Խx�yЧ���ϑGAу~�i1&�_��x0lm�n;��Y�o��ɲ��L9>��Y�Afh��[~v2U�ǋ%�U�3��sG<-����>�eU�03�hjˋ%���ˋ��)j#my�W#7lz��(
���-с]4��%.��imIzȂ�zٛ:b�iف�QH����#��"�=�KVw)q"4ـUnmilm��Z��q���t&'��    � �6T�+'��Be~�;���Ł�6҂�ŇGS,�5�
ގ�wP�b�q���x>�M�D�7;^	�����3N�O����`ǡ���f9aÁ!(2T�Ck�Խ[\Xb���|c��ľ�C�F�~f�l1:�m��S�<V�ë�Ӓ��C�6�r5F� ����+̣����p�ǃ�q�\Ԑ'V�֦]a��0E�O��mE�`���Vɓ�C�rn"-U7��I����6$���0W�g��b�Ȫ<n�V<�y�]S+�Ĥ�{�K���}`���e9\��V|�/G�,tDҗv�o�	����I��o-[`ަ&Ŷ�	��E�'�v�ڀ����Eޓ4�\a�+lD�Ч�A��yO��?a��/u����t��.剶�oC�?�6컾U30{��hB�W�KnO]%�_�1�`�*�`�֖`u՗O�mJ�k�0E.�9d���C�c<�->�W����bH�����{�˗����&Xp]�ʄl(�)��l�6���M�0x�\LD,y�m��B��V�;������AX;�X!r�FJ֟of�<�p'�U70{]��ċO�si[�����[�u�����Јx��R߂o�j:Ya����A�X?c4[}ӂΉ��6���O���~�l`֜*��*�Ua��Ƴ��������V�g�~mg�W��3���h��|�F/:rT=�݁}&@�:ا���Ł%����w\ ��ܴX��
k�`zý~[t`"%���s��{���֒�ղ3NT��a���#������K��b��Mk�Bk�S.��M�偅����� ��YL-��pW��`�L�S���o�&Gő~ցE�l=N��������*+��
�<�@ٵ"�A���%--�|� r����{J<Z�VT�X"�;̊����=��C�!���2+�~�ǒ��ݣTiz�弑3n����r ���藬���G���	Тm�֙/�y���0�+��z�<Z�^*�\�D�6޴HS��������:,4�0y�Ձ݂��|R,�-a� W͖݁'~��>�L=��J�d_�Ώ��#�c�ї��v�)�����(,:�c@�;]�SaɁ�~����QDq\�y�XYRj�8|�Z=��<Z�����������<Z�A�[S���ݶ׾L,�������[4���j՗�%vo�he$�C�+��eb���Y�E�
��	x�0�dN��E��z)wA�&�|��=L����z�x`s��-|t�x`����Jo���KЧM<����5�ܙ/�=L<�Q�B�.DV��`��Kz<��bO�s�-��iO��	�K���Ob����ج0]��\#?�~�ӀXqɴ��~�����U��4 ��V|������� gꢕ�8tI>-�
����=ø��E��B���i@�7X�&3;��;ؼ?��E[�fa����k��=Qa�K�ADQ��YNr��%�b`���NǞ�Ч����ŃPg��.9Q�95G��7��KUAQ�i�s�{z�O1�"S=��
;¦;uz�b�Ӭ,O(�;
�4��b&Ӌp�Y�؂mk�">#����|�Vn�t:�2`�_��^,�p�̊��;���n����3�{L��=/θ��ATR�rr2̾����U�O���VUNrt`��#�`���~Ч%�%��D�=5�R�iف����Q4=�%'�<aՁ�:a-�2{<�7��	���ѱ�-��EU��w_W��D#��}�<���r+�XX� �9(�1��y+��q�=+�q�+Z;N�~m\�;vj���bE;}eÆ$�YA1��M��b%���zKz6ԮL�F�[��w�P6��a�jp`����"M�vW��5:��cj���}4
_A��@M�+�8�L%���V�J�V&������B��R	���O��q:r�
�6���8k�/&ĺޛj�<���c�6+�������|�YI[�p鑣��p��`jhoV��5{�����[IOo�`uQѮ�3Z��f%ma5�H�w���7*��J��fc+a��gs%a��EU]�d�O�֗��Qo��ե�bz��w�s%Y�<�%�����m�T�L����X[ݣ�,�S=�6��t�=Z4Vy�X�%�T��-��ʢ�k ��u�<Z�k��a�cr�+�J|鬥�7<�/�`+��|�'x9U���G�d�eO��T֊���Kϣ����joOPR"��@���V���vzӜ���<�&����	9�W�ʂtz�|Z�9�,?�|��;ļÙ���Π??^�8��4!B~O����Y�i"l_���l@�=���46��,��ݎ��X|��t]�md�t�8��i"l_�[������G�W�#E8���~��|1�h�`�6�2�V:u/  ֺh��-[�(Bs�x3�d+�ƚ� �X_�;��9x�O�w��o�,������ϝ�-̆ L%K6��'G�4���DQe��p1�Ժ����Z�|	8��PS����#j�(qw\�8�́��f,W$H9��~���ڈ7$_�p`�O���9w:iF\���#�?��fܤ�sJ�:���K?:&6_
A���x����N�3,��pge]�<���Ơ��bO򶪦�hy0}��:�;Kw�^5��,&��s� ����SG�<���Z��
o���<H�r�0�V�R�����<���e���T�� �=Cw�dYba�^�,-��b���Z�+�C����*�6o�BC�&K��3����4&b!*���A�L#YZXX�f$R
L�� O�&��f���Yh]������!�Jtz�W� �Ң�]G�� :���٣#�`��Zy٣��{���_�RI���Kn6e��qF���b��B�HdN��9��0��!�ra�����KF�Ѯ��P
�i-n��x<��3@mg�ǥ[_�xpOq�?G��<�˂$J�,p_o������h6��_�Ȕf�Q<t&4m�Y����V<	:���S�;�o�+U3VnF�ҮS�� �3Ţ�EY��'v�'?��_�n��x�;=�F�C=T$$½��L>�߰�.�͆���'���n<�7/�o�;.�q6�P�.d���Zئb<���j��j'c779�Ӟ�Y�^�6��F9����iO���YK�Wˠ�'v��̷͵���>�8s����x>+*a��K�$���/�*tZ�x�	�f�$��_�����~��^<���L�h���;*[60{=�7�V̸��Yp��J�0�a�j`�<��\5g�~����\d��K�OK�o�S(לU߆�6�B���fef��C���X���Ubzp`j�=:�z���"x:�[%6N�@{������Ł�a� ّ�"{�>�:09�E�CɈ��P�����d��]	�[�0����PE֤�0�rq��!"F����V9<Z�L"/z�Ǌ"��y����q����~�������`by���D�E����]@�%r��!zGg0FV�x�Y��-r��ʣ:08ۙ+;
��]��h,2�Q�,һ�dw`؟Y�@�hQu5ds���P��e8[�`�M˲8��<��s��L!�����ʸ-��"iޛ��w�%6��D���&-�3N�����@ʣʥ?_��Z)ݠ��Cf�5�6 Jl82�q>�{��p)$�o��y�ӆ;�M3�cY�W'�i������3���c��<�I�����m����ӌ0��u�B�?ć�ȏ�<Z\�Fhptı��<���8v�8�S���B%0�%I�	,��Q�,�,���� �%��K��-@�
a�c�\hP^�6��V��ǒ]�9��E�
�cɽ�D�h(ƂWAx�	̣�\=d�,�����<Z\n�GV�s�$�-6v��LZ�T�K���<���M�F�ԟe��[�M�G�D�������X+m��`�]aFBFU`.V���K>,�q�_����1Ӥ��]rμ��WC�e,A%�l`��qR�h�M���Vض �Zx�H\*Ї�2�/�gs2�^��\_��g��(��|�&�ar�D�nU�"z    �i���Ǵ�=x�З�<L����?
��H���RV��D���q����^��Mx��aNs2��_�-�>Eve�h=Yg^������W�/�U3n��"�E�
�q�K�(Mc[����Ot�������f�ș�|(Ҧ�d��L~IW��M��D?ZC0�|�%�D�G���nz�茛}����`E`�n`�s�G���6"\����ϩZn),U��;�WD��*�R��"#r2g/�Ҭ4o�W�6;3R���²dr��w��p`! �8WĪO�-dO�ZX�hR
�-8�M�4��B�oM�x}N.]$��dS�l����*~p��x��#���+�Ը�V���r���� }o����v&&%V�̫�5�{/�X3�x,���Jol�5���Ł��m��<�O�������2�!%�	��W�l�φ�4��\�|'�ԙ�D>C�Z`Ԇ$����FÛ�kθe9X"��(�o������g\a����1v�.�Q�k�7l�F���o�W�D�E�c������ҵ�ؖ�^��H�b��A���SwO�7��'i9�D'=D�PF?�<�J���w��K����,"���e:�ȃ���`(�$D�+_rx<�̥jj7�S7<�S7<��f��H�6�b��x����KĶ�Z�R�s5� xN����$����hOF�uj�U���]�S	f!RX<��ۇœ�\Ʉ?�i�S�#�@�6,�hQ(��VMhĢ0O�p���|f���=$��&m�Pe/��5a�fT�i�S�ЖM���|�֞0ĩ�3Yiߗ��-+�n`6mv���a�@˲J/X�\�h �v4e�Ex�#�C~DC�6�{ܜ�s�\."�P�o��	~�SJO�yD;-^A��&�0�{ĸl�fۉ2fa����ы{��#*V�9Z#&E_Pʇj`��Y�_�.���޴�S�a��P�f.j�u�*x�t(�xV���o{Ӣ���V�̓1�t�;�,��B��|ӵ��}ܶ�1�q�*�8W:��/\�U�YC|	�#lU��_��hyjDXמ�h"��T
oj1Źj6%��.�{�����vh
r[�.u�	�%i�Ƭ�<�B����Ǯ�S���5#���"#�YPj2aс͞)�dJ�O��8����^�/�[�|��.���rYa�+�k|�.��՜�|:��'x�+8Y��	!�eO���ɞ�eS�� A
a��O޺��cL��K���I:�'�ՓD�dO��Iza���P>Q�n �-�D��lt���v*�!7���|᝾4�XXw`�^��3��f��z�A���x0�P!��f����P�K;�E-��f{
,:��(;�����>���{0e\N�c��'K60kv-+;q,<B��FX�`���-�v/�by`�eVx��C�]�R`���O٢nHJ�bi1����g�����E:qzG��NՂ����������IZfi�1u�L�<��8O���({����y��o�|�'�k�r~�@ߵ/��,l4hf�ZT�#�ZX��QNL��b �c����Z
�
ގ����p���Ь�-�ҶO���y�Y�O����,�V̲"{�@[K~u��qٌ���7fIgJCT����z���z� AX{�@s1vmL�
��ׇ�Uw`�A�����g���f>mA�i�O��6��t4��!��l���N",��zr7��_���^�wZf/�$m?�	��G�f�Kݹ�v-P%���C��^tvY�U���e��ޒnS*lU^,��j��ޒ�sݎC|e�޴ ����Y���쓉蠨)m)�7�ha��e����F0����ĢO��P�i�Xg�ͺ��8{�����G7�9���@J�qLL
��i��l��}Ə��?��$�X W�"_��=jt֡����|OU�p`�B�8���9	������D3̔\3q�|���q���8+f3�*l+�Łͧ3�V����I�3;�/�i+�¬��N���X36d�'����}5�N1X�O���l��"�Χ+x�X��,P������?ʠs����_�#�C��fy0����hd����,��VV�v������nYa��D��墱�(0�rb�s�H+Tm
�xpL��;Γ���E,邶��<I��z!"���#���[y�^�ݓ��忷�$���!L?z����|ɜ�b�͇ɒ*���,"X[�;0��#e�S9�v]�q80=�bZ�����&���>�c�,���q@_�Ӓ��w��aВ�s���%c�Sq`�n���J{ x@a-D��7|��*?_ҥEcW�
k�@ �>ͣ�/��
;�f̣�Ů,k1t�%�c��r��k��;�<�N�(�i
�y,����$;�W���$!������6���p������8�'���o@|Vg�6C�6����N-
!�lYbMr��;��2�pw�ٲdj��0]�@?��
{�$3�v�����b���а�&Bv���]+�h?u��D[_|�	�I��L����%O!;\���Kf�Z����	r��n�n޲�e��ޕO� �iZ�_�g!�ƴyd�l���&�ƘS%YV��J����=M��YG�����b�~Q&�\}��W��}��a�Y���Z�����8[�f�?]��K��_��I;��H�'Ю�v}^;���ʢ,(A�>���<�]��͌w�����iP��Y$앨p�2�L�f��ؽ2|�Q����
ja�*46��~��7�.���h��5_��u�?��^<@G����؂�Un �V-�:<�n�^<��'��/����k�qÒ�}V��q/�%�&�`28&����V��"�M�L��H�=ڦ��KXs`(C��4�BM<V����27o����>m8�ʓ+k��c��/��Aθ���3�R)�=�-T5J�{�ߊ�<���y7�m��UaV����3M�.MX�O`V��|��]�`�&Ea�ـY�YI��aE;i
��j������0��3�D�h"�YI��ޢ��Ϡ�.NSt��PM=�S�x��>�,48h}��:0Y��Q̅�WWXs`�z�LZ:_;��tL��g7%���M�SZMJ���y� -�����)JV
�}w�f�J��l��]��>��h\�)I�D��T�L���]T��Q�'��5�2�b��`:�6�b6W�e{�^�M��͐S�[�M����Aa���At�0�®�M�
L�;�(l����xǸʵ�l�K�ma���e\�2m"�Z�i-�P}ǡ-zN[�݋�<Z\4�f�`
�O�汄Ca>C:�ҧy,ѭ/�s�H��G�CglC�"�QԬ�-ؕ��vt�LO�b�K��M�W�ʻ���(�im,���A�O�"�d�����<��pi�r$w�%P�)�>��4/j?M�����`���v�X10��H��-��7�����ɍٸ�5F�ߜ>��`��b�HS�=���͙��*���t�U�6��'��Io��5�D�I8���˞H{	>�&��
J���]o�i���~=���Y�>�E��
C��.�i���z
�la�M�b�B�;V���ҋz���k$Q�7)�:0t�=��Um��tJ�����**��%a�LH$
@dكm/�%����xZ^�)�g-��aQg�Q��{��ha��b�ə�+&��9`G�������}�����{����Kz,��մ�î�� M�cIД��kaLP�({,A۠Q�+q������N`�auJ��D&���O�m���V<�0�W����%�ǒ�
��Lf���%��R<Z$�X���0���
�h���ֲ3���by`a�1�������by`as�>�����4�,,�>D���8��j%�a3�P¬��)��w������0+��Ԋ�:����î0+�}�'x�����l��\=�߼����y�]"���c�`�H��hE���,[�����IZTQ��sQf�]��|�p�]��H
�����ܷ��Y�ֽ�qV�v\
    ��^�&ȁ��DR���T�����
������Z�?F�35˃����[�q{��Cj��m�����?߭�?�aUt+���lM�-Tx�(̓��؞e�F�k�{���nU@�h|��ѱ#�0�V��6U0�+�����ژ�ϗ����DmBe����|�	vO�E��y���Ag���p�'�'�?��4 V�mi���;��ʲ�(���tǯ��2.�ƥ�H�=9O�a�rE��#�"���&�4 ���K�cy�{����V�k�+
��������z$<���|�[²���b�@z� ��RzZ�W5X�Ɏ��~+~c�}5/���K��Z��t1�3̶gIl^";�L�7���)v��ƀI��i������e�ٹ��8\�h��K��9��sP�qs$4?�Ń/����u��uзj��l���JU����F���^����;z�3QmL�:؋G�$s�^�)�}St\Լ>��V��9�7؋�``��:��x0n �$F�;��	����\y�C=�-O�'�f���:ekR�'x���RI|*;ܰ�����5��B�/]p��秉�V����r��|C O�',! ���~��H~Z?a���=��X�'Kl���e�%bK���q�ӊ;�����K������qN������uC~?a����~�<�|�$��vQZD�'�%3�+,y���I��g�<��
�h��&;+nfwes�y��,��?�S.�y���x�X��B�q�y���"r
�z��y�,X/�U�!�$@�K�����W(���?�"YZ|�Cvv�qƞX��b�ɱ)	R��������G�H����Jm��C������ly�qV�S]Xƺɒ^hS�t�f+����k%m�m�2,[�<��|��l%ma�I�8Zk�sj%ma�G�g�)IU�loa�b��SES:qKԧY�O]�Y;]tT��7r���0�]� )6�_A.V�������C�s�<�>�X�qLI��UE%�x �OE�)%�\^�Z���r�h���i�
)eS�hq�Y�#���t�\Zt`:��as�Kz����M��Gl��O"M�x	�2��i"$l*HS����
b����h`SwG�.�L��Z��i"�����$�(�˛W~����5�����C¦��#o�7,�]������q�0�H����Ď@W��k+m�L�m��u��⿚~
l�`��3���%#��k�-fk0�Q4��AF�r��ڋ%����K��E��ԃ��X�ӹ�����^,	m�,��U+��y޲CqL�I�����J`��l��}��7-�tc��,0�Am���έ9������m���޴_�3ne�s��%
l��=����x@�:�s���p��=�q�F�2�{͌4w@{���lZ�e E�dz20݆����]�����^�,I�{q��]�ψ�u6��Ջ�^n@��J(kI+�9��)��8M��	>�AUW��{� 3dD>ic��<�e���"Q���@����,�p��tӻ�޷(m`�*0%#90�Sʸ���_��<��f|�2\�,:�(J��mx�G��eUl�ܒ�ǃڵ�4��&8<�ǔ��Ţ>�7�z��R���8iclL�]��,V�6
,S�/��}i�(�������DcE}�����=���Vv��偅�ePTу�P�
Me����V�����Y+4���b�ɎSV��n��+���!1�ŁL�;u&--,�m'T����+���6m�v3r��Y���%v�/�W�'���]6���%_-�e�D�16��m-�M˥���I>%L<����'���o�T	>#�J�?Wo-�F/j�N�y�כW	�������In&�!k O���#�яvczOS�'i��@�\��r�Ca��Q��%�d�V�f��'��er��ӆje�y<8�)�QY���S�� �ր2/,���=Z�1����.ѣ����fSfN�y,�ɚ<Z|&{������=�P��ae�eD�y<��B���Jr��`���'���c�����c%�a�[y���D�V������V��E1j�I+�+��ɓtex/Q�+���	^�n���'J���`��OG_y���q�&NV<���
dy��ܳ}H�LY�;�yz+*O��'��Ӽ�q�*(]�;Q�E�ǋ�bz�3cm�e�e�=X�G}������+�)yHe�(TGR�?͋���V�	�%�!4��<͋�Y?�-��=q�o��o�`���u@VL.ZkV���Z�V�W֖�wh���/o���.�E+3�뗢�l`߁r�3�4'�-�6��gmˬ�2!����f`��2�aK7�IS`��x�˼��CT�[�}�,wF��l/�j�u�0�:]q8ؿ ��z�̓��僵�Q�sC*f�F�g2+X Ҟ��v%)5�����h�eCgS����X����lн\U�Z�f 8Þ���ό�,���Iy7�m�4��+�����M����J�fS
���^}���U�bI��:Gc!^
��:J>�%���D�<��p�G����+#u�zK�}�,�,Ė�[ �T�}K��||@�(�Wn-;���ъ?�]�qs�d�|��k�?��$}�n�D+kuֹ��ʮh�D�H/�KA'��挥{�e��
�iPg��<��;u�������-�t@��c�h-L6�uG�44�x��,�Jzj�������٠�n%ma����F�!�*�
��~��
ގC�C�~�XF�=�S�&�֚�u%T2�̓4I���ɾ�=���Kс�*ӏn��
j$�z�g�A�De�Pف�e҂�M\�P�E��X�����O�x'�QX�n�(4:^tJ�[Y%'#`�Z����;��c8�dO���>���ߴ.˟~�.�6T���X����YIO�MXX����f%m�q�āx2�z)�JzJ}ۡ{����F�D]��-lg���(5���:V��;V��J����x%���)P+i;��/�(\�U�����z�v3�
��c����%t"����BM�>�~i��^$6'�;�X�i��s7���`1b�Vc}f�x��,�^x?V�0�G�
�ڱi��ϰ(��`���R[��L&�����0��+}�W(�@u�ׇ�Pa�|V�����
��a1�L�}�`se����0zi��b�ط�v���ݔ�v��ԇ�0i?��m$�h�zA�Bp�2�h�Ej]���G6o�k�j�e��Ef1�ʪ�8�I�Xl*)��/�H�����������j�]�r��a�oZ�Y�`�l�nw�>�E��X���l�?�M�܍�����TB=VQ�;5-f�R_���Q���]�-��\St�!���Z4+G�2?&%&2��9[�v�:){����'.�hu��n*ln�̩�}�p9�Ai���Cu%��	vT�WX���;8�%��⢰��P{�Nf����=퀍�x2�v����8�3�`��_R3Aj�h�lg&���~7����_:�@��8���:�d�6u8kןo�σ����5��;+*���4���Ł�@��k�cRXp`�,�X-��`W���Ta�ʁDϼ���1�'��B�qO�1b*���w��Z� x��?עa�&\�r�z�j�oɯ���8�X�NS&�ë�/� 
�h�	R���T�QX�(fG�/k�<�J��Ve�����4�CyuD`@'�|j�<�
'�B�N�jA_��`*�T`�֡|�
�'_��`����1�3#�:�>��b����P[ϻa�^��<�b�Yib�>�����jy0N*X���$gZpk�h1�j��M����w��@�^������G�x��q���1��ʜ��[���I�s$:�P��j�*�6	~�B�h�FPtD$��&����(�W�PWrmRd�	D�������`d��2�����.��=�ѩ^fz�6��u�+���Ċ������ 딵NE��:�i-s ��b����?�c�?K`Ү��U*H=�%݆����Qa�_�    �����?:���̋:n�� ����jׂ�s�̺��q�N}� צ���F��%7�	��o��Vu�?k�����`�e��EC������0�hFq"i:[�hy����QauN0M�Y/���گ�Y֦Ƙ�v�)s񢼳�H����!;���'�����l����F���t]��M�>�6�EZَ�PC��hf�U;�Zd'�P�.��Ǜ%c�QȲ��ZYgT��u�ҕYegt��[��-/��7��?�%�q֖�;.�q���)�����.����{m
��ߥ'��{�u0V�g���T�
Z[�3	��\+�]xqT}���"�B��,h4-�����4t�3���h�haq`'�����7u������lY3Q�����d�Q!�tkG�+�y��,(�Zi��D�<Z�~߂ǃH��<As{�!{d�C@�ue_j���h6�%d����<�<Z�~�˃��B��`��آ�Y�y�E���� V�U�w�=��H|~6�"�9��J`,5υ��(օ�	Q��vw�l�80�/�<Qe2ؠsP�d�s�̰ת>-6V�:�i�Ѐ^���=M� ���N%k�ZpH^'#�&K�����0�Zܼ��ؽE����!���[�hq�'y<����!FN�&���� ��l�#;�����0�B��U�X.�y<���bІZ�JT�ǃ���+�T�ǃ{�'���~�^��>߲'x�hm�~�d���Z��rJ�>6�������8O�+��m�H+'�z��'x�³	��y�hy��� �_f�aԽ���I�T)D�;���%oh-O��<�t��TFAj�X|0j�
�c^�XIܭ��+Z;�@���uE��b%ma��h�}5(M��boaS�Nv�̿y�<�#�ZPA��F#w@I,}Z{��l��/���־�w�V��Yo���%L�kB2��a`6��=�uD�u�)��80��*�;��\���i5�`q��Lo�j�}Z|��W�(�[�k\�h�M�������
�f�`��	3^���Kp`-�|�wѯV_�@���O��X:�����j30�qG4 B�9i��@�E;�3�x��(Zf�&���:��o�է�����e@��ƒ�h�Jo6�м�V�+b
�n��M�����֒�|�Z6��h,��ʛ���vko�)���O���ik�
V-����K�q�-��,[а�R�����`:B8� U����>#��DDnNq_̶��y�I�x�֦�xf�&���_����֓7і%}d�.:ε�p�/��m�5�3��<�zY�jto�:���tҰ�44M�ӚC���RW�;� z�`��ȉ���Á���Ը�.������w�&+�(,80�i�%��J�^�뷍��6�*�`�B}#�P�d`6H�H`]@M��0j��b�ջ���I�Ͳ��"�eT��3�O-;ò��:�+2�ցh�LZ�X��#L�[.��wӆe�;a�MX�/4��X�X�.ľXZL���t]�C��=��bi񯟷<��
�h~H�H(XG��D�/P�6j�+��A`��T!4|�
�x���3�SC�L
�xP�I�<�?�}�xИ� ���ʃ�x<��%`��������p��9�`z`�3r⇾�ǃ��#�����e�4z�<�ʀ�e����������M=u���x �O�ll��@�<̆#>����̈C�K���i����Z�q�.�=Z��Q�V�,��=�z�X��+j� �w������z�Ξ�e��[z�X2�q��X�^�N�Ӽ�൴<X�X�T�m��S<͋�[�c>�g��׸0�EF^��ą��q|�a`S1m�+S�Q��Ob���ޅ�zZ9�Ω���E�	��������Ǡ�/kG){աOKL$ �C�"����ӞH�m���1/I�2���@3��(T��j`���.F�t�轺f�[�u*��0��b�pؑt�I݁��#$�g8*��ӛ�.��U� ��xT�]����>Lp���8[�>r4�J��n�
��@�"?:'���E,�{ո{�f�����^<`�ă�&��qڪ'�\l�]q����!S�/|[���6�+�ծ[2݁A���Y�e��ۆ�Zg�ʞ��M�{��f%8���8D�x֏)с!=�1ͮil�>-�ß��8QI󁹊�=�n�R�)f�ƺ2=ޙ�T�i'����Du�by`��D��
o(GP`��,����=����˃)x��ڇv����v�^ߴ����j[�kp`j�5:�PX�2�8#�Q�{M����Ų�L}�!"(�8����O�5e�V��k�ߊ�Ӝq�nD�J�f$(�;�����m@��eQ	��7By*�IPܛ'xQҰ*y�n
�/���ڎǢ��
�xp������8rc������fx�P�����@����A#�~��t)消S(��{�hq��y<�L_ivD����A��ee�"T�b�_�"���fƵ�=T�#��ʝK����G�?l �	~e�e�ox��#�{����`�P\kܙ��a��x��L,Do4:��Pw��o�tOҟe��p��)o=<I���mY�0oI?��y�0O���#�`SԘޟ��Z�F��~���o�h3k�~����b���Z�-�����~h��ѐ �z�߾�`s� 2~�^�Z3��COa�*u#{�`xd:�݋�&B¬�N��N���x�����f\ol���2x�Sb1^���b��M�Q�l(��QD�ܢ���%�X��ݗl,/Iǹر(}�T��#� *��tO���˿�r��jasD#��+v:8,�~�ޑx��jvf�!�RK70{����B9�����p`�]qL��s����W��}E$s�SM!8�9 �O�lgG��p��0a�%v�'dg��>+�FD�V��Z�ݲ5�! #To�ؐie*7���MK�'�p��
��2.�]�����@����w�[�!#Y�θ�u�o�]�{���X;q_ԐLD,�W���P���Ad%����1W�qЫ� hL<*�[5���:���y�Aw`��ZlL�Ҥ��7ul��J.&��1���"����K�y�aN�M����B�Z�i$�h�Y�C��I�usK-nv&�(	��7�'���p�ǃ�q���y����!��O5a���QG��";7:_�闭��!��n��������-1���^�0E���J����7\�Qa��Ӭ���<��_��Q���
����?�������S���.dbQ_����^�
ގC��ּ����n�����e)���	��c�����a!`�g�2m�7��������P&�dG"¬�-le���+�=6�����u��3t8�kէY�[�-�b��qV�v7�R���y�)�����"G%@� ϡ0+�I2.��nZ�L���V��E�U"�^n�.[9�偅*��Ğ�te��,�����_��k��ZL�u�mt��q�O�<��[�V�����\U���)��?�̆���r�\]�������:�Y?�#s5���x������e���,z�y��
���8������g�:���Wx��������Lsm88�f>¾�6�i��8�1'U*ᵬ��P�=�|
��k*춸�.H��95�f���A�-��򝝺���f{�1lv�� �Y�3˪Ok6����AQ?��l���E�R/�n�q�ԁ���`��.�0��m������
��j��у�}7��-�>Y0~�%3�^���`c�J���o��/Br3{�"/]�V�^�E�0��"�4����=���$���M��ج�cI����]o,θ��6����\�#8��n%ȝ���I%3��1������H����?�8�dU�40�j����ਞ�C�`� v��0<�/�j����d��2�<���/�9pl��rO��N+�5�������� ���hͮ^fy`O��1�`�7X*D �<�`����e��Efy`a']����7v����jbW���V�Y�X�`���
���p�Y�|Ə�8K    �)1�ê��L�EY��,-�������8!�h1��rMd�T�y�G�����U�0*�|b?�Ucp����'��%5�A��Y�gKꁯ����/0+x;��!C��@��/�
��䄒7�>�,d�0�ۙ���
�4�����rq�ѧYZX�ҼDK��N&Ʋ�<�07�YZ|�<^#Z�q"`��v:���П�<���
�J;��� ���L���ѡRa�V�I,���3��U_���C�X�O?��Y��p̅E�
��F����F�s#_���n��d?�|��(@Z�fS
�
��DK<��l4f]�����Vn�N�:����`z����p�#�7)����6�ぃ�uCY�<l���X�X�:Qv�x�L��)��aQx�y��#�<���cc/7�-Y�qU<m����h8��K�b��6��U!�&h�]�B�|5��'��V�g��F9&�
,z��B,��i�_E�o�w,ͤ�i$�z��+�X�s�/�Y`��>�VW��i�z>��`y
������Ő�)ϐ)G��'�^T]���l��p�����y�� ]Y�ia�K;��,f{+mD	iz��d>��YR&��B�쿝��Y˛%u�6�c����,��?��96- �7K�dL/lɱim���ӊ���;��{�gic�{��ˋ%qn�+'*{�yn�Qw������(�K�k�M:n�_,��6죖~�.f�^�hSX촢M���E�'6oμ�\���-���	z�<s��*ް����D���P	��ޮkqơ�ʁ<�Č�UO����\  �Bi�C�`t��o�ƀ����uo�݁L�ղot�:Á5�E��H)���.�֙�q�����Ew���d�����ћ��֢������Z�� .��z@���p��`c+L�?UjŁ];�3����
�h�&F�Iv�n�c6��s�� r'8i{������ƮG3�Y$�����`k�����{jt˃ɏ�~�wH������	2��`r\W���y��转[X6:�$���KC�<�>f�� :�5� X���_c?y�&���*�n
�<�>&!=�`��M���偅Uf���IšƁay`���h������՘4,,�`|-L�9�<�&G?�P��3�(`�YZ|��c��'
bE�;ƶ�I<,,Mi���Ŏ�����X��SAD���1��y�2���_m?��].?W����zgӢ��/�Mrg����Sa��W:�P>.3�[nX<��U(�m���AQjD#�o���b&���������,I+范(V��lV�k��\���y��,N���d�C��)
�/�g-e��qyIkl/�a�=����&	�7\�h���,w\X0���jƤ%�b������չB��ʔ�"w��S�4M*�&%�Xsr9XhBȩ���}d��XEN�BC(6e�8��TY۽/
�m�̆<y[eSxӢO
���޴��o�[���Gqd��R�2ߵg��`��jz�usE�x|�"�5*Z��t�K��A�8����nT��a/a��%v�A��8�<1�C��7}���Nj�j;De��oU��_bs����=��ڣ���:��J�T�)!c���菧�琖�}L��;Γ4Z����4j�ɓ��F��l�C�M��	��Ƌ&!��`�g�y����?J:y��犖ehr��Q�Ca�h��)('�(�=��n ����dk�����������ř�h���b����������,�3������efa��Ե_�$[I[�I3b>ٻn�}"![�O߶�`�R}'V�lϖ��'[�#���t7�ly�͓dc�����P,,!J;�e���O˃�������;2�'r�@FJuQ���b�VD�ӀK�W�XZX��6�aC��)����r�	�Y�:�����4u� �t��dу�XZLO�B}��n*�eG`-�f߄y��,����L�Xisգ�\O�-vV
�Z��c\aK�R���qn�oB`K-���A4$��T�%�V=Z�,*l�xYNzhV���/6��h��m.�Ѣ_��� �\����<Z��]�s���)�|=Z�B-K+X�r�9�ͣ�����c��txZ�h��.ԏL?P����b�@yK��S�ͣ�}�4���x.Z(���GQn� Ww^��o���8����rc�Fc<n�%������n(Ǎ׸0�J\52q��'`�9x�;n��岱�}ͯ��\`�˓g42!�1\��7a�+�K&�ს�ڒ�۞�E�&�GX�]�����@��yQa֩���u����/?O�b�� �������~�J@�
/���E���mbSХ�XѮ��l����Y�9��0�l��y�c��Ժ��fɘ.�������-a����DX#��J��~7;؋%p�}T�8��!n�6n��HfK�ާ�x���i��q�@ �Q�8;��Š��ʌ]��x	>~�j�Y����W�k�͕݁	L�r��g6ߞ��,��e�N��$_���".�'����%�4ERXr`}���`+�Sa��o�|���r*��iuڛ�R�:0�t�E�-]��ĥ9�L���/�����u�xDtD��I�2�\�/Xk��.��S����4���(����S-�48�O}Zr`�nE���H�_2;0�b�h!���W�����G!8�����3������\qA�������<0�J�2o��=`�n���^ ,,0���D/ڷ�̾�ǃ�֚r��Ј�=�D#q�`Q�U��*���Z���E.o
�h�h���ܰ�0��f=l��PYOPD\��<Zt��/t�$[Ţ0��Xjs��[I��<Z`�E*1̉[w�YZL�k�-�1���A�������2m�I�lJ���:�{�)�����.5��6�
���diaa���dy`���*��2D�vρ����[)�����1YZLO[���V=kE������������Pݑ);�V�O��',��
w�ES�4M~��֝�q��
,:���<��ؽ����q�fA�:ӹj�;��:��뢷��Z��L���(�M=ޟ��oA�cxa�LQ�o�?-��O�w��b��*��K���_k�����;�آ�,*���Ra6�5��Ll�8���T6�rl��OV<%���'^Ws/��ٽ+�f�m�%K�6������!r'����p	X �ޔ�Y�M�d���=å��Kb��R��n����{�ȸ��ј�ݠ+�1�_a��>k?ɸ>
��k炷?���R��A�D��wJgV؋�t��M<�e�F.��_��}���qo���w����%iD���z;`��C�A�֟I�#t�s(���ݫ�Q��Mz��� \>؄�V�j30�^XLhc�&9�����%�� ̹(�d8��♈Pf ��A[<�Ŷm�S|��u-8���Y�V&�[�`'��h����Zr`+��0�RzI����ͺV��b�ۜ�'�����:0�(����W�5O��Ӎx�"V�jl-dOkTJW���<Z�s�=��{>M	ݙ���2)�5���``?�l�4Ӈ;�~+���^�%�����Ö��DL-E˧	�:0T�a}|��_+������k(|`����w��Ex���U�n80�
;r�W��`��Łie����������L�<:Q��m�jZ���/̭Yrԗ���l'�,츃��FأB�����_?oy0��>�a�VU2��`���e��|��/�y<�Yf��[Sd.2ӫL�����cKrg눀�f0�+k��?�(-����.شx��# ��w�<�y�i�x`��j��4��}�c&|�i�x0��C�����6������6��s���s�!����㆗6���=8��0y���ă��BE�u�L�����S&��S�A���Pق��	�g�Sa���[��<,jbڱf��)�<�8�;3����A��R�x�JozXC�� *  -�~��Y2,�z!�E�x<aP_���  3f}?nIzXf�~'�w���vJk#`s1�=R2+.+s��9,l��}�]$�am,OG�������6*�Zb��g]`pP�]�am�NT��B#Gb�X�=��F��jH���[~�%�0>*�;�"�-��6��2���?��a`�.DT-����vC}2����-�R"IX��
{��#�O����!�$N)�M]EO��9f���%_��Pf5VG�#�R"�������O�8�P��c٘�?�ª;��D.�p����˴Xl�8.�u��t����A#P�-2���A^�qx������
�:Ba��y�n�$:�4�Q&����'ix���*g�Zo�Tʞ�����ϋQ��<�#KfG�tf���t̞�7��%���K��@��
�a�����5*eO���k6y8��IX�8����8O�'t=��^N��A���f8"T1,��oP�M�_4�GF��by`a�U�E�h7�p�T,�v�p���M{�	��ࣹ��
���5I�΋�b����P%���0���˩Z�O�ۉ)1���0˃);��Y�8�;��,-��#U˃��w9*2�����ZLev�hٝ�@z�U˃)��d{����T�[�4���6��M�Z|T=�8�;��#���/�j�o�X|Է-�QP��Mz�YL��Й�wE2��%���gaYg?U�e�2�tn�pj��be��T����塐��f����$�;�-��;b�*�/rR�'i(}
�h��o�Fj��Q螋�7���O��'i��t�D+��� i����Q3ߍh�.��I�Hݓtg'4�_��LOadչ8�h0���_����O���'[_b;LV/�>��`a~I4ԂR�����~�	�*z�(6U�k|z�#��Zl0�tF���!�j��DH�}ɺ��p1����Ӟ&�O�-GVxaeܤ�柳�0�:�h*�g)�̩�x�#k�|浥���㲍��n�2c�w�L/Z ��VɥC�1�>�ο�[U���+����l�Mj�soZ��J.��#�I���K�na�hUb�J�gݵ����Y1*x�w��/�ʞ�7-�4�����8T���cИ��'��<����/�zw��#�������٧!=�4�/�[A؛}*0���K1�ͺ<0�cݰ*+c�������H_�`r����b;yif+��|�)e�	�S�ljK�t��t�j�&����6�
���Փ��u�����Ln���8c�a�1W�;��� �C�0���.$�S'��]윽_�M/���J|����~e1��V
���?}��[��1�+��7�q_��r���k�l�ѢhSà��7W�/J4�-hZϗ�с-�F6��p?�Ӓ���Y��]QAX����r�#g�uWv����`���V����dS���J��y<��p;�{�]���0�v|D>M�қ�ǒʦ���a򝪤�������]��z�j@h%NZ$K�9�,�V�SsB+�E������d�d�e�Ma�o�qV�ӶtA�p�m����S+�����:��pk�w����-lc���z�rE<n�����m�6�V�c�{g����R`��
��|�H9{<��@��jj��y�&{��������/����nA���q��3n�1v2�SHu�́��q��O��vV�$�{��ҧ�����qx�W��B-s�����;FTN�зVd�bX�(2�"i'�A��xh�p�Łu��]��'�r(,8����(�XHP��j&�����v�7rS�P<Ï�4-6ʽS2*�ǃU��n,&sϓ_Ђ�<Z<{9s�<ZVP7�Y'nR�e<Z<�9��-�4����K�	�G����2s����S<Z�/�x<�����cfoCl�%��x�GN�Ƥ����5[���m_��L�3<��cQo'��	���{L���c._��ǅ�^��ȁu��u67�{����ٶ�$ߓ�]��{01��&��M�CF���|�	f�����L�_�
��{L0�o^�SL+1�4=��C�	�a��|�jx,�G����}�2|��w�̷h��.]�����L�\��仃Q�g-3\��`<X+��w{I��Ϸ/��^�UkԎg�#�t�ܾ�hƳ�G6LKbX�}n���q,�������_�2||��Yq������k1-;�����������Y����=�s��H��U��V��͌{׎ɭ;��+oэ���v��p�n]g�3���6ՙ�8*�u��с��?¾���/̿f��{]��5��-T.���v��U�[ÿ�8��ގCM�B��@=Quƺ5�c%H����_r�%�ǃ��Ā���`e����w�Z&�ǃ�Zƅ��X�W`�x<ki��5�NN�ǃa�AV�SE�d�x�R\��8�_Pz�w�x�� V�j��m]��Bc/B�}H��ŏ+� �9<,��Om �<���hFpG1�xH��D?	-P�u2Y��*�J�h�S|C�dfO�G�H%���L͸N�y����]x��Ua-*s�J�-δ�_�G��-�a��yͣ�w���^gz2*΃�\Zp��*��Tے`i��J�<���**�>GڍG����u�M�O�굪0K;�3i�f��A���.S�l��i--,,��0�U�!����N�9(�=��]L�hi����Ԯb��x<d��#�P.8^�h����q ���Y��Ɍ�5K+l|�1������,K,����-�"��g)�%��Vg��s��n��û���&wS��^�X�.fK�Y�8�����k|�H���5ɧv��[��+N�yIŁ��Ly�<��T�/��Y�ٶϺ���L]wƥm��;����Ł��'�Kv������k��bq�uѮy����e0W���g����Q���1��h���}�B��'�=,���_��Ri���~[� b���qA��-9|J3)�}��_�1�1��v�{�03q��%�N�@��qf��>�<�C>f�����!����a�o�~i�,
Kf3�'�������;u��1{k��s f5����
7�ãR��/�����<՗��+�^�x��~5p}�K7�U���XB!�tᩰ�I70k�K;1���DS��k'L�U	θqXF[���?a�?��qx˒�q�ƅ��I����DRā��ms���f]�/��:�P�������z�(��?Oug�8�ׄk�)1��v,j��Q�**r��Yy�<�VP�.��Zڦ��ZK��ÜVki;.��	w^��=����6^:��}b�|*kifÌ/xe#����//�ɱ���p�����̂P�5�#Ղ[h/�X��foa=�����_j�foa��rZ��+�)���$*)*���`�4�;��#���:3�,-,�T;�9|�����,-,���Rm����_h�������ЉRa�����U�'�>�eɻ�4K;�j�h�o/�� �[ZXXbӪ�0�;.�¾����8�����
��lQ �0���(�4��@�E���ny`a;Ef^��2�[XR	2Ef+.-����偅=% ��,-����t#�z�)�<����,�'`D?�niaa�ؙ���,ߴH��Օ��x�������,����[��>mP	����ų9U�#(,90�0�~�b�z),{���������ӽ�,śݯ\��=ϟ��`�-:wTn�vY���~��? �����*x<vD/���$�&ʃ�� P��p+�0�����~ю���9EI<�~޳4Ҩ.
f�zE��~~�0 2      W   @   x�3�J,J�FVfV&&z�@`b��7�2����N��Tqs&��d�$�h�ꍹb���� n�      g      x��]�v�F�]�_�ݬ��Ԭ��(K��!9��>��@MT�T�]�����Gfd�3�BG�yO&2�ƍG���
Y
����M���XʏR�JQZ��V�Bh7��~�¹��𓟺v���f��t��E	��U�H���3i|�K�Ңr�*���n[���)�/J�	��(�v�m�U��*m����m�?��K���I�I���l�^�L�S���ִ�vl�������dp|�^ϒ�V�� wׯ��u�Z��KX��h�ﵜY��BYWV�+����^o��麰8��[�pj�DWJ��v�y{��/�a�����v��UUt�-���3��F�n�ۗqw��i�8�g&9Wu�Hh������Ybp^wzۏ�jU�(��i��7�e��x~r3O�&�^We�yh�e�*�ڮ�	���s.e���f"��J+S\��5����v�J�g��J3�{�[U�*�떾���kW��V�Gp�l�̗��,�Kj!vz�nƧ��xj��j��S2T[�tvV�/
�FY�u��vU|kV��Y�-*����BU�;����[��i5��%�L\��}����^-��E34`5B31��IѬ�9,E�5��Y,7�Eq54�c��6�7u5��xo��s39�9N?0�r.s�`����\�~j:��?�~�?���J�G�9V�H��E���yS�q�<�ǀ���b����:��#��]?��z����?�-�2���~fc�.��@���싋~X��8-0Gɉ�̼�w��2�����M��G�-�fx�x.9]'��<h�*ATK��J�Ec!+e�Uŷ6p��z5o�뉂�f�|ϕ��P�#۞����Ο�&�=m�0��d���L[����y����=�·�*���&��]�#�6r(	�wο����aTZ\���K4�i��?�	�)���p8�FΪT1 ��F��}j���2X�)0�	w3� �0x�Z�c(s;��H��'����(n����a�}@�	���r�{�k<�_���M�8S�!�&C6*���t5<#�|",��`��q���G��������	�̾��W�${~�+ҹ�(g91��R��jEZi^�+Z�&�){?*8�t��RSP�m�Oa��a)�2?+���JX
��8�t���U�_���j: %8UUd�0���������:�C��E�4z�D��y�����^ԛ�~"*[&�����PW��[*� ��kt�/�i8��ص�	��X��M�f�>P�� c��=��鈭��B>����I��?���N�N�KR#r��5G6�i�����j�.R ��=x��_Ơ
�M�Tv�F̪�ZJ����b�i�14�|93�\\hlU\��+����ڌ�!ي��|	�1�5�y%4BXв ��f5\j#װdv�H�F�_N{cJ��~��F�b��_ϕ	�ξ��,�N�����/�M�)v"�s�j@��d���8���W!s��錓S����J�����a[\��8����C1'�:J��f�,��5i����f�*�&/LP��$Y�QQݵ�}�Y����C���G䛶�2�|��W��������|-C��,J?���(����Q������?q3O����T5�#�W|�E[?��OXŐ��2�f*9sLC��"�9�ԯ5E��&�'��<X�2�k�T�A� �8�A�XaU28/%��]���˚�����?5m��J$��E�WX�*�F��w<���Xt�q0�J&�>۴53�8��ڏ/+Cջ����t~p�Jŀ��T�i�!>���C���맶� �{Z��f��I|[LN���V�M3Ik���c���$��L�h�b�Dx�(i=[ ��G���D���Q���9�!��ի�-�%�����8 ;�YmP Pᬊ}�����8���qoV��&��ꖺ2���ӵ�ߡw�� 9I�A���ۋ���`���D�;�6,l9��/c(:�
H\x���B_�5�p�'��>���q��ܼ�E�##��O��7�E����K�͎�%+��'��:�r�"	�׫Q��E�[&2A�]��cqݮƧ�-�W38�It�]�{�����o~!��Ƴr	E$���<8�i%��=�>x���/�Ģ���r�����M�=��z�ky� y���1K<KDR�Ui��ˌ�gFw�j���<���*pf:dW?Z�Vq�o�'�-�$����������%����vX#��oB�J �����[LZ8&��F�B�V\�9�a�'4�!Fd�&\^8�%5����ś�[pU]����H��`X/b#�N��.u(��.���(�;�����+Ҡ�L�"(
x�!�x,.�ff���r9S��T@�j���_�n5 k�Ο�c���˭����C!��D���M�J��*�����Y�a/o?�C3����mE< �ХO O���8w���W	U|v_�lW}0`Qr���9^���^�����d2��<X��g�=�j��8�{�o��?7�s�
}K+���P ���p7M���?_vF,�㽞
�z����YSE
�o�x���s� ��S!�Z������"�����tn�c�J-�� ���� �U�wM{_o�� "gBa�G��d?AD�/�ʣ2(7i�V�ѧ6w7lƱ�g�mV	��hXQA�%٢�r��W�؅v��7,�'�*ϵ �臨̜3j`X.�$L���v%�-U	��������j1ES��H�˽��,����j� 6*������xy�،�*��m�l�o���9����-Cs��e�������@���=�ne����=�e��"2ٮ-@DU�X����wpY�3W{� Xⴑ5fP���aL&n�Қ��_�,/���q�L�3 �FY14�n-�m��κf]�D���f3Y�g���U�+<�3����h��Ɖ>b�,�>
�u3�C�^��'\��#ݚѻ���D��p�H���$��$=�,{�K'U(�X�SK:kڪ,9��U�j^�Mg�C���
:�q���YW J3�(鎚�����V���z����M�.����3��;��U�����~�����x�]^9v��~��0���U���:,�0�����<ٷ�%%7�y$0��u�Et���N	���DVÒ�!�#�"�Ҷ8�!]���&� �Ies��������C(]��P��
�N����t�s���7P'��s��I�����R��WawF%�z�SE��|�q�d�Q�[j����&rb��`���?H1w����wɨ��9�-�j�I�㐗/�l�7���dl]�Ç���C��f;s�/gb�S���w(�L��5Ųn��.��W���P=�H��z��]Ͽ7�"�9�Ǘg+^~�g_���� ��m>]Űr��>rj$�\�"D��N�^<��W�$dbs��!�x���qX��',s�"�L�𝨻���ZQO�NLSVzi��\�+8�m��]|6���sD4�I�s����@k�Ro�~� ����4A��KK@�'��yxh���~W2���w���]&�q\��
�����~3��$p:�*'X{7�l��_�z�&h&�n�f���G�X�J��U񍺀o��ϰ>� �<�2��(�9�eݭ��M=,�M�먝MpUF�4֒�
��},5�eh��q	�K�M�qH���io�C�
�P:jh�y�jMV�#�U���+N�z�u�d���O�l9�+�s?z*Gv~=?���ߨ�-�)1l�L����+��ɻyK����6H�8Z�jfY]�`|?Z�G�m�F%-M3�L
Sq4�s��L���f$nzm��"���r0Y�`?�rA�'�5u�t��&8��O!�����������w�ի���z�Ҟ
Z)��ݗ]@y$^���^N6W1�L�[��8z�Y� �E��Q#[ړtlr;T!;�B�5����=�q>Ƈ�/��	�A}bRKSWIG���r4���K��d��&ZV��V&E;$������9%��$�F����J����}�?���Q{ �  ��|��l���,��s���7+�:C�6��3�
M���աώܵ�e�4l���%jbK���,3�<0��S�t�[?�/��)<F]�	0;_�,�S�����m��˒a}�gTT��TX	љM�RS�䢟�<�мlס�5��I��@UeZc$<��튻��A�D��K�=у����w�u��tԹ&0��,k���9��6�N�Dmk«��]J6�#zA
�:BUoS0���;<��Vȝ��s������z���g8xn֨/y�2��nK��u�@�NS�:�V��d;k�]�C�Ng�im��e�N���!�R��X[�,��N}aZ�cp��A��.֠N�x^LG���Y�)�,�/���u��v�S�	ԉqwh��`�r_�:�)�:��	�D:�L&�5y����{]=>M)JԴ�@5��j䱉"��&.$�6s@�	�918*���������/�����n5�Hޝ(O�����T��W(�q�]�:�t�n5��#Нy1a_��&kk�S����#C�Z�;H&|�s�|;R�����y�Rܵ�0ħ����5%�K�����E��L�F���s��;QTP��Q�_���[z撊�?N܅������!��3�l�������:�?���¦!�0e���I��ܹ���70�0�4S���e�J�gw�,��y�y����iqG�Pe�=�O�>�0p�']�8��@S1՝��牔I t�,!�Vm���w��mMp*;U_qnק�9f0�_��"���AR�mHmVS��D�kB˓c�Nɻ]1��8����e;8����:񓳒ݝ<���l��:4��&jYV>�-�99�]�/��.~��/u;4�ǀXYv��󆽘��:X3��F]kU�*��)����(�^�AHlis�
"�D=�	.+Y?���
D�3$'u��o]11,��P%G=1:���~J�3"��~S/A*�^><�_�C�7p��#4���$yY�}��IJn�f8�)���m�w�UX��K<��`�t�i��Uӑ���9���<Չ�����c�H��Q�,��r�_���ix�s4�Y$��H�м��vxۮ�+6L�]shf�����3k�P����
�or[p�z�ϟi��^��g��8Qg��RY0�:t��^�?/� �9��'�*+2
j��˂�=_���To��њC3{�yw��L��_�1&�2��#�~�%��h-�	�ġh?���z���ۆ"���2<��!S��vH.��to��]��!��q4�:(<6�.���3|�Eh|\��:����0?³Q�$�Dx�5 k.�����_a�>A���&L~�+	��*7�T���<�y��8S�g���1��C�y|
�"�!r���,���Ԕ@R��Z�T6*r�"w�RC3���B��j�DJ_�>lF�-�ҲQE�aZ�����K?ݻ4J'��Dצ���\9�q$8c��!�5��W���EB(�X��me,yKK���ƫ��j�M Mn��B���'j��s	��
+J�����o��q��4���Q��U���	����IX>��Y@�P�%tF/����֮�ձM���n��K�0�$�E6�o�&�d�Ev�
�p� ��Ӓ�et׵I�Fҿ����w��n��DU:q�S�B#2ɼ�~Z6ݢ..�qM�F����"\��n3��K��hؐ�mb�S��J�]�)Q����]o����a�9�e�y� fi�G闕0�v/v��3��t ������|�2���C��]��M�ߤ>u����m�1��O�T7�*�`B�
!�=v4�D:�L��8P��gz��^��`h�3<���_����fY�h;>���`�d8YV"�O@�K�ƷO���
�K?N�R�۰��A�A;�Z��~j��W�0{I��|n|oqT�,��p�ӥc"�0���
gX��j��Yu�����(�f��6�9ZJq��%`&��Nd/��^����i����̭J�\6�z�.���+��v3BQu��-�ǐ������J[�kv�ؒ�������T��r�Uۅ���~`��ew����=�~��{s?l�����q�D.ű�8;�s�_
�x� y�3��3�JE�����Λz=��..ۑ�\���D���,tbwv����ɚk�҂�h �dgM�s��D�t�ЦҒ&�{����ˡ�O�Z��F��/�~�����=V�&��M�U=�x���Ӳ��!��~m�J>]�в����d9��^�A���\M*�z��sT>ffHiz�Y�t+eZ�+�<��8��x�����*���������	�]VwٵY�GJEc�}�}���M24y��k���bp��2+:��p�ߩ�C��"�pa؊A���%�K�;F�Y� � M(2r�˻/���3�&�:�vU�@�!��G۽�5�ƗMȣ�K�����I�ZO=Od\�@��R�*�0�S!�{�^o�!9��xA�ټF%��"���>��fM�)s�����H���~B��]6�?�x�*��D&����YXZ]B�h
�S�ծ�YI�U��rܱ�"ж�ꚷ���+Bk?+��'�n+GV�%<������.�tw!;;oC�߬)��cT&�;uKEUl�:�Y����G,s:����wE��nPN8�ĉ��8�̮� Q.c��:� �T%��V�>���z�*����6��r,SS#�;n�ڰgx�lN�^9$�����.��m���e�W��1��_��/�G�f�xS��E�`��CJ�^2��R0e�p�� a��0�F��{���)a||6���-<�5��T����W���+��KU}(������.4���P�J��f�e�������̎O���G^��.S��R>Qj�g^�4)��ގ���U�����T��!\t����z�/��H�'x>�2��cw(��XME�����Ck�\��}�z��Ӗe{B 
zf������UBB1K�!�l\h����͟䱥d�Y�-}^m�g�7��EV�����鲥J����h��'(�4FKGբvMc���S�hˣ[���f�}�x�{��41�8Q=95����4 �KD�mX�M�\vZ@�&.'(����Ƹ��a����%�>K@�-W�=Skˊ�qZ�����}L�we��~�Y���1ډGZ�D��+��5+�-�T*�C�Q�+G���n���ܽ�.�0�7�=�#�e�]�83+.VU6�w|�up"Bq���D�O4�S��eE�"�]��)��-7�+�R~�y�[�b��$X2K���mU��+�Yݍ��M�T^K�y�Ô��	�������T�6���Ǐ��)V��W�Ϻ��TӠc�GVT1����4YV��W:?����?���eG���w�8�0g��O�%n��D����䬭G
�?�<D3�0�^C�}7l��޽�ݸ<��~�����=���q\�m%C��w�3���3�-�/��r��w�����m�lR3�,'����o���^Y�����
������s�zt�~�Î��(l&j}��z�/k�?�'�.�e �9���l��֪���"���
8��.ŇCi�C�f%h��	��-�=�~o��� �(����g��{`�mh��q|��e6jyO�������]@D��&���2Wk�
��=���O�[X���(RfWNlv��Pi�/�٨�==���iF��+�e.H����}�7����]M�F�	5�ٳ��,�>�ap�$!R�%��\��)ˑx	����k�'X%jwOo g�B��q��y�"H����U%X>KC�6ȇ}�v�Q(z���ۜ�J{
8�z�	a��AD�����,NV �$�W�8r~�0�? 3�M�BQ���k�
H�x=�E���$]��oH�W!G�޻�����O�"QJ����(]��-L5�O�,��Efv�Ζ�4���.�H��j�q��?7��5w4�6��Ș���Ч^���gz�0`��	t]"�x��a���eS4"�t��ؠ;�~���f�����_A     