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
const csvFilePath = 'festivals_more.csv';

// Function to parse CSV and write data to Firestore
const importCSVToFirestore = () => {
  fs.createReadStream(csvFilePath)
    .pipe(csv())
    .on('data', (row) => {
      // Process each row from the CSV
      const festivalData = {
        name: row['Festival Name'],
        description: row['Description'],
        startDate: row['Start Date'],
        endDate: row['End Date'],
        category: row['Category'],
        regionsCelebrated: row['Regions Celebrated'],
        mostFamousPlaces: row['Most Famous Places'].split(',').map(place => place.trim()), // Convert comma-separated string to array
        activities: row['Activities'],
        uniqueCelebrations: row['Unique Celebrations'],
        imageURL: row['Image URL'],
      };

      // Add festival data to Firestore
      db.collection('festivals_more').doc().set(festivalData)
        .then(() => {
          console.log(`Festival ${festivalData.name} added to Firestore`);
        })
        .catch((error) => {
          console.error('Error adding festival to Firestore: ', error);
        });
    })
    .on('end', () => {
      console.log('CSV file successfully processed');
    });
};

// Call the function to start importing CSV data to Firestore
importCSVToFirestore();
