// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/group.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConversationInfoScreen extends StatefulWidget {
  ConversationInfoScreen({super.key, required this.type, this.group});

  final String type;
  Group? group;

  @override
  State<ConversationInfoScreen> createState() => _ConversationInfoScreenState();
}

class _ConversationInfoScreenState extends State<ConversationInfoScreen> {
  TextEditingController groupLink = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // avatar
            // name
            // turn off notification option ' video call ' audio call
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("Group QR Code"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: QrImageView(
                        data: widget.group!.link!,
                        version: QrVersions.auto,
                        size: 300,
                      ),
                    );
                  },
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.group),
            //   title: const Text("Join group"),
            //   onTap: () {
            //     showDialog(
            //       barrierDismissible: false,
            //       context: context,
            //       builder: (context) {
            //         return StatefulBuilder(
            //           builder: (context, setState) {
            //             return AlertDialog(
            //               title: const Text('', textAlign: TextAlign.left),
            //               content: Column(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   TextField(
            //                     controller: groupLink,
            //                     decoration: InputDecoration(
            //                       enabledBorder: OutlineInputBorder(
            //                         borderSide: BorderSide(color: Theme.of(context).primaryColor),
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       errorBorder: OutlineInputBorder(
            //                         borderSide: const BorderSide(color: Colors.red),
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       focusedBorder: OutlineInputBorder(
            //                         borderSide: BorderSide(color: Theme.of(context).primaryColor),
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                     ),
            //                   )
            //                 ],
            //               ),
            //               actions: [
            //                 ElevatedButton(
            //                   onPressed: () async {},
            //                   style: ElevatedButton.styleFrom(
            //                     backgroundColor: Theme.of(context).primaryColor,
            //                     padding: const EdgeInsets.all(10),
            //                   ),
            //                   child: const Text('Tạo'),
            //                 )
            //               ],
            //             );
            //           },
            //         );
            //       },
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }
}
