import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/register_page.dart';
import 'package:flutter_chat_app/service/authentication.dart';
import 'package:flutter_chat_app/service/database.dart';
import 'package:flutter_chat_app/shared/regular_expression.dart';
import 'package:flutter_chat_app/widgets/form_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isloading = false;
  String email = "";
  String password = "";
  final formkey = GlobalKey<FormState>();
  Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Tiến's Chat app",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Đăng nhập ngay để nhắn tin với nhau',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 25),
                      Image.asset(
                        "./assets/images/login_background.png",
                        width: MediaQuery.of(context).size.width * 0.65,
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        onChanged: (value) => {setState(() => email = value)},
                        validator: (value) {
                          if (emailValidator(value!) == false) {
                            return "Email không đúng định dạng";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInutDecoration.copyWith(
                          labelText: "Email",
                          prefix: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Mật khẩu phải có ít nhất 6 ký tự";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) =>
                              {setState(() => password = value)},
                          decoration: textInutDecoration.copyWith(
                              labelText: "Password",
                              prefix: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              ))),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: () => {login()},
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: 'Chưa có tài khoản?',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              text: 'Đăng ký ở đây',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const RegisterPage());
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authentication.login(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await Database(uid: FirebaseAuth.instance.currentUser!.uid)
                  .getUserData(email);
          await Helper.saveUserLoggedInStatus(true);
          await Helper.saveUserName(snapshot.docs[0]["fullName"]);
          await Helper.saveUserEmail(email);
          await Helper.saveUserAvatar(snapshot.docs[0]["profile_picture"]);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }
}
