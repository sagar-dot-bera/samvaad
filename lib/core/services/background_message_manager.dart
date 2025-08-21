import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/core/utils/message_with_chatid.dart';

import 'package:samvaad/core/utils/thumbnail.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';

class BackgroundMessageManager {
  List<MessageWithChatid> currentlySendingMessageList =
      List.empty(growable: true);

  final service = FlutterBackgroundService();

  static final BackgroundMessageManager instance =
      BackgroundMessageManager._privateConstructor();

  BackgroundMessageManager._privateConstructor();
  Thumbnail thumbnail = Thumbnail();

  bool _isProcessing = false;
  bool isRunning = false;
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);
  factory BackgroundMessageManager() {
    return instance;
  }

  // List<Map<String, String>> getReceviers(List<MessageWithChatid> messagelst) {
  //   List<Map<String, String>> recevierlst = List.empty(growable: true);
  //   messagelst.map((element) {
  //     recevierlst.add({'recevier': element.message!.receiver!});
  //   });

  //   return recevierlst;
  // }

  void addMessage(MessageWithChatid messageToDelivery) async {
    log("message added to list ${messageToDelivery.message!.messageId}");
    currentlySendingMessageList.add(messageToDelivery);

    if (!_isProcessing) {
      await processMessage();
    }
  }

  Future<void> forceStart() async {
    await service.startService();
  }

  Future<void> initService() async {
    await service.configure(
        androidConfiguration: AndroidConfiguration(
            onStart: onStart,
            autoStart: true,
            isForegroundMode: true,
            initialNotificationTitle: "SamVaad",
            initialNotificationContent: "Performing background task"),
        iosConfiguration: IosConfiguration(
          autoStart: true,
        ));
  }

  Future<void> sendMessageFromBackground(
      MessageWithChatid messageToDelivery) async {
    log("service send message called");

    fetchUserDataFromFirebase.sendMessage(
        messageToDelivery.message!, messageToDelivery.chatId!);
  }

  Future<void> startService() async {
    if (!isRunning) {
      log("service started");
      service.startService();
      isRunning = true;
    }
  }

  Future<void> processMessage() async {
    if (_isProcessing) {
      log("wating fro the other message  to realase message sender");
      return;
    }
    FileHandler fileHandler = FileHandler();
    _isProcessing = true;

    while (currentlySendingMessageList.isNotEmpty) {
      MessageWithChatid messageWithChatid = currentlySendingMessageList.first;
      log("sending message with id ${messageWithChatid.message!.messageId} from background");
      File? fileToUpload = File(messageWithChatid.message!.content!);
      if (messageWithChatid.message!.contentType == "image") {
      } else if (messageWithChatid.message!.contentType == "pdf" ||
          messageWithChatid.message!.contentType == "document") {
        final data = await thumbnail.getPdfFirstPage(fileToUpload);

        int imageHeight = 0, imageWidth = 0;

        messageWithChatid.message!.extraInfo!.thumbnail = data;
        messageWithChatid.message!.extraInfo!.height = imageHeight;
        messageWithChatid.message!.extraInfo!.width = imageWidth;
      }
      log("uploading message  with id ${messageWithChatid.message!.messageId}");
      messageWithChatid.message!.content = await fileHandler.uploadFileToRemote(
          fileToUpload, "userCreatedContent");
      messageWithChatid.message!.messageStatus = "sent";
      await sendMessageFromBackground(messageWithChatid);

      currentlySendingMessageList.removeWhere(
          (e) => e.message?.messageId == messageWithChatid.message?.messageId);

      log("sending message with id ${messageWithChatid.message!.messageId} from sent");
    }
    _isProcessing = false;

    FlutterBackgroundService().invoke("stopService");
  }

  Future<void> sendMutlipleMessageFromBackground(
      List<MessageWithChatid> messages) async {
    log("sending mutliple message using background message sender");
    for (var element in messages) {
      await sendMessageFromBackground(element);
    }
  }
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  log("service started");
  BackgroundMessageManager.instance.isRunning = true;

  service.on("stopService").listen((evant) {
    log("background message service stoped");
    BackgroundMessageManager.instance.isRunning = false;
    log("background message service stoped ${BackgroundMessageManager.instance.isRunning}");
    service.stopSelf();
  });

  service.on("sendMessage").listen((event) async {
    log("send background message invoked");
    if (BackgroundMessageManager
        .instance.currentlySendingMessageList.isNotEmpty) {
      await BackgroundMessageManager.instance.processMessage();
    }
  });

  service.on("addMessage").listen((event) async {
    log("sending message");
    MessageWithChatid? newMessage =
        MessageWithChatid.fromJson(event!["message"]);
    log("new message with id ${newMessage.message!.receiver}");
    await BackgroundMessageManager.instance
        .sendMessageFromBackground(newMessage);
  });
}
