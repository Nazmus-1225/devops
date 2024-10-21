import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import {environment} from '../../../src/environment/environment'
import { Course } from '../models/course.model'
import { Semester } from '../models/semester.model';
  const createCourseUrl = `${environment.courseUrl}/createCourse/`;
  const createSemesterUrl = `${environment.courseUrl}/createSemester/`;
  const getCourseUrl = `${environment.courseUrl}/getCourses/`;
  const getSemesterUrl = `${environment.courseUrl}/getSemesters/`;


@Injectable({
  providedIn: 'root'
})
export class CourseService {
  

  constructor(private http: HttpClient) {}

  getCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(getCourseUrl);
  }

  getSemesters(): Observable<Semester[]> {
    return this.http.get<Semester[]>(getSemesterUrl);
  }

  createCourse(course: Course): Observable<any> {
    return this.http.post(createCourseUrl, course, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`  // Assuming token is stored in localStorage
      }
    });
  }

  // Create a new semester
  createSemester(semester: Semester): Observable<any> {
    return this.http.post(createSemesterUrl, semester, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('token')}`  // Assuming token is stored in localStorage
      }
    });
  }


}
