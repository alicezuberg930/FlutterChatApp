import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/service/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  QuerySnapshot? searchSnapshot;
  QuerySnapshot? userSnapshot;
  String? searchString;
  String? password;
  bool hasUserSearch = false;
  bool isloading = false;
  List<ChatUser>? userList;

  @override
  void initState() {
    super.initState();
  }

  searchUser() async {
    isloading = false;
    var strangerData = await APIService.searchUser(searchString ?? "");
    print(strangerData);
    if (strangerData != null) {
      setState(() {
        userList = strangerData.data;
        isloading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isloading
          ? Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            )
          : SizedBox(child: searchList()),
    );
  }

  searchList() {
    return userList == null || userList!.isEmpty
        ? const SizedBox.shrink()
        : ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return ListTile();
            },
          );
  }
}
