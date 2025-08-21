// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalFileAdapter extends TypeAdapter<LocalFile> {
  @override
  final int typeId = 1;

  @override
  LocalFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalFile(
      fileId: fields[0] as String,
      filePath: fields[1] as String,
      sender: fields[2] as String,
      fileType: fields[4] as String,
      metaData: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalFile obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fileId)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.sender)
      ..writeByte(4)
      ..write(obj.fileType)
      ..writeByte(5)
      ..write(obj.metaData);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
