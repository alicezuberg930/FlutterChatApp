import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constants.apiKey,
        projectId: Constants.projectId,
        messagingSenderId: Constants.messagingSenderId,
        appId: Constants.appId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyChatApp());
}

class MyChatApp extends StatefulWidget {
  const MyChatApp({super.key});

  @override
  State<MyChatApp> createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  bool isSignedIn = false;
  @override
  void initState() {
    getUserLoggedInStatus();
    super.initState();
  }

  getUserLoggedInStatus() async {
    await Helper.getUserLoggedInStatus().then(
      (value) => {
        if (value != null) {isSignedIn = value}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chat app',
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
