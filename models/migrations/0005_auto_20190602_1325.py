# Generated by Django 2.2.1 on 2019-06-02 13:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('models', '0004_auto_20190602_1321'),
    ]

    operations = [
        migrations.AlterField(
            model_name='registrom',
            name='mac',
            field=models.CharField(blank=True, max_length=20, null=True),
        ),
    ]
