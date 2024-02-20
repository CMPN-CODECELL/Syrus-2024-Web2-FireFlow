import 'package:client/colors/pallete.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final List<PlaceCardData> places;

  const CategoryCard({required this.title, required this.places});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Pallete.list,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 180,
            // color: Colors.amber,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: places.length,
              itemBuilder: (context, index) {
                return PlaceCard(
                  imageUrl: places[index].imageUrl,
                  placeName: places[index].placeName,
                );
              },
            ),
          ),
          // const Gap(),
        ],
      ),
    );
  }
}

class PlaceCardData {
  final String imageUrl;
  final String placeName;

  PlaceCardData({required this.imageUrl, required this.placeName});
}

class PlaceCard extends StatelessWidget {
  final String imageUrl;
  final String placeName;

  const PlaceCard({required this.imageUrl, required this.placeName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.all(8),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                imageUrl,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  placeName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
