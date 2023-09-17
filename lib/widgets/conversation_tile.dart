// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class ConversationTile extends StatefulWidget {
  final String conversationId;
  final String recentMessage;
  final String conversationName;
  final String conversationAvatar;
  final String type;
  String? status;

  ConversationTile({
    Key? key,
    required this.conversationId,
    required this.recentMessage,
    required this.conversationName,
    required this.conversationAvatar,
    required this.type,
    this.status,
  }) : super(key: key);

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // UIHelpers.nextScreen(
        //   context,
        //   ChatPage(),
        // );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(widget.conversationAvatar),
          ),
          title: Text(
            widget.conversationName,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          subtitle: Text(
            widget.recentMessage,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
