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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : detail.error.isNotEmpty
              ? Center(
                  child: Text(detail.error),
                )
              : ListView.builder(
                  itemCount: detail.detailList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreen(
                                  imgUrl: detail.detailList[index].strMealThumb,
                                  text: detail.detailList[index].strMeal,
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            detail.detailList[index].strMealThumb,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            detail.detailList[index].strMeal,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            detail.detailList[index].strInstructions,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
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
