import 'dart:io';
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
  final String groupAvatar;
  const ChatPage({Key? key, required this.groupId, required this.groupName, required this.userName, required this.groupAvatar}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  ImagePicker picker = ImagePicker();
  String? adminName;
  Stream? chats;

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
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
                  adminName: adminName!,
                  groupAvatar: widget.groupAvatar,
                ),
              );
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: chatMessagesContainer()),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Map<Permission, PermissionStatus> statuses = await [Permission.storage, Permission.camera].request();
                        if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
                          if (context.mounted) showImagePicker(context, chooseImage);
                        } else {}
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.image,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Map<Permission, PermissionStatus> statuses = await [Permission.storage, Permission.camera].request();
                        if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
                          if (context.mounted) showImagePicker(context, chooseImage);
                        } else {}
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12, width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: chatController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            // contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: InputBorder.none,
                            hintText: "Nhập tin nhắn",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        chatController.text.isNotEmpty ? sendMessage(chatController.text) : sendMessage("👍");
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: chatController.text.isNotEmpty
                              ? Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.thumb_up,
                                  color: Theme.of(context).primaryColor,
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
      ),
    );
  }

  sendMessage(String message) {
    Map<String, dynamic> messageMap = {"message": message, "sender": widget.userName, "time": DateTime.now().millisecondsSinceEpoch.toString()};
    Database().sendGroupMessage(widget.groupId, messageMap);
    setState(() {
      chatController.clear();
    });
  }

  chatMessagesContainer() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? SizedBox(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(message: snapshot.data.docs[index]['message'], sender: snapshot.data.docs[index]['sender'], sentbyme: widget.userName == snapshot.data.docs[index]['sender']);
                  },
                ),
              )
            : Container();
      },
    );
  }

  chooseImage(ImageSource src) async {
    await picker.pickImage(source: src, imageQuality: 75).then(
          (value) => {
            if (value != null)
              {
                FileFirebase().uploadImage(File(value.path), "group_image").then(
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
}
