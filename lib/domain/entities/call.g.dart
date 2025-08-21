// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallAdapter extends TypeAdapter<Call> {
  @override
  final int typeId = 98;

  @override
  Call read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Call(
      withUser: fields[0] as User?,
      callType: fields[1] as CallType?,
      timeStamp: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Call obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.withUser)
      ..writeByte(1)
      ..write(obj.callType)
      ..writeByte(3)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
