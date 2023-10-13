import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/screen/home_screen.dart';
import 'package:flutter_chat_app/screen/login_screen.dart';
import 'package:flutter_chat_app/service/notification_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreference.initPref();
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
  await NotificationService().initializeNotification();
  runApp(const MyChatApp());
}

class MyChatApp extends StatefulWidget {
  const MyChatApp({super.key});

  @override
  State<MyChatApp> createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  bool isSignedIn = false;
  ChatUser? userData;
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    userData = SharedPreference.getUserData();
    if (userData != null) isSignedIn = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat app',
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: isSignedIn ? HomePage(user: userData!) : const LoginPage(),
      navigatorKey: navigatorKey,
    );
  }
}
