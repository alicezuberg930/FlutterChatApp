// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_conversation.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/widgets/message_tile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatPage extends StatefulWidget {
  UserConversation? userConversation;
  ChatUser? chatUser;

  ChatPage({Key? key, this.userConversation, this.chatUser}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ScrollController scrollController = ScrollController();
  TextEditingController chatController = TextEditingController();
  ImagePicker picker = ImagePicker();
  List<Message>? messageList;
  bool isControllerEmpty = true;
  bool showEmojiPicker = false;
  FocusNode focusNode = FocusNode();
  bool isDarkMode = SharedPreference.getDarkMode() ?? false;
  APIService apiService = APIService();
  int currentPage = 1;
  Stream? messagesListStream;
  bool loadMoreMessage = true;
  Stream? stream;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    getConversationMessages();
    stream = Stream.periodic(const Duration(seconds: 3), (int i) {
      fetchConversationMessagesPeriodically();
    });
    streamSubscription = stream!.listen((event) {});

    focusNode.addListener(() {
      if (focusNode.hasFocus) setState(() => showEmojiPicker = false);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        getConversationMessages(initialLoading: false);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    chatController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  void getConversationMessages({bool initialLoading = true}) async {
    if (widget.userConversation == null) return;
    if (!initialLoading) currentPage += 1;
    List<Message>? tempMessageList = await apiService.getConversationMessages(widget.userConversation!.conversationId!, page: currentPage);
    setState(() {
      if (initialLoading) {
        messageList = tempMessageList!;
      } else {
        tempMessageList != null ? messageList!.addAll(tempMessageList) : null;
      }
      loadMoreMessage = false;
    });
  }

  fetchConversationMessagesPeriodically() async {
    if (widget.userConversation == null) return;
    List<Message>? tempMessageList = await apiService.getConversationMessages(widget.userConversation!.conversationId!, page: 1);
    setState(() {
      List<int>? originalList = messageList!.map((message) => message.id!).toList();
      List<int>? newList = tempMessageList!.map((message) => message.id!).toList();
      if (originalList.isEmpty || newList.isEmpty) return;
      for (int id in newList) {
        if (!originalList.contains(id)) {
          Message m = tempMessageList.firstWhere((e) => e.id == id);
          messageList!.insert(0, m);
        }
      }
    });
  }

  sendMessage(String message) async {
    if (widget.userConversation == null) {
      UserConversation? userConversation = await apiService.startOneToOneConversation(widget.chatUser!.id!, recentMessage: message);
      widget.userConversation = userConversation;
    }
    await apiService.sendMessage({
      'content': message,
      'message_type': 'text',
      'conversation_id': widget.userConversation!.conversationId,
    }).then((value) {
      if (value != null) {
        setState(() {
          messageList!.insert(0, value);
        });
      }
      // getConversationMessages();
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    });
  }

  chooseFile() async {
    List<File> files = [];
    FilePickerResult? selectedFile = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'pdf', 'doc', 'txt'],
    );
    if (selectedFile != null) {
      files.add(File(selectedFile.files.first.path!));
      if (widget.userConversation == null) {
        UserConversation? userConversation = await apiService.startOneToOneConversation(widget.chatUser!.id!);
        widget.userConversation = userConversation;
      }
      await apiService.sendMessage(
        {
          'content': chatController.text,
          'sender_id': widget.userConversation!.userId!,
          'message_type': selectedFile.files.first.extension == "mp3" ? "audio" : "others",
          'conversation_id': widget.userConversation!.conversationId!.toString(),
        },
        files: files,
      ).then((value) {
        if (value != null) {
          setState(() {
            messageList!.insert(0, value);
          });
        }
        // getConversationMessages();
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    }
  }

  chooseMultipleImage() async {
    List<File>? photos;
    final selectedImages = await picker.pickMultipleMedia();
    if (selectedImages.isNotEmpty) {
      photos = selectedImages.map((e) => File(e.path)).toList();
      if (widget.userConversation == null) {
        UserConversation? userConversation = await apiService.startOneToOneConversation(widget.chatUser!.id!);
        widget.userConversation = userConversation;
      }
      await apiService.sendMessage(
        {
          'content': chatController.text,
          'sender_id': widget.userConversation!.userId,
          'message_type': 'image',
          'conversation_id': widget.userConversation!.conversationId,
        },
        files: photos,
      ).then((value) {
        if (value != null) {
          setState(() {
            messageList!.insert(0, value);
          });
        }
        // getConversationMessages();
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    }
  }

  takeCameraPicture() async {
    List<File> photos = [];
    picker.pickImage(source: ImageSource.camera).then((value) async {
      if (value != null) {
        photos.add(File(value.path));
        if (widget.userConversation == null) {
          UserConversation? userConversation = await apiService.startOneToOneConversation(widget.chatUser!.id!);
          widget.userConversation = userConversation;
        }
        apiService.sendMessage(
          {
            'content': chatController.text,
            'sender_id': widget.userConversation!.userId!,
            'message_type': 'image',
            'conversation_id': widget.userConversation!.conversationId.toString(),
          },
          files: photos,
        ).then((value) {
          if (value != null) {
            setState(() {
              messageList!.insert(0, value);
            });
          }
          // getConversationMessages();
          scrollController.jumpTo(scrollController.position.minScrollExtent);
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
              reverse: true,
              controller: scrollController,
              itemCount: messageList!.length + 1,
              itemBuilder: (context, index) {
                if (index < messageList!.length) {
                  return MessageTile(
                    message: messageList![index],
                    sentbyme: widget.userConversation!.userId == messageList![index].senderId,
                  );
                } else {
                  return loadMoreMessage
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }
              },
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (scrollController.hasClients) {
    //     scrollController.animateTo(
    //       scrollController.position.minScrollExtent,
    //       duration: const Duration(milliseconds: 1),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 5,
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(
                    widget.chatUser?.avatar ?? (widget.userConversation!.group?.avatar ?? widget.userConversation!.receiver!.avatar!),
                  ),
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
                  Text(
                    widget.chatUser?.name ?? (widget.userConversation!.group?.groupName ?? widget.userConversation!.receiver!.name!),
                    style: TextStyle(
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // if (widget.type == "friend")
                  //   Text(
                  //     widget.status == "0" ? "offline" : "online",
                  //     style: TextStyle(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w400,
                  //       color: isDarkMode ? Colors.white : Colors.black,
                  //     ),
                  //   ),
                ],
              ),
            ],
          ),
          backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
          iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
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
                          onTap: () => chooseFile(),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(child: Icon(Icons.file_copy, color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        InkWell(
                          onTap: () => chooseMultipleImage(),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(child: Icon(Icons.image, color: Theme.of(context).primaryColor)),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (context.mounted) takeCameraPicture();
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
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform == TargetPlatform.iOS
                                ? 1.30
                                : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
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
                        ),
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
