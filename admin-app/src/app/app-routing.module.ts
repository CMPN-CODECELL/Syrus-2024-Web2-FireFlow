import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './placeadmin/login/login.component';
import { HeroComponent } from './placeadmin/hero/hero.component';
import { AddPlaceComponent } from './placeadmin/add-place/add-place.component';


const routes: Routes = [

{
  path:'home',
  component:HeroComponent
},
{
  path:'addPlace',
  component:AddPlaceComponent
},
{
  path:'',
  component:LoginComponent
}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
