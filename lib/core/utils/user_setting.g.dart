// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingAdapter extends TypeAdapter<UserSetting> {
  @override
  final int typeId = 33;

  @override
  UserSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSetting()
      ..userBackgroundWallpaper = fields[0] as String?
      .._chatBubbleColor = fields[1] as int
      .._isEnterSend = fields[2] as bool
      .._isMediaVisible = fields[3] as bool
      .._isPrivateChatNotificationOn = fields[4] as bool
      .._isGroupChatNotificationOn = fields[5] as bool
      .._isShowBadgeIcon = fields[6] as bool
      .._conversationToneOn = fields[7] as bool
      .._notificationSound = fields[8] as String
      .._ringtoneSound = fields[9] as String
      .._ringtoneSoundUrl = fields[10] as String
      .._notificationSoundUrl = fields[11] as String
      ..selectedMessageFont = fields[12] as String;
  }

  @override
  void write(BinaryWriter writer, UserSetting obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userBackgroundWallpaper)
      ..writeByte(1)
      ..write(obj._chatBubbleColor)
      ..writeByte(2)
      ..write(obj._isEnterSend)
      ..writeByte(3)
      ..write(obj._isMediaVisible)
      ..writeByte(4)
      ..write(obj._isPrivateChatNotificationOn)
      ..writeByte(5)
      ..write(obj._isGroupChatNotificationOn)
      ..writeByte(6)
      ..write(obj._isShowBadgeIcon)
      ..writeByte(7)
      ..write(obj._conversationToneOn)
      ..writeByte(8)
      ..write(obj._notificationSound)
      ..writeByte(9)
      ..write(obj._ringtoneSound)
      ..writeByte(10)
      ..write(obj._ringtoneSoundUrl)
      ..writeByte(11)
      ..write(obj._notificationSoundUrl)
      ..writeByte(12)
      ..write(obj.selectedMessageFont);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
