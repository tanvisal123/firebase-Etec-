import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/logics/category_logic.dart';
import 'package:firebase2_project/logics/category_logic.dart';
//import 'package:flutter2g7/firebase_module/logics/product_logic.dart';
import 'package:firebase2_project/logics/product_logic.dart';
//import 'package:flutter2g7/firebase_module/models/product_model.dart';
import 'package:firebase2_project/models/product_model.dart';
//import 'package:flutter2g7/firebase_module/pages/product_page.dart';
import 'package:firebase2_project/pages/product_page.dart';
//import 'package:flutter2g7/firebase_module/pages/signin_page.dart';
import 'package:firebase2_project/pages/signin_page.dart';
//import 'package:flutter2g7/firebase_module/pages/unverified_email_page.dart';
import 'package:firebase2_project/pages/unverified_email_page.dart';
import 'package:provider/provider.dart';

class ProductSplashPage extends StatefulWidget {
  const ProductSplashPage({Key? key}) : super(key: key);

  @override
  State<ProductSplashPage> createState() => _ProductSplashPageState();
}

class _ProductSplashPageState extends State<ProductSplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () async {
      await context.read<CategoryLogic>().readData();
      await context.read<ProductLogic>().readData();

      FirebaseAuth.instance.authStateChanges().listen((usr) async{
        if(usr == null){
          if(mounted){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          }
        }
        else{
          if(usr.emailVerified){
            if(mounted){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ),
              );
            }
          }
          else{
            if(mounted){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => UnverifiedEmailPage(),
                ),
              );
            }
          }
        }
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Icon(Icons.wallet_giftcard, size: 100)),
    );
  }
}
