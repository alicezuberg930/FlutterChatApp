class Message {
  String? status;
  String? message;
  List<MessageData>? data;

  Message({this.status, this.message, required this.data});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<MessageData>.from(json["data"].map((x) => MessageData.fromJson(x))) : null,
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
  dynamic photos;
  String? name;
  dynamic fileNames;

  MessageData({
    this.id,
    this.content,
    this.senderId,
    this.conversationId,
    this.messageType,
    this.photos,
    this.name,
    this.fileNames,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'].toString(),
      content: json['content'],
      senderId: json['sender_id'].toString(),
      conversationId: json['conversation_id'].toString(),
      messageType: json['message_type'],
      photos: json['photos'],
      name: json['name'],
      fileNames: json['file_names'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'content': content,
      'sender_id': senderId.toString(),
      'conversation_id': conversationId.toString(),
      'message_type': messageType,
      'photos': photos,
      'name': name,
      'file_names': fileNames,
    };
  }
}
