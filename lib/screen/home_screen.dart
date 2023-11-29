import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/model/conversation.dart';
import 'package:flutter_chat_app/model/friend.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/screen/chat_screen.dart';
import 'package:flutter_chat_app/screen/login_screen.dart';
import 'package:flutter_chat_app/screen/my_profile_screen.dart';
import 'package:flutter_chat_app/screen/search_screen.dart';
import 'package:flutter_chat_app/screen/settings_screen.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';
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
  bool isDarkMode = SharedPreference.getDarkMode() ?? false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      backgroundColor: isDarkMode ? const Color.fromARGB(255, 40, 40, 40) : Colors.white,
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
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                      onTap: () => showImagePicker(context, chooseImage),
                      child: const Icon(Icons.camera_alt, color: Constants.primaryColor, size: 20),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Divider(height: 4, color: isDarkMode ? Colors.white : Colors.black),
          ListTile(
            onTap: () => {},
            selected: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.group, color: Constants.primaryColor),
            title: Text(
              "Nhóm",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () => {UIHelpers.nextScreen(context, const MyProfileScreen())},
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.verified_user, color: Constants.primaryColor),
            title: Text(
              "Personal information",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              toggleDrawer();
              UIHelpers.nextScreen(
                context,
                const SettingsScreen(),
                action: (value) {
                  setState(() => isDarkMode = value);
                },
              );
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.settings, color: Constants.primaryColor),
            title: Text(
              "Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
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
                          child: const Text("No"),
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
                          child: const Text("Yes"),
                        ),
                      ),
                    ],
                  );
                },
              ),
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            leading: const Icon(Icons.exit_to_app, color: Constants.primaryColor),
            title: Text(
              "Log out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  conversationsListWidget() {
    return conversationList == null
        ? noGroupWidget()
        : ScrollConfiguration(
            behavior: RemoveGlowingBehavior(),
            child: RefreshIndicator(
              onRefresh: () => getUserConversations(),
              child: ListView.builder(
                itemCount: conversationList!.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ConversationTile(conversationData: conversationList![index]);
                },
              ),
            ),
          );
  }

  friendListWidget() {
    return friendList == null
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 100,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: friendList!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
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
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: NetworkImage(friendList![index].avatar!),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 80,
                          child: Text(
                            friendList![index].name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black45),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
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

  cropImage(String path) async {
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

  toggleDrawer() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openEndDrawer();
    } else {
      scaffoldKey.currentState!.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () => UIHelpers.nextScreen(context, const SearchPage()),
              icon: const Icon(
                Icons.search,
              ),
            )
          ],
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Your chat",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
          iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        ),
        drawer: customDrawerWidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => popUpDiolog(context),
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
