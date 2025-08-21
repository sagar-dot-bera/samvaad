// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ansicolor/ansicolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hive/hive.dart';
import 'package:image/image.dart';
import 'package:just_audio/just_audio.dart';
import 'package:nanoid/async.dart';
import 'package:samvaad/core/services/background_message_manager.dart';
import 'package:samvaad/core/utils/compress.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/core/utils/message_maker.dart';
import 'package:samvaad/core/utils/message_with_chatid.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/data/datasources/local/fetch_user_data_from_local.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/data/repositories_impl/chat_handler_repository_imple.dart';
import 'package:samvaad/domain/entities/failed_message.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/pending_message.dart';
import 'package:samvaad/domain/entities/user.dart' as my_user;
import 'package:samvaad/domain/use_case/chat_handler_use_case.dart';
import 'package:image/image.dart' as img;
import 'package:samvaad/presentation/screens/message_screens/add_new_message_screen.dart';

//this class is used to maintain state fo chat screen and handling task realated to message
abstract class ChatHandlerViewModel extends ChangeNotifier {
  //details to user with whome current user is chatting
  MessageHandlerUseCase messageHandlerUseCase = MessageHandlerUseCase(
      messageHandlerRepository: MessageHandlerRepositoryImpl(
          fetchUserDataFromFirebase: FetchUserDataFromFirebase(
              firebaseFirestore: FirebaseFirestore.instance),
          fetchUserDataFromLocal: FetchUserDataFromLocal()));
  List<Message> _currentChatMessage = []; //list to hold messages
  FileHandler fileHandler = FileHandler();
  HiveHandler hiveHandler = HiveHandler();
  MediaHandler mediaHandler = MediaHandler();
  LocalStorageHandler localStorageHandler = LocalStorageHandler();

  bool _isSearchModeOn = false;

  bool get isSearchModeOn =>
      _isSearchModeOn; // used to hold participent details
  set setIsSearchMode(bool value) {
    _isSearchModeOn = value;
    notifyListeners();
  }

  final currentUserDetails = FirebaseAuth.instance.currentUser!;
  List<Map<String, String>> pendingMessageList = List.empty(growable: true);
  List<Message> get currentChatMessage => _currentChatMessage;
  List<DateTime> messageDateList = [];
  List<DateTime> appearedDate = [];
  List<DateTime> printedDate = [];
  List<String> _selectedMessages = [];
  List<String> get selectedMessage => _selectedMessages;
  AudioPlayer audioPlayer = AudioPlayer();
  Compress compress = Compress();
  bool isSelectionModeOn = false;
  Message? _quotedMessage;
  bool isPreMessageLoadingDone = false;
  bool _noMessageYet = false;
  List<Message> failedMessageList = List.empty(growable: true);
  final _changeStreamController = StreamController<ChatListChange>.broadcast();
  Stream<ChatListChange> get changes => _changeStreamController.stream;

  MessageMaker messageMaker = MessageMaker();

  bool deleteMessageSendByYou = true;

  bool get noMessageYet => _noMessageYet;
  set setNoMessageYet(bool value) {
    _noMessageYet = value;
    notifyListeners();
  }

  bool isThereQuotedMessage() {
    if (_quotedMessage != null) {
      return true;
    } else {
      return false;
    }
  }

  void addChatChangeEvent(ChangeType typeOfChange, int index) {
    _changeStreamController
        .add(ChatListChange(typeOfChange: typeOfChange, atIndex: index));
  }

  Message? get quotedMessage => _quotedMessage;

  set setQuotedMessage(Message? message) {
    _quotedMessage = message;
    notifyListeners();
  }

  bool isGroup();

