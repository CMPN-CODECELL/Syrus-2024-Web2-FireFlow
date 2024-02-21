import { Component } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { PlaceadminService } from 'src/app/placeadmin.service';

@Component({
  selector: 'app-add-place',
  templateUrl: './add-place.component.html',
  styleUrls: ['./add-place.component.css'],
})
export class AddPlaceComponent {
  constructor(
    private placeadminservice: PlaceadminService,
    private router: Router
  ) {}
  placeForm = new FormGroup({
    name: new FormControl(),
    tags: new FormControl(),
    latitude: new FormControl(),
    longitude: new FormControl(),
    keywords: new FormControl(),
    city: new FormControl(),
    description: new FormControl(),
    category: new FormControl(),
  });

  submit() {
    this.placeadminservice.addPlaces(this.placeForm.value).then((res) => {
      alert('added successfully');
      this.router.navigate(['home']);
    });
  }
}
