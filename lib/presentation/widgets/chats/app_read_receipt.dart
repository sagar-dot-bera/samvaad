// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/incoming_message_container.dart';

class ReadReceipt extends StatelessWidget {
  ReadReceipt({
    super.key,
    required this.message,
  });
  Format format = Format();
  final Message message;

  bool checkIfRead() {
    bool flag = false;
    message.readBy!.forEach((key, value) {
      if (value) {
        log("From readReceipt checkIfRead true");
        flag = true;
      }
    });
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        checkIfRead()
            ? Icon(
                Icons.done_all,
                color: ChatBubbleColors.readAndUnreadColor.values
                    .elementAt(
                        CurrentUserSetting.instance.userSetting.chatBubbleColor)
                    .first,
                size: 20,
              )
            : Icon(Icons.done_all,
                size: 20,
                color: ChatBubbleColors.readAndUnreadColor.values
                    .elementAt(
                        CurrentUserSetting.instance.userSetting.chatBubbleColor)
                    .last),
      ],
    );
  }
}

class AppMessageTimeText extends StatelessWidget {
  const AppMessageTimeText({
    super.key,
    required this.format,
    required this.message,
  });

  final Format format;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final date = message.timeStamp;
    return ChatBubleText(
      text: format.dateFormat24Hourse(date.toString()),
      senderNumber: message.sender!,
      fontSize: 13,
    );
  }
}
