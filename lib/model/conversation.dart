class Conversation {
  String? status;
  String? message;
  List<ConversationData>? data;

  Conversation({this.status, this.message, required this.data});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<ConversationData>.from(json["data"].map((x) => ConversationData.fromJson(x))) : null,
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

class ConversationData {
  String? userId;
  String? conversationId;
  String? type;
  String? recentMessage;
  String? recentSender;
  String? conversationAvatar;
  String? conversationName;

  ConversationData({
    this.userId,
    this.conversationId,
    this.type,
    this.recentMessage,
    this.recentSender,
    this.conversationAvatar,
    this.conversationName,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      userId: json['user_id'].toString(),
      conversationId: json['conversation_id'].toString(),
      type: json['type'],
      recentMessage: json['recent_message'],
      recentSender: json['recent_sender'].toString(),
      conversationAvatar: json['conversation_avatar'],
      conversationName: json['conversation_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString(),
      'conversation_id': conversationId.toString(),
      'type': type,
      'recent_message': recentMessage,
      'recent_sender': recentSender.toString(),
      'conversation_avatar': conversationAvatar,
      'conversation_name': conversationName,
    };
  }
}
