class Message {
  String? id;
  String? content;
  String? senderId;
  String? conversationId;
  String? messageType;
  dynamic photos;
  String? name;
  dynamic fileNames;

  Message({
    this.id,
    this.content,
    this.senderId,
    this.conversationId,
    this.messageType,
    this.photos,
    this.name,
    this.fileNames,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
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
