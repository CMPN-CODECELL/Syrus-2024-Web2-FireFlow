// import 'dart:js_interop';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  late String imageUrl;

  Future<void> fetchImage() async {
    final unsplashApiKey = 'buSU_UmLJboo1ASR9VjZJCImR6_SxUbweVleVFVcCBg';
    final response = await http.get(
      Uri.parse(
          'https://api.unsplash.com/photos/random?query=${widget.locationName}&client_id=$unsplashApiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final urls = data['urls'];
      setState(() {
        imageUrl = urls['regular'];
      });
    } else {
      print('Failed to load image: ${response.statusCode}');
    }
  }

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
        rating = double.parse(location['rating']);
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
    fetchImage();
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
              color: Pallete.light,
              child: Image.network(
                imageUrl,
                height: 180,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            Card(
              color: Pallete.light,
              child: Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    widget.locationName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ))),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Pallete.light,
              child: Container(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "City:",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this.city,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Pallete.light,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _addToList();
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Pallete.primary,
                        // minimumSize: const Size(double.infinity, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Pallete.primary, width: 2),
                        )),
                    child: Text(
                      'Add to Bucket List',
                      style: TextStyle(color: Pallete.whiteColor),
                    ),
                  ),
                  Row(
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
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Pallete.light,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description:",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Text(this.description)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
