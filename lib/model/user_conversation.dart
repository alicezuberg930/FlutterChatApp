import 'package:flutter_chat_app/model/group.dart';
import 'package:flutter_chat_app/model/user.dart';

class UserConversation {
  int? userId;
  int? conversationId;
  String? recentMessage;
  int? receiverId;
  Group? group;
  ChatUser? receiver;
  // List<Message>? messages;

  UserConversation({
    this.userId,
    this.conversationId,
    this.recentMessage,
    this.receiverId,
    this.group,
    this.receiver,
    // this.messages,
  });

  factory UserConversation.fromJson(Map<String, dynamic> json) {
    return UserConversation(
      userId: json['user_id'],
      conversationId: json['conversation_id'],
      recentMessage: json['recent_message'],
      receiverId: json['receiver_id'],
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
      receiver: json['receiver'] != null ? ChatUser.fromJson(json['receiver']) : null,
      // messages: json['messages'].isNotEmpty ? List<Message>.from(json["messages"].map((x) => Message.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'conversation_id': conversationId,
      'recent_message': recentMessage,
      'receiver_id': receiverId,
      'group': group?.toJson(),
      'receiver': receiver?.toJson(),
    };
  }
}
