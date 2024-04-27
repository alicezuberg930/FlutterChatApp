import 'package:flutter_chat_app/model/user.dart';

class Group {
  String? id;
  String? groupName;
  int? isActive;
  int? adminID;
  String? avatar;
  List<ChatUser>? users;

  Group({this.id, this.groupName, this.isActive, this.avatar, this.adminID, this.users});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["user_id"],
      groupName: json["group_name"],
      isActive: json['is_active'],
      avatar: json['avatar'],
      adminID: json['admin_id'],
      users: List<ChatUser>.from(json["users"].map((x) => ChatUser.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "group_name": groupName,
      "is_active": isActive,
      "avatar": avatar,
      "admin_id": adminID,
      "users": users.toString(),
    };
  }
}
