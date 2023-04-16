import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final String userName;
  final String friendUid;
  final String friendName;
  final String friendAvatar;
  const UserTile(
      {Key? key,
      required this.userName,
      required this.friendUid,
      required this.friendName,
      required this.friendAvatar})
      : super(key: key);

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  StreamSubscription<DocumentSnapshot>? _documentStream;
  String recentMessage = "";

  @override
  void dispose() {
    _documentStream!.cancel();
    super.dispose();
  }

  listenForDocumentChange(String documentId) {
    _documentStream = FirebaseFirestore.instance
        .collection('groups')
        .doc(documentId)
        .snapshots()
        .listen((documentSnapshot) {
      var myData = documentSnapshot.data();
      setState(() {
        recentMessage = myData!['recentMessage'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: widget.friendAvatar == ""
              ? const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(widget.friendAvatar),
                ),
          title: Text(
            widget.friendName,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          subtitle: Text(
            recentMessage,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
