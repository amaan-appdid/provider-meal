import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meals_pro/models/search_model.dart';

class SearchProvider extends ChangeNotifier {
  static const String apiEndpoint = "https://www.themealdb.com/api/json/v1/1/search.php?s=";

  bool isloading = false;
  String error = "";

  List<Meal> searchList = [];

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) return;
    log("Fetching Data From Api...");
    isloading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse("${apiEndpoint}$query"));
      log("Data Recieved: ${response.body}");
      log("Response Recieved: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['meals'];

        searchList = jsonData.map((e) => Meal.fromJson(e)).toList();

        error = "";
      } else {
        error = "Failed To Laod Data: ${response.statusCode}";
      }
    } catch (e) {
      log("Error Occured $e");
      error = "An Error Occured: $e";
    } finally {
      isloading = false;
      notifyListeners();
    }
  }
}
