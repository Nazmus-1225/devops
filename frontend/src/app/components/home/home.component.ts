import { Component } from '@angular/core';
import { RegistrationService } from '../../services/registration.service';
import { HttpResponse } from '@angular/common/http';
import { Router } from '@angular/router';
@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  registration_no: string = '';
  password: string = '';

  constructor(private registrationService:RegistrationService, private router: Router) {}

  onLogin() {
    this.registrationService.login(this.registration_no,this.password).subscribe(
      (response: HttpResponse<any>) => {
        localStorage.setItem('token',response.body.token);
        this.router.navigate(['/dashboard']);
      },
      error => {
        alert(error.error.message);
      }
    );
  }
  onRegister() {
    this.registrationService.register(this.registration_no,this.password).subscribe(
      (response: HttpResponse<any>) => {
        if(response.status!=201){
          alert(response.body.message);
        }
      },
      error => {
        alert(error.error.message);
      }
    );
  }
}
