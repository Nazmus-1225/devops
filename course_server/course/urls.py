from django.urls import path
from .views import createCourse,createSemester,deleteCourse,addSemester, getCourses,getSemesters
urlpatterns = [
    path('createCourse/', createCourse, name='createCourse'),
    path('deleteCourse/', deleteCourse, name='deleteCourse'),
    path('createSemester/', createSemester, name='createSemester'),
    path('addSemester/', addSemester, name='addSemester'),
    path('getCourses/',getCourses, name='getCourses'),
    path('getSemesters/',getSemesters, name='getSemesters')
]