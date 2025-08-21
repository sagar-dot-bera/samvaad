// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 3;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      sender: fields[0] as String?,
      receiver: (fields[1] as List?)?.cast<String>(),
      messageId: fields[6] as String?,
      timeStamp: fields[2] as String?,
      contentType: fields[3] as String?,
      content: fields[4] as String?,
      readBy: (fields[7] as Map?)?.cast<dynamic, dynamic>(),
      messageStatus: fields[5] as String?,
      messageNotVisible: (fields[8] as List?)?.cast<String>(),
      extraInfo: fields[9] as ExtraInfo?,
      quotedMessageId: fields[10] as String?,
      senderName: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.sender)
      ..writeByte(1)
      ..write(obj.receiver)
      ..writeByte(2)
      ..write(obj.timeStamp)
      ..writeByte(3)
      ..write(obj.contentType)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.messageStatus)
      ..writeByte(6)
      ..write(obj.messageId)
      ..writeByte(7)
      ..write(obj.readBy)
      ..writeByte(8)
      ..write(obj.messageNotVisible)
      ..writeByte(9)
      ..write(obj.extraInfo)
      ..writeByte(10)
      ..write(obj.quotedMessageId)
      ..writeByte(11)
      ..write(obj.senderName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageVisibilityAdapter extends TypeAdapter<MessageVisibility> {
  @override
  final int typeId = 4;

  @override
  MessageVisibility read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageVisibility(
      senderVisibility: fields[0] as bool?,
      receiverVisibility: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, MessageVisibility obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.senderVisibility)
      ..writeByte(1)
      ..write(obj.receiverVisibility);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageVisibilityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExtraInfoAdapter extends TypeAdapter<ExtraInfo> {
  @override
  final int typeId = 77;

  @override
  ExtraInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExtraInfo(
      caption: fields[0] as String?,
      width: fields[1] as int?,
      height: fields[2] as int?,
      fileName: fields[3] as String?,
      thumbnail: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ExtraInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.caption)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.fileName)
      ..writeByte(4)
      ..write(obj.thumbnail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtraInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
