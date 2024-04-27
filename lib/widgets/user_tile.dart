import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';

class UserTile extends StatelessWidget {
  final ChatUser chatUser;
  const UserTile({Key? key, required this.chatUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // UIHelpers.nextScreen(
          // context,
          // ChatPage(
          //   userId: chatUser.id!,
          //   conversationId: '1',
          //   conversationName: chatUser.name!,
          //   conversationAvatar: chatUser.avatar!,
          //   type: "friend",
          //   status: chatUser.status!,
          // ),
        // );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(chatUser.avatar!),
          ),
          title: Text(
            chatUser.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          // subtitle: Text(
          //   recentMessage,
          //   style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          // ),
        ),
      ),
    );
  }
}
