import 'package:flutter_chat_app/model/group.dart';
import 'package:flutter_chat_app/model/user.dart';

class UserCallChannel {
  int? id;
  String? token;
  String? channel;
  ChatUser? caller;
  ChatUser? receiver;
  Group? group;

  UserCallChannel({this.id, this.token, this.channel, this.caller, this.receiver, this.group});

  factory UserCallChannel.fromJson(Map<String, dynamic> json) {
    return UserCallChannel(
      id: json["id"],
      token: json["token"],
      channel: json['channel'],
      caller: json['caller'] != null ? ChatUser.fromJson(json['caller']) : null,
      receiver: json['caller'] != null ? ChatUser.fromJson(json['receiver']) : null,
      group: json['group'] != null ? Group.fromJson(json['group']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "token": token,
      "channel": channel,
      "caller": caller?.toJson(),
      "receiver": receiver?.toJson(),
      "group": group?.toJson(),
    };
  }
}
