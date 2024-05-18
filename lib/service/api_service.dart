import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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

  Future login(Map<String, String>? params) async {
    Response? response;
    try {
      response = await post(ApiURL.login, params);
      // if (response.statusCode == 200) {
      return response;
      // } else {
      //   return null;
      // }
    } catch (e) {
      return response;
      // return null;
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

  static Future updateUserAvatar(Map<String, dynamic>? params) async {
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
      if (response.statusCode == 200) {
        return List<UserConversation>.from(responseBody["data"].map((x) => UserConversation.fromJson(x)));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future getUserFriends(int userId) async {
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

  Future<List<Message>?> getConversationMessages(int conversationId, {int page = 1}) async {
    try {
      final response = await get(ApiURL.message, queryParameters: {"conversation_id": conversationId, "page": page});
      dynamic responseBody = response.data;
      // print(responseBody);
      if (response.statusCode == 200) {
        return List<Message>.from(responseBody["data"].map((x) => Message.fromJson(x)));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<ChatUser>?> searchUser(String fullname) async {
    try {
      final response = await get(ApiURL.user, queryParameters: {'fullname': fullname});
      dynamic responseBody = response.data;
      if (response.statusCode == 200) {
        return List<ChatUser>.from(responseBody["data"].map((x) => ChatUser.fromJson(x)));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Message?> sendMessage(Map<String, dynamic> params, {List<File>? files}) async {
    FormData formData = FormData.fromMap(params);
    if (files != null && files.isNotEmpty) {
      for (File? file in files) {
        // final fileSize = file!.lengthSync() / 1024;
        // if (fileSize > AppFileLimit.prescriptionFileSizeLimit) {
        // file = await Utils.compressFile(file: file, quality: 60);
        // }
        formData.files.add(
          MapEntry("medias[]", await MultipartFile.fromFile(file!.path)),
        );
      }
    }
    final response = await postWithFiles(ApiURL.message, formData);
    if (response.statusCode == 200) {
      return Message.fromJson(response.data["data"]);
    } else {
      return null;
    }
    // final apiResponse = ApiResponse.fromResponse(apiResult);
    // if (apiResponse.allGood) {
    //   return true;
    // } else {
    //   return false;
    // }
    // } catch (e) {
    //   print(e.toString());
    //   return null;
    // }
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
      if (response.statusCode == 200) {
        return UserConversation.fromJson(responseBody["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserConversation?> startOneToOneConversation(int receiverId, {String? recentMessage}) async {
    try {
      final response = await post(
        ApiURL.conversation,
        {'recent_message': recentMessage, 'receiver_id': receiverId},
      );
      dynamic responseBody = response.data;
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
