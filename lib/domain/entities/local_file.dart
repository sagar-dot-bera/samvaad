import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'local_file.g.dart';

@HiveType(typeId: 1)
class LocalFile {
  @HiveField(0)
  final String fileId;
  @HiveField(1)
  final String filePath;
  @HiveField(2)
  final String sender;
  @HiveField(4)
  final String fileType;
  @HiveField(5)
  final String metaData;

  LocalFile({
    required this.fileId,
    required this.filePath,
    required this.sender,
    required this.fileType,
    required this.metaData,
  });
}
