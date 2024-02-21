// import 'dart:js_interop';

import 'dart:convert';

import 'package:background_location/background_location.dart';
import 'package:client/screens/street_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  double predefinedLocationLat = 37.7749;
  double predefinedLocationLong = -122.4194;
  final double radius = 10000;
  double _rating = 0;
  String _review = '';
  bool _isButtonEnabled = false;
  var location;

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
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
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
    var locationtemp = await _getCoordinatesFromAddress(widget.locationName);
    setState(() {
      location = locationtemp;
    });
  }

  _getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      print('Error getting coordinates for address $address: $e');
      return [];
    }
  }

  @override
  void initState() {
    fetchImage();
    fetchInfo();
    _checkIfVisited();
    super.initState();
  }

  _checkIfVisited() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      var visitedCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('visited');
      var querySnapshot = await visitedCollection.doc(locationId).get();

      if (!querySnapshot.exists) {
        _initBackgroundLocation();
      }
    } catch (e) {
      _initBackgroundLocation();
    }
  }

  Future<void> _initBackgroundLocation() async {
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
    await BackgroundLocation.startLocationService();
    // await BackgroundLocation.startLocationUpdates();
    BackgroundLocation.getLocationUpdates((location) {
      _checkLocationAndShowAlert(location.latitude!, location.longitude!);
    });
  }

  void _submitRating() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    var currentratesnap = await FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .get();
    var currentrate = currentratesnap['Rating'];
    currentrate = (currentrate + _rating) / 2;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('visited')
        .doc(locationId)
        .set({
      "LocationID": locationId,
      "DateVisit": DateTime.now(),
      "Rated": _rating,
      "Review": _review
    });
    FirebaseFirestore.instance.collection('locations').doc(locationId).update({
      'Rating': currentrate,
    });
    FirebaseFirestore.instance
        .collection('locations')
        .doc(locationId)
        .collection('Reviews')
        .add({
      'RatedBy': userId,
      'Rating': _rating,
      'Review': _review,
      'Timestamp': Timestamp.now(),
    }).then((value) {
      // Reset fields after submission
      setState(() {
        _rating = 0;
        _review = '';
        _isButtonEnabled = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      // Show error message if any
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit rating: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _checkLocationAndShowAlert(double currentLat, double currentLong) {
    double distance = Geolocator.distanceBetween(
      currentLat,
      currentLong,
      predefinedLocationLat,
      predefinedLocationLong,
    );
    print("The distance is $distance");

    if (distance <= radius) {
      BackgroundLocation.stopLocationService();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Great!'),
          content: Text('Seems Like you are Already visiting this location'),
          actions: <Widget>[
            Text(
              'Rate it',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating.floor() ? Icons.star : Icons.star_border,
                    color: Pallete.primary,
                    size: 20.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                      _isButtonEnabled = true;
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Write a review (optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _review = value;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _submitRating : null,
              child: Text('Submit'),
            ),
          ],
        ),
      );
    }
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(this.description)
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Pallete.whiteColor,
          backgroundColor: Pallete.primary, // Text color
          // padding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          // elevation: 5,
          //minimumSize: Size(double.infinity, 0), // Full width
        ),
        onPressed: () async {
          double lat = location.first.latitude;
          double long = location.first.longitude;
          print("The lat long is $lat $long");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreetViewPanoramaInitDemo(
                        place: widget.locationName,
                        lat: lat,
                        long: long,
                        rating: rating,
                      )));
        },
        child: Container(
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            'Street View',
            style: TextStyle(color: Pallete.whiteColor),
          ),
        ),
      ),
    );
  }
}
