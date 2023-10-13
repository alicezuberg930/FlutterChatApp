import 'dart:convert';
import 'dart:io';

import 'package:flutter_chat_app/common/constant.dart';
import 'package:flutter_chat_app/model/conversation.dart';
import 'package:flutter_chat_app/model/friend.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/model/stranger.dart';
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

  static Future updateUserAvatar(Map<String, String>? params) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(Constant.updateUserAvatar));
      request.headers.addAll(Constant.headers);
      request.files.add(await http.MultipartFile.fromPath('avatar', params!['avatar']!));
      request.fields['id'] = params['id']!;
      var res = await request.send();
      var responseData = await res.stream.toBytes();
      Map<String, dynamic> responseBody = jsonDecode(String.fromCharCodes(responseData));
      if (res.statusCode == 200) {
        return ChatUser.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future updateUserStatus(Map<String, String> params) async {
    try {
      final response = await http.put(Uri.parse(Constant.updateUserStatus), body: params);
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

  static Future getUserConversation(String userId) async {
    try {
      final response = await http.get(Uri.parse("${Constant.getUserConversations}?user_id=$userId"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return Conversation.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future getUserFriends(String userId) async {
    try {
      final response = await http.get(Uri.parse("${Constant.getUserFriends}?user_id=$userId"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return Friend.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future getUserMessages(String conversationId) async {
    try {
      final response = await http.get(Uri.parse("${Constant.getUserMessages}?conversation_id=$conversationId"));
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
      final response = await http.get(Uri.parse("${Constant.searchUser}?fullname=$fullname"));
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return Stranger.fromJson(responseBody);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future sendMessage(Map<String, String> params, {List<File>? photos}) async {
    try {
      dynamic response;
      Map<String, dynamic> responseBody;
      if (photos != null) {
        var request = http.MultipartRequest('POST', Uri.parse(Constant.sendMessage));
        request.headers.addAll(Constant.headers);
        for (File photo in photos) {
          request.files.add(await http.MultipartFile.fromPath('photos[]', photo.path));
        }
        request.fields['content'] = params['content']!;
        request.fields['sender_id'] = params['sender_id']!;
        request.fields['message_type'] = params['message_type']!;
        request.fields['conversation_id'] = params['conversation_id']!;
        response = await request.send();
        var responseData = await response.stream.toBytes();
        responseBody = jsonDecode(String.fromCharCodes(responseData));
      } else {
        response = await http.post(Uri.parse(Constant.sendMessage), body: params);
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
}
