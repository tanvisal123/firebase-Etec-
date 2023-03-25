import 'package:firebase_auth/firebase_auth.dart';

class EmailAuthHelper {
  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Error while signing in: ${e.toString()}");
      return null;
    }
  }

  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(credential.user != null){
        credential.user!.sendEmailVerification();
      }
      return credential.user;
    } catch (e) {
      print("Error while signing up: ${e.toString()}");
      return null;
    }
  }

  static Future signOut() async{
    return await FirebaseAuth.instance.signOut();
  }
}
