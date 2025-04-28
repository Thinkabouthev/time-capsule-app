from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import Capsule
from .serializers import CapsuleSerializer
from .tasks import check_and_send_capsules
from .tasks import send_email_task

class CapsuleViewSet(viewsets.ModelViewSet):
    queryset = Capsule.objects.all()
    serializer_class = CapsuleSerializer

    def perform_create(self, serializer):
        capsule = serializer.save()
        send_email_task.apply_async(
            args=[capsule.email, capsule.subject, capsule.text, capsule.id],
            eta=capsule.send_date
        )
    

# Create your views here.
