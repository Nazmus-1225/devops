from rest_framework import serializers
from .models import Course, Semester, StudentSemesterCourse

class CourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Course
        fields = ['course_id', 'course_name', 'credit', 'instructor']

class SemesterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Semester
        fields = ['semester_id', 'semester_name', 'start_date', 'end_date']

class StudentSemesterCourseSerializer(serializers.ModelSerializer):
    class Meta:
        model = StudentSemesterCourse
        fields = ['registration_no', 'semester', 'course']
