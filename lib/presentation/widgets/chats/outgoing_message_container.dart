// ignore_for_file: unused_import, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/app_read_receipt.dart';
import 'package:samvaad/presentation/widgets/chats/incoming_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';
import 'package:samvaad/presentation/widgets/chats/text_message_outgoing_bubble.dart';

class OutgoingMessageContainer extends StatefulWidget {
  Widget contentLoader;
  Message message;
  bool isGroupChat;
  String? senderName;
  Message? quotedMessage;
  OutgoingMessageContainer(
      {super.key,
      required this.message,
      required this.contentLoader,
      required this.isGroupChat,
      this.quotedMessage,
      this.senderName});

  @override
  State<OutgoingMessageContainer> createState() =>
      _OutgoingMessageContainerState();
}

class _OutgoingMessageContainerState extends State<OutgoingMessageContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRect(
          child: OutgoingMessageShell(
              childWidget: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.quotedMessage != null
                          ? QuotedMessageWidget(
                              message: widget.quotedMessage!,
                            )
                          : SizedBox(),
                      widget.contentLoader,
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Caption(
                              text: widget.message.extraInfo!.caption!,
                              senderNumber: widget.message.sender!,
                            ),
                            ReadReceipt(message: widget.message),
                            SizedBox(
                              width: 3.0,
                            ),
                            AppMessageTimeText(
                                format: Format(), message: widget.message),
                          ],
                        ),
                      )
                    ],
                  ))),
        )
      ],
    );
  }
}

class QuotedMessageWidget extends StatelessWidget {
  const QuotedMessageWidget({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                  color: Theme.of(context).primaryColor, width: 4.0)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                    left: SizeOf.intance.getWidth(context, 0.01)),
                child: QuotedMsgSenderNameText(
                  senderName: message.senderName ?? "",
                  senderNumber: message.sender!,
                )),
            Padding(
              padding:
                  EdgeInsets.only(left: SizeOf.intance.getWidth(context, 0.01)),
              child: QuotedMessageContentText(message: message),
            )
          ],
        ),
      ),
    );
  }
}

class QuotedMsgSenderNameText extends StatelessWidget {
  const QuotedMsgSenderNameText(
      {super.key, required this.senderName, required this.senderNumber});

  final String senderName;
  final String senderNumber;

  String getSenderName() {
    if (senderName.isEmpty) {
      log("current user number ${CurrentUser.instance.currentUser!.phoneNo}");
      if (senderNumber == CurrentUser.instance.currentUser!.phoneNo) {
        return "You";
      } else {
        return senderName;
      }
    } else {
      return senderNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getSenderName(),
      overflow: TextOverflow.clip,
      style: GoogleFonts.ebGaramond(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.primary),
    );
  }
}

class QuotedMessageContentText extends StatelessWidget {
  final Message message;
  const QuotedMessageContentText({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.contentType == "text") {
      return QuotedMessageText(
        messageText: message.content!,
        senderNumber: message.sender!,
      );
    } else if (message.contentType == "audio") {
      return QuotedMessageText(
        messageText: "Audio message",
        senderNumber: message.sender!,
      );
    } else if (message.contentType == "pdf" ||
        message.contentType == "document") {
      return QuotedMessageText(
        messageText: message.extraInfo!.fileName!,
        senderNumber: message.sender!,
      );
    } else if (message.contentType == "video") {
      return QuotedMessageText(
        messageText: "Video message",
        senderNumber: message.sender!,
      );
    } else if (message.contentType == "contact") {
      return QuotedMessageText(
        messageText: "Contect message",
        senderNumber: message.sender!,
      );
    } else {
      return QuotedMessageText(
        messageText: "Nothing",
        senderNumber: message.sender!,
      );
    }
  }
}

class QuotedMessageText extends StatelessWidget {
  const QuotedMessageText(
      {super.key, required this.messageText, required this.senderNumber});
  final String messageText;
  final String senderNumber;
  @override
  Widget build(BuildContext context) {
    return ChatBubleText(text: messageText, senderNumber: senderNumber);
  }
}

class Caption extends StatelessWidget {
  const Caption({super.key, required this.text, required this.senderNumber});

  final String text;
  final String senderNumber;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: text != "NaN"
            ? ChatBubleText(text: text, senderNumber: senderNumber)
            : SizedBox());
  }
}
