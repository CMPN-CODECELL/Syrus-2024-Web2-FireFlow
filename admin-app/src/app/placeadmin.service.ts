import { Injectable } from '@angular/core';
import { AngularFireAuth } from '@angular/fire/compat/auth';
import {
  Firestore,
  addDoc,
  collection,
  collectionData,
  deleteDoc,
  doc,
} from '@angular/fire/firestore';

@Injectable({
  providedIn: 'root',
})
export class PlaceadminService {
  constructor(private fs: Firestore, private afs: AngularFireAuth) {}

  // registerwithemail(user: { email: string; password: string }) {
  //   return this.afs.createUserWithEmailAndPassword(user.email,user.password);
  // }

  // signinwithemail(user: { email: string; password: string }){
  //   return this.afs.signInWithEmailAndPassword(user.email,user.password);
  // }

  getUnverifiedPlaces() {
    let unverified = collection(this.fs, 'Unverified');
    return collectionData(unverified, { idField: 'id' });
  }

  addPlaces(data: any) {
    let places = collection(this.fs, 'location');
    return addDoc(places, data);
  }

  removeUnverified(id: string) {
    let docRef = doc(this.fs, 'Unverified/' + id);
    return deleteDoc(docRef);
  }
}
