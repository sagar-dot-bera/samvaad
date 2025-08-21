import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/call_log.dart';
import 'package:samvaad/domain/entities/failed_message.dart';
import 'package:samvaad/domain/entities/image.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/pending_message.dart';

class FetchUserDataFromLocal {
  final pendingMessageBox = Hive.box<PendingMessage>("pendingMessages");

  HiveHandler hiveHandler = HiveHandler();
  Future<Uint8List?> fetchUserProfileLocal(String userId) async {
    final imageBox = await Hive.openBox<LocalImage>('local_images');
    //try to get image form local storage
    LocalImage? localImage = imageBox.get(userId);
    if (localImage != null) {
      log("image loaded from local storage");
      //fetching image from local storage
      return localImage.imageData;
    }

    return null;
  }

  Stream<Message> getPendingMessages(String chatId) async* {
    try {
      log("fetching pending messages...");
      final pendingMessageStreamController = StreamController<
          Message>(); //stream controller to handle pending message stream
      // pending message box

      //listens to changes in pending message box
      pendingMessageBox.watch().listen((event) {
        // added newly added message to pending list
        final pendingMessage = pendingMessageBox.get(event.key);
        if (pendingMessage != null) {
          pendingMessageStreamController.add(pendingMessage.message);
        }
      });
      yield* pendingMessageStreamController.stream;
    } on Exception catch (e) {
      log("error found in fetching pending message $e");
    }
  }

  Stream<Message> getFailedMessages(String chatId) async* {
    try {
      final failedMessageBox =
          await Hive.openBox<FailedMessage>("failed_msg_v5");
      log("fetching failed messages...");

      final failedMessageStreamController = StreamController<
          Message>(); //stream controller to handle pending message stream

      for (var element in failedMessageBox.values) {
        if (element.chatReference == chatId) {
          failedMessageStreamController.add(element.message);
        }
      }

      //listens to changes in pending message box
      failedMessageBox.watch().listen((event) {
        final failedMessage = failedMessageBox.get(event.key);
        if (failedMessage != null) {
          failedMessageStreamController.add(failedMessage.message);
        }
      });
      yield* failedMessageStreamController.stream;
    } on Exception catch (e) {
      log("error found in fetching pending message $e");
    }
  }

  Future<void> removePendingMessage(String messageId) async {
    await pendingMessageBox.delete(messageId);
  }

  Future<void> addPendingMessage(PendingMessage newPendingMessage) async {
    await pendingMessageBox.put(
        newPendingMessage.message.messageId, newPendingMessage);
  }

  Future<List<CallLog>> fetchCallLogs() async {
    return await hiveHandler.getCallLogs();
  }

  Future<void> addCallLog(CallLog callLog) async {
    await hiveHandler.setCallLog(callLog);
  }

  Future<void> removeCallLog(String callId) async {
    final callLogBox = Hive.box<CallLog>("call_log");
    await callLogBox.delete(callId);
  }
}
