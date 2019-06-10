from django.contrib import admin
from .models import Persona,Entrada,EntradaCC,SalidaCC,Beacon,Camara, Tienda,Mesa,Compra,VentaRechazada,RegistroM,RegistroT,CompraEntrada,EntradaCarro,SalidaCarro
# Register your models here.

admin.site.site_header = 'Administracion Sambil'
class PersonaAdmin(admin.ModelAdmin):
    search_fields =('nombre','edad')
    
    


admin.site.register(Persona, PersonaAdmin)
admin.site.register(Entrada)
admin.site.register(EntradaCC)
admin.site.register(SalidaCC)
admin.site.register(Beacon)
admin.site.register(Camara)
admin.site.register(Tienda)
admin.site.register(Mesa)
admin.site.register(Compra)
admin.site.register(VentaRechazada)
admin.site.register(RegistroM)
admin.site.register(RegistroT)
admin.site.register(CompraEntrada)
admin.site.register(EntradaCarro)
admin.site.register(SalidaCarro)