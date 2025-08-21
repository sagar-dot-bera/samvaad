import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/chat_setting_screen.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/app_read_receipt.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';

class IncomingMessageContainer extends StatelessWidget {
  Message message;
  Widget contentLoader;
  bool isGroupChat;
  String? senderName;
  Message? quotedMessage;
  IncomingMessageContainer(
      {super.key,
      required this.message,
      required this.contentLoader,
      required this.isGroupChat,
      this.quotedMessage,
      this.senderName});

  IncomingMessageContainer.group(
      {required this.contentLoader,
      required this.message,
      required this.isGroupChat,
      this.quotedMessage,
      this.senderName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        ClipRect(
          child: Container(
            constraints: BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
                color: AppColors.neutralGrayLight,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12))),
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    isGroupChat
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: TitleMedium(text: senderName!),
                          )
                        : SizedBox(),
                    quotedMessage != null
                        ? QuotedMessageWidget(message: quotedMessage!)
                        : SizedBox(),
                    contentLoader,
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          Caption(
                            text: message.extraInfo!.caption!,
                            senderNumber: message.sender!,
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          AppMessageTimeText(
                              format: Format(), message: message),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        )
      ],
    );
  }
}

class ChatBubleText extends StatelessWidget {
  String text;
  String senderNumber;
  double? fontSize;
  ChatBubleText(
      {super.key,
      required this.text,
      required this.senderNumber,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return senderNumber == CurrentUser.instance.currentUser!.phoneNo ||
            UserRecord.instance.oldNumber.keys.contains(senderNumber)
        ? ChatBoxTextOutgoing(
            text: text,
            optionalFont: fontSize,
          )
        : ChatBoxTextIncoming(
            text: text,
            optionalFontSize: fontSize,
          );
  }
}
