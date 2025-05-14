import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals_pro/models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  static const String apiEndpoint = "https://www.themealdb.com/api/json/v1/1/categories.php";
  bool isLoading = false;
  String error = "";

  List<CategoryModel> categoryList = [];

  Future<void> getCategories() async {
    log("Fetching data from API...");
    isLoading = true;

    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiEndpoint));
      log("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['categories'];

        categoryList = jsonData.map((e) => CategoryModel.fromJson(e)).toList();
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
