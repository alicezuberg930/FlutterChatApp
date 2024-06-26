import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_chat_app/common/api_url.dart';
import 'package:flutter_chat_app/model/api_response.dart';
import 'package:flutter_chat_app/model/user_call_channel.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_friend.dart';
import 'package:flutter_chat_app/service/http_service.dart';
import 'package:http/http.dart' as http;

class APIService extends HttpService {
  Future<String?> getPublicIP() async {
    Response? response = await get('https://api.ipify.org');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<ApiResponse> login(Map<String, String>? params) async {
    Response? response = await post(ApiURL.login, params);
    return ApiResponse.fromResponse(response);
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
      final response = await get(ApiURL.conversation);
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

  Future<List<Message>?> getConversationMessages(int conversationId, {int page = 1}) async {
    try {
      final response = await get(ApiURL.message, queryParameters: {"conversation_id": conversationId, "page": page});
      dynamic responseBody = response.data;
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

  Future<UserConversation?> checkForConversationWithUser(int receiverId) async {
    try {
      final response = await get(ApiURL.checkForConversationWithUser, queryParameters: {'receiver_id': receiverId});
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

  Future<UserCallChannel?> getMeeting(int? receiverId, int? groupId) async {
    try {
      final response = await get(ApiURL.getMeeting, queryParameters: {'receiver_id': receiverId, 'group_id': groupId});
      dynamic responseBody = response.data;
      if (response.statusCode == 200) {
        return UserCallChannel.fromJson(responseBody["data"]);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<UserFriend>> getMyFriends() async {
    try {
      final response = await get(ApiURL.friend);
      dynamic responseBody = response.data;
      if (response.statusCode == 200 && responseBody['data'].isNotEmpty) {
        return List<UserFriend>.from(responseBody['data'].map((x) => UserFriend.fromJson(x))).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<ApiResponse> acceptFriendRequest({required int friendId}) async {
    final apiResult = await get(ApiURL.acceptFriendRequest, queryParameters: {'friend_id': friendId});
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> unfriend({required int friendId}) async {
    final apiResult = await get(ApiURL.unfriend, queryParameters: {'friend_id': friendId});
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> rejectFriendRequest({required int friendId}) async {
    final apiResult = await get(ApiURL.rejectFriendRequest, queryParameters: {'friend_id': friendId});
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> addFriend({required int friendId}) async {
    final apiResult = await post(ApiURL.friend, {'friend_id': friendId});
    return ApiResponse.fromResponse(apiResult);
  }

  Future<UserConversation> createGroup({required List<int> userIds, required String groupName}) async {
    final apiResult = await post(ApiURL.group, {'user_ids': userIds, 'group_name': groupName});
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return UserConversation.fromJson(apiResponse.body["data"]);
    } else {
      throw apiResponse.message!;
    }
  }

  Future<UserConversation> joinGroup(String link) async {
    final apiResult = await post(ApiURL.joinGroup, {'link': link});
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return UserConversation.fromJson(apiResponse.body["data"]);
    } else {
      throw apiResponse.message!;
    }
  }
}
