import { TestBed } from '@angular/core/testing';

import { PlaceadminService } from './placeadmin.service';

describe('PlaceadminService', () => {
  let service: PlaceadminService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PlaceadminService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
