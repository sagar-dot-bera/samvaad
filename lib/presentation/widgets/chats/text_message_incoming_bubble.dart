// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/app_read_receipt.dart';
import 'package:samvaad/presentation/widgets/chats/incoming_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';

class IncomingChatBubble extends StatelessWidget {
  Message message;
  Message? quotedMessage;
  IncomingChatBubble({required this.message, this.quotedMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
              color: AppColors.neutralGrayLight,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12))),
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: message.content!.length > 20
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        quotedMessage != null
                            ? Flexible(
                                child: QuotedMessageWidget(
                                    message: quotedMessage!))
                            : SizedBox(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ChatBubleText(
                                text: message.content!,
                                senderNumber: message.sender!),
                            SizedBox(
                              width: 6.0,
                            ),
                            AppMessageTimeText(
                                format: Format(), message: message)
                          ],
                        ),
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
                        SizedBox(
                          width: 6.0,
                        ),
                        AppMessageTimeText(format: Format(), message: message)
                      ],
                    )),
        )
      ],
    );
  }
}
