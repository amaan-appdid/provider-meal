import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_pro/provider/detail_provider.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(
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
                      children: [
                        Image.network(
                          detail.detailList[index].strMealThumb,
                        ),
                        Text(
                          detail.detailList[index].strMeal,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    );
                  },
                ),
    );
  }
}
