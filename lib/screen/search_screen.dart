import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/model/user_friend.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/service/route_generator_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchScreen> {
  String? searchString;
  bool? isloading;
  List<ChatUser>? userList;
  APIService apiService = APIService();
  List<UserFriend> friendList = [];

  @override
  void initState() {
    getMyFriends();
    super.initState();
  }

  getMyFriends() async {
    var tempFriendList = await apiService.getMyFriends();
    setState(() {
      friendList = tempFriendList;
    });
  }

  searchUser() async {
    if (searchString!.trim().isEmpty) return;
    setState(() => isloading = true);
    List<ChatUser>? chatUserList = await apiService.searchUser(searchString ?? "");
    if (chatUserList != null) setState(() => userList = chatUserList);
    setState(() => isloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: TextField(
            style: const TextStyle(color: Colors.black45),
            onChanged: (value) {
              searchString = value;
              if (value.isNotEmpty) {
                searchUser();
              }
            },
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              hintText: "Search for user or group",
              border: InputBorder.none,
            ),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: isloading == true
            ? Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              )
            : SizedBox(child: searchList()),
      ),
    );
  }

  searchList() {
    return userList == null
        ? const SizedBox.shrink()
        : ScrollConfiguration(
            behavior: RemoveGlowingBehavior(),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: userList!.length,
              itemBuilder: (context, index) {
                int status = -1;
                for (var f in friendList) {
                  if (f.friendId == userList![index].id && f.isRequest == "0" && f.status == "0") {
                    status = 0;
                    break;
                  }
                  if (f.friendId == userList![index].id && f.isRequest == "1" && f.status == "0") {
                    status = 1;
                    break;
                  }
                  if (f.friendId == userList![index].id && f.status == "1") {
                    status = 2;
                    break;
                  }
                }
                return searchUserTile(user: userList![index], status: status);
              },
            ),
          );
  }

  searchUserTile({required ChatUser user, required int status}) {
    return InkWell(
      onTap: () {
        Navigator.of(Constants().navigatorKey.currentContext!).pushNamed(
          RouteGeneratorService.chatScreen,
          arguments: user,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.avatar!),
          ),
          title: Text(
            user.name!,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
          ),
          trailing: ElevatedButton(
            onPressed: () async {
              if (status == -1) {
                // send friend request
                final apiResponse = await apiService.addFriend(friendId: user.id!);
                if (apiResponse.allGood) {
                  await getMyFriends();
                  setState(() => status = 1);
                }
                if (context.mounted) {
                  UIHelpers.showSnackBar(
                    context,
                    apiResponse.allGood ? Colors.green : Colors.red,
                    apiResponse.message,
                  );
                }
                return;
              }
              if (status == 0) {
                // accept friend request
                final apiResponse = await apiService.acceptFriendRequest(friendId: user.id!);
                if (apiResponse.allGood) {
                  await getMyFriends();
                  setState(() => status = 2);
                }
                if (context.mounted) {
                  UIHelpers.showSnackBar(
                    context,
                    apiResponse.allGood ? Colors.green : Colors.red,
                    apiResponse.message,
                  );
                }
                return;
              }
              if (status == 2) {
                // unfriend
                final apiResponse = await apiService.unfriend(friendId: user.id!);
                if (apiResponse.allGood) {
                  await getMyFriends();
                  setState(() => status = -1);
                }
                if (context.mounted) {
                  UIHelpers.showSnackBar(
                    context,
                    apiResponse.allGood ? Colors.green : Colors.red,
                    apiResponse.message,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(status == -1
                ? "Kết bạn"
                : status == 0
                    ? "Chấp nhận"
                    : status == 1
                        ? "Đang chờ"
                        : "Hủy kết bạn"),
          ),
        ),
      ),
    );
  }
}
