import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meals_pro/pages/product.dart';
import 'package:meals_pro/provider/category_provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      final homeApi = Provider.of<CategoryProvider>(context, listen: false);
      homeApi.getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: category.isLoading
          ? Center(child: CircularProgressIndicator())
          : category.error.isNotEmpty
              ? Center(child: Text(category.error))
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: category.categoryList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        log(category.categoryList[index].strCategory.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Product(title: category.categoryList[index].strCategory!),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              category.categoryList[index].strCategoryThumb.toString(),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                category.categoryList[index].strCategory.toString(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                category.categoryList[index].strCategoryDescription.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
