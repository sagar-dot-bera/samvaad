import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:nanoid/nanoid.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/router.dart';

class SingleChatMessageHandler extends ChatHandlerViewModel {
  Participant? participant;
  User chatWithUserDetails;
  bool clearChatFromServer = false;

  SingleChatMessageHandler(
      {this.participant, required this.chatWithUserDetails});

  Future<void> setUpParticipant() async {
    log("setting participant");
    final tempParticipant = await messageHandlerUseCase
        .callToGetParticipant(chatWithUserDetails.phoneNo!);

    if (tempParticipant != null) {
      log("participant ${tempParticipant.chatId}");
      participant = tempParticipant;
      notifyListeners();
    } else {
      final part = await checkIfParticipantExit(chatWithUserDetails.phoneNo!);
      if (part != null) {
        participant = part;
      } else {}
    }
  }

  void toggleClearFromServer(bool value) {
    clearChatFromServer = value;
  }

  Future<void> popUpListHandler(String value) async {
    switch (value) {
      case "clearChat":
        showDialog(
            Text("Clear chat"),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "you can recover chat later if want by not removing chat from our server",
                    softWrap: true),
                Row(
                  children: [
                    Checkbox.adaptive(
                        value: clearChatFromServer,
                        onChanged: (v) {
                          clearChatFromServer = v!;
                          notifyListeners();
                        }),
                    Text("delete chat from server")
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox.adaptive(
                        value: deleteMessageSendByYou,
                        onChanged: (v) {
                          deleteMessageSendByYou = v!;
                        }),
                    Text(
                      "delete message sent by you",
                      softWrap: true,
                    )
                  ],
                )
              ],
            ));
        break;
      case "newContact":
        log("new contact clicked");
        Contact contact = Contact(
            name: Name(first: chatWithUserDetails.userName!),
            phones: <Phone>[Phone(chatWithUserDetails.phoneNo!)]);

        final context = getIt<AppRouter>().navigatorKey.currentContext;
        if (context == null) {
          debugPrint("Navigator context is null!");
          log("Navigator context is null!");
          return;
        }
        showDialog(
          Text("Add new contact"),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () async {
                    var value = await FlutterContacts.openExternalEdit(
                        chatWithUserDetails.phoneNo!);
                    context.router.maybePop();
                    if (value == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "No contact found please first create contact")));
                    }
                  },
                  child: Text("Add to existing")),
              TextButton(
                  onPressed: () async {
                    await FlutterContacts.openExternalInsert(contact);
                    context.router.maybePop();
                  },
                  child: Text("Create new")),
            ],
          ),
        );

      default:
    }
  }

  Future<void> showDialog(Widget title, Widget content) async {
    await showAdaptiveDialog(
        context: getIt<AppRouter>().navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(title: title, content: content);
        });
  }

  String getChatId() {
    if (participant != null) {
      return participant!.chatId!;
    } else if (participant == null) {
      log("creating new participant");
      Participant newParticipant = Participant(
          withUser: chatWithUserDetails.phoneNo,
          chatId:
              currentUserDetails.phoneNumber! + chatWithUserDetails!.phoneNo!,
          lastMessage: "hello",
          isLastMessageRead: false,
          lastMessageType: "text",
          lastMessageTimeStamp: DateTime.now().toString(),
          newMessageCount: 0);

      setParticipant(newParticipant);
      participant = newParticipant;

      return newParticipant.chatId!;
    } else {
      return currentUserDetails.phoneNumber! + chatWithUserDetails.phoneNo!;
    }
  }

  @override
  Future<Message> messageCreator(String content, String contentType,
      String msgStatus, ExtraInfo extraInfo) async {
    String messageId = nanoid();
    log("single chat message creator called recevier ${chatWithUserDetails.phoneNo}");
    Message messageToSend = Message(
        sender: currentUserDetails.phoneNumber,
        receiver: [chatWithUserDetails.phoneNo!],
        messageId: messageId,
        timeStamp: DateTime.now().toIso8601String(),
        contentType: contentType,
        content: content,
        extraInfo: extraInfo,
        senderName: chatWithUserDetails.userName,
        messageStatus: msgStatus,
        readBy: {chatWithUserDetails.phoneNo!: false},
        messageNotVisible: []);

    return messageToSend;
  }

  @override
  Stream<Message> getMessageStream() {
    late final Stream<Message> messageStream;
    String chatId = getChatId();
    if (participant == null) {
      messageStream = messageHandlerUseCase.executeFetchMessage(chatId);
    } else {
      messageStream =
          messageHandlerUseCase.executeFetchMessage(participant!.chatId!);
    }

    return messageStream;
  }

  @override
  bool isGroup() {
    return false;
  }
}
