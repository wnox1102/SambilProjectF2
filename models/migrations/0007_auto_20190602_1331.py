# Generated by Django 2.2.1 on 2019-06-02 13:31

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0006_auto_20190602_1329'),
    ]

    operations = [
        migrations.AlterField(
            model_name='compra',
            name='total',
            field=models.FloatField(),
        ),
    ]