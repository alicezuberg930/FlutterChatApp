import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static String userloggedinKeys = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String useremailKey = "USEREMAILKEY";
  static String avatarKey = "AVATARKEY";

  static late SharedPreferences pref;

  static initPref() async {
    pref = await SharedPreferences.getInstance();
  }

  //Lưu dữ liệu vào shared prefrences
  static saveUserLoggedInStatus(bool isUserLoggedIn) async {
    await pref.setBool(userloggedinKeys, isUserLoggedIn);
  }

  static saveUserName(String username) async {
    await pref.setString(usernameKey, username);
  }

  static saveUserEmail(String email) async {
    await pref.setString(useremailKey, email);
  }

  static saveUserAvatar(String url) async {
    await pref.setString(avatarKey, url);
  }

  //Đọc dữ liệu từ shared preferences
  static getUserLoggedInStatus() {
    return pref.getBool(userloggedinKeys) ?? false;
  }

  static getUserName() {
    return pref.getString(usernameKey);
  }

  static getUserEmail() {
    return pref.getString(useremailKey);
  }

  static getUserAvatar() {
    return pref.getString(avatarKey);
  }

  static clearAllData() async {
    await pref.clear();
  }

  static clearKeyData(String key) async {
    await pref.remove(key);
  }
}
