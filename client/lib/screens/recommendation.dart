// import 'package:flutter/material.dart';
// import 'package:parichay/model/recommendation.dart';

// class RecommendationScreen extends StatefulWidget {
//   @override
//   _RecommendationScreenState createState() => _RecommendationScreenState();
// }

// class _RecommendationScreenState extends State<RecommendationScreen> {
//   ModelDownloader _modelDownloader = ModelDownloader();
//   List<String> recommendations = [];

//   @override
//   void dispose() {
//     // Close the interpreter when the widget is disposed
//     _modelDownloader.closeInterpreter();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Recommendation App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 _runModel();
//               },
//               child: Text('Run Recommendation Model'),
//             ),
//             SizedBox(height: 20),
//             if (recommendations.isNotEmpty)
//               Text('Recommendations: $recommendations'),
//           ],
//         ),
//       ),
//     );
//   }

//   void _runModel() async {
//     try {
//       await _modelDownloader.downloadModel();

//       // Example input data, replace with actual input values
//       List<String> inputData = ['Flora Fountain', 'Antilia'];

//       // Print the input data for inspection
//       print("Input Data: $inputData");

// //---------------------
//       // Convert the input data to float32
//       List<double> convertedInputData =
//           inputData.map((e) => double.parse(e)).toList();

//       // Print the converted input data for inspection
//       print("Converted Input Data: $convertedInputData");
//       //-------------------------------------
//       // // Convert the input strings to float32 values
//       // List<List<double>> convertedInputData = inputData.map((e) {
//       //   // Split the string by space or any other delimiter and parse as double
//       //   return e.split(' ').map((s) => double.parse(s)).toList();
//       // }).toList();

//       // // Print the converted input data for inspection
//       // print("Converted Input Data: $convertedInputData");

//       // Run inference with the input data:

//       final output =
//           await _modelDownloader.runModelInference(convertedInputData);

//       // Print the raw output for inspection
//       print("Raw Output: $output");

//       // Convert the double values in the output list to strings
//       List<String> stringOutput =
//           output.map((value) => value.toString()).toList();

//       print("recommendations: $stringOutput");

//       // Update the UI with the recommendations:
//       setState(() {
//         recommendations = stringOutput;
//       });
//     } catch (error) {
//       print("Error running model: $error");
//     }
//   }
// }

import 'dart:convert';
import 'package:client/colors/pallete.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  TextEditingController locationController = TextEditingController();
  List<String> recommendations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Enter Location',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                getRecommendations();
              },
              child: Text('Get Recommendations'),
            ),
            SizedBox(height: 16),
            Text('Recommendations:'),
            Expanded(
              child: ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Invoke getRecommendations with the tapped location
                      locationController.text = recommendations[index];
                      getRecommendations();
                    },
                    child: Card(
                      child: ListTile(
                        tileColor: Pallete.primary,
                        title: Text(recommendations[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getRecommendations() async {
    final String url = 'http://10.0.2.2:5000/get_recommendations';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> data = {'location': locationController.text};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          recommendations =
              List<String>.from(jsonDecode(response.body)['recommendations']);
        });
        print('Recommendations: $recommendations');
      } else {
        print(
            'Failed to fetch recommendations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Encountered: $e");
    }
  }
}
// Sandhan Valley