import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static String userloggedinKeys = "LOGGEDINKEY";
  static String usernameKey = "USERNAMEKEY";
  static String useremailKey = "USEREMAILKEY";
  static String avatarKey = "AVATARKEY";
  //Lưu dữ liệu vào shared prefrences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userloggedinKeys, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(usernameKey, username);
  }

  static Future<bool> saveUserEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(useremailKey, email);
  }

  static Future<bool> saveUserAvatar(String url) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(avatarKey, url);
  }

  //Đọc dữ liệu từ shared preferences
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(userloggedinKeys);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(usernameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(useremailKey);
  }

  static Future<String?> getUserAvatar() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(avatarKey);
  }
}
