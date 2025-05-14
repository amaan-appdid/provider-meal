import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/random_model.dart';
import 'package:http/http.dart' as http;

class RandomProvider extends ChangeNotifier {
  static const String apiEndpoint = "https://www.themealdb.com/api/json/v1/1/random.php";

  bool isLoading = false;

  String error = "";

  List<RandomModel> randomList = [];

  Future<void> randomMeal() async {
    log("Fetching Data From Api");
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(apiEndpoint),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        randomList = jsonData.map((e) => RandomModel.fromJson(e)).toList();
        error = "";
      } else {
        error = "Failed to Load data: ${response.body}";
      }
    } catch (e) {
      log("Error Occured $e");
      error = "An Error Occured: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
