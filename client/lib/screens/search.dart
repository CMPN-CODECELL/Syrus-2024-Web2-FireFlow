import 'package:client/colors/pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Search extends StatefulWidget {
  final String initialQuery;
  const Search({Key? key, required this.initialQuery}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool isSearchBarActive = false;

  bool _loading = false;

  late TextEditingController _searchController;
  // late Stream<QuerySnapshot> _locationsStream;
  Stream<List<String>>? _locationsStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    isSearchBarActive = widget.initialQuery.isNotEmpty;
    _locationsStream = getLocationSuggestions('');
  }

  Stream<List<String>> getLocationSuggestions(String query) async* {
    try {
      // Convert the query to uppercase for case-insensitive comparison
      final upperQuery = query.toUpperCase();

      // Fetch all documents
      final querySnapshot =
          await FirebaseFirestore.instance.collection('location').get();

      // Extract 'Location' and 'City' suggestions
      final suggestions = querySnapshot.docs
          .where((doc) =>
              (doc['name'] as String).toUpperCase().contains(upperQuery) ||
              (doc['city'] as String).toUpperCase().contains(upperQuery))
          .map((doc) => (doc['name'] as String))
          .toList();

      // Remove duplicates by converting to a set and back to a list
      final uniqueSuggestions = suggestions.toSet().toList();

      // Yield the suggestions
      yield uniqueSuggestions;
    } catch (error) {
      // Handle errors, log, or throw an exception if needed
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final searchQueryProvider = Provider.of<SearchQueryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Search',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(width: 5),
                      Icon(
                        PhosphorIcons.magnifying_glass,
                        color: Pallete.whiteColor, // Replace with your color
                      ),
                    ],
                  ),
                  Text("Search your destination...",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: isSearchBarActive ? Pallete.whiteColor : Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              isSearchBarActive = value.isNotEmpty;
                              _locationsStream = getLocationSuggestions(value);
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search your destination...',
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  StreamBuilder(
                    stream: _locationsStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      List<String> suggestions =
                          snapshot.data as List<String>? ?? [];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: suggestions.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(suggestions[index]),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Skeletonizer(
                  //   enabled: _loading && isSearchBarActive,
                  //   child: ListView.builder(
                  //     itemCount: 8,
                  //     shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemBuilder: (context, index) {
                  //       return Card(
                  //         child: ListTile(
                  //           title: Text('placeName'),
                  //           subtitle: Text('distance'),
                  //           leading: CircleAvatar(
                  //             radius: 24,
                  //             // backgroundImage: NetworkImage(),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Stream<List<String>> getLocationSuggestions(String query) {
//   return FirebaseFirestore.instance
//       .collection('locations')
//       .where('name', isGreaterThanOrEqualTo: query)
//       .where('name',
//           isLessThan:
//               query + 'z') // Assuming 'name' is the field in your collection
//       .snapshots()
//       .map((querySnapshot) {
//     return querySnapshot.docs.map((doc) => doc['name'] as String).toList();
//   });
// }
