# Generated by Django 2.2.1 on 2019-06-02 13:37

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0007_auto_20190602_1331'),
    ]

    operations = [
        migrations.AlterField(
            model_name='compra',
            name='fkpersona',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, to='models.Persona'),
        ),
    ]
