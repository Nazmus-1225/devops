from django.urls import path
from .views import createCourse,createSemester,deleteCourse,addSemester
urlpatterns = [
    path('createCourse/', createCourse, name='createCourse'),
    path('deleteCourse/', deleteCourse, name='deleteCourse'),
    path('createSemester/', createSemester, name='createSemester'),
    path('addSemester/', addSemester, name='addSemester')
]