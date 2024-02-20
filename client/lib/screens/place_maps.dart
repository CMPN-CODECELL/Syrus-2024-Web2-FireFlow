import 'dart:async';
import 'dart:ui' as ui;
import 'package:client/colors/pallete.dart';
import 'package:client/screens/place_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';

class PlaceMap extends StatefulWidget {
  final String category;
  const PlaceMap({Key? key, required this.category}) : super(key: key);

  @override
  _PlaceMapState createState() => _PlaceMapState();
}

class _PlaceMapState extends State<PlaceMap>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool isLoading = true;
  bool didModalBottomSheet = false;
  double radius = 3000;
  bool refreshLoading = false;

  final Completer<GoogleMapController> _controller = Completer();
  Map<String, LatLng> addressCoordinates = {};

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.0514885, 72.8869815),
    zoom: 5,
  );

  Stream<QuerySnapshot>? _stream1;

  @override
  void initState() {
    super.initState();

    setupMarkers();

    _stream1 = FirebaseFirestore.instance
        .collection('locations')
        .where("Category", isEqualTo: widget.category)
        .snapshots();
    getAddress(_stream1);
  }

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

  getAddress(Stream<QuerySnapshot<Object?>>? stream) {
    stream?.listen((QuerySnapshot querySnapshot) {
      for (var document in querySnapshot.docs) {
        try {
          final MarkerId markerId = MarkerId(document['Places']);

          final Marker senderMarker = Marker(
            markerId: markerId,
            position: LatLng(document['Latitude'], document['Longitude']),
            infoWindow: InfoWindow(title: document['Places']),
            icon: customMarkerIcon,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PlaceInfo(locationName: document['Place'])),
              );
            },
          );
          setState(() {
            _markers.add(senderMarker);
          });
          // }
          // }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  late BitmapDescriptor customMarkerIcon;

  late final Set<Marker> _markers = <Marker>{};
  final Set<Circle> _circles = <Circle>{};

  Future<void> setupMarkers() async {
    customMarkerIcon =
        await _createCustomMarkerIcon('assets/images/marker.png');

    final Position userLocation = await getUserCurrentLocation();
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('userLocation'),
          position: LatLng(userLocation.latitude, userLocation.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: const InfoWindow(title: "My current Places"),
        ),
      );
    });

    _circles.add(Circle(
      circleId: const CircleId('userLocationCircle'),
      center: LatLng(userLocation.latitude, userLocation.longitude),
      radius: radius, // Radius in meters
      fillColor: Colors.blue.withOpacity(0.2),
      strokeWidth: 0,
    ));

    CameraPosition cameraPosition = CameraPosition(
      zoom: 15,
      target: LatLng(userLocation.latitude, userLocation.longitude),
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<BitmapDescriptor> _createCustomMarkerIcon(String imagePath,
      {int width = 100, int height = 100}) async {
    final ByteData byteData = await rootBundle.load(imagePath);

    final Uint8List uint8List = byteData.buffer.asUint8List();
    ui.Codec codec = await ui.instantiateImageCodec(uint8List,
        targetHeight: height, targetWidth: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ByteData? resizedByteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedUint8List = resizedByteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedUint8List);
  }

  @override
  void dispose() {
    _circles.clear();
    _stream1 = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            markers: Set<Marker>.of(_markers),
            circles: Set<Circle>.of(_circles),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Pallete.primary,
              onPressed: () {
                Geolocator.getCurrentPosition().then((value) async {
                  CameraPosition cameraPosition = CameraPosition(
                    zoom: 16,
                    target: LatLng(value.latitude, value.longitude),
                  );
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
                });
              },
              child: const Icon(Icons.filter_center_focus),
            ),
          ],
        ),
      ),
    );
  }
}
