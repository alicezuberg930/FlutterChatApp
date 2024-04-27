class ChatUser {
  String? id;
  String? name;
  String? email;
  String? avatar;
  String? status;
  String? fcmID;

  ChatUser({
    this.name,
    this.id,
    this.email,
    this.avatar,
    this.status,
    this.fcmID,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
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
