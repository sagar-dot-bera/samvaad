import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:samvaad/core/services/rington_plyer.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/audio_files.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';

@RoutePage()
class PickSoundScreen extends StatefulWidget {
  AudioFileType audioFileType;
  PickSoundScreen({super.key, required this.audioFileType});

  @override
  State<PickSoundScreen> createState() => _PickSoundScreenState();
}

class _PickSoundScreenState extends State<PickSoundScreen> {
  String? selectedValue;
  List<String>? audioFileName;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.audioFileType == AudioFileType.ringtone) {
      selectedValue = AudioFiles.intance.ringtons.entries
          .firstWhere((entry) =>
              entry.value ==
              CurrentUserSetting.instance.userSetting.ringtoneSound)
          .key;
      audioFileName = List.from(AudioFiles.intance.ringtons.keys);
      RingtonPlayer.intance.setAudioPlyer();
    } else if (widget.audioFileType == AudioFileType.notification) {
      selectedValue = CurrentUserSetting.instance.userSetting.notificationSound;
      audioFileName = List.from(AudioFiles.intance.notificationTone.keys);
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop();
    audioFileName!.clear();
  }

  void setToneInUserSetting() {
    if (widget.audioFileType == AudioFileType.ringtone) {
      CurrentUserSetting.instance.userSetting.setRingtone =
          AudioFiles.intance.ringtons[selectedValue]!;
    } else if (widget.audioFileType == AudioFileType.notification) {
      CurrentUserSetting.instance.userSetting.setRingtone =
          AudioFiles.intance.notificationTone[selectedValue]!;
    }
    CurrentUserSetting.instance.saveUserSetting();
  }

  Future<void> playPickedSound() async {
    if (widget.audioFileType == AudioFileType.ringtone) {
      audioPlayer.setAudioSource(
          AudioSource.asset(AudioFiles.intance.ringtons[selectedValue]!));
    } else if (widget.audioFileType == AudioFileType.notification) {
      audioPlayer.setAudioSource(AudioSource.asset(
          AudioFiles.intance.notificationTone[selectedValue]!));
    }
    audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleMedium(text: "Selected Sound"),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.07,
                child: Card(
                  child: Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
                    child: TitleMedium(
                        text: selectedValue!.replaceRange(
                            0, 1, selectedValue![0].toUpperCase())),
                  ),
                ),
              ),
              TitleMedium(text: "Available sounds"),
              Flexible(
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                          title: TitleMedium(text: audioFileName![index]),
                          value: audioFileName![index],
                          groupValue: selectedValue,
                          onChanged: (value) {
                            playPickedSound();
                            setState(() {
                              selectedValue = value;
                              setToneInUserSetting();
                            });
                          });
                    },
                    itemCount: audioFileName!.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AudioFileType { notification, ringtone }
