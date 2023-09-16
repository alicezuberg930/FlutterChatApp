class Message {
  String? status;
  String? message;
  List<MessageData>? data;

  Message({this.status, this.message, required this.data});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<MessageData>.from(json["data"].map((x) => MessageData.fromJson(x))) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data != null ? data!.map((v) => v.toJson()).toList() : null,
    };
  }
}

class MessageData {
  String? id;
  String? content;
  String? senderId;
  String? conversationId;
  String? messageType;
  String? photos;

  MessageData({
    this.id,
    this.content,
    this.senderId,
    this.conversationId,
    this.messageType,
    this.photos,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      conversationId: json['conversation_id'],
      messageType: json['message_type'],
      photos: json['photos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'conversation_id': conversationId,
      'message_type': messageType,
      'photos': photos,
    };
  }
}
