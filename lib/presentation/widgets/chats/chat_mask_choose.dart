import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/incoming_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/loader_picker.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/text_message_incoming_bubble.dart';
import 'package:samvaad/presentation/widgets/chats/text_message_outgoing_bubble.dart';

class ChatMaskChooser extends StatelessWidget {
  Message message;
  String? senderName;
  bool isGroupChat;
  Message? quotedMessage;
  bool? isMarkedMessage;

  ChatMaskChooser(
      {super.key,
      required this.message,
      required this.isGroupChat,
      this.senderName = "",
      this.isMarkedMessage = false,
      this.quotedMessage});

  MediaType mediaTypeFinder() {
    if (message.contentType == 'image') {
      return MediaType.image;
    } else if (message.contentType == 'video') {
      return MediaType.video;
    } else if (message.contentType == "pdf") {
      return MediaType.document;
    } else if (message.contentType == "contact") {
      return MediaType.contact;
    } else if (message.contentType == "audio") {
      return MediaType.audio;
    } else {
      return MediaType.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (message.sender != FirebaseAuth.instance.currentUser!.phoneNumber &&
        !UserRecord.instance.oldNumber.containsKey(message.sender)) {
      log("old number ${UserRecord.instance.oldNumber.keys}");
      log("incoming msg loaded");
      if (message.contentType == 'text') {
        return IncomingChatBubble(
          message: message,
          quotedMessage: quotedMessage,
        );
      } else {
        return IncomingMessageContainer(
          isGroupChat: false,
          senderName: senderName,
          message: message,
          contentLoader:
              LoaderPicker(mediaType: mediaTypeFinder(), message: message),
          quotedMessage: quotedMessage,
        );
      }
    } else if (isMarkedMessage!) {
      if (message.contentType == 'text') {
        return IncomingChatBubble(
          message: message,
        );
      } else {
        return IncomingMessageContainer(
          isGroupChat: false,
          senderName: senderName,
          message: message,
          contentLoader:
              LoaderPicker(mediaType: mediaTypeFinder(), message: message),
        );
      }
    } else {
      log("outgoing message loaded ${message.sender}");

      if (message.contentType == 'text') {
        return OutgoingChatBubble(
          message: message,
          quotedMessage: quotedMessage,
        );
      } else {
        return OutgoingMessageContainer(
          message: message,
          isGroupChat: true,
          senderName: senderName,
          contentLoader:
              LoaderPicker(mediaType: mediaTypeFinder(), message: message),
          quotedMessage: quotedMessage,
        );
      }
    }
  }
}
