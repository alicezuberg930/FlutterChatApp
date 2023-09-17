// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_app/widgets/custom_image_network.dart';

class MessageTile extends StatefulWidget {
  final String content;
  final String sender;
  final bool sentbyme;
  final String messageType;
  dynamic photos;

  MessageTile({
    Key? key,
    required this.content,
    required this.sender,
    required this.sentbyme,
    required this.messageType,
    this.photos,
  }) : super(key: key);

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
            if (widget.messageType == "image")
              for (int i = 0; i < widget.photos.length; i++)
                ClipRRect(
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
                  child: CustomNetworkImage(imagePath: widget.photos[0]),
                ),
            if (widget.messageType == "text")
              Container(
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
                  widget.content,
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
