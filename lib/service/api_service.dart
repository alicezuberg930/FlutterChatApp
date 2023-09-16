import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_chat_app/common/constant.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:http/http.dart' as http;

class APIService {
  static Future login(Map<String, String>? params) async {
    try {
      final response = await http.post(Uri.parse(Constant.login), body: params);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return ChatUser.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future register(Map<String, String>? params) async {
    try {
      final response = await http.post(Uri.parse(Constant.register), body: params);
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return ChatUser.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future updateUserAvatar(String avatar, String id) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.updateUserAvatar));
      request.headers.addAll(Constant.headers);
      request.files.add(await http.MultipartFile.fromPath('image', avatar));
      request.fields['id'] = id;
      var res = await request.send();
      var responseData = await res.stream.toBytes();
      Map<String, dynamic> responseBody = jsonDecode(String.fromCharCodes(responseData));
      if (res.statusCode == 200) {
        return ChatUser.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
