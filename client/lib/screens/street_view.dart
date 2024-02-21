import 'dart:async';
// import 'dart:html';

import 'package:client/colors/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as GMap;

class StreetViewPanoramaInitDemo extends StatefulWidget {
  final String place;
  final double lat;
  final double long;
  final rating;
  StreetViewPanoramaInitDemo(
      {Key? key,
      required this.place,
      required this.lat,
      required this.long,
      required this.rating})
      : super(key: key);

  @override
  State<StreetViewPanoramaInitDemo> createState() =>
      _StreetViewPanoramaInitDemoState();
}

class _StreetViewPanoramaInitDemoState
    extends State<StreetViewPanoramaInitDemo> {
  // LatLng initPos = LatLng(widget.location.first.latitude, longitude)

  final initBearing = 352.54852294921875;

  final initTilt = -8.747010231018066;

  final initZoom = 0.01421491801738739;

  bool streatView = true;

  void togleViewMode() {
    // getCoordinates();
    setState(() {
      streatView = !streatView;
    });
  }

  final Completer<GMap.GoogleMapController> _controller =
      Completer<GMap.GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              streatView
                  ? FlutterGoogleStreetView(
                      markers: {
                        Marker(
                          markerId: const MarkerId("sadsdaa"),
                          position: LatLng(widget.lat, widget.long),
                        ),
                      },
                      onCameraChangeListener: (camera) {
                        print(camera.toMap());
                      },
                      initPos: LatLng(widget.lat, widget.long),
                      initSource: StreetViewSource.outdoor,
                      initBearing: initBearing,
                      initTilt: initTilt,
                      initZoom: initZoom,
                      onStreetViewCreated: (controller) async {
                        controller.animateTo(
                          duration: 50,
                          camera: StreetViewPanoramaCamera(
                            bearing: initBearing,
                            tilt: initTilt,
                            zoom: initZoom,
                          ),
                        );
                      },
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GMap.GoogleMap(
                        onTap: ((argument) {
                          print(argument);
                        }),
                        markers: {
                          GMap.Marker(
                            markerId: const GMap.MarkerId("sadsaa"),
                            position: GMap.LatLng(widget.lat, widget.long),
                          ),
                        },
                        mapType: GMap.MapType.satellite,
                        initialCameraPosition: GMap.CameraPosition(
                          target: GMap.LatLng(widget.lat, widget.long),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GMap.GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
              Positioned(
                top: 0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: togleViewMode,
                          child: Container(
                            height: 150,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      streatView ? mapview : streateview),
                                  fit: BoxFit.cover),
                              border: Border.all(
                                width: 2,
                                color: call.withOpacity(0.5),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Pallete.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    // gradient: LinearGradient(
                    //   colors: [
                    //     gradient1,
                    //     gradient2,
                    //     gradient3,
                    //   ],
                    // ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.20,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          widget.place,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Icon(
                                    CupertinoIcons.star_fill,
                                    size: 15,
                                    color: Colors.amber,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    widget.rating.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color call = Color.fromARGB(0, 255, 255, 255); // ->call
Color message = Color.fromARGB(0, 247, 247, 247); //->message

Color gradient1 = Color.fromARGB(0, 164, 193, 255); // ->gradient
Color gradient2 = Color.fromARGB(0, 250, 250, 250); // ->gradient
Color gradient3 = Color.fromARGB(0, 255, 255, 255); // ->gradient

//022770 ->bottom container

String profile = "https://avatars.githubusercontent.com/u/37832937?v=4";
String mapview =
    "https://static.vecteezy.com/system/resources/previews/002/920/438/original/abstract-city-map-seamless-pattern-roads-navigation-gps-use-for-pattern-fills-surface-textures-web-page-background-wallpaper-illustration-free-vector.jpg";
String streateview =
    "https://static1.anpoimages.com/wordpress/wp-content/uploads/2017/11/nexus2cee_Google-Street-View-Generic-Hero.png";
