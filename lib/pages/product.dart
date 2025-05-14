import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meals_pro/pages/detail.dart';
import 'package:meals_pro/provider/product_provider.dart';

import 'package:provider/provider.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: product.isLoading
          ? Center(child: CircularProgressIndicator())
          : product.error.isNotEmpty
              ? Center(child: Text(product.error))
              : ListView.builder(
                  itemCount: product.productList.length,
                  itemBuilder: (context, index) {
                    return Card(
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
                    );
                  },
                ),
    );
  }
}
