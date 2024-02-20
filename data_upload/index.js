const fs = require('fs');
const csv = require('csv-parser');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
const serviceAccount = require('./precise-sight-372314-firebase-adminsdk-fcf5k-f12fdd31aa.json'); 
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// Initialize Firestore
const db = admin.firestore();

// Path to your CSV file
const csvFilePath = 'locations_with_geocode_and_tags.csv';

// Function to parse CSV and write data to Firestore
const importCSVToFirestore = () => {
  fs.createReadStream(csvFilePath)
    .pipe(csv())
    .on('data', (row) => {
      // Process each row from the CSV
      const locationData = {
        name: row['Place'],
        description: row['Place_desc'],
        category: row['Category'],
        keyword:row['Keywords'],
        latitude:row['Latitude'],
        longitude:row['Longitude'],
        rating:row['Ratings'],
        tags:row['Tags'],
        city:row['City']
      };

      // Add festival data to Firestore
      db.collection('location').doc().set(locationData)
        .then(() => {
          console.log(`Location ${locationData.name} added to Firestore`);
        })
        .catch((error) => {
          console.error('Error adding location to Firestore: ', error);
        });
    })
    .on('end', () => {
      console.log('CSV file successfully processed');
    });
};

// Call the function to start importing CSV data to Firestore
importCSVToFirestore();
