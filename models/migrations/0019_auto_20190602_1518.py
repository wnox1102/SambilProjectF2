# Generated by Django 2.2.1 on 2019-06-02 15:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0018_auto_20190602_1516'),
    ]

    operations = [
        migrations.AlterField(
            model_name='persona',
            name='apellido',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
        migrations.AlterField(
            model_name='persona',
            name='nombre',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
    ]