import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/screen/home_screen.dart';
import 'package:flutter_chat_app/screen/register_screen.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/shared/regular_expression.dart';
import 'package:flutter_chat_app/common/form_input.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";
  final formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: ScrollConfiguration(
            behavior: RemoveGlowingBehavior(),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Tiến's Chat app",
                        style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Login now to message each other',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 25),
                      Image.asset(
                        "./assets/images/login_background.png",
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        onChanged: (value) => {setState(() => email = value)},
                        validator: (value) {
                          if (emailValidator(value!) == false) {
                            return "Email format is incorrect";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInutDecoration.copyWith(
                          labelText: "Email",
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password need to have at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => {setState(() => password = value)},
                        decoration: textInutDecoration.copyWith(
                          labelText: "Password",
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => login(),
                          child: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                              text: 'Register here',
                              recognizer: TapGestureRecognizer()..onTap = () => UIHelpers.nextScreen(context, const RegisterPage()),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      Loader.show(context, progressIndicator: const CircularProgressIndicator());
      APIService.login({'email': email, 'password': password}).then((value) {
        if (value != null) {
          ChatUser user = value;
          if (user.status == "success") {
            UIHelpers.showSnackBar(context, Colors.green, user.message);
            SharedPreference.saveUserData(jsonEncode(user));
            Future.delayed(const Duration(seconds: 2));
            UIHelpers.nextScreenReplace(context, HomePage(user: user));
          } else {
            UIHelpers.showSnackBar(context, Colors.red, user.message);
          }
        } else {
          UIHelpers.showSnackBar(context, Colors.red, "unidentified problem occurred");
        }
        Loader.hide();
      });
    }
  }
}