  Future<void> sendMessage(
    Message message,
  ) async {
    String chatId = getChatId();
    if (isThereQuotedMessage()) {
      message.setQuotedMessage = _quotedMessage!.messageId!;
    }
    log("sending message to chat id $chatId");
    if (message.contentType == "text" ||
        message.contentType == "contact" ||
        message.contentType == "location") {
      await messageHandlerUseCase.callSendMessage(message, chatId);

      await setLastMessage(message, isGroup(), chatId);
    } else {
      MessageWithChatid messageWithChatid =
          MessageWithChatid(message: message, chatId: chatId);
      log("Message with chat id added to list with id ${messageWithChatid.message!.messageId}");

      messageMaker.mediaMessageMaker(messageWithChatid).then((value) async {
        log(" * * *sending message with id ${value.message!.messageId} ");
        log("sending message with id ${value.message!.messageStatus} ");
        log("sending message ${value.message!.extraInfo!.height} ");
        log("sending message ${value.message!.extraInfo!.width} ");

        log("sending message ${value.message!.sender}* * *");

        if (failedMessageList
                .indexWhere((e) => e.messageId == value.message!.messageId) ==
            -1) {
          await BackgroundMessageManager.instance.forceStart();
          await BackgroundMessageManager.instance
              .sendMessageFromBackground(value);
          await setLastMessage(message, isGroup(), chatId);
        }
      });
    }

    if (CurrentUserSetting.instance.userSetting.isConversationToneOn) {
      audioPlayer.play();
    }
  }

  Future<void> stopMessage(Message message) async {
    messageMaker.stopIsolate();
    await addFailedMessage(message);
  }

  Future<void> multipleFileMessageSender(
      List<File> files, String contentType, ExtraInfo extraInfo) async {}

  Future<void> addPendingMessage(Message message) async {
    final pendingMessageBox = Hive.box<PendingMessage>("pendingMessages");
    Message messageWithPendingStatus = Message(
        sender: message.sender,
        receiver: message.receiver,
        messageId: message.messageId,
        timeStamp: message.timeStamp,
        contentType: message.contentType,
        content: message.content,
        readBy: message.readBy,
        messageStatus: "pending",
        extraInfo: message.extraInfo,
        messageNotVisible: message.messageNotVisible);

    String chatId = getChatId();

    PendingMessage newPendingMessage =
        PendingMessage(message: messageWithPendingStatus, chatid: chatId);
    await pendingMessageBox.put(
        newPendingMessage.message.messageId, newPendingMessage);

    log("message added to pending message box");
  }

  Future<void> resendPendingMessage(Message message) async {
    message.messageStatus = "pending";
    addPendingMessage(message);
    log("message ${message.toJson()}");
    await sendMessage(message);
  }

  void toggleDeleteSentMessage(bool value) {
    deleteMessageSendByYou = value;
  }

  //used when fetching participant details form database incase of first time convertation
  Future<void> setParticipant(Participant newParticipant) async {
    await messageHandlerUseCase.callToaddParticipant(newParticipant);
    notifyListeners();
  }

  Future<void> deletePendingMessage(String messageId) async {
    final pendingMessageBox = Hive.box<PendingMessage>("pendingMessages");

    pendingMessageBox.delete(messageId);
  }

  Future<Participant?> checkIfParticipantExit(String withUser) async {
    return await messageHandlerUseCase.checkIfParticipantExit(withUser);
  }

  String bytesToString(Uint8List byte) {
    String decodedString = base64Encode(byte);

    return decodedString;
  }

  Future<void> addFailedMessage(Message message) async {
    message.setStatus = "failed";
    FailedMessage failedMessage =
        FailedMessage(message: message, chatReference: getChatId());
    log("falied message ${failedMessage.message.toJson()}");
    final failedMessageBox = await Hive.openBox<FailedMessage>("failed_msg_v5");
    log("Message added to failed box");

    await failedMessageBox.put(failedMessage.message.messageId, failedMessage);
    final fmessage = failedMessageBox.get(failedMessage.message.messageId);
    log("added failed message ${fmessage!.message.toJson()}");
    await failedMessageBox.flush();
  }

  Future<void> deleteFailedMessage(String id) async {
    final failedMessageBox = Hive.box<FailedMessage>("failed_msg_v5");

    failedMessageBox.delete(id);
    failedMessageList.removeWhere((e) => e.messageId == id);
  }

