from django.db import models

class Course(models.Model):
    course_id = models.CharField(max_length=10, unique=True)  # Unique identifier for each course
    course_name = models.CharField(max_length=100)
    credit = models.PositiveIntegerField()  # Number of credits for the course
    instructor = models.CharField(max_length=100)  # Name of the instructor

    def __str__(self):
        return f"{self.course_name} ({self.course_id})"
    
class Semester(models.Model):
    semester_id = models.CharField(max_length=10, unique=True)  # Unique identifier for each semester
    semester_name = models.CharField(max_length=100)  # Name of the semester, e.g., "Fall 2024"
    start_date = models.DateField()  # Start date of the semester
    end_date = models.DateField()  # End date of the semester

    def __str__(self):
        return f"{self.semester_name} ({self.semester_id})"
    
class StudentSemesterCourse(models.Model):
    registration_no = models.CharField(max_length=20, unique=False)
    semester = models.ForeignKey(Semester, on_delete=models.CASCADE)  # Foreign key to Semester
    course = models.ForeignKey(Course, on_delete=models.CASCADE)  # Foreign key to Course

    def __str__(self):
        return f"Student: {self.student} - Semester: {self.semester.semester_name} - Course: {self.course.course_name}"

