class ChatUser {
  int? id;
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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      status: json['status'].toString(),
      fcmID: json['fcm_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'avatar': avatar,
      'status': status,
      'fcm_id': fcmID,
    };
  }
}
