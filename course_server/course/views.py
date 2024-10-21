from django.shortcuts import render
from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .serializers import CourseSerializer, SemesterSerializer, StudentSemesterCourseSerializer
from .middleware import is_user_admin, get_registration, is_student
from rest_framework import status
from rest_framework.response import Response
from .models import Semester, Course, StudentSemesterCourse
from django.utils import timezone
@api_view(['POST'])
def createCourse(request):
        user_token = request.META.get('HTTP_AUTHORIZATION').split()[1]
        
        if not is_user_admin(user_token):
            return Response({'error': 'Permission denied. Admin role required.'}, status=status.HTTP_403_FORBIDDEN)
        
        serializer = CourseSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['DELETE'])
def deleteCourse(request):
        user_token = request.META.get('HTTP_AUTHORIZATION').split()[1]
        if not is_user_admin(user_token):
            return Response({'error': 'Permission denied. Admin role required.'}, status=status.HTTP_403_FORBIDDEN)

        try:
            course = Course.objects.get(course_id=request.data.course_id)
            course.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Course.DoesNotExist:
            return Response({'error': 'Course not found.'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['POST'])
def createSemester(request):
        user_token = request.META.get('HTTP_AUTHORIZATION').split()[1]
        if not is_user_admin(user_token):
            return Response({'error': 'Permission denied. Admin role required.'}, status=status.HTTP_403_FORBIDDEN)
        serializer = SemesterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



@api_view(['POST'])
def addSemester(request):
        user_token = request.META.get('HTTP_AUTHORIZATION').split()[1]

        if is_student(user_token):
            registration_no=get_registration(user_token)
            semester_id = request.data.get('semester_id')
            try:
                semester = Semester.objects.get(semester_id=semester_id)
            except Semester.DoesNotExist:
                return Response({'error': 'Semester not found.'}, status=status.HTTP_404_NOT_FOUND)

            if semester.start_date > timezone.now().date() or semester.end_date < timezone.now().date():
                return Response({'error': 'Semester is not open for registration.'}, status=status.HTTP_400_BAD_REQUEST)

            # Step 3: Add courses to the semester
            courses_ids = request.data.get('courses', [])
            for course_id in courses_ids:
                try:
                    course = Course.objects.get(course_id=course_id)
                    StudentSemesterCourse.objects.create(
                        registration_no=registration_no,
                        semester=semester,
                        course=course
                    )
                except Course.DoesNotExist:
                    return Response({'error': f'Course with ID {course_id} not found.'}, status=status.HTTP_404_NOT_FOUND)

            return Response({'message': 'Courses added to semester successfully.'}, status=status.HTTP_201_CREATED)


        
        return Response({'error': 'Authentication failed.'}, status=status.HTTP_403_FORBIDDEN)

@api_view(['GET'])
def getCourses(request):
    print(request)
    courses = Course.objects.all()
    serializer = CourseSerializer(courses, many=True)
    print(courses)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['GET'])
def getSemesters(request):
    semesters = Semester.objects.all()
    serializer = SemesterSerializer(semesters, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)
