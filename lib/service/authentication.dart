import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // login
  Future login(String email, String password) async {
    try {
      User? user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
      if (user != null) return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register
  Future register(String fullName, String email, String password) async {
    try {
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if (user != null) {
        await Database(uid: user.uid).saveUser(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await Helper.saveUserLoggedInStatus(false);
      await Helper.saveUserEmail("");
      await Helper.saveUserName("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
