import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/widgets/form_input.dart';
import 'package:flutter_chat_app/service/authentication.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  const ProfilePage({Key? key, required this.username, required this.email})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          children: <Widget>[
            const Icon(Icons.account_circle, size: 150, color: Colors.grey),
            const SizedBox(height: 15),
            Text(
              widget.username,
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
            const ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text(
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
                          actions: [
                            IconButton(
                                onPressed: () => {Navigator.pop(context)},
                                icon: const Icon(Icons.cancel,
                                    color: Colors.red)),
                            IconButton(
                                onPressed: () async => {
                                      authentication.signOut(),
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()))
                                    },
                                icon: const Icon(Icons.done,
                                    color: Colors.green)),
                          ],
                          content: const Text("Bạn có muốn đăng xuất?"));
                    }),
                authentication.signOut().whenComplete(
                    () => {nextScreenReplace(context, const LoginPage())})
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(
            Icons.account_circle,
            size: 200,
            color: Colors.grey,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tên đầy đủ',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                widget.username,
                style: const TextStyle(fontSize: 17),
              )
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Email',
                style: TextStyle(fontSize: 17),
              ),
              Text(
                widget.email,
                style: const TextStyle(fontSize: 17),
              )
            ],
          )
        ]),
      ),
    );
  }
}
