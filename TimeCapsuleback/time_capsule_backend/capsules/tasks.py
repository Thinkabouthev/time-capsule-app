from celery import shared_task
from django.utils import timezone
from django.core.mail import send_mail
from django.conf import settings

@shared_task
def check_and_send_capsules():
    from .models import Capsule  
    now = timezone.now()
    capsules_to_send = Capsule.objects.filter(status='pending', send_date__lte=now)
    for capsule in capsules_to_send:
        send_mail(
            capsule.subject,
            capsule.text,
            settings.EMAIL_HOST_USER,
            [capsule.email],
            fail_silently=False,
        )
        capsule.status = 'sent'
        capsule.save()

@shared_task
def send_email_task(to_email, subject, text):
    send_mail(
        subject,
        text,
        settings.EMAIL_HOST_USER,
        [to_email],
        fail_silently=False,
    )