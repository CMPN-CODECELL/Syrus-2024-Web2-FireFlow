import 'dart:convert';
import 'package:client/api/planner_pro_request.dart';
import 'package:client/screens/navbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:client/colors/pallete.dart';
import 'package:flutter/material.dart';

class Tile {
  final String title;
  bool isAdded;

  Tile({required this.title, required this.isAdded});
}

class TileListPage extends StatefulWidget {
  const TileListPage({Key? key, required this.prompt}) : super(key: key);
  final String prompt;
  @override
  _TileListPageState createState() => _TileListPageState();
}

class _TileListPageState extends State<TileListPage> {
  List<Tile> tiles = [];
  List<dynamic> suggestions = [];
  String? response;
  List<dynamic> _itineraries = [];
  bool isLoading = true;
  TextEditingController _controller = TextEditingController();

  Map<String, dynamic> convertJsonString(String jsonString) {
    jsonString = jsonString.replaceAll('\n', '');

    return json.decode(jsonString);
  }

  fetchRequest() async {
    try {
      var responsetemp = await getRequest(widget.prompt);
      print("This is json $responsetemp");
      setState(() {
        response = responsetemp;
        isLoading = false;
      });
      _controller = TextEditingController(text: response);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("This is the error $e");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TileListPage(prompt: widget.prompt)));
    }
  }

  @override
  void initState() {
    fetchRequest();
    fetchRestaurantSuggestions();
    super.initState();
  }

  Future<void> fetchRestaurantSuggestions() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/suggest_restaurants'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'lat': 18.5204,
          'lon': 73.8567,
          'cuisine': 'Chinese',
          'num': 3,
        }),
      );
      print("This is api response $response");

      if (response.statusCode == 200) {
        setState(() {
          suggestions = jsonDecode(response.body);
        });
      } else {
        throw Exception('Failed to load restaurant suggestions');
      }
    } catch (e) {
      print('This is the error $e');
    }
  }

  void _addTile() {
    setState(() {
      tiles.insert(0, Tile(title: "Added Tile", isAdded: true));
    });
  }

  void _subtractTile(int index) {
    setState(() {
      tiles[index].isAdded = false;
      tiles.add(tiles.removeAt(index));
    });
  }

  void saveItineraryToCollection(String userId, String itineraryText) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference itineraries =
          FirebaseFirestore.instance.collection('itineraries');

      // Add a new document with a generated ID
      await itineraries.add({
        'userId': userId,
        'itineraryText': itineraryText,
      });

      print('Itinerary saved successfully!');
    } catch (e) {
      print('Error saving itinerary: $e');
    }
  }

  void _saveItinerary() {
    // Extract text from the TextField
    String itineraryText = _controller.text;

    // Save the itinerary to the "itineraries" collection
    // Along with the current user ID
    String userId = FirebaseAuth.instance.currentUser!
        .uid; // You need to implement getCurrentUserId function
    saveItineraryToCollection(userId, itineraryText);

    // Optionally, you can show a snackbar or navigate to another screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Itinerary saved successfully')),
    );
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TabsScreen(getIndex: 3)));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Pallete.primary));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Travel Itinerary'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: _controller,
                  maxLines: null, // Allows unlimited lines
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Pallete.primary.withOpacity(0.2),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: 120,
                // Replace SizedBox with Expanded
                child: ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestions[index]['name']),
                      subtitle: Text(suggestions[index]['cuisine']),
                      // Add more information from the response as needed
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Pallete.whiteColor,
                  backgroundColor: Pallete.primary, // Text color
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  //minimumSize: Size(double.infinity, 0), // Full width
                ),
                onPressed: _saveItinerary,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    'Save This Itinerary',
                    style: TextStyle(color: Pallete.whiteColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
