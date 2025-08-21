import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/core/utils/message_with_chatid.dart';
import 'package:samvaad/core/utils/thumbnail.dart';
import 'package:image/image.dart' as img;

class MessageMaker {
  SendPort? isolateSendPort; // Store SendPort globally
  FlutterIsolate? isolate;
  bool isRunning = false;
  @pragma('vm:entry-point')
  static void getSendReadyImageMessage(SendPort sendPort) async {
    log("getSendReadyImageMessage called");

    await Firebase.initializeApp();
    ReceivePort receivePort = ReceivePort();
    Thumbnail thumbnail = Thumbnail();
    FileHandler fileHandler = FileHandler();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((event) async {
      if (event is String) {
        if (event == "STOP") {
          log("Stopping isolate...");
          FlutterIsolate.current.kill();
        }
      }
      if (event is Map<String, dynamic>) {
        MessageWithChatid messageWithChatid = MessageWithChatid.fromJson(event);

        File fileToUpload = File(messageWithChatid.message!.content!);
        log("path to file to upload ${fileToUpload.path}");
        File? thumbnailFile;

        if (messageWithChatid.message!.contentType == "image") {
          log("making  message back isolate");
          final data =
              await thumbnail.getImageThumbnailAndFileToUpload(fileToUpload);
          messageWithChatid.message!.extraInfo!.thumbnail =
              data.values.elementAt(0);
          thumbnailFile = fileToUpload;
        } else if (messageWithChatid.message!.contentType == "pdf" ||
            messageWithChatid.message!.contentType == "document") {
          log("making pdf message");
          final pdfThumb = await thumbnail.getPdfFirstPage(fileToUpload);
          messageWithChatid.message!.extraInfo!.thumbnail = pdfThumb;
          log("pdf message thumbnail $pdfThumb");
        } else if (messageWithChatid.message!.contentType == "video") {
          final VideoTrimmer opVideoTrimmer = VideoTrimmer();

          final thumbnailRaw =
              File(messageWithChatid.message!.extraInfo!.thumbnail!);
          thumbnailFile = thumbnailRaw;
          final thumbString =
              await thumbnail.compress.compressImageAsByte(thumbnailRaw);

          if (thumbString != null) {
            String thumnailString = base64Encode(thumbString!);
            log("file creted to send ");
            messageWithChatid.message!.extraInfo!.thumbnail = thumnailString;
          }
        }

        int imageHeight = 0, imageWidth = 0;

        if (thumbnailFile != null) {
          await getImageSize(thumbnailFile, (h, w) {
            imageHeight = h;
            imageWidth = w;
          });
        }

        log("image height and width new $imageHeight : $imageWidth");
        messageWithChatid.message!.extraInfo!.height = imageHeight;
        messageWithChatid.message!.extraInfo!.width = imageWidth;

        String fileDownloadUrl = await fileHandler.uploadFileToRemote(
            fileToUpload, "userGeneratedMedia");
        log("image file download url $fileDownloadUrl");
        messageWithChatid.message!.content = fileDownloadUrl;
        messageWithChatid.message!.messageStatus = "sent";

        log("message ready to send");
        sendPort.send(messageWithChatid.toJson());
      }
    });
  }

  static Future<void> getImageSize(
      File file, Function(int width, int height) onDone) async {
    Uint8List imageBytes = await file.readAsBytes();

    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      log("Width: ${image.width}");
      log("Height: ${image.height}");
      onDone(image.width, image.height);
    }
  }

  Future<MessageWithChatid> mediaMessageMaker(MessageWithChatid message) async {
    log("image message maker started");
    Completer<MessageWithChatid> messageCompleter = Completer();
    ReceivePort receivePort = ReceivePort();

    try {
      isolate = await FlutterIsolate.spawn(
          getSendReadyImageMessage, receivePort.sendPort);
      isRunning = true;
    } on Exception catch (e) {
      log("error $e");
    }
    receivePort.listen((event) {
      try {
        if (event is SendPort) {
          isolateSendPort = event;
          Map<String, dynamic> messageToSend = message.toJson();
          log("mesage in json ${messageToSend['message']}");
          event.send(messageToSend);
        } else {
          MessageWithChatid messageToSend = MessageWithChatid.fromJson(event);

          log("image message maker received message from isolate ${messageToSend.message!.messageId!} ");
          messageCompleter.complete(messageToSend);
        }
      } on Exception catch (e) {
        log("error in receiving message from image message maker $e");
      }
    });

    return messageCompleter.future;
  }

  void stopIsolate() {
    if (isRunning) {
      if (isolateSendPort != null) {
        log("Sending STOP signal to isolate...");
        isolateSendPort!.send("STOP");
        isolateSendPort = null;
      }
      isolate?.kill();
      isolate = null;
      isRunning = false;
      log("Isolate Stopped");
    }
  }
}

class IsolateMessage {
  MessageWithChatid messageWithChatid;
  SendPort sendData;

  IsolateMessage({required this.messageWithChatid, required this.sendData});
}
