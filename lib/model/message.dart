import 'package:flutter_chat_app/model/media.dart';
import 'package:flutter_chat_app/model/user.dart';

class Message {
  String? id;
  String? content;
  int? senderId;
  int? conversationId;
  String? messageType;
  String? name;
  ChatUser? sender;
  List<Media>? medias;

  Message({
    this.id,
    this.content,
    this.senderId,
    this.conversationId,
    this.messageType,
    this.name,
    this.sender,
    this.medias,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'].toString(),
      content: json['content'],
      senderId: json['sender_id'],
      conversationId: json['conversation_id'],
      messageType: json['message_type'],
      name: json['name'],
      sender: json['sender'] != null ? ChatUser.fromJson(json['sender']) : null,
      medias: json['medias'].isNotEmpty ? List<Media>.from(json['medias'].map((x) => Media.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'conversation_id': conversationId,
      'message_type': messageType,
      'name': name,
      'sender': sender?.toJson(),
      'medias': medias?.map((e) => e.toJson()),
    };
  }
}
