import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:samvaad/core/utils/compress.dart';

class Thumbnail {
  Compress compress = Compress();
  Future<Map<File, String>> getImageThumbnailAndFileToUpload(File file) async {
    log("get image thumbnail called");
    final fileToUpload = await compress.compressImageFile(file);
    Uint8List? imageThumbnail = await compress.compressImageAsByte(file);
    String decodedString = bytesToString(imageThumbnail!);

    return {fileToUpload: decodedString};
  }

  String bytesToString(Uint8List byte) {
    String decodedString = base64Encode(byte);

    return decodedString;
  }

  Future<String?> getPdfFirstPage(File file) async {
    log("get pdf first page called");
    final pdf = await PdfDocument.openFile(file.path);
    final page = pdf.pages[0]; // First page
    final pageImage = await page.render();
    final image = pageImage != null ? await pageImage.createImage() : null;

    if (image == null) return null;

    final imgBytes = await image.toByteData(format: ImageByteFormat.png);
    final tempFilePath = await getApplicationCacheDirectory();

    File tempImageFile = File("${tempFilePath.path}/temp_image.png");
    await tempImageFile.writeAsBytes(imgBytes!.buffer.asUint8List());
    Uint8List? imageThumbnail =
        await compress.compressImageAsByte(tempImageFile);

    if (imageThumbnail == null) return null;

    return bytesToString(imageThumbnail);
  }
}
