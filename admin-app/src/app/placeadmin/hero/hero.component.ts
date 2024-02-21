import { Component, OnInit } from '@angular/core';
import { PlaceadminService } from 'src/app/placeadmin.service';

@Component({
  selector: 'app-hero',
  templateUrl: './hero.component.html',
  styleUrls: ['./hero.component.css'],
})
export class HeroComponent implements OnInit {
  unverified!: any[];
  constructor(private placeadminservice: PlaceadminService) {}
  ngOnInit(): void {
  this.view();
  }

  view(){
    this.placeadminservice.getUnverifiedPlaces().subscribe((data) => {
      this.unverified = data;
    });
  }


  submit(id:string,i:number){
    this.placeadminservice.addPlaces(this.unverified[i]).then((res)=>{
      console.log("added");
    })
    this.placeadminservice.removeUnverified(id).then((data)=>{
      alert("Successfully verified");
      this.view();
    })
  }
  
}
