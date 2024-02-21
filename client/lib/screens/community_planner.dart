import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cplanner extends StatefulWidget {
  const Cplanner({super.key});

  @override
  State<Cplanner> createState() => _CplannerState();
}

class _CplannerState extends State<Cplanner> {
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;
  Future<List<Map<String, dynamic>>> fetchOtherUserItineraries(
      currentUserID) async {
    List<Map<String, dynamic>> otherUserItineraries = [];

    try {
      // Replace 'your_collection_name' with the actual name of your collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('itineraries')
          .where('userId', isNotEqualTo: currentUserID)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Iterate through the documents and fetch itineraries
        querySnapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          otherUserItineraries.add(data);
        });
      }
    } catch (e) {
      print('Error fetching other user itineraries: $e');
      // Handle the error as per your application's needs
    }

    return otherUserItineraries;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Other User Itineraries'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
          // Replace 'currentUserID' with the actual ID of the current user
          future: fetchOtherUserItineraries(currentUserID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No other user itineraries found.'));
            } else {
              // Display the list of other user itineraries
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // Use data from the snapshot.data[index] to display itineraries
                  String itineraryText = snapshot.data![index]['itineraryText'];

                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(itineraryText),
                      // Add more ListTile properties as needed
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
