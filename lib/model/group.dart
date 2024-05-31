import 'package:flutter_chat_app/model/user.dart';

class Group {
  int? id;
  String? groupName;
  int? isActive;
  int? adminID;
  String? avatar;
  List<ChatUser>? users;
  String? link;

  Group({this.id, this.groupName, this.isActive, this.avatar, this.adminID, this.users, this.link});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["id"],
      groupName: json["group_name"],
      isActive: json['is_active'],
      avatar: json['avatar'],
      adminID: json['admin_id'],
      link: json['link'],
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
      "link": link,
      "users": users?.map((e) => e.toJson()),
    };
  }
}
