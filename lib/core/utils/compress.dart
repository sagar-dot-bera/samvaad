import 'dart:io';

import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:nanoid/async.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';

class Compress {
  Future<File> compressImageFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(r'.jp');
    log(" value of last index $lastIndex");
    final splittedPath = filePath.substring(0, lastIndex);
    final outputPath = "${splittedPath}_out${filePath.substring(lastIndex)}";
    log("output path $outputPath");

    var result = await FlutterImageCompress.compressAndGetFile(
        filePath, outputPath,
        quality: 95);

    File compressedFile = File(result!.path);

    return compressedFile;
  }

  Future<Uint8List?> compressImageAsByte(File imageFile) async {
    var result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      quality: 02,
    );
    log("${imageFile.lengthSync()}");
    log("result!.length");
    return result;
  }

  Future<File?> compressVideo(
    File videoFile,
  ) async {
    try {
      log("compressing video file... input video path ${videoFile.path}");
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(videoFile.path,
          deleteOrigin: true,
          quality: VideoQuality.DefaultQuality,
          includeAudio: true);

      if (VideoCompress.isCompressing) {
        log("video is compressing");
      }

      if (mediaInfo != null) {
        log("compressed video file output path ${mediaInfo.path}");
        final tempFile = File(mediaInfo.path!);
        return tempFile;
      } else {
        log("file compress unsuccessful...");
      }
    } on Exception catch (e) {
      log("error $e");
      return null;
    }

    return null;
  }

  Future<File?> compressPdf(
    File file,
    String inputPath,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final outputPath = '${dir.path}//${nanoid()}.pdf';
      // await PdfCompressor.compressPdfFile(
      //     inputPath, outputPath, CompressQuality.MEDIUM);

      // File outputFile = File(outputPath);
      return file;
    } on Exception catch (e) {
      log("error in compressing pdf $e");
      return null;
    }
  }
}
