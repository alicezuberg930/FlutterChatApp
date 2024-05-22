import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/service/awesome_notification_service.dart';
import 'package:flutter_chat_app/service/firebase_notification_service.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
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
        appId: Constants.firebaseAppId,
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await NotificationService.clearIrrelevantNotificationChannels();
  await NotificationService.initializeAwesomeNotification();
  await NotificationService.listenToActions();
  await FirebaseNotificationService().setUpFirebaseMessaging();
  // await NotificationService().initializeNotification();
  runApp(const MyChatApp());
}

class MyChatApp extends StatefulWidget {
  const MyChatApp({super.key});

  @override
  State<MyChatApp> createState() => _MyChatAppState();
}

class _MyChatAppState extends State<MyChatApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter chat app',
      theme: ThemeData(
        primaryColor: Constants.primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: RouteGeneratorService.generateRoute,
      initialRoute: RouteGeneratorService.splashScreen,
      navigatorKey: Constants().navigatorKey,
    );
  }
}
