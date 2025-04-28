from django.db import models

# Create your models here.
class Capsule(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('sent', 'Sent'),
    ]
    email = models.EmailField()
    subject = models.CharField(max_length=255)
    text = models.TextField()
    send_date = models.DateTimeField()
    status = models.CharField(max_length=255, choices=STATUS_CHOICES, default='pending')
    attachment = models.FileField(upload_to='attachments/%Y/%m/%d', null=True, blank=True)
