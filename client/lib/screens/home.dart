import 'dart:convert';

import 'package:client/colors/pallete.dart';
import 'package:client/common/gap.dart';
import 'package:client/common/places.dart';
import 'package:client/screens/add_place.dart';
import 'package:client/screens/addplace.dart';
import 'package:client/screens/calendar.dart';
import 'package:client/screens/community_planner.dart';
import 'package:client/screens/drawer.dart';
import 'package:client/screens/festivals.dart';
import 'package:client/screens/imagecam.dart';
import 'package:client/screens/maps.dart';
import 'package:client/screens/my_itinerary.dart';
import 'package:client/screens/search.dart';
import 'package:client/screens/speciality.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSearchBarActive = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    // Define your data for each category
    List<PlaceCardData> peacePlaces = [
      PlaceCardData(
          imageUrl:
              'https://www.pavitrya.com/wp-content/uploads/2020/08/shiv-mandir-ambernath-thane-temples--768x623.jpg',
          placeName: 'nature'),
      PlaceCardData(
          imageUrl:
              'https://cdnbbendpoint.azureedge.net/balancegurus/uploads/job-manager-uploads/gallery_images/2016/07/Ananda-Kriya-Yoga-Meditation-Ashram-%E2%80%A8Maharashtra10.jpg',
          placeName: 'adventure'),
      PlaceCardData(
          imageUrl:
              'https://tse2.mm.bing.net/th?id=OIP.45iaO4ojPbK7UFmnSf2iJwHaFj&pid=Api&P=0&h=180',
          placeName: 'food'),
    ];

    List<PlaceCardData> explorePlaces = [
      PlaceCardData(
          imageUrl:
              'https://images.assettype.com/freepressjournal/2020-09/289b3214-aff7-4783-b133-3e123ff04d80/Tourism.jpg?w=1200&auto=format%2Ccompress&ogImage=true',
          placeName: 'travel'),
      PlaceCardData(
          imageUrl:
              'https://www.dailypioneer.com/uploads/2021/story/images/big/maharashtra-govt-holds-agri-tourism-conference-2021-05-13.jpg',
          placeName: 'history'),
      PlaceCardData(
          imageUrl:
              'https://vignette.wikia.nocookie.net/travel/images/c/ce/Maharashtra_Highlights.jpg/revision/latest?cb=20100409143301&path-prefix=en',
          placeName: 'sports'),
    ];
    List<PlaceCardData> discoverPlaces = [
      PlaceCardData(
          imageUrl:
              'http://4.bp.blogspot.com/-JuGbCBQtdgQ/VM0G-cJlmXI/AAAAAAAAB4A/KtlA0_WnXmw/s1600/Pratapgad%2Bfort%2Bin%2Bmaharashtra.jpg',
          placeName: 'Fort'),
      PlaceCardData(
          imageUrl:
              'https://tse1.mm.bing.net/th?id=OIP.vu1AGrXiVqvGOySdIq0bKAAAAA&pid=Api&P=0&h=180',
          placeName: 'Caves'),
      PlaceCardData(
          imageUrl:
              'https://www.tripsavvy.com/thmb/YB9QxmMSuO8UXhmRKNFyokDIsOE=/3652x2430/filters:fill(auto,1)/GettyImages-520830422-591d69e93df78cf5fad8bdfd.jpg',
          placeName: 'Beaches'),
      PlaceCardData(
          imageUrl:
              'https://tse1.mm.bing.net/th?id=OIP.39dwslXSEIBba9lZg8Z1dgHaEx&pid=Api&P=0&h=180',
          placeName: 'Nature'),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: Row(
          children: [
            // Search Bar
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Pallete.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    // Update the search bar status based on input

                    setState(() {
                      isSearchBarActive = value.isNotEmpty;

                      if (isSearchBarActive) {
                        // Navigate to the SearchPage when the search bar is active
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(initialQuery: value),
                          ),
                        );
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search place...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
            ),

            // Calendar Icon
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyWidget()),
                  );
                },
                icon: Icon(
                  Icons.calendar_today,
                  color: Pallete.whiteColor,
                  size: 30,
                ),
              ),
            ),

            // Maps Icon
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cplanner()),
                  );
                },
                icon: Icon(
                  PhosphorIcons.map_pin,
                  color: Pallete.whiteColor,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: DrawerContent(),
      ),
      body: Container(
        color: Pallete.bgColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Camera Icon (New) below AppBar
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageCam()));
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30,
                      ),
                    ),
                  ),
                  CategoryCard(title: "Peace", places: peacePlaces),
                  Gap(),
                  CategoryCard(title: "Explore", places: explorePlaces),
                  Gap(),
                  CategoryCard(title: "Discover", places: discoverPlaces),
                  Gap(),
                  Gap(),
                ]),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SpecialityMh()));
                },
                backgroundColor: Pallete.primary,
                child: const Text(
                  'Festivals of Inida',
                  style: TextStyle(color: Pallete.whiteColor),
                )),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPlace()),
                  );
                  // final response = await http.post(
                  //   Uri.parse('http://127.0.0.1:5000/suggest_restaurants'),
                  //   headers: {
                  //     'Content-Type': 'application/json',
                  //   },
                  //   body: jsonEncode({
                  //     "lat": "18.5204",
                  //     "lon": "73.8567",
                  //     "cuisine": "Chinese",
                  //     "num": "3",
                  //   }),
                  // );
                  // print("This is api response $response");
                },
                backgroundColor: Pallete.primary,
                child: const Text(
                  'Add a Place',
                  style: TextStyle(color: Pallete.whiteColor),
                )),
          )
        ],
      ),
    );
  }
}
