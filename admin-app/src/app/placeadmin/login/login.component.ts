import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { PlaceadminService } from 'src/app/placeadmin.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css'],
})
export class LoginComponent implements OnInit {
  constructor(
    private placeadminservice: PlaceadminService,
    private router: Router
  ) {}
  ngOnInit(): void {
    // this.placeadminservice
    //   .registerwithemail({ email: 'admin', password: 'admin' })
    //   .then((res) => {})
    //   .catch((error: any) => {console.error(error)});
  }
  loginForm = new FormGroup({
    email: new FormControl(),
    password: new FormControl(),
  });

  submit() {
    if(this.loginForm.get("email")?.value==="admin" && this.loginForm.get("password")?.value==="admin"){
      this.router.navigate(['home']);
    }
  }
}
