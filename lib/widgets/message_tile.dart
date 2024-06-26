// ignore_for_file: must_be_immutable

import 'dart:io';

import "package:flutter/material.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_app/common/shared_preferences.dart';
import 'package:flutter_chat_app/common/ui_helpers.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/shared/constants.dart';
import 'package:flutter_chat_app/widgets/seekbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:http/http.dart' as http;

class MessageTile extends StatefulWidget {
  Message message;
  bool sentbyme;

  MessageTile({Key? key, required this.message, required this.sentbyme}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  VideoPlayerController? videoPlayerController;
  Future<void>? initializedVideoPlayerFuture;
  bool isPlaying = false;
  bool isPlayMusic = false;
  AudioPlayer? audioPlayer;
  Stream<SeekBarData>? seekBarDataStream;
  bool isDarkMode = SharedPreference.getDarkMode() ?? false;

  @override
  void initState() {
    super.initState();
    if (widget.message.messageType == "video") {
      videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.message.medias![0].originalUrl!));
      initializedVideoPlayerFuture = videoPlayerController!.initialize();
      videoPlayerController!.addListener(() {
        if (videoPlayerController!.value.position == videoPlayerController!.value.duration) {
          setState(() => isPlaying = false);
        }
      });
      videoPlayerController!.setVolume(1.0);
    }
    if (widget.message.messageType == "audio") {
      setState(() {
        initializeAudio();
      });
    }
    if (widget.message.messageType == "others") {}
  }

  initializeAudio() async {
    audioPlayer = AudioPlayer();
    await audioPlayer!.setUrl(widget.message.medias![0].originalUrl!);
    audioPlayer!.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setState(() {
          isPlayMusic = false;
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
        });
      }
    });
    setState(() {
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
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.message.messageType == "video") {
      videoPlayerController!.dispose();
    }
    if (widget.message.messageType == "audio") {
      audioPlayer!.dispose();
    }
  }

  downloadFile(String url, String fileName) async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      try {
        final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json"});
        Directory? directory;
        if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) directory = await getExternalStorageDirectory();
        }
        String downloadPath = directory!.path;
        File file = File('$downloadPath/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        if (context.mounted) UIHelpers.showSnackBar(context, Colors.green, "file saved successfully");
      } catch (value) {
        if (context.mounted) UIHelpers.showSnackBar(context, Colors.red, value.toString());
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  showMessageModal({Function? download}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                download;
                Navigator.pop(context);
              },
              leading: const Icon(Icons.download),
              title: const Text("Download"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: widget.sentbyme ? 0 : 24, right: widget.sentbyme ? 24 : 0),
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: widget.sentbyme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.sender!.name!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            if (widget.message.messageType == "image")
              for (int i = 0; i < widget.message.medias!.length; i++)
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
                    imageUrl: widget.message.medias![i].originalUrl!,
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
            if (widget.message.messageType == "video")
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
                        color: Constants.primaryColor,
                      ),
                    )
                  ],
                ),
              ),
            if (widget.message.messageType == "text")
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[400],
                ),
                child: Text(
                  widget.message.content!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.sentbyme ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
              ),
            if (widget.message.messageType == "audio")
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[400],
                ),
                child: InkWell(
                  onLongPress: () async {
                    showMessageModal(
                      download: await downloadFile(
                        widget.message.medias![0].originalUrl!,
                        widget.message.medias![0].fileName!,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (isPlayMusic) {
                              isPlayMusic = false;
                              audioPlayer!.pause();
                            } else {
                              isPlayMusic = true;
                              audioPlayer!.play();
                            }
                          });
                        },
                        child: Icon(
                          isPlayMusic ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
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
                    ],
                  ),
                ),
              ),
            if (widget.message.messageType == "others")
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
                  color: widget.sentbyme ? Colors.blue : Colors.grey[400],
                ),
                child: InkWell(
                  onLongPress: () async {
                    showMessageModal(
                      download: await downloadFile(
                        widget.message.medias![0].originalUrl!,
                        widget.message.medias![0].fileName!,
                      ),
                    );
                  },
                  onTap: () {
                    // showDialog(
                    //   barrierDismissible: false,
                    //   context: context,
                    //   builder: (context) {
                    //     return StatefulBuilder(
                    //       builder: (context, setState) {
                    //         return AlertDialog(
                    //           title: const Text('Download file?', textAlign: TextAlign.left),
                    //           actions: [
                    //             ElevatedButton(
                    //               onPressed: () => Navigator.of(context).pop(),
                    //               style: ElevatedButton.styleFrom(
                    //                 backgroundColor: Theme.of(context).primaryColor,
                    //                 padding: const EdgeInsets.all(10),
                    //               ),
                    //               child: const Text('No'),
                    //             ),
                    //             ElevatedButton(
                    //               onPressed: () => downloadFile(widget.files[0].toString(), widget.fileNames[0].toString()),
                    //               style: ElevatedButton.styleFrom(
                    //                 backgroundColor: Theme.of(context).primaryColor,
                    //                 padding: const EdgeInsets.all(10),
                    //               ),
                    //               child: const Text('Yes'),
                    //             )
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    // );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.file_open, color: Colors.white),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.message.medias![0].fileName!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                color: widget.sentbyme ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
                              ),
                            ),
                            Text(
                              widget.message.medias![0].humanReadableSize!,
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.sentbyme ? Colors.white : (isDarkMode ? Colors.white : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
