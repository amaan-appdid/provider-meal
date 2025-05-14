import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meals_pro/models/detail_model.dart';
import 'package:http/http.dart' as http;

class DetailProvider extends ChangeNotifier {
  static const String apiEndpoint = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=";
  bool isLoading = false;
  String error = "";

  List<DetailModel> detailList = [];

  Future<void> getDetails({required String id}) async {
    log("Fetching data from Api..");
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse("${apiEndpoint}$id"));
      log("Response Recieved: ${response.statusCode}");

      log("Data Recieved: ${jsonDecode(response.body)}");
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body)['meals'];

        detailList = jsonData.map((e) => DetailModel.fromJson(e)).toList();
        error = "";
      } else {
        error = "Failed to Load Data: ${response.statusCode}";
      }
    } catch (e) {
      log("Error Occured: $e");
      error = "An Error Occured: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
