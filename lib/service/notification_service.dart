import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final firebaseMessaging = FirebaseMessaging.instance;
  static AndroidNotificationChannel androidNotificationChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Important Notifications',
    description: 'this channel is android channel',
    importance: Importance.high,
  );
  static FlutterLocalNotificationsPlugin localNotification = FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initializePushNotification();
    initializeLocalNotification();
  }

  handleMessage(RemoteMessage? message) {
    if (message == null) return;
  }

  initializePushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((value) => handleMessage(value));
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('mysound'),
        channelDescription: androidNotificationChannel.description,
        // icon: "@drawable/ic_launcher",
        enableVibration: true,
        enableLights: true,
      );
      localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(android: notificationDetails),
        payload: jsonEncode(message.data),
      );
    });
  }

  initializeLocalNotification() async {
    const ios = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('ic_launcher');
    const settings = InitializationSettings(android: android, iOS: ios);
    await localNotification.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) {
        final message = RemoteMessage.fromMap(jsonDecode(payload.payload!));
        handleMessage(message);
      },
    );
    final platform = localNotification.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidNotificationChannel);
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  final notification = message.notification;
  if (notification == null) return;
  AndroidNotificationDetails notificationDetails = AndroidNotificationDetails(
    NotificationService.androidNotificationChannel.id,
    NotificationService.androidNotificationChannel.name,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: const RawResourceAndroidNotificationSound('mysound'),
    channelDescription: NotificationService.androidNotificationChannel.description,
    icon: "@drawable/ic_launcher",
  );
  NotificationService.localNotification.show(
    notification.hashCode,
    notification.title,
    notification.body,
    NotificationDetails(android: notificationDetails),
    payload: jsonEncode(message.data),
  );
}
