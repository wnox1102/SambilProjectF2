from django.shortcuts import render
from django.views.generic import View
from django.http import JsonResponse
from models.models import EntradaCC, Camara, Compra, Tienda, SalidaCC
from django.db import models,connection
from django.db.models import Count,Sum
import datetime
import psycopg2 as psy, pandas as pd
# Create your views here.

class Graph(View):

    def get(self,request, *args, **kwargs):
        conn=psy.connect(host = 'localhost', user= 'postgres', password ='postgres', dbname= 'Sambil')
        cur = conn.cursor()
        template_name = 'graph.html'
        number =[0,1,2,3]
        result = []
        sql='''SELECT count(*) FROM public.models_entradacc WHERE fkcamara_id=1;'''
        df = pd.read_sql_query(sql, conn)
        for index, row in df.iterrows():
                result.append(row['count'])
        print(result)
        return render(request,template_name, {} )

def get_data(request, *args, **kwargs):
        #variables :
        conn=psy.connect(host = 'localhost', user= 'postgres', password ='postgres', dbname= 'Sambil')
        cur = conn.cursor()
        cuenta = []
        camara = []
        SumVentas = []
        tienda = []
        horaEntrada1 = []
        horaEntrada2 =[]
        horaEntrada3 =[]
        horaSalida1 = []
        horaSalida2 = []
        horaSalida3 = []
        cantPersonas = []

        #querys para  contar las personas por camara 

        q1 = EntradaCC.objects.values('fkcamara__id').annotate(cuenta=Count('id'))
        for l in q1:
            cuenta.append(l['cuenta'])
            camara.append(l['fkcamara__id'])
        print(camara)

        # query para mostrar la cantidad de personas que entraron al centro comercial con y sin telefono

        q2 = EntradaCC.objects.values('id').filter(macadd__isnull=True).count()
        q3 = EntradaCC.objects.values('id').filter(macadd__isnull=False).count()

        # querys para determinar la edad de las personas que entran al centro comercial determinando si tiene o no macAddres
        
        edad1 = EntradaCC.objects.values('edad').filter(edad__range=(0,9), macadd__isnull=True).count()
        edad3 = EntradaCC.objects.values('edad').filter(edad__range=(10,20), macadd__isnull=True).count()
        edad5 = EntradaCC.objects.values('edad').filter(edad__range=(21,30), macadd__isnull=True).count()
        edad7 = EntradaCC.objects.values('edad').filter(edad__range=(31,40), macadd__isnull=True).count()
        edad9 = EntradaCC.objects.values('edad').filter(edad__range=(41,50), macadd__isnull=True).count()
        edad11 = EntradaCC.objects.values('edad').filter(edad__range=(51,60), macadd__isnull=True).count()
        edad13 = EntradaCC.objects.values('edad').filter(edad__range=(61,70), macadd__isnull=True).count()
        edad15 = EntradaCC.objects.values('edad').filter(edad__range=(71,80), macadd__isnull=True).count()
        edad17= EntradaCC.objects.values('edad').filter(edad__range=(81,90), macadd__isnull=True).count()
        
        edad2 = EntradaCC.objects.values('edad').filter(edad__range=(0,9), macadd__isnull=False).count()
        edad4 = EntradaCC.objects.values('edad').filter(edad__range=(10,20), macadd__isnull=False).count()      
        edad6 = EntradaCC.objects.values('edad').filter(edad__range=(21,30), macadd__isnull=False).count()
        edad8 = EntradaCC.objects.values('edad').filter(edad__range=(31,40), macadd__isnull=False).count()
        edad10 = EntradaCC.objects.values('edad').filter(edad__range=(41,50), macadd__isnull=False).count()
        edad12 = EntradaCC.objects.values('edad').filter(edad__range=(51,60), macadd__isnull=False).count()
        edad14 = EntradaCC.objects.values('edad').filter(edad__range=(61,70), macadd__isnull=False).count()
        edad16= EntradaCC.objects.values('edad').filter(edad__range=(71,80), macadd__isnull=False).count()
        edad18 = EntradaCC.objects.values('edad').filter(edad__range=(81,90), macadd__isnull=False).count()
        
        # querys que muestran las tiendas que vende mucho mas [top 5]
        qventas = Compra.objects.values('fktienda_id__nombre').annotate(ventas=Sum('total'))[:5]
        for l in qventas:
                tienda.append(l['fktienda_id__nombre'])
                SumVentas.append(l['ventas'])
        
        # query para visualizar las entradas de las personas por entrada 

        sql='''SELECT count(id) FROM public.models_entradacc WHERE fkcamara_id=1 AND date_part('month',registroe)=date_part('month',current_date)
        GROUP BY date_part('hour',registroe);'''
        df = pd.read_sql_query(sql, conn)
        for index, row in df.iterrows():
                horaEntrada1.append(int(row['count']))

        sql1='''SELECT count(id) FROM public.models_entradacc WHERE fkcamara_id=2 AND date_part('month',registroe)=date_part('month',current_date)
        GROUP BY date_part('hour',registroe);'''
        df = pd.read_sql_query(sql1, conn)
        for index, row in df.iterrows():
                horaEntrada2.append(int(row['count']))

        sql2='''SELECT count(id) FROM public.models_entradacc WHERE fkcamara_id=3 AND date_part('month',registroe)=date_part('month',current_date)
        GROUP BY date_part('hour',registroe);'''
        df = pd.read_sql_query(sql2, conn)
        for index, row in df.iterrows():
                horaEntrada3.append(int(row['count']))
        
        # querys para ver el flujo de salida de las personas por hora

        sql3='''SELECT count(id) FROM public.models_salidacc WHERE fkcamara_id=1 AND date_part('month',registros)=date_part('month',current_date)
        GROUP BY date_part('hour',registros);'''
        df = pd.read_sql_query(sql3, conn)
        for index, row in df.iterrows():
                horaSalida1.append(int(row['count']))

        sql4='''SELECT count(id) FROM public.models_salidacc WHERE fkcamara_id=2 AND date_part('month',registros)=date_part('month',current_date)
        GROUP BY date_part('hour',registros);'''
        df = pd.read_sql_query(sql4, conn)
        for index, row in df.iterrows():
                horaSalida2.append(int(row['count']))

        sql5='''SELECT count(id) FROM public.models_salidacc WHERE fkcamara_id=3 AND date_part('month',registros)=date_part('month',current_date)
        GROUP BY date_part('hour',registros);'''
        df = pd.read_sql_query(sql5, conn)
        for index, row in df.iterrows():
                horaSalida3.append(int(row['count']))



        data = {
                "labels": camara,
                "default":cuenta,
                "default2":[q2,q3],
                "labels2":['Personas sin telefono','Personas con telefono'],
                "default3":[edad1,edad3,edad5, edad7, edad9,edad11,edad13,edad15,edad17],
                "default4":[edad2,edad4,edad6,edad8,edad10,edad12,edad14,edad16,edad18],
                "labels4": tienda,
                "default5": SumVentas,
                "labelsHora":['8:00 am','9:00 am','10:00 am','11:00 am', '12:00 pm', '13:00 pm','14:00 pm','15:00 pm','16:00 pm','17:00 pm','18:00 pm', '19:00 pm','20:00 pm', '21:00 pm', '22:00 pm', '23:00 pm'],
                "default6":horaEntrada1,
                "default7":horaEntrada2,
                "default8":horaEntrada3,
                "default9":horaSalida1,
                "default10":horaSalida2,
                "default11":horaSalida3,

        }
        return JsonResponse(data)