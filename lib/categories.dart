import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_abas_4/meal_list.dart'; // Import the MealsList class

class Categories extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<Categories> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));

    if (response.statusCode == 200) {
      setState(() {
        categories = jsonDecode(response.body)['categories'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void navigateToMeals(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealsList(categoryName: categoryName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: GridView.builder(
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          String categoryName = categories[index]['strCategory'];
          String categoryThumb = categories[index]['strCategoryThumb'];
          String description = categories[index]['strCategoryDescription'];
          // Limit description to 30 words (adjust as needed)
          if (description.length > 300) {
            description = description.substring(0, 300) + "...";
          }

          return GestureDetector(
            onTap: () => navigateToMeals(categoryName),
            child: Card(
              child: Column(
                children: [
                  Image.network(categoryThumb),
                  ListTile(
                    title: Text(categoryName),
                    subtitle: Text(description),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
