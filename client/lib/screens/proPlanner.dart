import 'dart:convert';
import 'package:client/api/planner_pro_request.dart';
import 'package:client/api/planner_request.dart';
import 'package:client/colors/pallete.dart';
import 'package:client/key.dart';
import 'package:client/screens/proPlanner_output.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
//class ProPlanner extends StatefulWidget {
//   const ProPlanner({Key? key}) : super(key: key);

//   @override
//   _ProPlannerState createState() => _ProPlannerState();
// }

// class _ProPlannerState extends State<ProPlanner> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// Future<void> _getRequest(String prompt) async {
//   var _response;
//   final String apiUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${GPTKey.GapiKey}';
//   final Map<String, String> headers = {'Content-Type': 'application/'};

//   try {
//     var query = {
//       "contents": [
//         {
//           "parts": [
//             {"text": prompt}
//           ]
//         }
//       ]
//     };

//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: jsonEncode(query),
//     );

//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body);

//       _response = result['candidates'][0]['content']['parts'][0]['text'];
//     } else {
//       _response = 'Error occurred $response';
//     }
//   } catch (e) {
//     _response = 'Error occurred $e';
//   }
// }

class TripPlannerPro extends StatefulWidget {
  @override
  _TripPlannerProState createState() => _TripPlannerProState();
}

