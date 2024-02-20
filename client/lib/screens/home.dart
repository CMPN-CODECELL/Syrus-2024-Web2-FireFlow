import 'package:client/colors/pallete.dart';
import 'package:client/common/gap.dart';
import 'package:client/common/places.dart';
import 'package:client/screens/drawer.dart';
import 'package:client/screens/place_info.dart';
import 'package:client/screens/search.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:client/screens/speciality.dart';
import 'package:flutter/material.dart';

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
          placeName: 'Religious'),
      PlaceCardData(
          imageUrl:
              'https://cdnbbendpoint.azureedge.net/balancegurus/uploads/job-manager-uploads/gallery_images/2016/07/Ananda-Kriya-Yoga-Meditation-Ashram-%E2%80%A8Maharashtra10.jpg',
          placeName: 'Yoga Centre'),
      PlaceCardData(
          imageUrl:
              'https://tse2.mm.bing.net/th?id=OIP.45iaO4ojPbK7UFmnSf2iJwHaFj&pid=Api&P=0&h=180',
          placeName: 'Gurudwara'),
    ];

    List<PlaceCardData> explorePlaces = [
      PlaceCardData(
          imageUrl:
              'https://images.assettype.com/freepressjournal/2020-09/289b3214-aff7-4783-b133-3e123ff04d80/Tourism.jpg?w=1200&auto=format%2Ccompress&ogImage=true',
          placeName: 'Agro Tourism'),
      PlaceCardData(
          imageUrl:
              'https://www.dailypioneer.com/uploads/2021/story/images/big/maharashtra-govt-holds-agri-tourism-conference-2021-05-13.jpg',
          placeName: 'Rural Tourism'),
      PlaceCardData(
          imageUrl:
              'https://vignette.wikia.nocookie.net/travel/images/c/ce/Maharashtra_Highlights.jpg/revision/latest?cb=20100409143301&path-prefix=en',
          placeName: 'Cultural Tourism'),
      PlaceCardData(
          imageUrl:
              'https://www.outlookindia.com/traveller/wp-content/uploads/2017/03/ART-AND-CRAFTS1_FI.jpg',
          placeName: 'Arts & Crafts'),
      PlaceCardData(
          imageUrl:
              'https://images.thrillophilia.com/image/upload/s--5m8BEEt---/c_fill,f_auto,fl_strip_profile,g_auto,h_600,q_auto,w_975/v1/images/photos/000/148/677/original/1552909095_shutterstock_1149090467.jpg.jpg?1552909095',
          placeName: 'Eco-Tourism'),
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
                onPressed: () {},
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
                onPressed: () {},
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
        // color: Pallete.bgColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Gap(),
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
      floatingActionButton: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: FloatingActionButton(
            onPressed: () {
              // Navigator.push(context,
              // MaterialPageRoute(builder: (context) => Speciality()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlaceInfo(
                            locationName: "  George Everest's House ",
                          )));
            },
            backgroundColor: Pallete.primary,
            child: const Text(
              'Speciality of India',
              style: TextStyle(color: Pallete.whiteColor),
            )),
      ),
    );
  }
}
