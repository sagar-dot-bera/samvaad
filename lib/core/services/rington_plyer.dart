import 'package:just_audio/just_audio.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';

class RingtonPlayer {
  AudioPlayer audioPlayer = AudioPlayer();

  static final intance = RingtonPlayer._privateConstructor();

  RingtonPlayer._privateConstructor();

  Future<void> setAudioPlyer() async {
    await audioPlayer.setAudioSource(AudioSource.asset(
        CurrentUserSetting.instance.userSetting.ringtoneSoundUrl));
  }

  factory RingtonPlayer() {
    return intance;
  }

  Future<void> startPlaying() async {
    audioPlayer.play();
  }

  Future<void> stopPlaying() async {
    audioPlayer.stop();
  }
}
