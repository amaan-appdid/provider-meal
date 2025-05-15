import 'package:flutter/material.dart';
import 'package:meals_pro/provider/random_provider.dart';
import 'package:provider/provider.dart';

class RandomScreen extends StatelessWidget {
  get index => null;

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<RandomProvider>(context);


    return Scaffold(
      appBar: AppBar(title: Text('Random Meal Generator')),
      body: Center(
        child: mealProvider.isLoading
            ? CircularProgressIndicator()
            // ignore: unnecessary_null_comparison
            : mealProvider.randomList == null
                ? Text('Press the button to get a meal')
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(mealProvider.randomList[index].imageUrl),
                      ],
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mealProvider.randomMeal();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
