import 'package:flutter_chat_app/model/user.dart';

class Stranger {
  String? status;
  String? message;
  List<ChatUserData>? data;

  Stranger({this.status, this.message, required this.data});

  factory Stranger.fromJson(Map<String, dynamic> json) {
    return Stranger(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? List<ChatUserData>.from(json["data"].map((x) => ChatUserData.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      // 'data': data != null ? data!.toJson() : null,
    };
  }
}
