// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/widgets/image_picker.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String conversationName;
  final String conversationAvatar;
  final String type;
  final String userId;
  String? status;

  ChatPage({
    Key? key,
    required this.userId,
    required this.conversationId,
    required this.conversationName,
    required this.conversationAvatar,
    required this.type,
    this.status,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();
  ImagePicker picker = ImagePicker();
  List<MessageData>? messageList;

  @override
  void initState() {
    getUserMessages();
    super.initState();
  }

  getUserMessages() async {
    var messageData = await APIService.getUserMessages(widget.conversationId);
    if (messageData != null) {
      setState(() {
        messageList = messageData.data;
      });
    }
  }

  sendMessage(String message) async {
    await APIService.sendMessage({
      'content': message,
      'sender_id': widget.userId,
      'message_type': 'text',
      'conversation_id': widget.conversationId,
    }).then((value) {
      getUserMessages();
    });
  }

  chooseMultipleImage() async {
    List<File>? photos;
    final selectedImages = await picker.pickMultiImage(imageQuality: 100);
    if (selectedImages.isNotEmpty) {
      photos = selectedImages.map((e) => File(e.path)).toList();
      await APIService.sendMessage(
        {
          'content': chatController.text,
          'sender_id': widget.userId,
          'message_type': 'image',
          'conversation_id': widget.conversationId,
        },
        photos: photos,
      ).then((value) {
        getUserMessages();
      });
    }
  }

  chatMessagesContainer() {
    return messageList == null
        ? const SizedBox.shrink()
        : ScrollConfiguration(
            behavior: RemoveGlowingBehavior(),
            child: ListView.builder(
              itemCount: messageList!.length,
              itemBuilder: (context, index) {
                return MessageTile(
                  content: messageList![index].content ?? "",
                  sender: messageList![index].name!,
                  sentbyme: widget.userId == messageList![index].senderId,
                  messageType: messageList![index].messageType!,
                  photos: messageList![index].photos ?? "",
                );
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(widget.conversationAvatar),
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.conversationName, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 2),
                  if (widget.type == "friend")
                    Text(
                      widget.status == "0" ? "offline" : "online",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey[300]),
                    ),
                ],
              ),
            ],
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info),
            )
          ],
        ),
        body: Column(
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
                        // PermissionStatus status = await Permission.storage.request();
                        // if (status.isGranted) {
                        if (context.mounted) await chooseMultipleImage();
                        // } else {
                        // await openAppSettings();
                        // }
                      },
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: Icon(Icons.image, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     Map<Permission, PermissionStatus> statuses = await [Permission.storage, Permission.camera].request();
                    //     if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
                    //       if (context.mounted) showImagePicker(context, chooseImage);
                    //     } else {}
                    //   },
                    //   child: SizedBox(
                    //     height: 40,
                    //     width: 40,
                    //     child: Center(
                    //       child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                    //     ),
                    //   ),
                    // ),
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
                            border: InputBorder.none,
                            hintText: "Enter a message",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: chatController.text.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  sendMessage(chatController.text);
                                  chatController.text = "";
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                            : GestureDetector(
                                onTap: () => sendMessage("👍"),
                                child: Icon(
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
}
