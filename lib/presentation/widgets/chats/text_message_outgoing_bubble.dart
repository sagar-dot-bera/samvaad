// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/app_read_receipt.dart';
import 'package:samvaad/presentation/widgets/chats/incoming_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';

class OutgoingChatBubble extends StatelessWidget {
  Message message;
  Message? quotedMessage;
  //used for formating date to time format

  OutgoingChatBubble({required this.message, this.quotedMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        OutgoingMessageShell(
          childWidget: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  quotedMessage != null
                      ? Flexible(
                          child: QuotedMessageWidget(message: quotedMessage!))
                      : SizedBox(),
                  message.content!.length > 20
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChatBubleText(
                                text: message.content!,
                                senderNumber: message.sender!),
                            ReadReceipt(message: message),
                            SizedBox(
                              width: 6.0,
                            ),
                            AppMessageTimeText(
                                format: Format(), message: message)
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChatBubleText(
                                text: message.content!,
                                senderNumber: message.sender!),
                            SizedBox(
                              width: 6.0,
                            ),
                            ReadReceipt(message: message),
                            SizedBox(
                              width: 6.0,
                            ),
                            AppMessageTimeText(
                                format: Format(), message: message)
                          ],
                        ),
                ],
              )),
        )
      ],
    );
  }
}

class OutgoingMessageShell extends StatelessWidget {
  final Widget childWidget;

  const OutgoingMessageShell({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
          color: ChatBubbleColors.availableColors.elementAt(
              CurrentUserSetting.instance.userSetting.chatBubbleColor),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12))),
      child: childWidget,
    );
  }
}
