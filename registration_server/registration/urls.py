from django.urls import path
from .views import register,verify_otp, signup, signin, auth

urlpatterns = [
    path('register/', register, name='register'),
    path('otp/', verify_otp, name='verify_otp'),
    path('signup/', signup, name='signup'),
    path('signin/', signin, name='signin'),
    path('auth/', auth, name='auth')
]
