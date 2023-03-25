import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter2g7/firebase_module/helpers/email_auth_helper.dart';
import 'package:firebase2_project/helpers/email_auth_helper.dart';
//import 'package:flutter2g7/firebase_module/pages/product_page.dart';
import 'package:firebase2_project/pages/product_page.dart';
//import 'package:flutter2g7/firebase_module/pages/signup_page.dart';
import 'package:firebase2_project/pages/signup_page.dart';
//import 'package:flutter2g7/localhost_module/utils/snackbar_util.dart';
import 'package:firebase2_project/utils/snackbar_util.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
              _buildGotoSignupPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Sign In",
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
          User? user = await EmailAuthHelper.signIn(
              _emailCtrl.text.trim(), _passCtrl.text.trim());
          if (user != null) {

            if(user.emailVerified){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductPage(),
                ),
              );
            }
            else{
              showDialog(context: context, builder: (context){
                return _buildAlertDialog();
              });
            }
          } else {
            showSnackBar(context, "Login failed");
          }
        } else {
          showSnackBar(context, "All fields are required");
        }
      },
      child: Text("Login"),
    );
  }

  _buildAlertDialog() {
    return AlertDialog(
      title: Text("Unverified Email"),
      content: Text(
          "This Email is not yet verified. \nPlease go to your Email and click on a verification link."),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("DONE"),
        ),
      ],
    );
  }

  Widget _buildGotoSignupPage() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpPage(),
          ),
        );
      },
      child: Text("No account yet? Sign up"),
    );
  }
}
