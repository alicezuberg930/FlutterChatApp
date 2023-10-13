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
  String? status;
  String? fcmID;

  ChatUserData({
    this.name,
    this.id,
    this.email,
    this.avatar,
    this.status,
    this.fcmID,
  });

  factory ChatUserData.fromJson(Map<String, dynamic> json) {
    return ChatUserData(
      name: json['name'],
      id: json['id'].toString(),
      email: json['email'],
      avatar: json['avatar'],
      status: json['status'].toString(),
      fcmID: json['fcm_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id.toString(),
      'email': email,
      'avatar': avatar,
      'status': status.toString(),
      'fcm_id': fcmID ?? "",
    };
  }
}
