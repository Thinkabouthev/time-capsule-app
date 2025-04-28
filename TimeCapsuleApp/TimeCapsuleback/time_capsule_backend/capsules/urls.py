from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CapsuleViewSet

router = DefaultRouter()
router.register('capsules', CapsuleViewSet)

urlpatterns = router.urls