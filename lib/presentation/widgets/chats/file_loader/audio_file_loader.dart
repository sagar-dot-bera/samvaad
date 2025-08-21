import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/audio_loader.dart';

class AudioMessagePlayerWidget extends StatefulWidget {
  File audioFile;
  double sliderWidth;
  AudioMessagePlayerWidget(
      {super.key, required this.audioFile, this.sliderWidth = 185});

  @override
  State<AudioMessagePlayerWidget> createState() =>
      _AudioMessagePlayerWidgetState();
}

class _AudioMessagePlayerWidgetState extends State<AudioMessagePlayerWidget> {
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
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.neutralGray,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.black26,
              )
            ]),
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

class ProgressBarState {
  final Duration currentValue;
  final Duration maxValue;

  ProgressBarState({required this.currentValue, required this.maxValue});
}

class AudioFileChecking extends StatelessWidget {
  const AudioFileChecking({super.key});

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Stack(
      children: [
        PlaceHolderAudioPlayer(),
        Positioned.fill(child: CheckingText()),
      ],
    ));
  }
}

class GlassContainerWidget extends StatelessWidget {
  Widget childWidget;
  GlassContainerWidget({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black26.withValues(alpha: 0.3)),
      child: childWidget,
    );
  }
}

class PlaceHolderAudioPlayer extends StatelessWidget {
  const PlaceHolderAudioPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.audio_file_rounded),
        Slider(
          value: 10,
          onChanged: (value) {},
          max: 10,
        )
      ],
    );
  }
}

class AudioPlayerWithDownloadButton extends StatelessWidget {
  Function() onDownloadPress;
  AudioPlayerWithDownloadButton({super.key, required this.onDownloadPress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
            opacity: 0.5,
            child: MessageContainer(
              widget: PlaceHolderAudioPlayer(),
            )),
        Positioned.fill(
            child: GlassContainerWidget(
                childWidget: IconButton(
                    onPressed: onDownloadPress,
                    icon: Icon(Icons.file_download_outlined))))
      ],
    );
  }
}

class AudioPreviewDownloading extends StatelessWidget {
  const AudioPreviewDownloading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
            opacity: 0.5,
            child: MessageContainer(widget: PlaceHolderAudioPlayer())),
        Positioned.fill(
            child: Center(
          child: CircularProgressIndicator(),
        ))
      ],
    );
  }
}