class _TripPlannerProState extends State<TripPlannerPro> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String _location = 'Nagpur';
  int _numPeople = 1;
  String _startDate = '20 February 2024';
  String _endDate = '25 February 2024';

  RangeValues _budgetRange = const RangeValues(5000, 10000);
  String _duration = '1 day';
  bool _isKids = false;

  // Additional Fields
  String _destination = 'Mumbai';
  int _hotelRating = 1;
  String _foodType = 'Veg';
  String _transportMode = 'Bus';
  double _totalBudget = 10000;

  List<String> _itineraries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Planner'),
        backgroundColor: Pallete.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DropdownButtonFormField<String>(
                  value: _location,
                  decoration: InputDecoration(
                    labelText: 'Location',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                  items:
                      ['Nagpur', 'Mumbai', 'Konkan', 'Alibag'].map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: _destination,
                  decoration: InputDecoration(
                    labelText: 'Destination',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _destination = value!;
                    });
                  },
                  items: ['Agra', 'Mumbai', 'Pune'].map((destination) {
                    return DropdownMenuItem<String>(
                      value: destination,
                      child: Text(destination),
                    );
                  }).toList(),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Number of People',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      _numPeople = int.parse(value!);
                    });
                  },
                ),
                TextFormField(
                  // keyboardType: TextInputType.num,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                  ),

                  onSaved: (value) {
                    setState(() {
                      _startDate = value!;
                    });
                  },
                ),
                TextFormField(
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                  ),

                  onSaved: (value) {
                    setState(() {
                      _endDate = value!;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Text("Budget(Rs.5,000 to 59,000)"),
                RangeSlider(
                  activeColor: Pallete.primary,
                  values: _budgetRange,
                  min: 5000,
                  max: 59000,
                  divisions: 54,
                  labels: RangeLabels(
                    'Min Budget: ${_budgetRange.start.round()}',
                    'Max Budget: ${_budgetRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _budgetRange = values;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _duration,
                  decoration: InputDecoration(
                    labelText: 'Duration',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _duration = value!;
                    });
                  },
                  items: [
                    '1 day',
                    '2 days',
                    '3 days',
                    '1 week',
                    '2 weeks',
                    '3 weeks',
                    '1 month'
                  ].map((duration) {
                    return DropdownMenuItem<String>(
                      value: duration,
                      child: Text(duration),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<int>(
                  value: _hotelRating,
                  decoration: InputDecoration(
                    labelText: 'Hotel Rating',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _hotelRating = value!;
                    });
                  },
                  items: [1, 2, 3, 4, 5].map((rating) {
                    return DropdownMenuItem<int>(
                      value: rating,
                      child: Text('$rating star'),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: _foodType,
                  decoration: InputDecoration(
                    labelText: 'Food Type',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _foodType = value!;
                    });
                  },
                  items: ['Veg', 'Veg-Not-Veg'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                ),
                DropdownButtonFormField<String>(
                  value: _transportMode,
                  decoration: InputDecoration(
                    labelText: 'Transport Mode',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _transportMode = value!;
                    });
                  },
                  items: ['Bus', 'Train', 'Flight'].map((mode) {
                    return DropdownMenuItem<String>(
                      value: mode,
                      child: Text(mode),
                    );
                  }).toList(),
                ),

                CheckboxListTile(
                  title: Text('Is kids associated?'),
                  value: _isKids,
                  onChanged: (value) {
                    setState(() {
                      _isKids = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {
                          isLoading = true;
                        });

                        // Prepare user input for ChatGPT
                        Map<String, dynamic> userInput = {
                          'location': _location,
                          'destination': _destination,
                          'numPeople': _numPeople.toInt(),
                          'budgetRange':
                              '${_budgetRange.start} - ${_budgetRange.end}',
                          'duration': _duration,
                          'isKids': _isKids,
                          'hotelRating': _hotelRating,
                          'foodType': _foodType,
                          'transportMode': _transportMode,
                        };
                        String prompt = """Given the following parameters: User
plane a detail trip to : $_destination from $_location for duration :$_duration days  ,number of people :${_numPeople.toInt()},mode of transport :$_transportMode, minimum budget ${_budgetRange.start},maximum budget${_budgetRange.end} ,food type $_foodType , Is associated with kids: $_isKids
generate a complete trip day wise in which each day has number of activities
The response shoulde be in a correct and perfect define  format with out any extra new line and spaces 
the format of the response should be in  only 
same as below example

  Give the response in the below pattern only \n refers to next line  \n\n refers to skip the next line

flights info 
 Form:ngp  airport \n
  to:Dubai airport \n
return flights\n
 From:dubai airport \n
 to: nagpur airport \n\n

flight to cost: 10000    \n
booking links: {}   \n\n

Stay Hotels Option \n\n

  Option 1:\n
    Hotel name: MaxCity Hotel  \n
    Price:5000/day    \n
    Booking Link:{} \n\n

  Option 2:\n
    Hotel name:Burj Arab\n
    Price: 100000/day   \n
 



   Booking Link:{} \n\n

Trip Itineraries day wise:\n\n
 
Day 1:\n\n

Date:23/2/24    \n
Total cost for Day: 20000   \n
Food:\n
  details for whole day : \n
  Cost: 2000 rs   \n\n

  
  Day 1:\n
  Date: {date}\n
 Activity 1:\n 
Description best desert of dubai    \n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Desert Safari\n
   Latitute :20.12\n
  longitude:80.23\n
  Cost/Person: 100 Rs\n\n
  
  Activity 2:\n
  Description best desert of dubai    \n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Skydive Dubai\n
    Latitute :20.12\n
  longitude:80.23\n
  Cost/Person: 600 Rs\n\n
  
  Total Day Cost for day1: 2800 Rs \n\n\n


  Day 2:\n
  Date: {date}\n
  Activity 1:\n
 Description best desert of dubai    \n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Dubai Mall\n
   Latitute :20.12\n
  longitude:80.23\n
  Cost/Person: Free\n\n
  
  Activity 2:\n
 Description best desert of dubai    \n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Burj Khalifa\n
   Latitute :20.12\n
  longitude:80.23\n
  Cost/Person: 1200 Rs\n\n
  
  Total Day 2Cost: 2400 Rs\n\n\n

  Total Budget of 2 days: 5200 Rs\n

    """;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TileListPage(
                                      prompt: prompt,
                                      userInput: userInput,
                                    )));
                        // try {
                        //   // Call ChatGPT API to get itineraries
                        //   var response = await getRequest(prompt);
                        //   print(
                        //       'ChatGPT Response: $response'); // Log the actual response

                        //   List<String> responseList = response.split('\n\n\n');

                        //   print("This is responselist $responseList");
                        //   int i = 0;
                        //   List<String> dayInfoList = [];

                        //   setState(() {
                        //     _itineraries = responseList;
                        //     isLoading = false;
                        //   });

                        //   // Log the response for debugging
                        //   dayInfoList.forEach(print);
                        // } catch (error) {
                        //   // Handle errors when calling ChatGPT
                        //   print('Error calling ChatGPT: $error');
                        // }
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator(color: Pallete.whiteColor)
                        : Text('Generate'),
                  ),
                ),

                // Display generated itineraries in cards
                if (_itineraries.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _itineraries.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _itineraries[index],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
