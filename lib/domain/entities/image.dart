import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'image.g.dart';

@HiveType(typeId: 0)
class LocalImage {
  @HiveField(0)
  final String imageId;
  @HiveField(1)
  final Uint8List imageData;

  const LocalImage({required this.imageData, required this.imageId});
}
