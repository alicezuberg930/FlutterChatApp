import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/service/authentication.dart';
import 'package:flutter_chat_app/widgets/form_input.dart';
import 'package:flutter_chat_app/shared/regular_expression.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isloading = false;
  String email = "";
  String password = "";
  String fullname = "";
  Authentication authentication = Authentication();
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
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
                        'Đăng ký ngay để tạo tài khoản mới',
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
                        onChanged: (value) =>
                            {setState(() => fullname = value)},
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return "Tên không được để trống";
                          }
                        },
                        decoration: textInutDecoration.copyWith(
                            labelText: "Tên đầy đủ",
                            prefix: Icon(
                              Icons.person,
                              color: Theme.of(context).primaryColor,
                            )),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        onChanged: (value) => {setState(() => email = value)},
                        validator: (value) {
                          if (emailValidator(value!) == false) {
                            return "Email sai định dạng";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInutDecoration.copyWith(
                            labelText: "Email",
                            prefix: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
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
                          labelText: "Mật khẩu",
                          prefix: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
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
                          onPressed: () => {register()},
                          child: const Text(
                            "Đăng ký",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text.rich(
                        TextSpan(
                          text: 'Đã có tài khoản?',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              style: const TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              text: ' Đăng nhập ở đây',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreen(context, const LoginPage());
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

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authentication
          .register(fullname, email, password)
          .then((value) async => {
                if (value == true)
                  {
                    //Lưu dữ liệu vào shared preferences
                    await Helper.saveUserLoggedInStatus(true),
                    await Helper.saveUserName(fullname),
                    await Helper.saveUserEmail(email),
                    nextScreenReplace(context, const HomePage())
                  }
                else
                  {
                    showSnackBar(context, Colors.red, value),
                    setState(() {
                      _isloading = false;
                    })
                  }
              });
    }
  }
}
