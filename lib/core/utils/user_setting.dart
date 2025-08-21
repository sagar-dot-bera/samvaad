// ignore_for_file: prefer_final_fields, unused_field

import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
// ignore: unused_import
import 'package:samvaad/domain/entities/user.dart';

part 'user_setting.g.dart';

@HiveType(typeId: 33)
class UserSetting {
  @HiveField(0)
  String? userBackgroundWallpaper = "lib/assets/image/chat_background_3.jpg";
  @HiveField(1)
  int _chatBubbleColor = 0;
  @HiveField(2)
  bool _isEnterSend = true;
  @HiveField(3)
  bool _isMediaVisible = false;
  @HiveField(4)
  bool _isPrivateChatNotificationOn = true;
  @HiveField(5)
  bool _isGroupChatNotificationOn = true;
  @HiveField(6)
  bool _isShowBadgeIcon = false;
  @HiveField(7)
  bool _conversationToneOn = false;
  @HiveField(8)
  String _notificationSound = "default";
  @HiveField(9)
  String _ringtoneSound = "default";
  @HiveField(10)
  String _ringtoneSoundUrl = "lib/assets/sound/default_rington.mp3";
  @HiveField(11)
  String _notificationSoundUrl = "lib/assets/sound/simple_notification.mp3";
  @HiveField(12)
  String selectedMessageFont = "Medium";

  Future<void> setChatBackgroundWallpaper(File file) async {
    log("user background wallpaper path $userBackgroundWallpaper");
    LocalStorageHandler localStorageHandler = LocalStorageHandler();

    String pathToImage = await localStorageHandler.imageLocalStorage(file);

    log("user background changed path to new wallpaper $userBackgroundWallpaper");
  }

  String getUserChatBackgroundImage() {
    return userBackgroundWallpaper ?? "";
  }

  set chatBackgroundSetter(String path) {
    userBackgroundWallpaper = path;
  }

  set setChatBubbleColor(int index) {
    if (index >= 0) {
      _chatBubbleColor = index;
    }
  }

  set setRingtone(String ring) {
    _ringtoneSoundUrl = ring;
  }

  set setNotificationSound(String sound) {
    _notificationSoundUrl = sound;
  }

  set setPrivateChatNotification(bool value) {
    _isPrivateChatNotificationOn = value;

    log("user setting updated is private chate notifaction set to $value");
  }

  set setGroupChatNotification(bool value) {
    _isGroupChatNotificationOn = value;

    log("user setting updated is group notifaction set to $value");
  }

  set setShowBadge(bool value) {
    _isShowBadgeIcon = value;

    log("user setting updated show badge notifaction set to $value");
  }

  set setConversationTone(bool value) {
    _conversationToneOn = value;

    log("user setting updated conversation tone set to $value");
  }

  set setEnterIsSend(bool value) {
    _isEnterSend = value;

    log("user setting updated Enter is send to $value");
  }

  set setMessageFont(String font) {
    selectedMessageFont = font;
  }

  int get chatBubbleColor => _chatBubbleColor;
  bool get isPrivateChatNotificationOn => _isPrivateChatNotificationOn;
  bool get isGroupChatNotificationON => _isGroupChatNotificationOn;
  bool get isShowBadgeIcon => _isShowBadgeIcon;
  bool get enterIsSend => _isEnterSend;
  bool get isConversationToneOn => _conversationToneOn;
  bool get isMediaVisible => _isMediaVisible;

  String get notificationSound => _notificationSound;
  String get ringtoneSound => _ringtoneSound;
  String get ringtoneSoundUrl => _ringtoneSoundUrl;
}
