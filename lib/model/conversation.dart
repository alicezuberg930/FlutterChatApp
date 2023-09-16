class Conversation {
  String? status;
  String? message;
  List<ConversationData>? data;

  Conversation({this.status, this.message, required this.data});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<ConversationData>.from(json["data"].map((x) => ConversationData.fromJson(x))) : [],
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
  String? name;
  String? id;
  String? type;
  String? recentMessage;
  String? recentSender;

  ConversationData({this.name, this.id, this.type, this.recentMessage, this.recentSender});

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      name: json['name'],
      id: json['id'],
      type: json['type'],
      recentMessage: json['recent_message'],
      recentSender: json['recent_sender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'type': type,
      'recent_message': recentMessage,
      'recent_sender': recentSender,
    };
  }
}
