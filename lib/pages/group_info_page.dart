import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/user.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/shared/gets.dart';

class GroupInfoPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;
  final String groupAvatar;
  const GroupInfoPage({Key? key, required this.groupId, required this.groupName, required this.adminName, required this.groupAvatar}) : super(key: key);

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Thông tin nhóm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Thoát nhóm"),
                    content: const Text("Bạn có chắc chắn thoát khỏi nhóm?"),
                    actions: [
                      IconButton(
                        onPressed: () => {Navigator.pop(context)},
                        icon: const Icon(Icons.cancel, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () async {
                          ChatUser? chatUser;
                        },
                        icon: const Icon(Icons.done, color: Colors.green),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  widget.groupAvatar != ""
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            widget.groupAvatar,
                          ),
                        )
                      : CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            widget.groupName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nhóm: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length > 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index]).substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }
}
