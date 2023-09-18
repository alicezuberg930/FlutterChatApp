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
  dynamic receiverName;
  dynamic groupName;
  dynamic userAvatar;
  dynamic groupAvatar;
  dynamic status;

  ConversationData({
    this.userId,
    this.conversationId,
    this.type,
    this.recentMessage,
    this.recentSender,
    this.receiverName,
    this.groupName,
    this.userAvatar,
    this.groupAvatar,
    this.status,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      userId: json['user_id'].toString(),
      conversationId: json['conversation_id'].toString(),
      type: json['type'],
      recentMessage: json['recent_message'],
      recentSender: json['recent_sender'].toString(),
      receiverName: json['receiver_name'],
      groupName: json['group_name'],
      userAvatar: json['user_avatar'],
      groupAvatar: json['group_avatar'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString(),
      'conversation_id': conversationId.toString(),
      'type': type,
      'recent_message': recentMessage,
      'recent_sender': recentSender.toString(),
      'receiver_name': receiverName,
      'group_name': groupName,
      'user_avatar': userAvatar,
      'group_avatar': groupAvatar,
      'status': status,
    };
  }
}
