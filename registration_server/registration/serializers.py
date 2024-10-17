

from rest_framework import serializers
from .models import Student, OTP, Account

class StudentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = ['registration_no', 'name', 'address', 'phone_number', 'email']


class OTPSerializer(serializers.ModelSerializer):
    class Meta:
        model = OTP
        fields = ['registration_no', 'otp', 'expiration_time']

class AccountSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)  # Ensure password is not readable in responses

    class Meta:
        model = Account
        fields = ['registration_no', 'password']

    def create(self, validated_data):
        account = Account(
            registration_no=validated_data['registration_no'],
        )
        # Set the password securely
        account.set_password(validated_data['password'])
        account.save()
        return account
