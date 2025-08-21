import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/video.dart';
import 'package:video_compress/video_compress.dart';

class MediaHandler {
  HiveHandler hiveHandler = HiveHandler();
  LocalStorageHandler localStorageHandler = LocalStorageHandler();
  FetchFiles fetchFiles = FetchFiles(dio: Dio());
  Map<String, File> cache = {};
  List<String> downloadUrlCache = List.empty(growable: true);
  static final instance = MediaHandler._private();

  factory MediaHandler() {
    return instance;
  }

  MediaHandler._private();
  Future<File?> getMedia(String mediaId, String downloadUrl,
      MediaType typeOfMedia, String metaData,
      [String sender = "", String docExtension = ".pdf"]) async {
    if (metaData == "ProfilePicture" &&
        !downloadUrlCache.contains(downloadUrl) &&
        cache.containsKey(mediaId)) {
      await hiveHandler.deleteLocalFile([mediaId]);
      cache.remove(mediaId);
    }
    downloadUrlCache.add(downloadUrl);

    if (cache.containsKey(mediaId)) {
      log("file loaded from cache");
      return cache[mediaId];
    }

    //try to get image form local storage
    final localFIle = await hiveHandler.getLocalFile(mediaId);

    if (localFIle != null) {
      log("image loaded from local storage");
      //fetching image from local storage
      cache[mediaId] = localFIle;
      return localFIle;
    } else {
      log("image fetched form server (^_^)");
      //if image is not in local storage then fetch from server
      final data = await fetchFiles.fetchFile(downloadUrl);
      String? ext = await getSmartFileExtension(downloadUrl);
      log("file ext $ext");
      if (typeOfMedia == MediaType.audio) {
        ext = ".mp3";
      } else if (typeOfMedia == MediaType.video) {
        ext = ".mp4";
      } else if (typeOfMedia == MediaType.document) {
        ext = ".pdf";
      }
      if (data == null) return null;
      final tempDir = await getApplicationDocumentsDirectory();
      final path = '${tempDir.path}\\$mediaId$ext';
      final file = File(path);
      var ref = file.openSync(mode: FileMode.write);
      ref.writeFromSync(data);
      ref.close();
      log(" 888 download url is $ext");
      //store image in local storage for future use

      String filePath = "";
      if (typeOfMedia == MediaType.video) {
        log("download url is $ext");
        filePath = await localStorageHandler.videoLocalStorage(file, ext!);
      } else if (typeOfMedia == MediaType.image) {
        log("download url is $ext");
        filePath = await localStorageHandler.imageLocalStorage(file, ext!);
      } else if (typeOfMedia == MediaType.document) {
        filePath =
            await localStorageHandler.documentLocalStorage(file, docExtension);
      } else {
        log("no matching media type found unknown media type");
      }
      if (filePath.isNotEmpty) {
        String mediaType = mediaTypeToString(typeOfMedia);
        log("File saved on hive local storage");
        cache[mediaId] = File(filePath);
        hiveHandler.setLocalFile(
            mediaId, filePath, sender, mediaType, metaData);
      } else {
        log("File path is empty cannot save user image");
      }

      return file;
    }
  }

  String? getExtensionFromPath(String path) {
    final uri = Uri.parse(path);
    final segments = uri.pathSegments;
    if (segments.isEmpty) return null;

    final lastSegment = segments.last;
    final dotIndex = lastSegment.lastIndexOf('.');

    if (dotIndex == -1 || dotIndex == lastSegment.length - 1) return null;

    return lastSegment.substring(dotIndex).toLowerCase();
  }

  Future<String?> getSmartFileExtension(String url) async {
    final dio = Dio();

    try {
      final response = await dio.head(url);
      final contentType = response.headers.value('content-type');
      final extFromUrl = getExtensionFromPath(url);

      switch (contentType) {
        case 'image/jpeg':
          return '.jpg';
        case 'image/png':
          return '.png';
        case 'image/webp':
          return '.webp';
        case 'video/mp4':
          return '.mp4';
        case 'audio/mpeg':
          return '.mp3';
        case 'application/pdf':
          return '.pdf';
        // Add more as needed
      }

      return extFromUrl;
    } catch (e) {
      print('Error getting content type: $e');
      return getExtensionFromPath(url);
    }
  }

  File? getFileFromCache(String mediaId) {
    if (cache.containsKey(mediaId)) {
      return cache[mediaId];
    } else {
      return null;
    }
  }

  Future<void> localStoragePreFetch(List<String> mediaIds) async {
    for (var element in mediaIds) {
      await storeFileInCache(element);
    }
  }

  Future<void> storeFileInCache(String mediaId) async {
    File? localFileCopy = await hiveHandler.getLocalFile(mediaId);
    if (localFileCopy != null) {
      cache[mediaId] = localFileCopy;
    }
  }

  String mediaTypeToString(MediaType mediaType) {
    if (mediaType == MediaType.image) {
      return "image";
    } else if (mediaType == MediaType.audio) {
      return "audio";
    } else if (mediaType == MediaType.document) {
      return "document";
    } else if (mediaType == MediaType.video) {
      return "video";
    } else {
      return "unknown";
    }
  }

  Future<Video?> getVideoThumbnailAndVideo(File videoFile) async {
    try {
      Video? videoThumbnailFile;
      log("file path $videoFile");
      final thumbnailFile = await getFileThumbnail(videoFile);
      videoThumbnailFile = Video(video: videoFile, thumbnail: thumbnailFile);

      log("video file path ${videoThumbnailFile.video.path}");
      return videoThumbnailFile;
    } on Exception catch (e) {
      log("Error $e");
      return null;
    }
  }

  Future<File> getFileThumbnail(File file) async {
    final thumbnail =
        await VideoCompress.getFileThumbnail(file.path, quality: 100);
    log("thumbnail path ${thumbnail.path}");
    return thumbnail;
  }

  Future<PdfDocument?> getPdfDocument(File file) async {
    final tempPdf = await PdfDocument.openFile(file.path);
    return tempPdf;
  }

  Map<String, dynamic> decodeContact(String encodeContact) {
    Map<String, dynamic> contact = jsonDecode(encodeContact);

    return contact;
  }

  Future<void> removeMedia(String mediaId) async {
    cache.remove(mediaId);
    await hiveHandler.removeLocalFile(mediaId);
  }
}
