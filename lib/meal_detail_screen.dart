import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MealDetailsScreen extends StatefulWidget {
  final String mealId;

  MealDetailsScreen({required this.mealId});

  @override
  _MealDetailsScreenState createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Map<String, dynamic> mealDetails = {};

  @override
  void initState() {
    super.initState();
    fetchMealDetails(widget.mealId);
  }

  Future<void> fetchMealDetails(String mealId) async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId'));

    if (response.statusCode == 200) {
      setState(() {
        mealDetails = jsonDecode(response.body)['meals'][0];
      });
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (mealDetails.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Display loading indicator while fetching data
    }

    String mealName = mealDetails['strMeal'];
    String mealThumb = mealDetails['strMealThumb'];
    String mealInstructions = mealDetails['strInstructions'];
    String mealCategory = mealDetails['strCategory'];
    String mealArea = mealDetails['strArea'];
    String mealYoutube = mealDetails['strYoutube']; // Assuming 'strYoutube' exists for the meal

    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
      ),
      body: SingleChildScrollView( // Allow scrolling for potentially long content
        child: Column(
          children: [
            // Fixed-height image row
            SizedBox(
              height: 400.0, // Adjust height as needed
              child: Image.network(
                mealThumb,
                fit: BoxFit.cover, // Cover the available space
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
                children: [
                  Row( // Create a Row for Category, Area, and Button
                    children: [
                      Text(
                        'Category:',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0), // Spacing between labels
                      Text(mealCategory, style: TextStyle(fontSize: 16.0)),
                      Spacer(), // Expand to fill remaining space
                      if (mealYoutube.isNotEmpty)
                        ElevatedButton( // Use ElevatedButton for a raised button with background color
                          onPressed: () => launchUrl(Uri.parse(mealYoutube)),
                          child: Row( // Row for text and icon
                            mainAxisAlignment: MainAxisAlignment.center, // Center contents
                            children: [
                              Text(
                                'View on YouTube',
                                style: TextStyle(fontSize: 16.0, color: Colors.white), // White text for contrast
                              ),
                              SizedBox(width: 8.0), // Spacing between text and icon
                              Icon(Icons.play_circle, color: Colors.white), // YouTube icon
                            ],
                          ),
                          style: ElevatedButton.styleFrom( // Customize button style
                            backgroundColor: Colors.teal, // Set background color to red
                            shape: RoundedRectangleBorder( // Rounded corners
                              borderRadius: BorderRadius.circular(20.0), // Radius of corners
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 8.0), // Spacing after the Row
                  Text(
                    'Area:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Text(mealArea, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 16.0),
                  Text(
                    'Instructions:',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      mealInstructions,
                      style: TextStyle(fontSize: 16.0),
                      textAlign: TextAlign.justify, // Change the text alignment to justify
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}