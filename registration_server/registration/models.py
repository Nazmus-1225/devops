from django.db import models
from django.utils import timezone
from datetime import timedelta

# Create your models here.
class Student(models.Model):
    registration_no = models.CharField(max_length=20, unique=True)
    name = models.CharField(max_length=100)
    address = models.TextField()
    phone_number = models.CharField(max_length=15)
    email = models.EmailField(unique=True)

    def __str__(self):
        return self.name
    

class Account(models.Model):
    registration_no = models.CharField(max_length=20, unique=True)
    password = models.CharField(max_length=256)

    def __str__(self):
        return self.registration_no
    
    def set_password(self, password):
        self.password=password

class OTP(models.Model):
    registration_no = models.CharField(max_length=20)
    otp = models.CharField(max_length=6)
    expiration_time = models.DateTimeField()

    def __str__(self):
        return f"OTP for {self.registration_no}"

    def is_expired(self):
        return timezone.now() > self.expiration_time

    def set_expiration(self, minutes=5):
        """Set expiration time to a certain number of minutes from now."""
        self.expiration_time = timezone.now() + timedelta(minutes=minutes)
