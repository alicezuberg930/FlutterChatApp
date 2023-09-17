class Friend {
  String? status;
  String? message;
  List<FriendData>? data;

  Friend({this.status, this.message, required this.data});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<FriendData>.from(json["data"].map((x) => FriendData.fromJson(x))) : null,
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

class FriendData {
  String? userId;
  String? friendId;
  String? name;
  String? email;
  String? avatar;
  String? friendStatus;
  String? userStatus;
  String? conversationId;

  FriendData({
    this.userId,
    this.friendId,
    this.name,
    this.email,
    this.avatar,
    this.friendStatus,
    this.userStatus,
    this.conversationId,
  });

  factory FriendData.fromJson(Map<String, dynamic> json) {
    return FriendData(
      userId: json["user_id"].toString(),
      friendId: json["friend_id"].toString(),
      name: json["name"],
      email: json["email"],
      avatar: json["avatar"],
      friendStatus: json["friend_status"],
      userStatus: json["user_status"].toString(),
      conversationId: json['conversation_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId.toString(),
      "friend_id": friendId.toString(),
      "name": name,
      "email": email,
      "avatar": avatar,
      "friend_status": friendStatus,
      "user_status": userStatus.toString(),
      "conversation_id": conversationId.toString(),
    };
  }
}
