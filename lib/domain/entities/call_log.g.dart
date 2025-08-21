// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallLogAdapter extends TypeAdapter<CallLog> {
  @override
  final int typeId = 15;

  @override
  CallLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallLog(
      callDetail: (fields[0] as Map).cast<String, dynamic>(),
      receivedOrAnswer: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CallLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.callDetail)
      ..writeByte(1)
      ..write(obj.receivedOrAnswer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
