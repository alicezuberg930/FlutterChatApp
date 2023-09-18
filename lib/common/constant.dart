import 'dart:io';

class Constant {
  static const apiUrl = "http://192.168.2.10:8000/api/v1";
  static Map<String, String> headers = {HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'};
  static const login = "$apiUrl/login";
  static const register = "$apiUrl/register";
  static const getUserFriends = "$apiUrl/get-user-friends";
  static const getUserConversations = "$apiUrl/get-user-conversations";
  static const getUserMessages = "$apiUrl/get-user-messages";
  static const deleteMessage = "$apiUrl/delete-message";
  static const sendMessage = "$apiUrl/send-message";
  static const updateUserAvatar = "$apiUrl/update-user-avatar";
  static const updateUserStatus = "$apiUrl/update-user-status";
  static const searchUser = "$apiUrl/search-user";
}
