import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/scroll_behavior.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/service/api_service.dart';
import 'package:flutter_chat_app/shared/constants.dart';
import 'package:flutter_chat_app/widgets/user_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? searchString;
  bool? isloading;
  List<ChatUser>? userList;

  @override
  void initState() {
    super.initState();
  }

  searchUser() async {
    if (mounted) setState(() => isloading = true);
    var strangerData = await APIService.searchUser(searchString ?? "");
    if (strangerData != null) {
      if (mounted) {
        setState(() {
          userList = strangerData.data;
          isloading = false;
        });
      }
    }
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
              searchUser();
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
                return UserTile(chatUser: userList![index]);
              },
            ),
          );
  }
}
