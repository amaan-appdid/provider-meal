import 'package:flutter/material.dart';
import 'package:meals_pro/pages/home.dart';

import 'package:meals_pro/provider/category_provider.dart';
import 'package:meals_pro/provider/detail_provider.dart';
import 'package:meals_pro/provider/product_provider.dart';
import 'package:meals_pro/provider/random_provider.dart';
import 'package:meals_pro/provider/search_provider.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RandomProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
