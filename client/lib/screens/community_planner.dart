// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class Cplanner extends StatefulWidget {
//   const Cplanner({super.key});

//   @override
//   State<Cplanner> createState() => _CplannerState();
// }

// class _CplannerState extends State<Cplanner> {
//   String currentUserID = FirebaseAuth.instance.currentUser!.uid;

//   Future<List<Map<String, dynamic>>> fetchOtherUserItineraries(
//       currentUserID) async {
//     List<Map<String, dynamic>> otherUserItineraries = [];

//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('itineraries')
//           .where('userId', isNotEqualTo: currentUserID)
//           .get();

//       if (querySnapshot.docs.isNotEmpty) {
//         querySnapshot.docs.forEach((doc) {
//           Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//           otherUserItineraries.add(data);
//         });
//       }
//     } catch (e) {
//       print('Error fetching other user itineraries: $e');
//     }

//     return otherUserItineraries;
//   }

//   Future<void> storeRating(
//       String userID, String itineraryID, int newRating) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('itineraries')
//           .doc(itineraryID)
//           .update({'rating': newRating});
//     } catch (e) {
//       print('Error storing rating: $e');
//     }
//   }

//   Widget buildRatingIcons(int rating) {
//     List<Icon> icons = List.generate(
//       5,
//       (index) => Icon(
//         index < rating ? Icons.star : Icons.star_border,
//         color: Colors.amber,
//       ),
//     );

//     return Row(children: icons);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Other User Itineraries'),
//         ),
//         body: FutureBuilder<List<Map<String, dynamic>>>(
//           future: fetchOtherUserItineraries(currentUserID),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(child: Text('No other user itineraries found.'));
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, index) {
//                   String itineraryText = snapshot.data![index]['itineraryText'];
//                   int rating = snapshot.data![index]['rating'] ?? 0;

//                   return Card(
//                     margin: EdgeInsets.all(8.0),
//                     child: ListTile(
//                       title: Text(itineraryText),
//                       subtitle: buildRatingIcons(rating),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:client/colors/pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cplanner extends StatefulWidget {
  @override
  _CplannerState createState() => _CplannerState();
}

class _CplannerState extends State<Cplanner> {
  Future<List<DocumentSnapshot>> fetchAllItineraries() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('itineraries').get();
      return querySnapshot.docs;
    } catch (e) {
      print('Error fetching itineraries: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary List'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchAllItineraries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No itineraries found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                DocumentSnapshot itinerary = snapshot.data![index];
                String city = itinerary['destination'] ?? 'Unknown City';
                String date = itinerary['location'] ?? 'Unknown Date';
                String itineraryId = itinerary.id;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ItineraryDetailsPage(itineraryId: itineraryId),
                        ),
                      );
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Pallete.primary),
                        // color: Pallete.primary,
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 100,
                        child: Center(
                            child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '$city - $date',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Pallete.whiteColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              itinerary['duration'],
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          ],
                        ))
                        // Add more fields as needed
                        ),
                  ),
                );

                // ListTile(
                //   title: Text('$city - $date'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) =>
                //             ItineraryDetailsPage(itineraryId: itineraryId),
                //       ),
                //     );
                //   },
                // );
              },
            );
          }
        },
      ),
    );
  }
}

class ItineraryDetailsPage extends StatefulWidget {
  final String itineraryId;

  ItineraryDetailsPage({required this.itineraryId});

  @override
  _ItineraryDetailsPageState createState() => _ItineraryDetailsPageState();
}

class _ItineraryDetailsPageState extends State<ItineraryDetailsPage> {
  Future<Map<String, dynamic>> fetchItineraryDetails() async {
    try {
      DocumentSnapshot itinerarySnapshot = await FirebaseFirestore.instance
          .collection('itineraries')
          .doc(widget.itineraryId)
          .get();

      return itinerarySnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching itinerary details: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itinerary Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchItineraryDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No itinerary details found.'));
          } else {
            // Use snapshot.data to display detailed information on this page
            // For example: snapshot.data['city'], snapshot.data['date'], etc.
            return Container(
              child: Column(children: [
                Text(
                  'City: ${snapshot.data!['location']} - ${snapshot.data!['destination']}',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Pallete.primary),
                ),
                Text(
                  'City: ${snapshot.data!['duration']}',
                  style: TextStyle(fontSize: 15.0, fontStyle: FontStyle.italic),
                ),
                Text(
                  'City: ${snapshot.data!['budgetRange']}',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Pallete.primary),
                ),
                Text(
                  'City: ${snapshot.data!['itineraryText']}',
                  style: TextStyle(fontSize: 15.0),
                ),
              ]),
            );
          }
        },
      ),
    );
  }
}
