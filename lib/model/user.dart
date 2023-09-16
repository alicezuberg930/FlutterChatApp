class ChatUser {
  String? status;
  String? message;
  ChatUserData? data;

  ChatUser({this.status, this.message, required this.data});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? ChatUserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data != null ? data!.toJson() : null,
    };
  }
}

class ChatUserData {
  String? id;
  String? name;
  String? email;
  String? avatar;

  ChatUserData({
    this.name,
    this.id,
    this.email,
    this.avatar,
  });

  factory ChatUserData.fromJson(Map<String, dynamic> json) {
    return ChatUserData(
      name: json['name'],
      id: json['id'].toString(),
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id.toString(),
      'email': email,
      'avatar': avatar,
    };
  }
}
