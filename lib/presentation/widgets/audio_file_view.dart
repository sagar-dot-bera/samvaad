import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/size.dart';

import 'package:samvaad/presentation/widgets/chats/media_loaders/audio_loader.dart';

class AudioFileView extends StatefulWidget {
  File audioFile;
  double sliderWidth;
  AudioFileView(
      {super.key, required this.audioFile, required this.sliderWidth});

  @override
  State<AudioFileView> createState() => _AudioFileViewState();
}

class _AudioFileViewState extends State<AudioFileView> {
  late AudioPlayer player = AudioPlayer();
  bool isplaying = false;
  double trackPoistion = 0;
  Duration currentDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.audioFile.path);

    player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          player.seek(Duration.zero);
          player.stop();
        });
      }
    });
  }

  Stream<ProgressBarState> getprogressStream(AudioPlayer player) {
    return Rx.combineLatest2<Duration, Duration?, ProgressBarState>(
        player.positionStream,
        player.durationStream,
        (currentValue, maxValue) => ProgressBarState(
            currentValue: currentValue, maxValue: maxValue ?? Duration.zero));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        padding: EdgeInsets.all(SizeOf.intance.getWidth(context, 0.03)),
        decoration: BoxDecoration(
            color: AppColors.neutralGrayLight,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            StreamBuilder<ProgressBarState>(
                stream: getprogressStream(player),
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return Text("no data");
                  } else {
                    log("max value ${snapshot.data!.maxValue.inSeconds.toDouble()} current value ${snapshot.data!.currentValue.inSeconds.toDouble()}");
                    currentDuration = snapshot.data!.currentValue;
                    return Row(
                      children: [
                        snapshot.data!.currentValue.inSeconds != 0 && isplaying
                            ? IconButton.outlined(
                                onPressed: () async {
                                  player.pause();
                                  isplaying = false;
                                },
                                icon: Icon(FeatherIcons.pause))
                            : IconButton.outlined(
                                onPressed: () async {
                                  player.seek(currentDuration);
                                  player.play();
                                  isplaying = true;
                                },
                                icon: Icon(FeatherIcons.play)),
                        SizedBox(
                          width: widget.sliderWidth,
                          child: Slider(
                            value: snapshot.data!.currentValue.inSeconds
                                .toDouble(),
                            onChanged: (value) {
                              log("on value changed called");
                              player.seek(Duration(seconds: value.toInt()));
                              player.play();
                              if (isplaying != true) {
                                isplaying = true;
                              }
                              log("is playing value $isplaying");
                            },
                            max: snapshot.data!.maxValue.inSeconds.toDouble(),
                            inactiveColor: AppColors.neutralGray,
                          ),
                        ),
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
