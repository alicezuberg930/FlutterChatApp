import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/conversation.dart';
import 'package:flutter_chat_app/model/friend.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/widgets/conversation_tile.dart';
import 'package:flutter_chat_app/widgets/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final ChatUser user;
  const HomePage({Key? key, required this.user}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImagePicker picker = ImagePicker();
  List<ConversationData>? conversationList;
  List<FriendData>? friendList;
  String? email;
  String groupAvatar = "";
  String friendAvatar = "";
  Stream? userMetaData;
  String? groupName;
  bool _isloading = false;

  @override
  void initState() {
    getUserConversations();
    getUserFriends();
    super.initState();
  }

  getUserConversations() async {
    var conversationData = await APIService.getUserConversation(widget.user.data!.id!);
    if (conversationData != null) {
      setState(() {
        conversationList = conversationData.data;
      });
    }
  }

  getUserFriends() async {
    var friendData = await APIService.getUserFriends(widget.user.data!.id!);
    if (friendData != null) {
      setState(() {
        friendList = friendData.data;
      });
    }
  }

  popUpDiolog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tạo ra 1 nhóm', textAlign: TextAlign.left),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isloading
                      ? Center(
                          child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                        )
                      : TextField(
                          onChanged: (value) => {setState(() => groupName = value)},
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isloading = true;
                      });
                      Navigator.of(context).pop();
                      UIHelpers.showSnackBar(context, Colors.green, "Nhóm được tạo thành công");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(10),
                  ),
                  child: const Text('Tạo'),
                )
              ],
            );
          },
        );
      },
    );
  }

  noGroupWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(),
          GestureDetector(
            onTap: () {
              popUpDiolog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[700], size: 70),
          ),
          const SizedBox(height: 10),
          const Text(
            'You dont have any conversations.',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  customDrawerWidget() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Container(
            alignment: Alignment.center,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(widget.user.data!.avatar!),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                      onTap: () => showImagePicker(context, chooseImage),
                      child: const Icon(Icons.camera_alt, color: Colors.black, size: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Text(
            widget.user.data!.name!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          const Divider(height: 2),
          ListTile(
            onTap: () => {},
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.group),
            title: const Text(
              "Nhóm",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () => {UIHelpers.nextScreen(context, const ProfilePage())},
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.verified_user),
            title: const Text(
              "Personal information",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () async => {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    elevation: 5,
                    title: Row(
                      children: const [
                        Icon(Icons.warning),
                        SizedBox(width: 5),
                        Text(
                          "Alert",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      GestureDetector(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(10)),
                          onPressed: () => {Navigator.pop(context)},
                          child: const Text("Yes"),
                        ),
                      ),
                      GestureDetector(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            backgroundColor: Colors.yellow[700],
                          ),
                          onPressed: () async {
                            SharedPreference.clearAllData();
                            UIHelpers.nextScreenReplace(context, const LoginPage());
                          },
                          child: const Text("No"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Log out",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          ListTile(
            onTap: () => {},
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.settings),
            title: const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  conversationsListWidget() {
    return conversationList == null
        ? noGroupWidget()
        : RefreshIndicator(
            onRefresh: () => getUserConversations(),
            child: ListView.builder(
              itemCount: conversationList!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ConversationTile(
                  conversationId: conversationList![index].conversationId!,
                  recentMessage: conversationList![index].recentMessage!,
                  conversationName: conversationList![index].conversationName!,
                  conversationAvatar: conversationList![index].conversationAvatar!,
                  type: conversationList![index].type!,
                );
              },
            ),
          );
  }

  friendListWidget() {
    return friendList == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15),
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: friendList!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      UIHelpers.nextScreen(
                        context,
                        ChatPage(
                          userId: widget.user.data!.id!,
                          conversationId: friendList![index].conversationId!,
                          conversationName: friendList![index].name!,
                          conversationAvatar: friendList![index].avatar!,
                          type: "friend",
                          status: friendList![index].userStatus!,
                        ),
                      );
                    },
                    child: Container(
                      height: 110,
                      margin: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: NetworkImage(friendList![index].avatar!),
                              height: 65,
                              width: 65,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            width: 80,
                            child: Text(friendList![index].name!, textAlign: TextAlign.center),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
  }

  chooseImage(ImageSource src) async {
    await picker.pickImage(source: src, imageQuality: 100).then(
      (value) async {
        if (value != null) {
          await cropImage(value.path);
        }
      },
    );
  }

  Future cropImage(String path) async {
    List<CropAspectRatioPreset> androidPreset = [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ];
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: Platform.isAndroid
          ? androidPreset
          : androidPreset +
              [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Cắt ảnh",
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: "Cắt ảnh")
      ],
    );
    if (croppedImage != null) {
      imageCache.clear();
      APIService.updateUserAvatar({'avatar': croppedImage.path, 'id': widget.user.data!.id!}).then((value) {
        if (value != null) {
          ChatUser user = value;
          if (user.status == "success") {
            setState(() {
              widget.user.data!.avatar = user.data!.avatar;
            });
            SharedPreference.saveUserData(jsonEncode(user));
          } else {
            UIHelpers.showSnackBar(context, Colors.red, user.message);
          }
        } else {
          UIHelpers.showSnackBar(context, Colors.red, "unidentified problem occurred");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => UIHelpers.nextScreen(context, const SearchPage()),
              icon: const Icon(Icons.search),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Tiến's Messenger",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: customDrawerWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {popUpDiolog(context)},
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              friendListWidget(),
              conversationsListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
