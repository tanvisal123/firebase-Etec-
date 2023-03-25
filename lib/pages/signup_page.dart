import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/helpers/email_auth_helper.dart';
import 'package:firebase2_project/helpers/email_auth_helper.dart';
//import 'package:flutter2g7/firebase_module/pages/product_page.dart';
import 'package:firebase2_project/pages/product_page.dart';
//import 'package:flutter2g7/firebase_module/pages/signin_page.dart';
import 'package:firebase2_project/pages/signin_page.dart';
//import 'package:flutter2g7/localhost_module/utils/snackbar_util.dart';
import 'package:firebase2_project/utils/snackbar_util.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitle(),
              _buildEmailTextField(),
              _buildPasswordTextField(),
              _buildSignInButton(),
              _buildGotoSigninPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Sign Up",
      style: TextStyle(fontSize: 25),
    );
  }

  var _emailCtrl = TextEditingController();

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter email';
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.email),
        hintText: "Enter email",
      ),
    );
  }

  var _passCtrl = TextEditingController();

  bool _hidePassword = true;

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _passCtrl,
      autocorrect: false,
      obscureText: _hidePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter password';
        }
        return null;
      },
      decoration: InputDecoration(
        icon: Icon(Icons.vpn_key),
        hintText: "Enter password",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _hidePassword = !_hidePassword;
            });
          },
          icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          User? user = await EmailAuthHelper.signUp(
              _emailCtrl.text.trim(), _passCtrl.text.trim());
          if (user != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SignInPage(),
              ),
            );
          }else{
            showSnackBar(context, "Sign up failed");
          }
        } else {
          showSnackBar(context, "All fields are required");
        }
      },
      child: Text("Sign up"),
    );
  }

  Widget _buildGotoSigninPage() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      },
      child: Text("Already have an account? Sign in instead"),
    );
  }
}
