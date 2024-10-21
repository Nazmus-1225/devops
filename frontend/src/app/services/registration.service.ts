import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import {environment} from '../../../src/environment/environment'



const loginUrl = `${environment.registrationUrl}/signin/`;
const registerUrl = `${environment.registrationUrl}/signup/`;

@Injectable({
  providedIn: 'root'
})
export class RegistrationService {

  constructor(private http: HttpClient, private router: Router) { }
  
  login(registration_no:string, password:string): Observable<HttpResponse<any>> {
    return this.http.post<any>(loginUrl, {registration_no: registration_no, password: password}, { observe: 'response' });
  }

  register(registration_no:string, password:string): Observable<HttpResponse<any>> {
    return this.http.post<any>(registerUrl, {registration_no: registration_no, password: password}, { observe: 'response' });
  }

}
