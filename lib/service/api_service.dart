import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_app/common/api_url.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/service/http_service.dart';
import 'package:http/http.dart' as http;

class APIService extends HttpService {
  static Future getPublicIP() async {
    try {
      const url = 'https://api.ipify.org';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future login(Map<String, String>? params) async {
    Map<String, dynamic>? responseBody;
    try {
      final response = await http.post(Uri.parse(ApiURL.login), body: params);
      responseBody = json.decode(response.body);
      print(responseBody);  
      return responseBody;
    } catch (e) {
      return responseBody;
    }
  }

  static Future register(Map<String, String>? params) async {
    try {
      final response = await http.post(Uri.parse(ApiURL.register), body: params);
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

  static Future updateUserAvatar(Map<String, String>? params) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiURL.updateUserAvatar));
      request.headers.addAll(ApiURL.headers);
      request.files.add(await http.MultipartFile.fromPath('avatar', params!['avatar']!));
      request.fields['id'] = params['id']!;
      var res = await request.send();
      var responseData = await res.stream.toBytes();
      Map<String, dynamic> responseBody = jsonDecode(String.fromCharCodes(responseData));
      if (res.statusCode == 200) {
        return responseBody;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future updateUserStatus(Map<String, String> params) async {
    try {
      final response = await http.put(Uri.parse(ApiURL.updateUserStatus), body: params);
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

  Future<List<UserConversation>?> getUserConversation() async {
    try {
      final response = await get(ApiURL.getUserConversations);
      final responseBody = response.data;
      print(responseBody);
      if (response.statusCode == 200) {
        return List<UserConversation>.from(responseBody["data"].map((x) => UserConversation.fromJson(x)));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future getUserFriends(String userId) async {
    try {
      final response = await http.get(Uri.parse("${ApiURL.getUserFriends}?user_id=$userId"));
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

  static Future<Message?> getUserMessages(String conversationId) async {
    try {
      final response = await http.get(Uri.parse("${ApiURL.getUserMessages}?conversation_id=$conversationId"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return Message.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future searchUser(String fullname) async {
    try {
      final response = await http.get(Uri.parse("${ApiURL.searchUser}?fullname=$fullname"));
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

  static Future sendMessage(Map<String, String> params, {List<File>? files}) async {
    try {
      dynamic response;
      Map<String, dynamic> responseBody;
      if (files != null) {
        var request = http.MultipartRequest('POST', Uri.parse(ApiURL.sendMessage));
        request.headers.addAll(ApiURL.headers);
        for (File file in files) {
          request.files.add(await http.MultipartFile.fromPath('files[]', file.path));
        }
        request.fields['content'] = params['content']!;
        request.fields['sender_id'] = params['sender_id']!;
        request.fields['message_type'] = params['message_type']!;
        request.fields['conversation_id'] = params['conversation_id']!;
        response = await request.send();
        var responseData = await response.stream.toBytes();
        responseBody = jsonDecode(String.fromCharCodes(responseData));
      } else {
        response = await http.post(Uri.parse(ApiURL.sendMessage), body: params);
        responseBody = json.decode(response.body);
      }
      if (response.statusCode == 200) {
        return Message.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future createGroup(Map<String, dynamic> params) async {
    Map<String, dynamic>? responseBody;
    try {
      final response = await http.post(Uri.parse(ApiURL.group), body: params);
      responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {
        return responseBody;
      }
    } catch (e) {
      return responseBody;
    }
  }

  Future<UserConversation?> getUserConversationDetails(int conversationId) async {
    try {
      final response = await get("${ApiURL.conversation}/$conversationId");
      dynamic responseBody = response.data;
      print(responseBody);
      if (response.statusCode == 200) {
        return UserConversation.fromJson(responseBody["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
