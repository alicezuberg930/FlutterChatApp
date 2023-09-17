import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/service/database.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot? searchSnapshot;
  QuerySnapshot? userSnapshot;
  String? username;
  String? password;
  User? user;
  bool hasUserSearch = false;
  bool _isloading = false;
  bool _isJoined = false;
  bool _isFriended = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Tìm kiếm',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) async {
                      if (value != "") {
                        setState(() {
                          _isloading = true;
                        });
                        await Database().searchGroups(value).then(
                              (snapshot) => {
                                setState(() {
                                  searchSnapshot = snapshot;
                                  _isloading = false;
                                  hasUserSearch = true;
                                })
                              },
                            );
                        await Database().searchUsers(value).then(
                              (snapshot) => {
                                setState(() {
                                  userSnapshot = snapshot;
                                  _isloading = false;
                                  hasUserSearch = true;
                                })
                              },
                            );
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên tìm kiếm',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(40)),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      groupList(),
                      userList(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  groupTile(String userName, String groupId, String groupName, String groupIcon) {
    checkUserJoined(userName, groupId, groupName);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: InkWell(
        onTap: () async {
          await Database(uid: user!.uid).toggleGroupJoin(groupId, groupName, userName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            if (context.mounted) UIHelpers.showSnackBar(context, Colors.green, 'Đã vào nhóm thành công');
            Future.delayed(const Duration(seconds: 2), () {
              // UIHelpers.nextScreen(
              //   context,
              //   ChatPage(
              //     groupId: groupId,
              //     groupName: groupName,
              //     userName: userName,
              //     groupAvatar: groupIcon,
              //   ),
              // );
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            if (context.mounted) UIHelpers.showSnackBar(context, Colors.red, 'Bạn đã ở trong nhóm');
          }
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, border: Border.all(color: Colors.white, width: 1)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Đã vào",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Vào nhóm",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  userTile(String userName, String strangerUid, String strangerName, String strangerAvatar) {
    checkUserFriended(strangerUid);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: strangerAvatar == ""
            ? const CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),
              )
            : CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(strangerAvatar),
              ),
      ),
      title: Text(
        strangerName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: InkWell(
        onTap: () async {
          // await Database(uid: user!.uid)
          //     .toggleGroupJoin(groupId, groupName, userName);
          // if (_isJoined) {
          //   setState(() {
          //     _isJoined = !_isJoined;
          //   });
          //   showSnackBar(context, Colors.green, 'Đã vào nhóm thành công');
          //   Future.delayed(const Duration(seconds: 2), () {
          //     nextScreen(
          //         context,
          //         ChatPage(
          //           groupId: groupId,
          //           groupName: groupName,
          //           userName: userName,
          //           groupAvatar: groupIcon,
          //         ));
          //   });
          // } else {
          //   setState(() {
          //     _isJoined = !_isJoined;
          //   });
          //   showSnackBar(context, Colors.red, 'Bạn đã ở trong nhóm');
          // }
        },
        child: _isFriended
            ? Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, border: Border.all(color: Colors.white, width: 1)),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Đã kết bạn",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Thêm bạn",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  groupList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                username!,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['groupIcon'],
              );
            },
          )
        : const SizedBox(width: 0, height: 0);
  }

  userList() {
    return hasUserSearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return userTile(username!, userSnapshot!.docs[index]['uid'], userSnapshot!.docs[index]['fullName'], userSnapshot!.docs[index]['profile_picture']);
            },
          )
        : const SizedBox(width: 0, height: 0);
  }

  checkUserJoined(String username, String groupId, String groupName) async {
    await Database(uid: user!.uid).isUserJoined(groupName, groupId, username).then((value) {
      setState(() {
        _isJoined = value;
      });
    });
  }

  checkUserFriended(String strangerUid) async {
    await Database(uid: user!.uid).isFriended(strangerUid).then((value) {
      setState(() {
        _isFriended = value;
      });
    });
  }
}
