import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/group_info_page.dart';
import 'package:flutter_chat_app/service/database.dart';
import 'package:flutter_chat_app/service/file_firebase.dart';
import 'package:flutter_chat_app/widgets/form_input.dart';
import 'package:flutter_chat_app/widgets/image_picker.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  String adminName = "";
  Stream<QuerySnapshot>? chats;
  final picker = ImagePicker();
  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  chooseImage(ImageSource src) async {
    await picker.pickImage(source: src, imageQuality: 100).then(
          (value) => {
            if (value != null)
              {
                FileFirebase()
                    .uploadImage(File(value.path), "group_image")
                    .then(
                  (value) {
                    String val = value;
                    sendMessage(val);
                  },
                )
              }
          },
        );
  }

  getChatAndAdmin() {
    Database().getChats(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
    Database().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        adminName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfoPage(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: adminName),
              );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatMessages(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              color: Colors.grey[700],
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        Permission.camera
                      ].request();
                      if (statuses[Permission.storage]!.isGranted &&
                          statuses[Permission.camera]!.isGranted) {
                        showImagePicker(context, chooseImage);
                      } else {}
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12, width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: chatController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nhập tin nhắn",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      chatController.text.isNotEmpty
                          ? sendMessage(chatController.text)
                          : sendMessage("👍");
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: chatController.text.isNotEmpty
                            ? const Icon(
                                Icons.send,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.thumb_up,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  sendMessage(String message) {
    Map<String, dynamic> messageMap = {
      "message": message,
      "sender": widget.userName,
      "time": DateTime.now().millisecondsSinceEpoch.toString()
    };
    Database().sendGroupMessage(widget.groupId, messageMap);
    setState(() {
      chatController.clear();
    });
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentbyme: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }
}
