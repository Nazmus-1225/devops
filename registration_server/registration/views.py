
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.utils.crypto import get_random_string
from django.utils import timezone
from datetime import timedelta
from django.core.mail import send_mail
from .models import Student, Account, OTP
from .serializers import StudentSerializer, OTPSerializer, AccountSerializer
from django.conf import settings
import jwt
import datetime


@api_view(['POST'])
def register(request):
    registration_no = request.data.get('registration_no')
    # Check if the student exists using the StudentSerializer
    try:
        student = Student.objects.get(registration_no=registration_no)
        student_serializer = StudentSerializer(student)
    except Student.DoesNotExist:
        return Response({'message': 'Student does not exist'}, status=status.HTTP_404_NOT_FOUND)

    # Check if an account already exists for the student
    if Account.objects.filter(registration_no=registration_no).exists():
        return Response({'message': 'Account already exists'}, status=status.HTTP_400_BAD_REQUEST)

    # Generate OTP
    otp_value = get_random_string(length=6, allowed_chars='0123456789')
    expiration_time = timezone.now() + timedelta(minutes=5)

    # Create and save the OTP record using OTPSerializer
    otp_data = {
        'registration_no': registration_no,
        'otp': otp_value,
        'expiration_time': expiration_time
    }
    otp_serializer = OTPSerializer(data=otp_data)

    if otp_serializer.is_valid():
        otp_serializer.save()

        # Send OTP to student's email
        send_mail(
            'Your OTP Code',
            f'Your OTP is {otp_value}. It will expire in 5 minutes.',
            settings.EMAIL_HOST_USER,
            [student.email],
            fail_silently=False,
        )
    
        return Response({'message': 'OTP has been sent to your email'}, status=status.HTTP_200_OK)

    return Response(otp_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def verify_otp(request):
    registration_no = request.data.get('registration_no')
    otp_value = request.data.get('otp')

    if not registration_no or not otp_value:
        return Response({'message': 'Registration number and OTP are required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        # Fetch the OTP record for the given registration number
        otp_record = OTP.objects.get(registration_no=registration_no, otp=otp_value)

        # Check if the OTP has expired
        if timezone.now() > otp_record.expiration_time:
            return Response({'message': 'OTP has expired'}, status=status.HTTP_400_BAD_REQUEST)

        # If OTP is valid and not expired, return success response
        return Response({'message': 'OTP is valid'}, status=status.HTTP_200_OK)

    except OTP.DoesNotExist:
        return Response({'message': 'Invalid registration number or OTP'}, status=status.HTTP_400_BAD_REQUEST)
    

@api_view(['POST'])
def signup(request):
    registration_no = request.data.get('registration_no')
    password = request.data.get('password')

    # Validate input
    if not registration_no or not password:
        return Response({'message': 'Registration number and password are required'}, status=status.HTTP_400_BAD_REQUEST)

    # Check if an account already exists for the registration number
    if Account.objects.filter(registration_no=registration_no).exists():
        return Response({'message': 'Account already exists'}, status=status.HTTP_400_BAD_REQUEST)

    # Create the account using the AccountSerializer
    account_data = {
        'registration_no': registration_no,
        'password': password
    }
    account_serializer = AccountSerializer(data=account_data)

    if account_serializer.is_valid():
        account_serializer.save()  # Save the account to the database
        return Response({'message': 'Account created successfully'}, status=status.HTTP_201_CREATED)

    return Response(account_serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def signin(request):
    registration_no = request.data.get('registration_no')
    password = request.data.get('password')

    # Validate input
    if not registration_no or not password:
        return Response({'message': 'Registration number and password are required'}, status=status.HTTP_400_BAD_REQUEST)

    try:
        # Fetch the account record from the database
        account = Account.objects.get(registration_no=registration_no)
    except Account.DoesNotExist:
        return Response({'message': 'Invalid registration number or password'}, status=status.HTTP_401_UNAUTHORIZED)

    # Check the provided password against the stored hashed password
    if password==account.password:
        # Generate JWT token
        token_payload = {
            'registration_no': registration_no,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1),  # Token expiration time
        }
        token = jwt.encode(token_payload, settings.SECRET_KEY, algorithm='HS256')

        return Response({'token': token}, status=status.HTTP_200_OK)
    else:
        return Response({'message': 'Invalid registration number or password'}, status=status.HTTP_401_UNAUTHORIZED)
    


@api_view(['GET'])
def auth(request):
    token = request.META.get('HTTP_AUTHORIZATION')  # Get token from the Authorization header

    if not token:
        return Response({'message': 'Token is required'}, status=status.HTTP_401_UNAUTHORIZED)

    try:
        # Decode the token to get the payload
        payload = jwt.decode(token.split(" ")[1], settings.SECRET_KEY, algorithms=['HS256'])
        registration_no = payload.get('registration_no')  # Get registration number from payload

        return Response({'registration_no': registration_no}, status=status.HTTP_200_OK)

    except jwt.ExpiredSignatureError:
        return Response({'message': 'Token has expired'}, status=status.HTTP_401_UNAUTHORIZED)
    except jwt.InvalidTokenError:
        return Response({'message': 'Invalid token'}, status=status.HTTP_401_UNAUTHORIZED)