import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/pages/signin_page.dart';
import 'package:firebase2_project/pages/signin_page.dart';
//import 'package:flutter2g7/firebase_module/pages/signup_page.dart';
import 'package:firebase2_project/pages/signup_page.dart';
class UnverifiedEmailPage extends StatelessWidget {
  const UnverifiedEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "This Email is not yet verified. \nPlease go to your Email and click on a verification link.",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              },
              child: Text("Go to Sign In Page"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
              },
              child: Text("Or Go to Sign Up Page"),
            ),
          ],
        ),
      ),
    );
  }
}
