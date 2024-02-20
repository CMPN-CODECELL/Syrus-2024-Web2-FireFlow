// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../colors/pallete.dart';

class PlaceInfo extends StatefulWidget {
  const PlaceInfo({Key? key, required this.locationName}) : super(key: key);
  final String locationName;
  @override
  _PlaceInfoState createState() => _PlaceInfoState();
}

class _PlaceInfoState extends State<PlaceInfo> {
  String category = "";
  String city = "";
  String description = "";
  double rating = 0.0;
  String locationId = "";
  double latitude = 37.7749;
  double longitude = -122.4194;

  fetchInfo() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('location')
        .where("name", isEqualTo: widget.locationName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      QueryDocumentSnapshot firstDocument = querySnapshot.docs.first;
      Map<String, dynamic> location = querySnapshot.docs.first.data();
      setState(() {
        print(location);
        locationId = firstDocument.id;

        latitude = double.parse(location['latitude']);
        print('Rating before conversion: ${location['latitude']}');
        print('Rating before conversion: ${location['longitude']}');
        longitude = double.parse(location['longitude']);
        category = location['category'];
        description = location['description'];
        city = location['city'];
        //  rating = (location['rating'] ?? 0).toDouble();
        print('Rating before conversion: ${location['rating']}');

        try {
          // Use toDouble() method on 'rating' field
          rating = (location['rating'] ?? 0).toDouble();
        } catch (e) {
          print('Error converting rating to double: $e');
          // Set a default value or handle the error as needed
          rating = 0.0;
        }
      });
    } else {
      throw Exception('Location not found');
    }
    // var locationtemp = await _getCoordinatesFromAddress(title);
    // setState(() {
    //   location = locationtemp;
    // });
  }

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  _addToList() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    CollectionReference bucketCollectionRef = userRef.collection('bucket');

    await bucketCollectionRef.doc(widget.locationName).set({
      'LocationId': this.locationId,
      'LocationName': widget.locationName,
      'LocationCity': city,
      'LocationRating': rating,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.locationName}'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              child: Row(children: [Text(widget.locationName)]),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: Row(
                children: [Text("City:"), Text(this.city)],
              ),
            ),
            Card(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _addToList();
                      },
                      icon: Icon(
                        Icons.list_alt,
                        size: 40,
                        color: Pallete.primary,
                      )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.star,
                              size: 30,
                              color: Pallete.primary,
                            )),
                        Padding(
                            padding: EdgeInsetsDirectional.only(top: 10),
                            child: Text(
                              rating.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: Column(
                children: [Text("Description:"), Text(this.description)],
              ),
            ),
          ],
        ));
  }
}
