import 'dart:convert';
import 'package:client/key.dart';
import 'package:http/http.dart' as http;

Future<String> getTripItinerary(userInput) async {
  try {
    final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${GPTKey.apiKey}',
        },
        // body: jsonEncode({
        //   'model': 'gpt-3.5-turbo-instruct',
        //   'prompt':
        //       'Given the following parameters:\nLocation: ${userInput['location']}\nNumber of People: ${userInput['numPeople']}\nBudget: ${userInput['budgetRange']}\nDuration: ${userInput['duration']} and is associated with kids: ${userInput['isKids']} \nPlan a detailed trip itinerary with real time data of stay, places and restaurants along with budget of each activity based on number of people.',
        //   'max_tokens': 150,
        // }),
        body: jsonEncode({
          "model": "gpt-3.5-turbo-instruct",
          "prompt": """
  Given the following parameters:
  Location: ${userInput['location']}
  Number of People: ${userInput['numPeople']}
  Budget: ${userInput['budgetRange']}
  Duration: ${userInput['duration']}
  Is associated with kids: ${userInput['isKids']}
  
  Plan a detailed trip itinerary with real-time data of stay, places, and restaurants along with the budget of each activity based on the number of people. 
  Provide the activities in the following example format:
  hey chatgpt always give the same response as mention in example not a simple change in the format will be tollerated
  For example, if I am planning a trip to Dubai for 2 days with 4 persons, the response should be:
  strictly followed this \n new line and \n\n define start the next line leaving a line blank between
  
  Day 1:\n
  Date: {date}\n
  Activity 1:\n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Desert Safari\n
  Cost/Person: 100 Rs\n\n
  
  Activity 2:\n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Skydive Dubai\n
  Cost/Person: 600 Rs\n\n
  
  Total Day Cost for day: 2800 Rs \n\n\n


  Day 2:\n
  Date: {date}\n
  Activity 1:\n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Dubai Mall\n
  Cost/Person: Free\n\n
  
  Activity 2:\n
  Start Time: {start time}\n
  End Time: {end time}\n
  Location: Burj Khalifa\n
  Cost/Person: 1200 Rs\n\n
  
  Total Day Cost: 2400 Rs\n\n\n

  Total Budget of 2 days: 5200 Rs\n

  """,
          "max_tokens": 1000
        }));

    if (response.statusCode == 200) {
      // Handle potential errors in the response data
      Map<String, dynamic> data = jsonDecode(response.body);
      // Extract and parse the generated itinerary
      // print(data);
      // print(data['choices'][0]['text'].toString());
      return data['choices'][0]['text'].toString();
    } else {
      throw Exception(
          'Failed to get response. Status Code: ${response.statusCode}, Response: ${response.body}');
    }
  } catch (error) {
    throw Exception('Failed to connect to OpenAI service: $error');
  }
}
