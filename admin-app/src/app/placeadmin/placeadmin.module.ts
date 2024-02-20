import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginComponent } from './login/login.component';
import { HeroComponent } from './hero/hero.component';



@NgModule({
  declarations: [
    LoginComponent,
    HeroComponent
  ],
  imports: [
    CommonModule
  ]
})
export class PlaceadminModule { }
