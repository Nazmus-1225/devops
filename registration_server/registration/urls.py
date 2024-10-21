from django.urls import path
from .views import signup, signin, auth

urlpatterns = [
    path('signup/', signup, name='signup'),
    path('signin/', signin, name='signin'),
    path('auth/', auth, name='auth')
]
