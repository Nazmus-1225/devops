from django.contrib.auth import get_user_model
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
from django.contrib.auth import authenticate

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

    user = authenticate(username=registration_no, password=password)
    if user is not None:
        if user.is_superuser:
            token_payload = {
                'registration_no': registration_no,
                'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=1),  # Token expiration time
            }
            token = jwt.encode(token_payload, settings.SECRET_KEY, algorithm='HS256')

            return Response({'token': token}, status=status.HTTP_200_OK)
        else:
            return Response({'message': 'Invalid registration number or password'}, status=status.HTTP_401_UNAUTHORIZED)
    else:
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
        User = get_user_model()
        if User.objects.filter(username=registration_no, is_superuser=True).exists():
            return Response({'role': 'admin'}, status=status.HTTP_200_OK)

        return Response({'registration_no': registration_no}, status=status.HTTP_200_OK)

    except jwt.ExpiredSignatureError:
        return Response({'message': 'Token has expired'}, status=status.HTTP_401_UNAUTHORIZED)
    except jwt.InvalidTokenError:
        return Response({'message': 'Invalid token'}, status=status.HTTP_401_UNAUTHORIZED)