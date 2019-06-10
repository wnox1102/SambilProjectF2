# Generated by Django 2.2.2 on 2019-06-08 22:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0021_auto_20190602_1521'),
    ]

    operations = [
        migrations.CreateModel(
            name='EntradaCarro',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('macadd', models.CharField(blank=True, max_length=20, null=True)),
                ('placa', models.CharField(max_length=7)),
                ('registroe', models.DateTimeField()),
            ],
        ),
        migrations.CreateModel(
            name='SalidaCarro',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('macadd', models.CharField(blank=True, max_length=20, null=True)),
                ('placa', models.CharField(max_length=7)),
                ('registros', models.DateTimeField()),
            ],
        ),
    ]
