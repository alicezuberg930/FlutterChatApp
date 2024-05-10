import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_chat_app/service/firebase_notification_service.dart';

class GeneralAppService {
  //

//Hnadle background message
  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    //if it doesn't have data then it is a normal notification so ignore it
    if (message.data.isEmpty) return;
    await Firebase.initializeApp();
    //normal notifications
    FirebaseNotificationService().showNotification(message);
  }
}
