// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalImageAdapter extends TypeAdapter<LocalImage> {
  @override
  final int typeId = 0;

  @override
  LocalImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalImage(
      imageData: fields[1] as Uint8List,
      imageId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.imageId)
      ..writeByte(1)
      ..write(obj.imageData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
