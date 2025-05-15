import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_pro/pages/full_screen.dart';
import 'package:meals_pro/provider/detail_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Description extends StatefulWidget {
  Description({super.key, required this.id, this.title});
  final String id;
  String? title;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    Timer.run(() {
      final detailApi = Provider.of<DetailProvider>(context, listen: false);
      detailApi.getDetails(id: widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<DetailProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.title ?? "Description Page",
        ),
      ),
      body: detail.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : detail.error.isNotEmpty
              ? Center(
                  child: Text(detail.error),
                )
              : ListView.builder(
                  itemCount: detail.detailList.length,
                  itemBuilder: (context, index) {
                    final item = detail.detailList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreen(
                                  imgUrl: item.strMealThumb,
                                  text: item.strMeal,
                                ),
                              ),
                            );
                          },
                          child: Image.network(item.strMealThumb),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.strMeal,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.strInstructions,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Ingredients",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey),
                            columnWidths: {
                              // 0: FlexColumnWidth(2),
                              // 1: FlexColumnWidth(1),
                              0: FlexColumnWidth(1.5),
                              1: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: Colors.grey.shade300),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Ingredient", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Measure", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...item.ingredients.map(
                                (entry) {
                                  final ingredient = entry.keys.first;
                                  final measure = entry.values.first;
                                  return TableRow(
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
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
