import 'package:flutter_chat_app/model/user.dart';

class UserFriend {
  String? status;
  int? friendId;
  String? isRequest;
  ChatUser? friend;

  UserFriend({
    this.status,
    this.friendId,
    this.isRequest,
    this.friend,
  });

  factory UserFriend.fromJson(Map<String, dynamic> json) {
    return UserFriend(
      status: json['status'],
      friendId: json['friend_id'],
      isRequest: json['is_request'],
      friend: ChatUser.fromJson(json['friend']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'friend_id': friendId,
      'is_request': isRequest,
      'friend': friend?.toJson(),
    };
  }
}
