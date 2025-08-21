import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/screens/message_screens/send_image_preview_screen.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:video_trimmer/video_trimmer.dart';

@RoutePage()
class SendVideoScreen extends StatefulWidget {
  List<File> files;
  ChatHandlerViewModel messageChangeNotifier;
  SendVideoScreen(
      {super.key, required this.files, required this.messageChangeNotifier});

  @override
  State<SendVideoScreen> createState() => _SendVideoScreenState();
}

class _SendVideoScreenState extends State<SendVideoScreen> {
  final Trimmer _trimmer = Trimmer();
  final _key = GlobalKey<FormState>();

  TextEditingController capitionTextControler = TextEditingController();
  FocusNode capitionTextFocusNode = FocusNode();
  final VideoTrimmer opVideoTrimmer = VideoTrimmer();
  double _startValue = 0.0;
  double _endValue = 0.0;
  File? thumbnail;
  LocalStorageHandler localStorageHandler = LocalStorageHandler();
  bool isLoading = false;

  bool _isPlaying = false;

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.files.first);
  }

  Future<void> sendImageFile(File file) async {
    String captionString = capitionTextControler.text.trim().isNotEmpty
        ? capitionTextControler.text.trim()
        : "NaN";
    int startValue = (_startValue * 1000).round();
    int endValue = (_endValue * 1000).round();

    String? filePath;
    log("$startValue and $endValue");
    await _trimmer.saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        onSave: (outputPath) async {
          filePath = outputPath;
          log("video trimmed $outputPath");
          await opVideoTrimmer.loadVideo(widget.files.first.path);
          final thumb = await opVideoTrimmer.getVideoThumbnail(
              positionMs: 1000, quality: 80);
          File? thumbnail;
          if (thumb != null) {
            log("video loaded");
            thumbnail =
                File(await localStorageHandler.imageLocalStorage(File(thumb)));
          }

          if (filePath == null) {
            log("unable to trime video");

            return;
          }
          String thumbnailPath = thumbnail!.path;

          File fileToSend = File(filePath!);
          widget.messageChangeNotifier.sendMessageWithFile(fileToSend, 'video',
              ExtraInfo(caption: captionString, thumbnail: thumbnailPath));
        });
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: HeadlineMedium(text: "Share video"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Visibility(
                visible: isLoading,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.neutralWhite,
                )),
            TrimViewer(
              trimmer: _trimmer,
              viewerHeight: 50.0,
              viewerWidth: MediaQuery.of(context).size.width,
              maxVideoLength: const Duration(seconds: 10),
              onChangeStart: (startValue) => _startValue = startValue,
              onChangeEnd: (endValue) => _endValue = endValue,
              onChangePlaybackState: (value) =>
                  setState(() => _isPlaying = value),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                      child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      VideoViewer(trimmer: _trimmer),
                    ],
                  )),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: _isPlaying
                          ? Icon(
                              Icons.pause,
                              size: 80.0,
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.play_arrow,
                              size: 80.0,
                              color: Colors.white,
                            ),
                      onPressed: () async {
                        bool playbackState =
                            await _trimmer.videoPlaybackControl(
                          startValue: _startValue,
                          endValue: _endValue,
                        );
                        setState(() {
                          _isPlaying = playbackState;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CapitionBox(
                            capitionTextFocusNode: capitionTextFocusNode,
                            capitionTextControler: capitionTextControler,
                            key: _key),
                        SizedBox(
                          height: 12.0,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: FloatingActionButton.extended(
                              icon: const Icon(FeatherIcons.send),
                              onPressed: () async {
                                await sendImageFile(widget.files.first);
                                if (!isLoading) {
                                  context.router.maybePop();
                                }
                              },
                              label: const Text(
                                "Send",
                                style: TextStyle(fontSize: 16.0),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
