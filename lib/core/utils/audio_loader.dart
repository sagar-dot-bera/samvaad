import 'package:just_audio/just_audio.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';

class AudioLoader {
  AudioPlayer audioPlayer = AudioPlayer();

  static final intance = AudioLoader._private();
  AudioLoader._private();

  factory AudioLoader() {
    return intance;
  }

  final ConcatenatingAudioSource systemAudios =
      ConcatenatingAudioSource(children: [
    AudioSource.asset("lib/assets/sound/busy-signal.mp3"),
    AudioSource.asset("lib/assets/sound/cell-phone-dial.mp3"),
  ]);

  Future<void> preloadAudio() async {
    audioPlayer.setAudioSource(systemAudios,
        preload: true, initialIndex: 0, initialPosition: Duration.zero);
  }
}
