// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class ConversationTile extends StatelessWidget {
  UserConversation? userConversation;

  ConversationTile({Key? key, this.userConversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = SharedPreference.getDarkMode() ?? false;
    return InkWell(
      onLongPress: () {},
      onTap: () {
        Navigator.of(Constants().navigatorKey.currentContext!).pushNamed(RouteGeneratorService.chatScreen, arguments: userConversation);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
              userConversation!.group != null ? userConversation!.group!.avatar! : userConversation!.receiver!.avatar!,
            ),
          ),
          title: Text(
            userConversation!.group != null ? userConversation!.group!.groupName! : userConversation!.receiver!.name!,
            style: TextStyle(fontWeight: FontWeight.bold, color: isDarkMode ? Colors.grey : Colors.black45),
          ),
          subtitle: Text(
            userConversation!.recentMessage!,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.grey : Colors.black45),
          ),
        ),
      ),
    );
  }
}
