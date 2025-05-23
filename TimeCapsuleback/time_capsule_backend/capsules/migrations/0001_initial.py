# Generated by Django 5.2 on 2025-04-26 19:11

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Capsule',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.EmailField(max_length=254)),
                ('subject', models.CharField(max_length=255)),
                ('text', models.TextField()),
                ('send_date', models.DateTimeField(auto_now_add=True)),
                ('status', models.CharField(choices=[('pendoing', 'Pendoing'), ('sent', 'Sent')], default='pendoing', max_length=255)),
                ('attachment', models.FileField(upload_to='attachments/%Y/%m/%d')),
            ],
        ),
    ]
