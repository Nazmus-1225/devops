from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.core.management import CommandError
from django.conf import settings
class Command(BaseCommand):
    help = 'Create a superuser without any input'

    def handle(self, *args, **kwargs):
        User = get_user_model()
        if not User.objects.filter(username='admin').exists():
            User.objects.create_superuser(
                username=settings.DJANGO_SUPERUSER_USERNAME,
                email=settings.DJANGO_SUPERUSER_EMAIL,
                password=settings.DJANGO_SUPERUSER_PASSWORD
            )
            self.stdout.write(self.style.SUCCESS('Superuser created successfully'))
        else:
            self.stdout.write(self.style.WARNING('Superuser already exists'))
