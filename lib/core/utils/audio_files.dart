class AudioFiles {
  final Map<String, String> ringtons = {
    "basic_ring": "lib/assets/sound/ring_basic.mp3",
    "simsalabim_basic": "lib/assets/sound/ring_basic.mp3",
    "classic": "lib/assets/sound/classic.mp3",
    "default": "lib/assets/sound/default_rington.mp3",
    "basic": "lib/assets/sound/basic.mp3",
    "cruizin_beat": "lib/assets/sound/cruizin_beat.mp3"
  };

  final Map<String, String> notificationTone = {
    "beep_beep": "lib/assets/sound/beep_beep.mp3",
    "R2D2": "lib/assets/sound/r2d2.mp3",
    "pew_pew": "lib/assets/sound/pew_pew.mp3",
    "default": "lib/assets/sound/simple_notification.mp3",
    "Chime_ding": "lib/assets/sound/chime_ding.mp3",
    "simple notification": "lib/assets/sound/message_notification.mp3",
    "basic": "lib/assets/sound/new_message_tone.mp3"
  };

  static final intance = AudioFiles._private();

  AudioFiles._private();

  factory AudioFiles() {
    return intance;
  }
}
