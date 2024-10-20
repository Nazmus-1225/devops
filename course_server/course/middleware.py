import requests
from decouple import config
# Define a function to check if the user is an admin
def is_user_admin(user_token):
    url = f"{config('REGISTRATION_SERVER_URL')}/auth"
    headers = {'Authorization': f'Bearer {user_token}'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return response.json().get('role') == 'admin'
    return False

def is_student(user_token):
    url = f"{config('REGISTRATION_SERVER_URL')}/auth"
    headers = {'Authorization': f'Bearer {user_token}'}
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        return True
    return False

def get_registration(user_token):
    url = f"{config('REGISTRATION_SERVER_URL')}/auth"
    headers = {'Authorization': f'Bearer {user_token}'}
    response = requests.get(url, headers=headers)
    return response.json().get('registration_no')
