import "package:flutter/material.dart";
import "package:flutter_chat_app/widgets/custom_image_network.dart";
// import 'package:cached_network_image/cached_network_image.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentbyme;
  const MessageTile({Key? key, required this.message, required this.sender, required this.sentbyme}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentbyme ? 0 : 24, right: widget.sentbyme ? 24 : 0),
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          crossAxisAlignment: widget.sentbyme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            widget.message.contains("https://firebasestorage.googleapis.com/v0/b/flutterchatapp-6c211.appspot.com/o/")
                ? ClipRRect(
                    borderRadius: widget.sentbyme
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                    child: CustomNetworkImage(imagePath: widget.message),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: widget.sentbyme
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              )
                            : const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                        color: widget.sentbyme ? Colors.blue : Colors.grey[300]),
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: widget.sentbyme ? Colors.white : Colors.black),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
