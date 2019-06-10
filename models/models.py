from django.db import models

# Create your models here.
class Beacon(models.Model):
    modelo = models.CharField(max_length=20)
    def __str__(self):
        return self.modelo

class Tienda(models.Model):
    nombre = models.CharField(max_length=20)
    dueño = models.CharField(max_length=20)
    horaA  = models.TimeField()
    horaC = models.TimeField()
    fkbeacon = models.ForeignKey(Beacon, on_delete=models.CASCADE)
    def __str__(self):
        return self.nombre

class Entrada(models.Model):
    nombre = models.CharField(max_length=30, null=False, blank=False)

class Mesa(models.Model):
    puestos = models.IntegerField()
    fkbeacon = models.ForeignKey(Beacon, on_delete=models.CASCADE)

class Camara(models.Model):
    fkentrada = models.ForeignKey(Entrada, on_delete=models.CASCADE)
    modelo =models.CharField(max_length=20)
    def __str__(self):
        return self.modelo

class EntradaCC(models.Model):
    fkcamara = models.ForeignKey(Camara, on_delete=models.CASCADE)
    sexo = models.CharField(max_length=10)
    edad = models.IntegerField()
    macadd = models.CharField(max_length=20, null=True, blank= True)
    registroe = models.DateTimeField(null=True, blank=True)

class  SalidaCC(models.Model):
    fkcamara = models.ForeignKey(Camara, on_delete= models.CASCADE)
    registros = models.DateTimeField()
    macadd= models.CharField(max_length=20, null=True, blank=True)


class Persona(models.Model):
    nombre = models.CharField(max_length=20, null=True, blank=True)
    apellido = models.CharField(max_length=20, null=True, blank=True)
    macadd = models.CharField(max_length=20, unique=True, null=False, blank=False)
    cedula = models.IntegerField(unique=True, null=True, blank=True)
    def __str__(self):
        return self.macadd

class Compra(models.Model):
    fktienda = models.ForeignKey(Tienda, on_delete=models.CASCADE)
    fkpersona = models.ForeignKey(Persona,to_field="macadd", on_delete=models.CASCADE, null=True, blank=True)
    fecha = models.DateTimeField()
    total = models.FloatField()
    cedula = models.IntegerField()
    nombre = models.CharField(max_length=30)
    apellido = models.CharField(max_length=30)
    def __str__(self):
        return self.nombre

class VentaRechazada(models.Model):
    fktienda = models.ForeignKey(Tienda, on_delete=models.CASCADE)
    fecha = models.DateTimeField()
    total = models.FloatField()
    cedula = models.IntegerField()
    nombre = models.CharField(max_length=30)
    apellido = models.CharField(max_length=30)
    def __str__(self):
        return self.nombre

class RegistroT(models.Model):
    mac = models.CharField(max_length=20, null=True, blank=True)
    fkbeacon = models.ForeignKey(Beacon, on_delete=models.CASCADE)
    fecha = models.DateTimeField()
    io = models.BooleanField()

class RegistroM(models.Model):
    mac = models.CharField(max_length=20, null=True, blank=True)
    fkmesa = models.ForeignKey(Beacon, on_delete=models.CASCADE)
    fecha = models.DateTimeField()
    io = models.BooleanField()

class CompraEntrada(models.Model):
    fkcompra = models.IntegerField(null=True)
    fkentrada = models.IntegerField(null=True)

class EntradaCarro(models.Model):
    macadd = models.CharField(max_length=20, null=True, blank= True)
    placa = models.CharField(max_length=7, null=True, blank=False)
    registroe = models.DateTimeField()

class SalidaCarro(models.Model):
    macadd = models.CharField(max_length=20, null=True, blank= True)
    placa = models.CharField(max_length=7, null=True, blank=False)
    registros = models.DateTimeField()
