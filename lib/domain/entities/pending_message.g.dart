// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingMessageAdapter extends TypeAdapter<PendingMessage> {
  @override
  final int typeId = 11;

  @override
  PendingMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingMessage(
      message: fields[0] as Message,
      chatid: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PendingMessage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.chatid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
