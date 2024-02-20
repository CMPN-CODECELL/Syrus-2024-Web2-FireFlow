import 'dart:async';

import 'package:client/colors/pallete.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

//_Speciality page
class SpecialityMh extends StatefulWidget {
  const SpecialityMh({super.key});

  @override
  State<SpecialityMh> createState() => _SpecialityMhState();
}

class _SpecialityMhState extends State<SpecialityMh> {
  late Stream<QuerySnapshot> festivals;
  String selectedCity = "All";
  List<String> cities = ['All'];

  // fetchdata() {
  //   setState(() {
  //     festivals =
  //         FirebaseFirestore.instance.collection('festivals').snapshots();
  //   });
  // }

  fetchdata() {
    setState(() {
      if (selectedCity == "All") {
        // Fetch all festivals if no city is selected
        festivals =
            FirebaseFirestore.instance.collection('festivals').snapshots();
      } else {
        // Fetch festivals based on the selected city

        festivals = FirebaseFirestore.instance
            .collection('festivals')
            .where('category', isEqualTo: selectedCity)
            .snapshots();
      }
    });
  }

  List<String> getCitiesFromSnapshot(QuerySnapshot snapshot) {
    Set<String> cities = Set<String>();

    for (var doc in snapshot.docs) {
      var festivalData = doc.data() as Map<String, dynamic>;
      var regionsCelebrated = festivalData['category'];
      cities.add(regionsCelebrated);
    }

    return cities.toList();
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
    festivals = FirebaseFirestore.instance.collection('festivals').snapshots();

    // Fetch cities and update the dropdown list
    festivals.listen((QuerySnapshot snapshot) {
      List<String> newCities = ['All'];
      for (var doc in snapshot.docs) {
        var festivalData = doc.data() as Map<String, dynamic>;
        var regionsCelebrated = festivalData['category'];
        if (!newCities.contains(regionsCelebrated)) {
          newCities.add(regionsCelebrated);
        }
      }
      setState(() {
        cities = newCities;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Festival List'),
      ),
      body: Column(
        children: [
          // Add a dropdown for selecting the city
          DropdownButton<String>(
            value: selectedCity,
            items: cities.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCity = newValue!;
                fetchdata();
              });
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: festivals,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var festivalDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: festivalDocs.length,
                  itemBuilder: (context, index) {
                    var festivalData =
                        festivalDocs[index].data() as Map<String, dynamic>;

                    List<String> mostFamousPlaces =
                        List.from(festivalData['mostFamousPlaces']);

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(
                          color: Pallete.primary,
                          width: 2.0,
                        ), // Adjust the radius and color as needed
                      ),
                      color: Pallete.bgColor,
                      child: ListTile(
                        title: Text(festivalData['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Regions Celebrated: ${festivalData['regionsCelebrated']}',
                            ),
                            Text(
                              'Most Famous Places:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            for (var place in mostFamousPlaces)
                              Text('- $place'),
                          ],
                        ),
                        onTap: () {
                          // Navigate to the details page on card tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                festivalData: festivalData,
                                mostFamousPlaces: mostFamousPlaces,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// deatil page
class DetailPage extends StatelessWidget {
  final Map<String, dynamic> festivalData;
  final List<String> mostFamousPlaces;

  DetailPage({required this.festivalData, required this.mostFamousPlaces});
  Future<Position> getUserCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(festivalData['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${festivalData['description']}'),
            Text('Start Date: ${festivalData['startDate']}'),
            Text('End Date: ${festivalData['endDate']}'),
            Text('Regions Celebrated: ${festivalData['regionsCelebrated']}'),
            Text(
              'Most Famous Places:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            for (var place in mostFamousPlaces)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Implement the logic to convert place into coordinates
                    // and mark it on the map
                    final coordinates = await _getCoordinatesFromAddress(place);
                    _markPlaceOnMap(context, place, coordinates);
                  },
                  child: Text(place),
                ),
              ),
            SizedBox(height: 16.0),
            FloatingActionButton(
              onPressed: () {
                // Implement the logic to add the festival to the bucket list
                // You can use a state management solution or other methods to handle this
              },
              tooltip: 'Add to Bucket List',
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Location>> _getCoordinatesFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (e) {
      print('Error getting coordinates for address $address: $e');
      return [];
    }
  }

  void _markPlaceOnMap(
      BuildContext context, String place, List<Location> coordinates) {
    // Navigate to a new screen with Google Maps
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          place: place,
          coordinates: coordinates,
        ),
      ),
    );
  }
}

//map screen
class MapScreen extends StatefulWidget {
  final String place;
  final List<Location> coordinates;

  MapScreen({required this.place, required this.coordinates});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Future<Position> getUserCurrentLocation() async {
    var permission = await Geolocator.checkPermission();
    print('the permission is $permission');
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      await Geolocator.requestPermission().catchError((error) {
        print("error: $error");
      });
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.coordinates.first.latitude,
            widget.coordinates.first.longitude,
          ),
          zoom: 15.0,
        ),
        markers: _createMarkers(),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: ElevatedButton(
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
          onPressed: <Future>() async {
            final Position currentLocation = await getUserCurrentLocation();

            String url =
                'https://www.google.com/maps/dir/?api=1&origin=${currentLocation.latitude},${currentLocation.longitude} &destination=${widget.coordinates.first.latitude},${widget.coordinates.first.longitude}';
            print(url);
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Container(
            height: 60,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              'View Directions',
              style: TextStyle(color: Pallete.whiteColor),
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return widget.coordinates
        .map(
          (location) => Marker(
            markerId: MarkerId(location.toString()),
            position: LatLng(location.latitude, location.longitude),
            infoWindow: InfoWindow(title: widget.place),
          ),
        )
        .toSet();
  }
}

//webview
class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(widget.url));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
      ),
      body: SafeArea(
          child: Scaffold(body: WebViewWidget(controller: controller))),
    );
  }
}
