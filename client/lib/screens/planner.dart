import 'dart:convert';
import 'package:client/api/planner_request.dart';
import 'package:client/colors/pallete.dart';
import 'package:flutter/material.dart';

class Planner extends StatefulWidget {
  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner> {
  final _formKey = GlobalKey<FormState>();
  String? _location;
  int _numPeople = 2;
  RangeValues _budgetRange = RangeValues(5000, 59000);
  String? _duration;
  bool _isKids = false;
  List<String> _itineraries = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Planner'),
        backgroundColor: Pallete.primary,
      ),
      body: Padding(
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
                items: ['Nagpur', 'Mumbai', 'Konkan', 'Alibag'].map((location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
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
                        'numPeople': _numPeople.toInt(),
                        'budgetRange':
                            '${_budgetRange.start} - ${_budgetRange.end}',
                        'duration': _duration,
                        'isKids': _isKids,
                      };

                      try {
                        // Call ChatGPT API to get itineraries
                        var response = await getTripItinerary(userInput);
                        print(
                            'ChatGPT Response: $response'); // Log the actual response

                        List<String> responseList = response.split('\n\n\n');

                        print("This is responselist $responseList");
                        int i = 0;
                        List<String> dayInfoList = [];

                        setState(() {
                          _itineraries = responseList;
                          isLoading = false;
                        });

                        // Log the response for debugging
                        dayInfoList.forEach(print);
                      } catch (error) {
                        // Handle errors when calling ChatGPT
                        print('Error calling ChatGPT: $error');
                      }
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
    );
  }
}
