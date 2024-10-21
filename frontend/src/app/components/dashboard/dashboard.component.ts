import { Component } from '@angular/core';
import { Course } from '../../models/course.model';
import { Semester } from '../../models/semester.model';
import { CourseService } from '../../services/course.service';
import { OnInit } from '@angular/core';
import { Router } from '@angular/router';
@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent implements OnInit {
  newCourse: Course = { course_id: '1',course_name: '', instructor: '', credit: 0 };  // Initialize course model
  newSemester: Semester = { semester_id:'1',semester_name: '', start_date: '', end_date: '' };
  courses: Course[]=[];
  semesters: Semester[]=[];

  constructor(private courseService:CourseService,private router:Router){}
  ngOnInit(): void {
    this.loadCourses();
    this.loadSemesters(); // Call loadCourses when the component initializes
  }

  loadCourses(): void {
    this.courseService.getCourses().subscribe(
      response => {
        this.courses = response; // Assign the response to the courses array
      },
      error => {
        console.error('Error:', error); // Log any errors
      }
    );
  }

  loadSemesters(): void {
    this.courseService.getSemesters().subscribe(
      response => {
        this.semesters = response; // Assign the response to the courses array
      },
      error => {
        console.error('Error:', error); // Log any errors
      }
    );
  }

  addCourse(){
    this.courseService.createCourse(this.newCourse).subscribe(
      response => {
        this.router.navigate(['/dashboard']);
      },
      error => {
        console.error('Error:', error); // Log any errors
      }
    );
  }
  addSemester(){
    this.courseService.createSemester(this.newSemester).subscribe(
      response => {
        this.router.navigate(['/dashboard']);
      },
      error => {
        console.error('Error:', error); // Log any errors
      }
    );
  }
}
