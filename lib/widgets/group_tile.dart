import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/service/database.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  final String groupAvatar;
  const GroupTile({Key? key, required this.userName, required this.groupId, required this.groupName, required this.groupAvatar}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  StreamSubscription<DocumentSnapshot>? _documentStream;
  String recentMessage = "";
  @override
  void initState() {
    Database().getGroupRecentMessage(widget.groupId).then((value) => {recentMessage = value});
    listenForDocumentChange(widget.groupId);
    super.initState();
  }

  @override
  void dispose() {
    _documentStream!.cancel();
    super.dispose();
  }

  listenForDocumentChange(String documentId) {
    _documentStream = FirebaseFirestore.instance.collection('groups').doc(documentId).snapshots().listen((documentSnapshot) {
      var myData = documentSnapshot.data();
      setState(() {
        recentMessage = myData!['recentMessage'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        UIHelpers.nextScreen(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
            groupAvatar: widget.groupAvatar,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: widget.groupAvatar == ""
              ? CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    widget.groupName.substring(0, 1).toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.groupAvatar),
                ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          subtitle: Text(
            recentMessage.contains("https://firebasestorage.googleapis.com/v0/b/flutterchatapp-6c211.appspot.com/o/") ? "Ảnh" : recentMessage,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
