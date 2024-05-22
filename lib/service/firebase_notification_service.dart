import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/service/awesome_notification_service.dart';
import 'package:flutter_chat_app/service/general_app_service.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class FirebaseNotificationService {
  NotificationModel? notificationModel;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Map? notificationPayloadData;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  setUpFirebaseMessaging() async {
    //Request for notification permission
    await firebaseMessaging.requestPermission();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //subscribing to all topic
    firebaseMessaging.subscribeToTopic("all");
    //on notification tap to bring app back to life when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
      print("background + ${message?.data.toString()}");
      notificationPayloadData = message?.data;
      selectNotification("From onMessageOpenedApp");
      // refreshConversationsList(message!);
    });
    //normal notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print("foreground + ${message?.data.toString()}");
      showNotification(message!);
      // refreshConversationsList(message);
    });
    // tap to bring app back from terminated state
    FirebaseMessaging.onBackgroundMessage(GeneralAppService.onBackgroundMessageHandler);
  }

  showNotification(RemoteMessage message) async {
    if (message.notification == null && message.data["title"] == null) return;
    notificationPayloadData = message.data;
    try {
      String? imageUrl;
      try {
        imageUrl = message.data["image"] ?? (Platform.isAndroid ? message.notification?.android?.imageUrl : message.notification?.apple?.imageUrl);
      } catch (error) {
        print(error.toString());
        print("error getting notification image");
      }
      if (imageUrl != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey: NotificationService.appNotificationChannel().channelKey!,
            title: message.notification?.title,
            body: message.notification?.body,
            bigPicture: imageUrl,
            icon: "resource://drawable/ic_launcher",
            notificationLayout: NotificationLayout.BigPicture,
            payload: Map<String, String>.from(message.data),
          ),
        );
      } else {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: Random().nextInt(20),
            channelKey: NotificationService.appNotificationChannel().channelKey!,
            title: message.notification?.title,
            body: message.notification?.body,
            icon: "resource://drawable/ic_launcher",
            notificationLayout: NotificationLayout.Default,
            payload: Map<String, String>.from(message.data),
          ),
        );
      }
    } catch (error) {
      print("Notification Show error ===> ${error}");
    }
  }

  //handle on notification selected
  Future selectNotification(String? payload) async {
    // if (payload == null) return;
    try {
      log("NotificationPaylod ==> ${jsonEncode(notificationPayloadData)}");
      if (notificationPayloadData != null && notificationPayloadData is Map) {
        UserConversation userConversation = UserConversation.fromJson(
          jsonDecode(notificationPayloadData?['data']),
        );
        Navigator.of(Constants().navigatorKey.currentContext!).pushNamed(RouteGeneratorService.chatScreen, arguments: userConversation);
      }
    } catch (error) {
      print("Error opening Notification ==> $error");
    }
  }

  //refresh orders list if the notification is about assigned order
  //   BehaviorSubject<bool> refreshAssignedOrders = BehaviorSubject<bool>();
  void refreshConversationsList(RemoteMessage message) async {
    // AppService().refreshAssignedOrders.add(true);
  }
}
