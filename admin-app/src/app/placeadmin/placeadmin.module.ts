import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { LoginComponent } from './login/login.component';
import { HeroComponent } from './hero/hero.component';
import { AddPlaceComponent } from './add-place/add-place.component';
import { SharedModule } from '../shared/shared.module';
import { RouterModule } from '@angular/router';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { PlaceadminService } from '../placeadmin.service';



@NgModule({
  declarations: [
    LoginComponent,
    HeroComponent,
    AddPlaceComponent
  ],
  imports: [
    NgbModule,
    CommonModule,
    SharedModule,
    FormsModule,
    ReactiveFormsModule,
    RouterModule
  ],
  exports:[
    LoginComponent,
    HeroComponent,
    AddPlaceComponent
  ],
  providers:[
    PlaceadminService
  ]
})
export class PlaceadminModule { }
