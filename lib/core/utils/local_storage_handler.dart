import 'dart:developer';
import 'dart:io';

import 'package:hive_flutter/adapters.dart';
import 'package:nanoid/nanoid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/local_file.dart';
import 'package:samvaad/domain/entities/user.dart';

class LocalStorageHandler {
  HiveHandler hiveHandler = HiveHandler();
  Future<String> imageLocalStorage(File file, [String? docExtension]) async {
    //create or if exit get path of directory to store image
    Directory imageDirectory = await createDirectory('image');
    //create  a file path to store image file
    String filePath = "";
    if (docExtension != null) {
      filePath = p.join(imageDirectory.path, '${nanoid()}$docExtension');
    } else {
      final ext = getExtensionFromPath(file.path);
      filePath = p.join(imageDirectory.path, '${nanoid()}.$ext');
    }
    //create file on path
    File newFile = await File(file.path).copy(filePath);
    log("new file created to store data ${newFile.path}");

    //return file path
    return newFile.path;
  }

  String? getExtensionFromPath(String path) {
    final uri = Uri.parse(path);
    final segments = uri.pathSegments;

    if (segments.isEmpty) return null;

    final lastSegment = segments.last;
    final dotIndex = lastSegment.lastIndexOf('.');

    if (dotIndex == -1 || dotIndex == lastSegment.length - 1) {
      return null; // No extension or dot at end
    }

    return lastSegment.substring(dotIndex); // includes the dot, e.g. ".jpg"
  }

  Future<Directory> createDirectory(String forFileType) async {
    final appDir = await getApplicationDocumentsDirectory();
    final appDirPath = appDir.path;

    final imagePath = p.join(appDirPath, forFileType);

    Directory appFileDirectory = Directory(imagePath);
    if (!await appFileDirectory.exists()) {
      await appFileDirectory.create(recursive: true);
    }

    return appFileDirectory;
  }

  Future<String> videoLocalStorage(File file, String docExtension) async {
    //create or if exit get path of directory to store video
    Directory videoDirectory = await createDirectory('video');
    String filePath = p.join(videoDirectory.path, '${nanoid()}$docExtension');
    File newFile = await File(file.path).copy(filePath);
    log("new file created to store data ${newFile.path}");

    return newFile.path;
  }

  Future<String> documentLocalStorage(File file, String docExtension) async {
    Directory videoDirectory = await createDirectory('document');
    String filePath = p.join(videoDirectory.path, '${nanoid()}.$docExtension');
    File newFile = await File(file.path).copy(filePath);
    log("new file created to store data ${newFile.path}");

    return newFile.path;
  }

  Future<String> audioLocalStorage(File file, String? docExtension) async {
    Directory videoDirectory = await createDirectory('audio');
    String filePath = p.join(videoDirectory.path, '${nanoid()}$docExtension');
    File newFile = await File(file.path).copy(filePath);
    log("new file created to store data ${newFile.path}");

    return newFile.path;
  }

  Future<String> makeTempPath(String docExtension) async {
    Directory makeTempPath = await getApplicationCacheDirectory();
    String filePath = p.join(makeTempPath.path, '${nanoid()}.$docExtension');
    return filePath;
  }

  // ignore: use_function_type_syntax_for_parameters
  Future<void> totalStorageCalculator(
      Function(
              double imageTotalSize,
              double audioTotalSize,
              double videoTotalSize,
              double documentTotoalSize,
              double totoalSize)
          onCalculationDone) async {
    try {
      List<LocalFile> localFiles = await hiveHandler.getAllLocalFiles();
      double imageFileSize = 0;
      double videoFileSize = 0;
      double totalFileSize = 0;
      double audioFileSize = 0;
      double documentFileSize = 0;
      int currentFileSize = 0;
      for (var element in localFiles) {
        log("**** File path ${element.filePath} ****\n****File type ${element.filePath}****,");
        currentFileSize = await calculateFileSize(element.filePath);
        if (element.fileType == "image") {
          imageFileSize = imageFileSize + currentFileSize;
          log("image file total size current value $imageFileSize");
        } else if (element.fileType == "video") {
          videoFileSize = videoFileSize + currentFileSize;
          log("video file total size current value $videoFileSize");
        } else if (element.fileType == "audio") {
          audioFileSize = audioFileSize + currentFileSize;
          log("audio file total size current value $audioFileSize");
        } else if (element.fileType == "document" ||
            element.fileType == "pdf") {
          documentFileSize = documentFileSize + currentFileSize;
          log("document file total size current value $documentFileSize");
        }
      }

      totalFileSize =
          imageFileSize + audioFileSize + videoFileSize + documentFileSize;
      onCalculationDone(imageFileSize, audioFileSize, videoFileSize,
          documentFileSize, totalFileSize);
    } on Exception catch (e) {
      log("Error in calculating file size $e");
    }
  }

  Future<int> calculateFileSize(String filePath) async {
    File file = File(filePath);

    if (await file.exists()) {
      return file.length();
    } else {
      return 0;
    }
  }

  (double, String) byteToUnitSize(double size) {
    double kbSize = byteSizeToKb(size);
    if (kbSize >= 1024) {
      double mbSize = kbSizeToMB(kbSize);
      return (mbSize, "MB");
    }
    return (kbSize, "KB");
  }

  double kbSizeToMB(double size) {
    double filesize = size / 1024;

    return filesize;
  }

  double byteSizeToKb(double size) {
    double filesize = size / 1024;

    return filesize;
  }

  Future<Map<User, String>> userWiseStorageUses(List<User> user) async {
    Map<User, String> result = {};

    List<LocalFile> localFiles = await hiveHandler.getAllLocalFiles();
    for (var element in user) {
      log("calculating toal storage of user with id ${element.phoneNo}");
      int currentUserStorage = 45;
      for (var file in localFiles) {
        if (file.sender == element.phoneNo!) {
          currentUserStorage =
              currentUserStorage + await calculateFileSize(file.filePath);
        }
      }
      log("total storage of user with id ${element.phoneNo} is ${currentUserStorage.toString()}");
      result[element] = currentUserStorage.toString();
    }

    return result;
  }

  Future<Map<String, List<LocalFile>>> specificUserFiles(String user) async {
    try {
      log("+++++++++++++++++++++++++++++++++++++++++++++++++==================================");
      Map<String, List<LocalFile>> localFiles = {};
      localFiles["image"] = List.empty(growable: true);
      localFiles["video"] = List.empty(growable: true);
      localFiles["doc"] = List.empty(growable: true);
      localFiles["audio"] = List.empty(growable: true);

      List<LocalFile> files = await hiveHandler.getAllLocalFiles();

      log("total files on local storage ${files.length}");
      if (files.isNotEmpty) {
        for (var element in files) {
          log("total files on local storage ${element.fileId} ${element.sender} ${element.metaData}");
          // if (element.sender == user) {
          log("file type ${element.fileType}");
          if (element.fileType == "image") {
            log("image file added to list of $user");
            localFiles["image"]!.add(element);
          } else if (element.fileType == "video") {
            log("video file added to list of $user");
            localFiles["video"]!.add(element);
          } else if (element.fileType == "audio") {
            log("audio file added to list of $user");
            localFiles["audio"]!.add(element);
          } else if (element.fileType == "document" ||
              element.fileType == "pdf") {
            log("doc file added to list of $user");
            localFiles["doc"]!.add(element);
          }
          // }
        }
      }

      return localFiles;
    } on Exception catch (e) {
      log("error in get specific user storage $e");
      return {};
    }
  }
}
