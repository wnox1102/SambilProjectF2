import ssl
import sys
import psycopg2 
import pandas as pd
import paho.mqtt.client 
import json


conn = psycopg2.connect(host = 'localhost', user= 'postgres', password ='caballoalfabetico', dbname= 'Sambil')

def on_connect(client, userdata, flags, rc):    
    print('Conectado (%s)' % client._client_id)
    client.subscribe(topic='Sambil/#', qos = 0) 

def on_message_C(client,userdata,message): 
    c = json.loads(message.payload)
    if ((message.topic=="Sambil/Camaras/Entrada")) :
        if (c["macAddress"]!="null"):
            print(c)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public."models_entradacc" (fkcamara_id, sexo, edad, macadd, registroe)VALUES ( %s, %s, %s, %s, %s);'''
            cur.execute(sql, (c["cameraID"],c["gender"], c["age"],c["macAddress"],c["time"]))
            conn.commit()
        else:
            print(c)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public."models_entradacc" (fkcamara_id, sexo, edad, registroe)VALUES ( %s, %s, %s, %s);'''
            cur.execute(sql, (c["cameraID"],c["gender"], c["age"],c["time"]))
            conn.commit()
    else:
        if (c["macAddress"]!="null"):
            print(c)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public."models_salidacc"(fkcamara_id, registros, macadd)VALUES (%s, %s, %s);'''
            cur.execute(sql, (c["cameraID"],c["time"],c["macAddress"]))
            conn.commit()
        else:
            print(c)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public."models_salidacc"(fkcamara_id, registros)VALUES (%s, %s);'''
            cur.execute(sql, (c["cameraID"],c["time"]))
            conn.commit()

def on_message_A(client,userdata,message):
    a = json.loads(message.payload)
    print(a)
    print('topic: %s' % message.topic)
    if(message.topic == "Sambil/Estacionamiento/Entrada"):
        if(a["macAddress"] != "null"):
            if(a["numberPlate"] != "null"):
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_entradacarro" (macadd,placa,registroe) VALUES (%s,%s,%s)'''
                cur.execute(sql, (a["macAddress"],a["numberPlate"],a["time"]))
                conn.commit()
            else:
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_entradacarro" (macadd,registroe) VALUES (%s,%s)'''
                cur.execute(sql, (a["macAddress"],a["time"]))
                conn.commit()
        else:
            if(a["numberPlate"] != "null"):
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_entradacarro" (placa,registroe) VALUES (%s,%s)'''
                cur.execute(sql, (a["numberPlate"],a["time"]))
                conn.commit()
            else:
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_entradacarro" (registroe) VALUES (%s)'''
                cur.execute(sql,(a["time"],))
                conn.commit()

    else:
        if(a["macAddress"] != "null"):
            if(a["numberPlate"] != "null"):
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_salidacarro" (macadd,placa,registros) VALUES (%s,%s,%s)'''
                cur.execute(sql, (a["macAddress"],a["numberPlate"],a["time"]))
                conn.commit()
            else:
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_salidacarro" (macadd,registros) VALUES (%s,%s)'''
                cur.execute(sql, (a["macAddress"],a["time"]))
                conn.commit()
        else:
            if(a["numberPlate"] != "null"):
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_salidacarro" (placa,registros) VALUES (%s,%s)'''
                cur.execute(sql, (a["numberPlate"],a["time"]))
                conn.commit()
            else:
                cur = conn.cursor()
                sql = '''INSERT INTO public."models_salidacarro" (registros) VALUES (%s)'''
                cur.execute(sql, (a["time"],))
                conn.commit()

def on_message_M(client,userdata,message):   
    m = json.loads(message.payload)
    if (message.topic=="Sambil/Mesa/Parado") :
        if (m["macAddress"]!="null"):
            print(m)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrom( mac, fkmesa_id, fecha, io)VALUES ( %s, %s, %s, %s);'''
            cur.execute(sql, (m["macAddress"],m["beaconID"], m["time"], False))
            conn.commit()
        else:
            print(m)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrom(fkmesa_id, fecha, io)VALUES ( %s, %s, %s);'''
            cur.execute(sql, (m["beaconID"], m["time"],False))
            conn.commit()
    else:
        if (m["macAddress"]!="null"):
            print(m)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrom( mac, fkmesa_id, fecha, io)VALUES ( %s, %s, %s, %s);'''
            cur.execute(sql, (m["macAddress"],m["beaconID"], m["time"], True))
            conn.commit()
        else:
            print(m)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrom(fkmesa_id, fecha, io)VALUES ( %s, %s, %s);'''
            cur.execute(sql, (m["beaconID"], m["time"],True))
            conn.commit()

def on_message_T(client,userdata,message): 
    t = json.loads(message.payload)
    print('------------------------------')  
    if (message.topic=="Sambil/Tienda/Entrando") :
        if (t["macAddress"]!="null"):
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrot(mac, fkbeacon_id, fecha, io)VALUES (%s, %s, %s, %s);'''
            cur.execute(sql, (t["macAddress"],t["beaconID"], t["time"], True))
            conn.commit()
        else:
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrot(fkbeacon_id, fecha, io)VALUES ( %s, %s, %s);'''
            cur.execute(sql, (t["beaconID"], t["time"], True))
            conn.commit()
    if (message.topic=="Sambil/Tienda/Saliendo") :
        if (t["macAddress"]!="null"):
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrot(mac, fkbeacon_id, fecha, io)VALUES (%s, %s, %s, %s);'''
            cur.execute(sql, (t["macAddress"],t["beaconID"], t["time"], False))
            conn.commit()
        else:
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_registrot(fkbeacon_id, fecha, io)VALUES ( %s, %s, %s);'''
            cur.execute(sql, (t["beaconID"], t["time"], False))
            conn.commit()
    if (message.topic=="Sambil/Tienda/Compra") :
        if (t["macAddress"]!="null"):
            print("Mamame el huevo, Wilmer")
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_compra(fktienda_id, fkpersona_id, fecha, cedula, nombre, apellido, total)VALUES ( %s, %s, %s, %s, %s, %s, %s);'''
            cur.execute(sql, (t["beaconID"],t["macAddress"], t["time"],t["personID"],t["name"],t["lastname"],t["price"]))
            conn.commit()
        else:
            print(t)
            print('topic: %s' % message.topic)
            cur = conn.cursor()
            sql = '''INSERT INTO public.models_compra(fktienda_id, fecha, cedula, nombre, apellido, total)VALUES ( %s, %s, %s, %s, %s, %s);'''
            cur.execute(sql, (t["beaconID"],t["time"],t["personID"],t["name"],t["lastname"],t["price"]))
            conn.commit()



def main():	
    client = paho.mqtt.client.Client(client_id='Actividad Sambil',clean_session=False)
    client.on_connect = on_connect
    client.message_callback_add('Sambil/Camaras/#', on_message_C)
    client.message_callback_add('Sambil/Estacionamiento/#', on_message_A)
    client.message_callback_add('Sambil/Mesa/#', on_message_M)
    client.message_callback_add('Sambil/Tienda/#', on_message_T)
    client.connect(host='localhost') 
    client.loop_forever()

if __name__ == '__main__':
	main()
	sys.exit(0)
