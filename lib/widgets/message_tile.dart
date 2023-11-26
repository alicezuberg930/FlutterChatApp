// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_app/widgets/seekbar.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MessageTile extends StatefulWidget {
  final String content;
  final String sender;
  final bool sentbyme;
  final String messageType;
  dynamic files;
  dynamic fileNames;

  MessageTile({
    Key? key,
    required this.content,
    required this.sender,
    required this.sentbyme,
    required this.messageType,
    this.files,
    this.fileNames,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  VideoPlayerController? videoPlayerController;
  Future<void>? initializedVideoPlayerFuture;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;
  Stream<SeekBarData>? seekBarDataStream;

  @override
  void initState() {
    super.initState();
    if (widget.messageType == "video") {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.files[0]));
      initializedVideoPlayerFuture = videoPlayerController!.initialize();
      videoPlayerController!.addListener(() {
        if (videoPlayerController!.value.position == videoPlayerController!.value.duration) {
          setState(() => isPlaying = false);
        }
      });
      videoPlayerController!.setVolume(1.0);
    }
    if (widget.messageType == "audio") {
      initializeAudio();
    }
  }

  initializeAudio() async {
    audioPlayer = AudioPlayer();
    seekBarDataStream = rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
      audioPlayer!.positionStream,
      audioPlayer!.durationStream,
      (Duration position, Duration? duration) {
        return SeekBarData(
          position: position,
          duration: duration ?? Duration.zero,
        );
      },
    );
    await audioPlayer!.setUrl(widget.files[0]);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.messageType == "video") {
      videoPlayerController!.dispose();
    }
    if (widget.messageType == "audio") {
      audioPlayer!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentbyme ? 0 : 24, right: widget.sentbyme ? 24 : 0),
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          crossAxisAlignment: widget.sentbyme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender,
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
              for (int i = 0; i < widget.files.length; i++)
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
                  child: CachedNetworkImage(
                    imageUrl: widget.files[i],
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red),
                  ),
                ),
            if (widget.messageType == "video")
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FutureBuilder(
                      future: initializedVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio: videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(videoPlayerController!),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (isPlaying) {
                            isPlaying = false;
                            videoPlayerController!.pause();
                          } else {
                            isPlaying = true;
                            videoPlayerController!.play();
                          }
                        });
                      },
                      iconSize: 70,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[300],
                ),
                child: Text(
                  widget.content,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16, color: widget.sentbyme ? Colors.white : Colors.black),
                ),
              ),
            if (widget.messageType == "audio")
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[300],
                ),
                child: StreamBuilder<SeekBarData>(
                  stream: seekBarDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      position: positionData?.position ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onchangeEnd: audioPlayer!.seek,
                    );
                  },
                ),
              ),
            if (widget.messageType == "others")
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[300],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.file_open, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      widget.fileNames[0].toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, color: widget.sentbyme ? Colors.white : Colors.black),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
