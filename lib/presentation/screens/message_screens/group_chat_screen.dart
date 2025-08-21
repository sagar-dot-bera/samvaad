import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/background_message_manager.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/menu.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/screens/message_screens/single_chat_screen.dart';
import 'package:samvaad/presentation/viewmodels/group_chat_message_handler.dart';
import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/attachment_dialog.dart';
import 'package:samvaad/presentation/widgets/group_chat_avatar.dart';
import 'package:samvaad/presentation/widgets/message_input_box.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  late final ChatHandlerViewModel provider;
  ScrollController messageScrollController = ScrollController();
  TextEditingController messageBoxTextController = TextEditingController();
  FocusNode messageBoxFocusCotroller = FocusNode();
  late (String, bool) chatWallpaper;
  late UserDetailsViewModel userDetailProvider;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userDetailProvider =
        Provider.of<UserDetailsViewModel>(context, listen: false);
    provider = Provider.of<ChatHandlerViewModel>(context, listen: false);
    chatWallpaper = provider.getChatWallpaper();
  }

  Future<void> sendMessage() async {
    log("onSend called");
    final messageHandler =
        Provider.of<ChatHandlerViewModel>(context, listen: false);

    if (messageHandler is GroupChatMessageHandler) {
      final messageToSend = await messageHandler.messageCreator(
          messageBoxTextController.text.trim(), "text", "sent", ExtraInfo());
      messageHandler.setQuotedMessage = null;
      messageHandler.sendMessage(messageToSend);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Consumer<ChatHandlerViewModel>(
          builder: (context, messageMangerProvider, child) {
            return messageMangerProvider is GroupChatMessageHandler &&
                    !messageMangerProvider.isSearchModeOn
                ? GestureDetector(
                    onTap: () {
                      Provider.of<UserDetailsViewModel>(context, listen: false)
                          .setGroupInfo = messageMangerProvider.chatWithGroup;
                      getIt<AppRouter>().push(GroupRoute(
                          groupDetail: messageMangerProvider.chatWithGroup));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: SizeOf.intance.getWidth(context, 0.03),
                          top: SizeOf.intance.getWidth(context, 0.03)),
                      child: GroupChatAvatar(
                          groupDetail: messageMangerProvider.chatWithGroup),
                    ))
                : TextField(
                    controller: textEditingController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        provider.searchMessage(value);
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Search message",
                        icon: GestureDetector(
                            onTap: () {
                              provider.clearSelected();
                            },
                            child: Icon(Remix.close_line))),
                  );
          },
        ),
        actions: [
          Consumer<ChatHandlerViewModel>(builder: (context, provider, child) {
            if (provider.isSelectionModeOn) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        final selectedMessage = provider
                            .getSelectedMessage(provider.selectedMessage);
                        getIt<AppRouter>()
                            .push(ForwardMessage(message: selectedMessage));
                      },
                      icon: Icon(Remix.share_2_line)),
                  SizedBox(
                    width: 2.0,
                  ),
                  IconButton(
                      onPressed: () {
                        provider.markSelectedMessage();
                      },
                      icon: Icon(Remix.book_marked_line)),
                  SizedBox(
                    width: 2.0,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete message"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "You won't be able to recover deleted message")
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        provider.deleteMessage(
                                            provider.getChatId(),
                                            provider.selectedMessage,
                                            null);
                                        context.router.maybePop();
                                      },
                                      child: Text("Delete"))
                                ],
                              );
                            });
                      },
                      icon: Icon(Remix.delete_bin_2_line)),
                  BodyMedium(text: provider.selectedMessage.length.toString()),
                  SizedBox(
                    width: 5.0,
                  )
                ],
              );
            } else {
              return Row(
                children: [
                  IconButton(
                      onPressed: () {
                        provider.setIsSearchMode = !provider.isSearchModeOn;
                      },
                      icon: Icon(Remix.search_2_line)),
                  PopupMenuButton(onSelected: (value) async {
                    final provider = Provider.of<ChatHandlerViewModel>(context,
                        listen: false);

                    if (provider is GroupChatMessageHandler) {
                      log("pop up list handler called $value");
                      switch (Menu.intance.groupChatScreenMenu[value]!) {
                        case "groupInfo":
                          Provider.of<UserDetailsViewModel>(context,
                                  listen: false)
                              .setGroupInfo = provider.chatWithGroup;
                          getIt<AppRouter>().push(
                              GroupRoute(groupDetail: provider.chatWithGroup));
                        case "clearChat":
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Clear chat"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            "you can recover chat later if want by not removing chat from our server",
                                            softWrap: true),
                                        Row(
                                          children: [
                                            Checkbox.adaptive(
                                                value: provider
                                                    .deleteMessageSendByYou,
                                                onChanged: (v) {
                                                  Provider.of<ChatHandlerViewModel>(
                                                          context)
                                                      .toggleDeleteSentMessage(
                                                          v!);
                                                  setState(() {});
                                                }),
                                            Text(
                                              "delete message sent by you",
                                              softWrap: true,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            provider.clearChat();
                                          },
                                          child: Text("Delete")),
                                      TextButton(
                                          onPressed: () {
                                            context.router.maybePop();
                                          },
                                          child: Text("Cancel")),
                                    ],
                                  );
                                });
                              });
                          break;
                        default:
                      }
                    }
                  }, itemBuilder: (context) {
                    return Menu.intance.getPopUpList(
                        Menu.intance.groupChatScreenMenu.keys.toList());
                  }),
                ],
              );
            }
          })
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: ChatBackGroundWallpaper(
                  chatBackGroundWallpaper: chatWallpaper)),
          MessageLoaderWidget(
              failedMessageStream:
                  Provider.of<ChatHandlerViewModel>(context, listen: false)
                      .getFailedMessage(),
              messageStream: provider.getMessageStream(),
              pendingMessageStream: provider.getPendingMessageStream(),
              messageScrollController: messageScrollController),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: MessageInputBox(
                onEnterPressed: (value) async {
                  if (CurrentUserSetting.instance.userSetting.enterIsSend) {
                    sendMessage();
                  }
                },
                onAttachment: () async {
                  final messageProvider =
                      Provider.of<ChatHandlerViewModel>(context, listen: false);
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return ChangeNotifierProvider.value(
                          value: messageProvider,
                          child: AttachmentDialog(),
                        );
                      },
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width - 40));
                },
                onSendTap: () async {
                  sendMessage();
                },
                messageTextControler: messageBoxTextController,
                messageTextFocusNode: messageBoxFocusCotroller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
