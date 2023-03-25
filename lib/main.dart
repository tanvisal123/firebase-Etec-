import 'package:firebase2_project/pages/product_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase2_project/logics/category_logic.dart';
import 'package:firebase2_project/pages/product_splash_page.dart';
import 'package:firebase2_project/logics/product_logic.dart';
import 'package:firebase2_project/pages/product_page.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return _buildMaterial(
            Scaffold(body: Center(child: Text("Error Firebase"))),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => CategoryLogic()),
              ChangeNotifierProvider(create: (context) => ProductLogic()),

            ],
            child: _buildMaterial(
              ProductSplashPage(),
              //SplashPage(),
            ),
          );
        } else {
          return _buildMaterial(Center(
            child: Scaffold(body: CircularProgressIndicator()),
          ));
        }
      },
    );
  }

  _buildMaterial(Widget home) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: home);
  }
}