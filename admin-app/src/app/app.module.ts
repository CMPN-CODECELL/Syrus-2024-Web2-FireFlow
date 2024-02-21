import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { provideFirebaseApp, getApp, initializeApp } from '@angular/fire/app';
import { getFirestore, provideFirestore } from '@angular/fire/firestore';
import { AppComponent } from './app.component';
import { PlaceadminService } from './placeadmin.service';
import { RouterModule } from '@angular/router';
import { PlaceadminModule } from './placeadmin/placeadmin.module';
import { SharedModule } from './shared/shared.module';
import { AppRoutingModule } from './app-routing.module';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { AngularFireModule } from '@angular/fire/compat';


const firebaseConfig = {
  apiKey: 'AIzaSyAoVFZjj7rjdcPOBUWWPAJ8FWsY2XL7KC8',
  authDomain: 'precise-sight-372314.firebaseapp.com',
  projectId: 'precise-sight-372314',
  storageBucket: 'precise-sight-372314.appspot.com',
  messagingSenderId: '170735395486',
  appId: '1:170735395486:web:d8814c8e29d12c780fd18f',
  measurementId: 'G-5YGQSYTF75',
};
@NgModule({
  declarations: [AppComponent],
  imports: [
    AppRoutingModule,
    BrowserModule,
    RouterModule,
    PlaceadminModule,
    SharedModule,
    provideFirebaseApp(() => initializeApp(firebaseConfig)),
    provideFirestore(() => getFirestore()),
    AngularFireModule.initializeApp(firebaseConfig),
    NgbModule
  ],
  providers: [PlaceadminService],
  bootstrap: [AppComponent],
})
export class AppModule {}
