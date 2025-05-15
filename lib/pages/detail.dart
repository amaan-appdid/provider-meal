import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:meals_pro/pages/full_screen.dart';
import 'package:meals_pro/provider/detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget {
  Description({super.key, required this.id, this.title});
  final String id;
  final String? title;

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      final detailApi = Provider.of<DetailProvider>(context, listen: false);
      detailApi.getDetails(id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detail = Provider.of<DetailProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(widget.title ?? "Description Page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              if (detail.detailList.isNotEmpty) {
                final item = detail.detailList.first;
                final shareText = '''
                Check out this meal!

                ${item.strMeal}
                ${item.strInstructions}
                ${item.strMealThumb}
                ''';
                Share.share(shareText);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No meal details to share.')),
                );
              }
            },
          ),
        ],
      ),
      body: detail.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detail.error.isNotEmpty
              ? Center(child: Text(detail.error))
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
                          child: Image.network(
                            item.strMealThumb,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item.strMeal,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
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
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Table(
                            border: TableBorder.all(color: Colors.grey),
                            columnWidths: const {
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
                              ...item.ingredients.map((entry) {
                                final ingredients = entry.keys.first;
                                final measures = entry.values.first;
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(ingredients),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(measures),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                        if (item.strYoutube.trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                label: Text("Watch On Youtube"),
                                icon: Icon(Icons.video_library_outlined),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () async {
                                  final urlString = item.strYoutube.trim();
                                  final Uri url = Uri.parse(urlString);
                                  try {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Failed to open Youtube Link: $e"),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
    );
  }
}
