import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_function.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/authentication.dart';
import 'package:flutter_chat_app/service/database.dart';
import 'package:flutter_chat_app/service/file_firebase.dart';
import 'package:flutter_chat_app/shared/gets.dart';
import 'package:flutter_chat_app/widgets/form_input.dart';
import 'package:flutter_chat_app/widgets/group_tile.dart';
import 'package:flutter_chat_app/widgets/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Authentication authentication = Authentication();
  ImagePicker picker = ImagePicker();
  File? userAvatar;
  String? userName;
  String? email;
  String? avatar;
  String groupAvatar = "";
  Stream? groups;
  bool _isloading = false;
  String? groupName;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const SearchPage());
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Tiến's Messenger",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          children: [
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  avatar != ""
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image(
                            image: NetworkImage(avatar!),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.medium,
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 150,
                          color: Colors.blueGrey,
                        ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50)),
                      child: InkWell(
                        onTap: () => {showImagePicker(context, chooseImage)},
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              userName!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Divider(height: 2),
            ListTile(
              onTap: () => {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Nhóm",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () => {
                nextScreen(
                    context,
                    ProfilePage(
                      username: userName!,
                      email: email!,
                    ))
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.verified_user),
              title: const Text(
                "Thông tin cá nhân",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async => {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Đăng xuất"),
                      content: const Text("Bạn có muốn đăng xuất?"),
                      actions: [
                        IconButton(
                            onPressed: () => {Navigator.pop(context)},
                            icon: const Icon(Icons.cancel, color: Colors.red)),
                        IconButton(
                            onPressed: () async => {
                                  authentication.signOut(),
                                  nextScreen(context, const LoginPage())
                                },
                            icon: const Icon(Icons.done, color: Colors.green)),
                      ],
                    );
                  },
                ),
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Đăng xuất",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {popUpDiolog(context)},
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  popUpDiolog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Tạo ra 1 nhóm',
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isloading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          onChanged: (value) => {
                            setState(() => {groupName = value})
                          },
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text(
                    'Hủy',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isloading = true;
                      });
                      Database(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(
                              userName!,
                              FirebaseAuth.instance.currentUser!.uid,
                              groupName!)
                          .whenComplete(() => {_isloading = false});
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Nhóm được tạo thành công");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text('Tạo'),
                )
              ],
            );
          },
        );
      },
    );
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length > 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    Database()
                        .getGroupAvatar(
                            getId(snapshot.data['groups'][reverseIndex]))
                        .then((value) => groupAvatar = value);
                    return GroupTile(
                        userName: snapshot.data['fullName'],
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        groupAvatar: groupAvatar);
                  },
                );
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor));
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(),
          GestureDetector(
            onTap: () {
              popUpDiolog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[700], size: 75),
          ),
          const SizedBox(height: 20),
          const Text(
            'Bạn chưa vào nhóm nào',
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  getUserData() async {
    await Helper.getUserName().then((value) => {
          setState(() => {email = value!})
        });
    await Helper.getUserEmail().then((value) => {
          setState(() => {userName = value!})
        });
    await Helper.getUserAvatar().then((value) => {
          setState(() => {avatar = value!})
        });
    await Database(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshots) {
      setState(() {
        groups = snapshots;
      });
    });
  }

  chooseImage(ImageSource src) async {
    await picker.pickImage(source: src, imageQuality: 100).then(
          (value) => {
            if (value != null)
              {
                cropImage(value.path).then((value) {
                  FileFirebase().uploadImage(userAvatar!, "avatar").then(
                    (value) {
                      setState(
                        () => {avatar = value},
                      );
                      Database(uid: FirebaseAuth.instance.currentUser!.uid)
                          .updateAvatar(value);
                    },
                  );
                }),
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
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Cắt ảnh",
        )
      ],
    );
    if (croppedImage != null) {
      imageCache.clear();
      setState(() {
        userAvatar = File(croppedImage.path);
      });
    }
  }
}
