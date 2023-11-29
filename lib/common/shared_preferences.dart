import 'dart:convert';

import 'package:flutter_chat_app/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static String userloggedinKeys = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String useremailKey = "USEREMAILKEY";
  static String avatarKey = "AVATARKEY";
  static String userDataKey = "USERDATA";
  static String darkModeKey = "DARKMODE";

  static late SharedPreferences pref;

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  //Lưu dữ liệu vào shared prefrences
  static saveUserLoggedInStatus(bool isUserLoggedIn) async {
    await pref.setBool(userloggedinKeys, isUserLoggedIn);
  }

  static saveUserData(String data) async {
    await pref.setString(userDataKey, data);
  }

  static saveDarkMode(bool darkMode) async {
    await pref.setBool(darkModeKey, darkMode);
  }

  //Đọc dữ liệu từ shared preferences
  static clearAllData() async {
    await pref.clear();
  }

  static clearKeyData(String key) async {
    await pref.remove(key);
  }

  static getUserData() {
    String? userData = pref.getString(userDataKey);
    if (userData == null) return null;
    Map<String, dynamic> userMap = json.decode(userData);
    return ChatUser.fromJson(userMap);
  }

  static bool? getDarkMode() {
    bool? darkMode = pref.getBool(darkModeKey);
    return darkMode;
  }
}
