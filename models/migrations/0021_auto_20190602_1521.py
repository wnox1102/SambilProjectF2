# Generated by Django 2.2.1 on 2019-06-02 15:21

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0020_auto_20190602_1519'),
    ]

    operations = [
        migrations.AlterField(
            model_name='compra',
            name='fkpersona',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='models.Persona', to_field='macadd'),
        ),
    ]
