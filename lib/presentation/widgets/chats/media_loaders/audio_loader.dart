import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/audio_file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class AudioMessagePlayerWidget extends StatefulWidget {
  File audioFile;
  double sliderWidth;
  AudioMessagePlayerWidget(
      {super.key, required this.audioFile, this.sliderWidth = 170});

  @override
  State<AudioMessagePlayerWidget> createState() =>
      _AudioMessagePlayerWidgetState();
}

class _AudioMessagePlayerWidgetState extends State<AudioMessagePlayerWidget> {
  AudioPlayer? player; // Lazy initialization
  bool isPlaying = false;
  Duration currentDuration = Duration.zero;

  void loadAudio() async {
    if (player == null) {
      player = AudioPlayer();
      await player!.setFilePath(widget.audioFile.path);

      player!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            player!.seek(Duration.zero);
            player!.stop();
            isPlaying = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
      widget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(isPlaying ? FeatherIcons.pause : FeatherIcons.play),
            onPressed: () {
              if (isPlaying) {
                player!.pause();
              } else {
                player!.play();
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
          ),
          if (player != null)
            StreamBuilder<Duration>(
              stream: player!.positionStream,
              builder: (context, snapshot) {
                return SizedBox(
                  width: 170,
                  child: Slider(
                    value: snapshot.data?.inSeconds.toDouble() ?? 0,
                    max: player!.duration?.inSeconds.toDouble() ?? 1,
                    onChanged: (value) {
                      player!.seek(Duration(seconds: value.toInt()));
                      if (!isPlaying) {
                        player!.play();
                        setState(() {
                          isPlaying = true;
                        });
                      }
                    },
                    inactiveColor: AppColors.neutralGrayLight,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ProgressBarState {
  final Duration currentValue;
  final Duration maxValue;

  ProgressBarState({required this.currentValue, required this.maxValue});
}

class PendingAudioMessage extends StatelessWidget {
  PendingAudioMessage({super.key});

  final slider = SleekCircularSlider(
    appearance: CircularSliderAppearance(
        customWidths: CustomSliderWidths(progressBarWidth: 10)),
    min: 10,
    max: 28,
    initialValue: 14,
  );
  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Row(
      children: [
        Stack(
          children: [
            IconButton(onPressed: () {}, icon: Icon(FeatherIcons.headphones)),
            Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        width: 36,
                        height: 36,
                        child: SizedBox()) //CircularProgressIndicator()),
                    ))
          ],
        ),
        SizedBox(
          width: 170,
          child: Slider(
            value: 10,
            onChanged: (value) {},
            max: 10,
            inactiveColor: AppColors.brandColorLightGray,
            allowedInteraction: SliderInteraction.tapOnly,
          ),
        )
      ],
    ));
  }
}

class MessageContainer extends StatelessWidget {
  Widget widget;
  MessageContainer({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.neutralGray.withValues(alpha: 0.5),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: 1,
              color: Colors.black26,
            )
          ]),
      child: widget,
    );
  }
}

class AudioLoader extends StatefulWidget {
  final Message message;
  const AudioLoader({super.key, required this.message});

  @override
  State<AudioLoader> createState() => _AudioLoaderState();
}

class _AudioLoaderState extends State<AudioLoader> {
  bool doesUserWantsToDownload = false;
  bool isDownloaded = false;
  bool isCheking = true;
  HiveHandler hiveHandler = HiveHandler();

  @override
  void initState() {
    super.initState();
    hiveHandler
        .checkIfFileIsDownloaded(widget.message.messageId!)
        .then((value) {
      setState(() {
        isDownloaded = value;
        isCheking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.messageStatus == "sent" && doesUserWantsToDownload ||
        isDownloaded) {
      return MediaLoaderWidget(
          mediaType: MediaType.image, message: widget.message);
    } else if (widget.message.messageStatus == "pending") {
      return PendingAudioMessage();
    } else if (isCheking) {
      return AudioFileChecking();
    } else if (!isCheking) {
      return AudioPlayerWithDownloadButton(onDownloadPress: () {
        setState(() {
          doesUserWantsToDownload = true;
        });
      });
    } else {
      return SizedBox(
        child: Text("nathi khabar su karvanu che"),
      );
    }
  }
}
