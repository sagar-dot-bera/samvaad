// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failed_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FailedMessageAdapter extends TypeAdapter<FailedMessage> {
  @override
  final int typeId = 44;

  @override
  FailedMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FailedMessage(
        message: fields[0] as Message, chatReference: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, FailedMessage obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
