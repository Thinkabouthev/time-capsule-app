from rest_framework import serializers

from . import models
from .models import Capsule

class CapsuleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Capsule
        fields = '__all__'

