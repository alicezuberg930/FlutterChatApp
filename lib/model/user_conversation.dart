import 'package:flutter_chat_app/model/group.dart';
import 'package:flutter_chat_app/model/user.dart';

class UserConversation {
  String? userId;
  int? conversationId;
  String? recentMessage;
  int? receiverId;
  Group? group;
  ChatUser? receiver;

  UserConversation({
    this.userId,
    this.conversationId,
    this.recentMessage,
    this.receiverId,
    this.group,
    this.receiver,
  });

  factory UserConversation.fromJson(Map<String, dynamic> json) {
    return UserConversation(
      userId: json['user_id'].toString(),
      conversationId: json['conversation_id'],
      recentMessage: json['recent_message'],
      receiverId: json['receiver_id'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      receiver: json['receiver'] != null ? ChatUser.fromJson(json['receiver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString(),
      'conversation_id': conversationId.toString(),
      'recent_message': recentMessage,
      'receiver_id': receiverId,
      'group': group!.toJson().toString(),
      'receiver': receiver!.toJson().toString(),
    };
  }
}