  Future<void> getImageSize(
      File file, Function(int width, int height) onDone) async {
    Uint8List imageBytes = await file.readAsBytes();

    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      log("Width: ${image.width}");
      log("Height: ${image.height}");
      onDone(image.width, image.height);
    }
  }

  void createImageExtraInfo(File file) {}

  //method to mark message read
  List<Message> checkForUnreadMessage(List<Message> messages) {
    List<Message> unreadedMessageList = [];
    for (var message in messages) {
      if (message.readBy != null &&
          message.readBy!['${currentUserDetails.phoneNumber}'] == false) {
        unreadedMessageList.add(message);
      }
    }
    final greenPen = AnsiPen()..green();
    String greanMsg =
        greenPen("${unreadedMessageList.length} || (^_^) || (^_^) ||");
    log("Unreaded message count $greanMsg");

    return unreadedMessageList;
  }

  String getChatId();

  Future<void> readMessage(List<Message> unreadedMessage) async {
    try {
      String chatId = getChatId();
      if (unreadedMessage.isNotEmpty) {
        log("marking message read");
        await messageHandlerUseCase.execReadMessage(
            unreadedMessage, chatId, currentUserDetails.phoneNumber!);
      }
    } on Exception catch (e) {
      log("Error $e");
    }
  }

  Future<void> muteNotification() async {
    await muteNotification();
    notifyListeners();
  }

  Future<my_user.User?> chatWithUserSatus(String phoneNo) async {
    my_user.User? updatedUserDetail;
    messageHandlerUseCase.exceCheckUserStatus(phoneNo, (userDetails) {
      updatedUserDetail = userDetails;
    });
    return updatedUserDetail;
  }

  Future<Message> messageCreator(String content, String contentType,
      String msgStatus, ExtraInfo extraInfo);

  Future<void> sendMessageWithFile(
      File file, String typeOfFile, ExtraInfo extraInfo) async {
    String chatId = getChatId();

    Message pendingMessage =
        await messageCreator(file.path, typeOfFile, "pending", extraInfo);

    await addPendingMessage(pendingMessage);

    String localPathToImage =
        await localStorageHandler.documentLocalStorage(file, typeOfFile);
    await hiveHandler.setLocalFile(pendingMessage.messageId!, localPathToImage,
        pendingMessage.sender!, pendingMessage.contentType!, "");
    await mediaHandler.storeFileInCache(pendingMessage.messageId!);
    await sendMessage(pendingMessage);
  }

  void notifiyNoMessage() {
    notifyListeners();
  }

  Future<void> pendingMessageTracker() async {
    BackgroundMessageManager.instance.service
        .on('pendingMessageTracker')
        .listen(
      (event) {
        log("message sent from service");
        pendingMessageList = event!['messageList'];
        log("${pendingMessageList.length} message added to list");
        notifyListeners();
      },
    );
  }

  Stream<Message> getMessageStream();

  Stream<Message> getPendingMessageStream() {
    return messageHandlerUseCase.excePendingMsg(getChatId());
  }

  Stream<Message> getFailedMessage() {
    return messageHandlerUseCase.executeFetchFailedMessage(getChatId());
  }

  Message? getQuotedMessageIfExits(String id) {
    if (id.isNotEmpty) {
      return currentChatMessage.firstWhere((e) => e.messageId == id);
    } else {
      return null;
    }
  }

  List<Message> getSelectedMessage(List<String> messageIds) {
    return _currentChatMessage
        .where((e) => messageIds.contains(e.messageId))
        .toList();
  }

  String messageListTopDate(String timeStamp) {
    DateTime messageDate = DateTime.parse(timeStamp);
    DateTime currentDate = DateTime.now();
    List<String> dayOfWeek = ["mon", "tue", "wen", "thu", "fri", "sat", "sun"];
    List<String> month = [
      "jan",
      "feb",
      "march",
      "apr",
      "may",
      "jun",
      "jul",
      "aug",
      "sep",
      "nov",
      "dec"
    ];
    if (messageDate.day == currentDate.day) {
      return "today";
    } else if (currentDate.day - messageDate.day == 1) {
      return "yesterday";
    } else if (currentDate.day - messageDate.day <= 7) {
      return "${dayOfWeek[messageDate.weekday - 1]}, ${messageDate.day} ${month[currentDate.month - 1]}";
    } else {
      return "${messageDate.day}, ${month[messageDate.month - 1]}";
    }
  }

  int checkIfContainMsg(Message msg) {
    return _currentChatMessage.indexWhere((e) => e.messageId == msg.messageId);
  }

  void addMessageToCurrentMsgList(Message msgs) {
    if (msgs.messageStatus == "deleted") {
      return;
    }
    int id = checkIfContainMsg(msgs);
    log("does message exits   $id");
    if (id == -1) {
      _currentChatMessage.add(msgs);
      addChatChangeEvent(ChangeType.insert, _currentChatMessage.length - 1);
    } else {
      if (msgs.contentType == "pending" &&
          _currentChatMessage[id].messageStatus == 'failed') {
        _currentChatMessage[id] = msgs;
        addChatChangeEvent(ChangeType.update, _currentChatMessage.length - 1);
      } else if (_currentChatMessage[id].messageStatus == 'pending' &&
          msgs.contentType == "failed") {
        _currentChatMessage[id] = msgs;
        addChatChangeEvent(ChangeType.update, _currentChatMessage.length - 1);
      } else {
        _currentChatMessage[id] = msgs;
        addChatChangeEvent(ChangeType.update, _currentChatMessage.length - 1);
      }
    }

    if (!isPreMessageLoadingDone) {
      Timer(Duration(seconds: 3), () async {
        await messagePreLoad();
        _currentChatMessage.forEach(
          (element) {
            messageDateList.add(DateTime.parse(element.timeStamp!));
          },
        );
        isPreMessageLoadingDone = true;
        notifyListeners();
      });
    }

    //readMessage(checkForUnreadMessage(_currentChatMessage));
    _currentChatMessage.sort((e, e2) => e.compareTo(e2));

    if (isPreMessageLoadingDone) {
      notifiyNoMessage();
    }
  }

  void emptyMessageList() {
    _currentChatMessage = [];
  }

  void modifySelectedMessage(String messageId) {
    if (!_selectedMessages.contains(messageId)) {
      log("Message added to list $messageId");
      _selectedMessages.add(messageId);
      addChatChangeEvent(ChangeType.select,
          _currentChatMessage.indexWhere((e) => e.messageId == messageId));
      if (!isSelectionModeOn) {
        isSelectionModeOn = true;
      }
    } else {
      log("Message removed from list $messageId");
      _selectedMessages.remove(messageId);
      addChatChangeEvent(ChangeType.selectionRemoved,
          _currentChatMessage.indexWhere((e) => e.messageId == messageId));
      if (_selectedMessages.isEmpty) {
        isSelectionModeOn = false;
      }
    }
    notifyListeners();
  }

  Future<void> messagePreLoad() async {
    if (CurrentUserSetting.instance.userSetting.isConversationToneOn) {
      loadConversationTone();
    }
    MediaHandler mediaHandler = MediaHandler();

    List<String>? mediaIds =
        _currentChatMessage.map((e) => e.messageId!).toList();

    if (mediaIds.isNotEmpty) {
      await mediaHandler.localStoragePreFetch(mediaIds);
    }
  }

  bool checkIfDateAppeared(String timeStamp) {
    DateTime date = DateTime.parse(timeStamp);

    if (appearedDate.indexWhere((e) => compareDate(e, date)) == -1) {
      appearedDate.add(date);
      printedDate.add(date);
      return false;
    } else if (printedDate.contains(date)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> deleteMessage(
      String chatId, List<String> message, bool? isSoftDeleteAll) async {
    final messageToDelete = selectedMessageSeperator(message);

    if (messageToDelete['sent'] != null &&
        messageToDelete['sent']!.isNotEmpty) {
      await messageHandlerUseCase.deleteMessageUseCase(
          messageToDelete['sent']!, chatId, isSoftDeleteAll ?? false);
    }

    if (messageToDelete['received'] != null &&
        messageToDelete['received']!.isNotEmpty) {
      await messageHandlerUseCase.deleteMessageUseCase(
          messageToDelete['received']!, chatId, true);
    }

    if (messageToDelete["failed"] != null &&
        messageToDelete["failed"]!.isNotEmpty) {
      for (var element in messageToDelete['failed']!) {
        await deleteFailedMessage(element);
      }
    }
    deleteMessageFromCurrentList(message);
    selectedMessage.clear();
  }

  Map<String, List<String>> selectedMessageSeperator(
      List<String> selectedMessage) {
    List<String> sent = List.empty(growable: true);
    List<String> received = List.empty(growable: true);
    List<String> failedMessage = List.empty(growable: true);

    for (var element in selectedMessage) {
      if (_currentChatMessage
              .firstWhere((e) => e.messageId == element)
              .messageStatus ==
          "failed") {
        failedMessage.add(element);
      } else {
        if (checkIfCurrentUserIsSender(element)) {
          sent.add(element);
        } else {
          received.add(element);
        }
      }
    }

    return {"sent": sent, "received": received, "failed": failedMessage};
  }

  void deleteMessageFromCurrentList(List<String> selected) {
    for (var element in selected) {
      _currentChatMessage.removeWhere((e) => e.messageId == element);
      notifyListeners();
    }
  }

  bool isAllSelectedFromSender() {
    for (var element in _selectedMessages) {
      if (!checkIfCurrentUserIsSender(element)) {
        return false;
      }
    }
    return true;
  }

  Future<void> markSelectedMessage() async {
    Map<String, dynamic> messageToMark = {};
    if (selectedMessage.isNotEmpty) {
      for (var element in currentChatMessage) {
        if (selectedMessage.contains(element.messageId)) {
          messageToMark[element.messageId!] = element.toJson();
          log("message added toMarkedMessage map with id ${element.messageId} data ${messageToMark[element.messageId]}");
        } else {
          log("no matching message found in current message list");
        }
      }
    }
    if (messageToMark.isNotEmpty) {
      log("sending message to be marked data to hive handler message to be marked ${messageToMark.entries}");
      UserRecord.instance.addToMarkedMessage(messageToMark);
    } else {
      log("message to mark is empty");
    }
  }

  bool checkIfCurrentUserIsSender(String msgId) {
    if (_currentChatMessage.firstWhere((e) => e.messageId == msgId).sender ==
        FirebaseAuth.instance.currentUser!.phoneNumber!) {
      return true;
    } else {
      return false;
    }
  }

  bool compareDate(DateTime firstDate, DateTime secondDate) {
    if (firstDate.day == secondDate.day &&
        firstDate.weekday == secondDate.weekday &&
        firstDate.month == secondDate.month &&
        firstDate.year == secondDate.year) {
      return true;
    } else {
      return false;
    }
  }

  void loadConversationTone() {
    log("audio sound played loaded");
    audioPlayer.setAudioSource(
        AudioSource.asset("lib/assets/sound/conversation_tone.mp3"),
        preload: true);
  }

  bool checkIfChatIsBlocked() {
    return UserRecord.instance.blockedUser.containsKey(getChatId());
  }

  List<String> messageSendByYou() {
    List<String> sendByYou = List.empty(growable: true);
    for (var element in _currentChatMessage) {
      if (element.sender == CurrentUser.instance.currentUser!.phoneNo!) {
        sendByYou.add(element.messageId!);
      }
    }
    return sendByYou;
  }

  Future<void> clearChat() async {
    await deleteMessage(
        getChatId(),
        _currentChatMessage.map((e) => e.messageId!).toList(),
        !deleteMessageSendByYou);
  }

  void searchMessage(String query) {
    for (var element in currentChatMessage) {
      // if (element.quotedMessageId != null &&
      //     currentChatMessage.contains(element)) {
      //   final message = currentChatMessage.firstWhere(
      //     (e) => e.messageId == element.quotedMessageId,
      //   );
      //   checkMessage(query, element);
      // }
      checkMessage(query, element);
    }
  }

  void checkMessage(String query, Message element) {
    if (element.contentType == "text") {
      if (element.content!.contains(query)) {
        selectedMessage.add(element.messageId!);
        notifyListeners();
      }
    } else if (element.extraInfo!.fileName!.contains(query)) {
      selectedMessage.add(element.messageId!);
      notifyListeners();
    } else if (element.extraInfo!.caption!.contains(query)) {
      selectedMessage.add(element.messageId!);
      notifyListeners();
    } else if (selectedMessage.contains(element)) {
      selectedMessage.contains(element.messageId);
      notifyListeners();
    }
  }

  void clearSelected() {
    selectedMessage.clear();

    notifyListeners();
  }

  Future<void> setLastMessage(Message message, bool isGroup, String id) async {
    if (message.contentType == "text") {
      await messageHandlerUseCase.updateLastMessage(
          message.content!, isGroup, id, message.timeStamp!);
    } else {
      await messageHandlerUseCase.updateLastMessage(
          message.contentType!, isGroup, id, message.timeStamp!);
    }
  }

  (String, bool) getChatWallpaper() {
    if (CurrentUserSetting.instance.userSetting.getUserChatBackgroundImage() ==
        "lib/assets/image/chat_background_3.jpg") {
      return ("lib/assets/image/chat_background_3.jpg", true);
    } else {
      return (
        CurrentUserSetting.instance.userSetting.getUserChatBackgroundImage(),
        false
      );
    }
  }
}

enum ChangeType { insert, update, delete, select, selectionRemoved }

class ChatListChange {
  ChangeType typeOfChange;
  int atIndex;

  ChatListChange({required this.typeOfChange, required this.atIndex});
}
