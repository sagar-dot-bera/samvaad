import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';

class AudioMessageRecorderWidget extends StatefulWidget {
  const AudioMessageRecorderWidget({
    super.key,
  });

  @override
  State<AudioMessageRecorderWidget> createState() =>
      _AudioMessageRecorderWidgetState();
}

class _AudioMessageRecorderWidgetState
    extends State<AudioMessageRecorderWidget> {
  bool onLongPress = false;
  final recorder = AudioRecorder();
  LocalStorageHandler localStorageHandler = LocalStorageHandler();
  FileHandler fileHandler = FileHandler();
  HiveHandler hiveHandler = HiveHandler();
  Offset? startPosition;
  bool cancelRecording = false;

  Future<void> sendAudioMessage(File audioFile) async {
    log("uploading audio file ${audioFile.path} to main server ");
    final provider = Provider.of<ChatHandlerViewModel>(context, listen: false);

    await provider.sendMessageWithFile(audioFile, "audio", ExtraInfo());
    String filePath =
        await localStorageHandler.audioLocalStorage(audioFile, "m4a");

    log("message stored on local storage with file path $filePath");
  }

  @override
  Widget build(BuildContext context) {
    String tempPathForAudio = "";
    return GestureDetector(
      onLongPress: () async {
        setState(() {
          onLongPress = true;
        });
        log("long press started");
        if (await recorder.hasPermission()) {
          tempPathForAudio = await localStorageHandler.makeTempPath("m4a");

          final audioFile = await recorder.start(
              RecordConfig(
                  encoder: AudioEncoder.aacHe,
                  androidConfig:
                      AndroidRecordConfig(audioSource: AndroidAudioSource.mic)),
              path: tempPathForAudio);
        }
      },
      onLongPressMoveUpdate: (details) {
        log("swipe recorded");
        startPosition = details.localPosition;
      },
      onHorizontalDragEnd: (details) {},
      onLongPressEnd: (details) async {
        log("start dx value ${startPosition!.dx}");
        double dx = details.globalPosition.dx + startPosition!.dx;
        log("start value ${startPosition!.dx} end value ${details.globalPosition.dx}");
        log("dx value $dx  ");

        if (dx < -25) {
          log("recording canceled");
          setState(() {
            onLongPress = false;
            recorder.stop();
            cancelRecording = false;
          });
        } else {
          setState(() {
            onLongPress = false;
          });
        }
        if (!cancelRecording) {
          log("long press ended");

          String? path = await recorder.stop();
          if (path != null && path.isNotEmpty) {
            log("provided path $tempPathForAudio");
            log("audio stored on this path $path");
            sendAudioMessage(File(path));
          }
        } else {
          log("recording canceled");
        }
      },
      child: Builder(builder: (context) {
        return Container(
          margin: EdgeInsets.fromLTRB(4.0, 0.0, 6.0, 0.0),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: !onLongPress
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.accentGreen),
          child: Icon(FeatherIcons.mic,
              color: Theme.of(context).colorScheme.onPrimary),
        );
      }),
    );
  }
}
