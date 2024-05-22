import 'package:flutter/material.dart';
import 'package:singleton/singleton.dart';

class Constants {
  factory Constants() => Singleton.lazy(() => Constants._());

  /// Private constructor
  Constants._();

  static String apiKey = "AIzaSyAOxnluqkSjG9NvHHxd1MQmSASe23YLWOo";
  static String authDomain = "flutterchatapp-6c211.firebaseapp.com";
  static String projectId = "flutterchatapp-6c211";
  static String storageBucket = "flutterchatapp-6c211.appspot.com";
  static String messagingSenderId = "1096719736898";
  static String firebaseAppId = "1:1096719736898:web:a415770c502c10edd6cddb";
  static String measurementId = "G-XFZ68P1M3E";
  static String agoraAppId = "25e16287fbb0481381faeeec8ace5f02";
  static const Color primaryColor = Color.fromARGB(255, 39, 140, 255);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
