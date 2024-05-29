import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_friend.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  bool isDarkMode = SharedPreference.getDarkMode() ?? false;
  List<ChatUser> selectedUser = [];
  List<ChatUser> friendList = [];
  Map<int, bool> selectedUserCheck = {};
  APIService? apiService = APIService();
  TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    getMyFriends();
    super.initState();
  }

  getMyFriends() async {
    List<UserFriend> userFriendlist = await apiService!.getMyFriends();
    List<ChatUser> tempFriendList = userFriendlist.map((user) => user.friend!).toList();
    if (tempFriendList.isNotEmpty) {
      setState(() {
        friendList = tempFriendList;
      });
      for (int i = 0; i < friendList.length; i++) {
        selectedUserCheck.addAll({friendList[i].id!: false});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedUser.length < 2) {
                UIHelpers.showSnackBar(context, Colors.red, "Please choose at least 2 people for your group");
              }
              try {
                final result = await apiService!.createGroup(
                  userIds: selectedUser.map((e) => e.id!).toList(),
                  groupName: groupNameController.text,
                );
                Navigator.of(Constants().navigatorKey.currentContext!).pushNamed(RouteGeneratorService.chatScreen, arguments: result);
              } catch (e) {
                if (mounted) UIHelpers.showSnackBar(context, Colors.red, e.toString());
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "New group",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black45 : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: groupNameController,
                decoration: const InputDecoration(
                  hintText: "Group Name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: 90,
              child: selectedUser.isEmpty
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedUser.length,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: NetworkImage(selectedUser[index].avatar!),
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
                                      selectedUser[index].name!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black45),
                                    ),
                                  )
                                ],
                              ),
                              Positioned(
                                top: -13,
                                right: -13,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedUserCheck[selectedUser[index].id!] = !selectedUserCheck[selectedUser[index].id!]!;
                                      selectedUser.remove(selectedUser[index]);
                                    });
                                  },
                                  splashRadius: 1,
                                  icon: const Icon(Icons.cancel_outlined, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
            ),
            SingleChildScrollView(
              child: ListView.builder(
                itemCount: friendList.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedUserCheck[friendList[index].id!] = !selectedUserCheck[friendList[index].id!]!;
                        if (selectedUserCheck[friendList[index].id!] == true && !selectedUser.contains(friendList[index])) {
                          selectedUser.add(friendList[index]);
                        }
                        if (selectedUserCheck[friendList[index].id!] == false) {
                          selectedUser.remove(friendList[index]);
                        }
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(friendList[index].avatar!),
                        ),
                        title: Text(
                          friendList[index].name!,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
                        ),
                        trailing: Checkbox(
                          onChanged: (check) {
                            setState(() {
                              selectedUserCheck[friendList[index].id!] = !selectedUserCheck[friendList[index].id!]!;
                              if (selectedUserCheck[friendList[index].id!] == true && !selectedUser.contains(friendList[index])) {
                                selectedUser.add(friendList[index]);
                              }
                              if (selectedUserCheck[friendList[index].id!] == false) {
                                selectedUser.remove(friendList[index]);
                              }
                            });
                          },
                          value: selectedUserCheck[friendList[index].id!],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
