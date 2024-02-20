import 'dart:convert';

import 'package:client/api/planner_pro_request.dart';
import 'package:client/colors/pallete.dart';
import 'package:client/screens/navbar.dart';
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
  Map<String, dynamic>? response;
  List<dynamic> _itineraries = [];
  bool isLoading = true;
  Map<String, dynamic> convertJsonString(String jsonString) {
    // Remove line breaks from the JSON string
    jsonString = jsonString.replaceAll('\n', '');

    // Parse the JSON string into a JSON object
    return json.decode(jsonString);
  }

  fetchRequest() async {
    try {
      var responsetemp = await getRequest(widget.prompt);
      var res = convertJsonString(responsetemp);
      print("This is json ${res.runtimeType} $res");
      setState(() {
        response = res;
      });
      // print("This is responselist $response");
      // List<String> responseList = response!.split('\n\n');

      // int i = 0;
      // List<String> dayInfoList = [];
      List<dynamic> itinerary = res['itinerary'];
      setState(() {
        _itineraries = itinerary;
        isLoading = false;
      });
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
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Tile List'),
    //     ),
    //     body: isLoading
    //         ? Center(child: CircularProgressIndicator(color: Pallete.primary))
    //         : ListView.builder(
    //             itemCount: _itineraries.length,
    //             itemBuilder: (context, index) {
    //               return ListTile(
    //                 selectedColor: Pallete.bgColor,
    //                 iconColor: Pallete.textprimary,
    //                 title: Text(_itineraries[index]),
    //                 trailing: IconButton(
    //                   icon: Icon(Icons.remove),
    //                   onPressed: () => _subtractTile(index),
    //                 ),
    //               );
    //             },
    //           ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: _addTile,
    //       tooltip: 'Add Tile',
    //       child: Icon(Icons.add),
    //     ),
    //   );
    // }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Travel Itinerary'),
        ),
        body: ListView.builder(
          itemCount: _itineraries.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> day = response![index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Hotels & Transport'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var hotel in response!['hotels'])
                              Text('${hotel['name']} per night'),
                            // Text(
                            // 'Flight: ${response!['transport']['mode']} to - \$${response!['transport']['cost_per_person']} per person'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ...day['activities'].map<Widget>((activity) {
                  return Card(
                    child: ListTile(
                      title: Text(activity['description']),
                      // subtitle: Text(
                      //     'Cost per Person: \$${activity['cost_per_person']}'),
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}
