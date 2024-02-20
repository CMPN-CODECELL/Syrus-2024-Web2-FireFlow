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
  String? response;
  List<String> _itineraries = [];
  bool isLoading = true;

  fetchRequest() async {
    try {
      var responsetemp = await getRequest(widget.prompt);
      setState(() {
        response = responsetemp;
      });
      print("This is responselist $response");
      List<String> responseList = response!.split('\n\n');

      int i = 0;
      List<String> dayInfoList = [];

      setState(() {
        _itineraries = responseList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("This is the error $e");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => TabsScreen(getIndex: 3)));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Tile List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Pallete.primary))
          : ListView.builder(
              itemCount: _itineraries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  selectedColor: Pallete.bgColor,
                  iconColor: Pallete.textprimary,
                  title: Text(_itineraries[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () => _subtractTile(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTile,
        tooltip: 'Add Tile',
        child: Icon(Icons.add),
      ),
    );
  }
}
