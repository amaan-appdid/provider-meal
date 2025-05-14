import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:meals_pro/models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  static const String apiEndpoint = "https://www.themealdb.com/api/json/v1/1/filter.php?c=";
  bool isLoading = false;
  String error = "";

  List<ProductModel> productList = [];

  Future<void> getProduct({required String title}) async {
    log("Fetching data from API...");
    isLoading = true;

    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${apiEndpoint}$title"));
      // log("Response received: ${response.body}");
      log("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['meals'];

        productList = jsonData.map((e) => ProductModel.fromJson(e)).toList();
        error = "";
      } else {
        error = "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      log("Error occurred: $e");
      error = "An error occurred: $e";
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
