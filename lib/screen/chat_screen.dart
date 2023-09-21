// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/widgets/image_picker.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' as foundation;

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
  ScrollController scrollController = ScrollController();
  TextEditingController chatController = TextEditingController();
  ImagePicker picker = ImagePicker();
  List<MessageData>? messageList;
  bool isControllerEmpty = true;
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    getUserMessages();
    focusNode.addListener(() {
      if (focusNode.hasFocus) setState(() => showEmojiPicker = false);
    });
    super.initState();
  }

  getUserMessages() async {
    var messageData = await APIService.getUserMessages(widget.conversationId);
    log(messageData.toJson().toString());
    if (messageData != null) {
      if (context.mounted) {
        setState(() {
          messageList = messageData.data;
        });
      }
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
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  chooseMultipleImage() async {
    List<File>? photos;
    final selectedImages = await picker.pickMultiImage(imageQuality: 75);
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
        scrollController.jumpTo(scrollController.position.maxScrollExtent + 300);
      });
    }
  }

  takeCameraPicture() async {
    List<File> photos = [];
    picker.pickImage(imageQuality: 75, source: ImageSource.camera).then((value) {
      if (value != null) {
        photos.add(File(value.path));
        APIService.sendMessage(
          {
            'content': chatController.text,
            'sender_id': widget.userId,
            'message_type': 'image',
            'conversation_id': widget.conversationId,
          },
          photos: photos,
        ).then((value) {
          getUserMessages();
          scrollController.jumpTo(scrollController.position.maxScrollExtent + 300);
        });
      }
    });
  }

  chatMessagesListWidget() {
    return messageList == null
        ? const SizedBox.shrink()
        : ScrollConfiguration(
            behavior: RemoveGlowingBehavior(),
            child: ListView.builder(
              controller: scrollController,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent+800,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });
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
              icon: const Icon(Icons.phone),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info),
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            if (showEmojiPicker) {
              setState(() => showEmojiPicker = false);
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(child: chatMessagesListWidget()),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await chooseMultipleImage();
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(child: Icon(Icons.image, color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // Map<Permission, PermissionStatus> statuses = await [Permission.storage, Permission.camera].request();
                            // if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
                            if (context.mounted) takeCameraPicture();
                            // } else {}
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() => isControllerEmpty = true);
                                } else {
                                  setState(() => isControllerEmpty = false);
                                }
                              },
                              controller: chatController,
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter a message",
                                hintStyle: const TextStyle(color: Colors.white, fontSize: 16),
                                suffixIconConstraints: const BoxConstraints(minWidth: 1, minHeight: 1),
                                suffixIcon: InkWell(
                                  onTap: () async {
                                    if (focusNode.hasFocus) {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = false;
                                    }
                                    setState(() => showEmojiPicker = !showEmojiPicker);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                      child: Icon(Icons.emoji_emotions, color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: Center(
                            child: isControllerEmpty
                                ? GestureDetector(
                                    onTap: () => sendMessage("👍"),
                                    child: Icon(
                                      Icons.thumb_up,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      sendMessage(chatController.text);
                                      chatController.clear();
                                    },
                                    child: Icon(
                                      Icons.send,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: showEmojiPicker,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji? emoji) {
                        chatController.text += emoji!.emoji;
                        setState(() => isControllerEmpty = false);
                      },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ), // Needs to be const Widget
                        loadingIndicator: const SizedBox.shrink(),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
