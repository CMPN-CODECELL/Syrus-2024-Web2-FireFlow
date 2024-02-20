import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './placeadmin/login/login.component';
import { HeroComponent } from './placeadmin/hero/hero.component';


const routes: Routes = [
{
  path:' ',
  component:LoginComponent
},
{
  path:'Home',
  component:HeroComponent
}
  
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
