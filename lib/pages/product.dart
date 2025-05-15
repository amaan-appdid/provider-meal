import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_pro/pages/detail.dart';
import 'package:meals_pro/pages/search.dart';
import 'package:meals_pro/provider/product_provider.dart';
import 'package:meals_pro/provider/random_provider.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.title});
  final String title;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    Timer.run(() {
      final productApi = Provider.of<ProductProvider>(context, listen: false);
      productApi.getProduct(title: widget.title);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    final random = Provider.of<RandomProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     random.randomMeal();
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => Description(id: product.getRandomProductID()),
      //         ));
      //   },
      //   child: Container(
      //     width: 200,
      //     child: Text("Random "),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Search(),
                ),
              );
            },
            icon: Icon(
              Icons.search,
            ),
          )
        ],
      ),
      body: product.isLoading
          ? ListView.builder(
              itemCount: product.productList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 24,
                      ),
                    ),
                    title: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            )
          : product.error.isNotEmpty
              ? Center(child: Text(product.error))
              : ListView.builder(
                  itemCount: product.productList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(4, 4),
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.12),
                          )
                        ],
                      ),
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Description(
                                  id: product.productList[index].idMeal,
                                  title: product.productList[index].strMeal,
                                ),
                              ),
                            );
                          },
                          title: Text(product.productList[index].strMeal),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product.productList[index].strMealThumb),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
