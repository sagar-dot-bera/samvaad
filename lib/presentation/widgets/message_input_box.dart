// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/attachment_dialog.dart';
import 'package:samvaad/presentation/widgets/audio_message_recorder.dart';
import 'package:samvaad/presentation/widgets/chats/outgoing_message_container.dart';
import 'package:samvaad/router.gr.dart';

class MessageInputBox extends StatefulWidget {
  TextEditingController messageTextControler;
  FocusNode messageTextFocusNode;
  void Function() onAttachment;
  Function(String value) onEnterPressed;
  void Function() onSendTap;
  Message? message;
  String? senderName;

  MessageInputBox(
      {required this.onAttachment,
      required this.messageTextControler,
      required this.messageTextFocusNode,
      required this.onSendTap,
      required this.onEnterPressed,
      this.message,
      this.senderName});

  @override
  State<MessageInputBox> createState() => _MessageInputBoxState();
}

class _MessageInputBoxState extends State<MessageInputBox> {
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
      width: MediaQuery.of(context).size.width - 20,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.20,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.neutralGrayLight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.message != null
              ? Container(
                  height: SizeOf.intance.getHight(context, 0.07),
                  margin: EdgeInsets.only(
                      left: SizeOf.intance.getWidth(
                        context,
                        0.05,
                      ),
                      top: SizeOf.intance.getWidth(context, 0.05)),
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3.0))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(
                                  left: SizeOf.intance.getHight(context, 0.01)),
                              child: QuotedMsgSenderNameText(
                                  senderName: widget.message!.senderName ?? "",
                                  senderNumber: widget.message!.sender!)),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              Provider.of<ChatHandlerViewModel>(context,
                                      listen: false)
                                  .setQuotedMessage = null;
                              widget.message = null;
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(
                                  right:
                                      SizeOf.intance.getHight(context, 0.02)),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Theme.of(context).colorScheme.primary),
                              child: Icon(
                                Remix.close_line,
                                size: 16,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: SizeOf.intance.getHight(context, 0.01)),
                          child: QuotedMessageContentText(
                              message: widget.message!))
                    ],
                  ),
                )
              : SizedBox(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: widget.messageTextFocusNode,
                  controller: widget.messageTextControler,
                  key: _key,
                  onFieldSubmitted: widget.onEnterPressed,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      UserDetailsHelper.intance.updateUserStatus(UserStatus(
                          isOnline: true,
                          lastSeenTimeStamp: DateTime.now().toIso8601String(),
                          isTyping: true));
                      Timer(Duration(seconds: 4), () {
                        UserDetailsHelper.intance.updateUserStatus(UserStatus(
                            isOnline: true,
                            lastSeenTimeStamp: DateTime.now().toIso8601String(),
                            isTyping: false));
                      });
                      setState(() {});
                    } else {
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(12),
                      hintText: "Type a message",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none),
                ),
              ),
              widget.messageTextControler.text.isNotEmpty
                  ? IconButton(
                      onPressed: widget.onSendTap,
                      icon: const Icon(FeatherIcons.send))
                  : Row(
                      children: [
                        IconButton(
                            onPressed: widget.onAttachment,
                            icon: Icon(
                              FeatherIcons.paperclip,
                              color: Theme.of(context).colorScheme.primary,
                            )),
                        IconButton(
                            onPressed: () async {
                              ImagePicker _picker = ImagePicker();
                              if (await Permission.videos.request().isGranted ==
                                      true &&
                                  await Permission.photos.request().isGranted ==
                                      true) {
                                log("permission granted");
                                List<File> selectedMedia =
                                    List.empty(growable: true);
                                XFile? selectedMediaFile = await ImagePicker
                                    .platform
                                    .getImageFromSource(
                                        source: ImageSource.camera);
                                if (selectedMediaFile != null) {
                                  selectedMedia
                                      .add(File(selectedMediaFile!.path));

                                  if (selectedMedia.isNotEmpty) {
                                    final provider =
                                        Provider.of<ChatHandlerViewModel>(
                                            context,
                                            listen: false);

                                    context.router.push(ImagePreviewRoute(
                                        images: selectedMedia,
                                        messageHandlerViewModel: provider));
                                  }
                                }
                              } else {
                                log("permission not granted");
                              }
                            },
                            icon: const Icon(
                              FeatherIcons.camera,
                            )),
                        AudioMessageRecorderWidget()
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }
}
