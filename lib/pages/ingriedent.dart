import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: MealTableView(),
    debugShowCheckedModeBanner: false,
  ));
}

class MealTableView extends StatefulWidget {
  @override
  _MealTableViewState createState() => _MealTableViewState();
}

class _MealTableViewState extends State<MealTableView> {
  Map<String, dynamic>? meal;

  @override
  void initState() {
    super.initState();
    fetchMeal();
  }

  Future<void> fetchMeal() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=52960'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        meal = data['meals'][0];
      });
    } else {
      throw Exception('Failed to load meal');
    }
  }

  List<TableRow> buildIngredientRows() {
    List<TableRow> rows = [
      TableRow(
        decoration: BoxDecoration(color: Colors.grey[300]),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ingredient', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Measure', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal?['strIngredient$i'];
      final measure = meal?['strMeasure$i'];

      if (ingredient != null && ingredient.toString().isNotEmpty && measure != null && measure.toString().isNotEmpty) {
        rows.add(
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(ingredient),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(measure),
              ),
            ],
          ),
        );
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Meal')),
      body: meal == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal!['strMeal'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text('Ingredients & Measures', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(),
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                    },
                    children: buildIngredientRows(),
                  ),
                ],
              ),
            ),
    );
  }
}
