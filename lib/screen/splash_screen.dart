// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/media.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    await Future.delayed(const Duration(seconds: 4));
    var userData = SharedPreference.getUserData();
    if (userData != null) {
      Navigator.of(Constants().navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        RouteGeneratorService.homeScreen,
        (Route<dynamic> route) => false,
        arguments: userData,
      );
    } else {
      Navigator.of(Constants().navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        RouteGeneratorService.loginScreen,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Image.asset("assets/images/splash_image.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
