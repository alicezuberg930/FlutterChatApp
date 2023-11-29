// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/conversation.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';

class ConversationTile extends StatelessWidget {
  ConversationData? conversationData;

  ConversationTile({Key? key, this.conversationData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = SharedPreference.getDarkMode() ?? false;
    return InkWell(
      onLongPress: () {},
      onTap: () {
        UIHelpers.nextScreen(
          context,
          ChatPage(
            conversationAvatar: conversationData!.type! == "group" ? conversationData!.groupAvatar! : conversationData!.userAvatar!,
            conversationId: conversationData!.conversationId!,
            conversationName: conversationData!.type! == "group" ? conversationData!.groupName! : conversationData!.receiverName!,
            type: conversationData!.type!,
            userId: conversationData!.userId!,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              conversationData!.type! == "group" ? conversationData!.groupAvatar! : conversationData!.userAvatar!,
            ),
          ),
          title: Text(
            conversationData!.type! == "group" ? conversationData!.groupName! : conversationData!.receiverName!,
            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.grey : Colors.black45),
          ),
          subtitle: Text(
            conversationData!.recentMessage!,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.grey : Colors.black45),
          ),
        ),
      ),
    );
  }
}
