// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/themes/app_colors.dart';

import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/menu.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/main.dart';

import 'package:samvaad/presentation/viewmodels/chat_handler_view_model.dart';
import 'package:samvaad/presentation/viewmodels/message_manager_viewmodel.dart';
import 'package:samvaad/presentation/viewmodels/single_chat_message_handler.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/attachment_bottom_sheet.dart';
import 'package:samvaad/presentation/widgets/attachment_dialog.dart';
import 'package:samvaad/presentation/widgets/message_input_box.dart';
import 'package:samvaad/presentation/widgets/chats/chat_mask_choose.dart';
import 'package:samvaad/presentation/widgets/user_app_bar_cell.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageBoxTextController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  ScrollController messageScrollController = ScrollController();
  //attachement bottom sheet
  AttachmentBottomSheet attachmentBottomSheet = AttachmentBottomSheet();
  AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController textEditingController = TextEditingController();
  late (String, bool) chatWallpaper;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<ChatHandlerViewModel>(context, listen: false);
    chatWallpaper = provider.getChatWallpaper();

    if (provider is SingleChatMessageHandler) {
      provider.chatWithUserSatus(provider.chatWithUserDetails.phoneNo!);

      //provider.getParticipant(provider.chatWithUserDetails.phoneNo!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    messageBoxTextController.dispose();
    messageScrollController.dispose();
  }

  Future<void> sendMessage() async {
    log("onSend called");
    final messageHandlerProvider =
        Provider.of<ChatHandlerViewModel>(context, listen: false);
    //message to be sent
    if (messageHandlerProvider is SingleChatMessageHandler) {
      Message message = await messageHandlerProvider.messageCreator(
          messageBoxTextController.text.trim(), "text", "sent", ExtraInfo());

      messageHandlerProvider.sendMessage(message);

      messageBoxTextController.text = "";
      messageHandlerProvider.setQuotedMessage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          titleSpacing: 0.0,
          title: Consumer<ChatHandlerViewModel>(
            builder: (context, provider, child) {
              return provider is SingleChatMessageHandler &&
                      !provider.isSearchModeOn
                  ? GestureDetector(
                      onTap: () {
                        navigatorKey.currentContext!.pushRoute(
                            OtherUserProfileRoute(
                                userDetail: provider.chatWithUserDetails));
                      },
                      child: StreamBuilder(
                          stream: UserDetailsHelper.intance
                              .getUpdatedUserDetail(
                                  provider.chatWithUserDetails.phoneNo!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return UserAppBarCell(
                                  userDetails: provider.chatWithUserDetails,
                                  showStatus: true,
                                  showBio: false);
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  getIt<AppRouter>().push(UserInfoRoute(
                                      userDetail:
                                          provider.chatWithUserDetails));
                                },
                                child: UserAppBarCell(
                                    userDetails: snapshot.data!,
                                    showStatus: true,
                                    showBio: false),
                              );
                            }
                          }))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    BodyMedium(
                        text: provider.selectedMessage.length.toString()),
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
                      final provider = Provider.of<ChatHandlerViewModel>(
                          context,
                          listen: false);

                      if (provider is SingleChatMessageHandler) {
                        log("pop up list handler called $value");
                        switch (Menu.intance.singlechatScreenMenu[value]!) {
                          case "newContact":
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Add new contact"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                            onPressed: () async {
                                              var value = await FlutterContacts
                                                  .openExternalEdit(provider
                                                      .chatWithUserDetails
                                                      .phoneNo!);
                                              context.router.maybePop();
                                              if (value == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "No contact found please first create contact")));
                                              }
                                            },
                                            child: Text("Add to existing")),
                                        TextButton(
                                            onPressed: () async {
                                              Contact contact = Contact(
                                                  name: Name(
                                                      first: provider
                                                          .chatWithUserDetails
                                                          .userName!),
                                                  phones: <Phone>[
                                                    Phone(provider
                                                        .chatWithUserDetails
                                                        .phoneNo!)
                                                  ]);
                                              await FlutterContacts
                                                  .openExternalInsert(contact);
                                              context.router.maybePop();
                                            },
                                            child: Text("Create new")),
                                      ],
                                    ),
                                  );
                                });
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
                                          // Row(
                                          //   children: [
                                          //     Checkbox.adaptive(
                                          //         value: provider
                                          //             .clearChatFromServer,
                                          //         onChanged: (v) {
                                          //           provider
                                          //               .toggleClearFromServer(
                                          //                   v!);
                                          //           setState(() {});
                                          //         }),
                                          //     Text("delete chat from server")
                                          //   ],
                                          // ),
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
                          Menu.intance.singlechatScreenMenu.keys.toList());
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
            Column(
              children: [
                Expanded(
                  child: Provider.of<ChatHandlerViewModel>(context,
                              listen: false)
                          .checkIfChatIsBlocked()
                      ? SizedBox(
                          child: Center(
                            child: TextButton(
                                onPressed: () async {
                                  await Provider.of<MessageManagerViewModel>(
                                          context,
                                          listen: false)
                                      .ublockUser([
                                    Provider.of<ChatHandlerViewModel>(context,
                                            listen: false)
                                        .getChatId()
                                  ]);
                                  setState(() {});
                                },
                                child: Text("Tap to unblock")),
                          ),
                        )
                      : MessageLoaderWidget(
                          failedMessageStream:
                              Provider.of<ChatHandlerViewModel>(context,
                                      listen: false)
                                  .getFailedMessage(),
                          messageStream: Provider.of<ChatHandlerViewModel>(
                                  context,
                                  listen: false)
                              .getMessageStream(),
                          pendingMessageStream:
                              Provider.of<ChatHandlerViewModel>(context,
                                      listen: false)
                                  .getPendingMessageStream(),
                          messageScrollController: messageScrollController),
                ),
                Consumer<ChatHandlerViewModel>(
                    builder: (context, chatHandlerViewModel, child) {
                  return MessageInputBox(
                    onEnterPressed: (value) async {
                      if (CurrentUserSetting.instance.userSetting.enterIsSend) {
                        await sendMessage();
                      }
                    },
                    message: chatHandlerViewModel.quotedMessage,
                    onAttachment: () async {
                      // final messageProvider = Provider.of<ChatHandlerViewModel>(
                      //     context,
                      //     listen: false);
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return ChangeNotifierProvider.value(
                              value: chatHandlerViewModel,
                              child: AttachmentDialog(),
                            );
                          },
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width - 40));
                    },
                    onSendTap: () async {
                      await sendMessage();
                    },
                    messageTextControler: messageBoxTextController,
                    messageTextFocusNode: messageFocusNode,
                  );
                }),
              ],
            ),
          ],
        ));
  }
}

class ChatBackGroundWallpaper extends StatelessWidget {
  final (String, bool) chatBackGroundWallpaper;
  const ChatBackGroundWallpaper(
      {super.key, required this.chatBackGroundWallpaper});

  @override
  Widget build(BuildContext context) {
    return chatBackGroundWallpaper.$2
        ? Image.asset(
            chatBackGroundWallpaper.$1,
            fit: BoxFit.cover,
          )
        : Image.file(
            File(chatBackGroundWallpaper.$1),
            fit: BoxFit.cover,
          );
  }
}

class MessageLoaderWidget extends StatefulWidget {
  const MessageLoaderWidget(
      {super.key,
      required this.messageStream,
      required this.messageScrollController,
      required this.pendingMessageStream,
      required this.failedMessageStream});

  final Stream<Message> messageStream;
  final ScrollController messageScrollController;
  final Stream<Message> pendingMessageStream;
  final Stream<Message> failedMessageStream;

  @override
  State<MessageLoaderWidget> createState() => _MessageLoaderWidgetState();
}

class _MessageLoaderWidgetState extends State<MessageLoaderWidget> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _keys = {}; // Store keys for each item
  final ValueNotifier<int> _topMostItemIndex = ValueNotifier<int>(0);
  final ValueNotifier<String> _currentDate = ValueNotifier<String>("");
  final GlobalKey<AnimatedListState> _messageListKey =
      GlobalKey<AnimatedListState>();
  final ScrollController _messageListScrollCtroller = ScrollController();
  bool isLoadingMessage = true;

  bool shouldPrintDate = false;
  List<Message> messages = List.empty(growable: true);

  void setCurrentDate(String date) {
    if (_currentDate.value != date) {
      _currentDate.value = date;
    }
  }

  String selectedMesssageId = "";

  StreamSubscription? messageStreamSubscription;
  StreamSubscription? pendingMessageStreamSubscription;
  StreamSubscription? failedMessageStreamSubscription;

  Offset? startPosition;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      if (mounted) {
        Provider.of<ChatHandlerViewModel>(context, listen: false)
                .setNoMessageYet =
            Provider.of<ChatHandlerViewModel>(context, listen: false)
                .currentChatMessage
                .isEmpty;
      }
    });

    final chantHandlerModel = context.read<ChatHandlerViewModel>();

    chantHandlerModel.addListener(() {});

    messageStreamSubscription = widget.messageStream.listen((data) {
      log("messsage stream listener called");
      if (mounted) {
        Provider.of<ChatHandlerViewModel>(context, listen: false)
            .addMessageToCurrentMsgList(data);
      } else {
        log("widget is no mounted");
      }
    }, onDone: () {
      log("message stream done");
    });

    _currentDate.addListener(() {
      shouldPrintDate = shouldPrintDate;
    });

    if (mounted) {
      pendingMessageStreamSubscription =
          widget.pendingMessageStream.listen((event) {
        log("data added in pending msg list");
        Provider.of<ChatHandlerViewModel>(context, listen: false)
            .addMessageToCurrentMsgList(event);
      });

      failedMessageStreamSubscription =
          widget.failedMessageStream.listen((event) {
        log("data added in failed message ");

        Provider.of<ChatHandlerViewModel>(context, listen: false)
            .addMessageToCurrentMsgList(event);
      });
    }
  }

  void addMessage(List<Message> updatedMessageList) {
    if (messages.isEmpty) {
      messages.addAll(updatedMessageList);
    } else if (messages.length < updatedMessageList.length) {
      int startIndex = messages.length;
      List<Message> newMessages = updatedMessageList.sublist(messages.length);
      messages.addAll(newMessages);
      _messageListKey.currentState!
          .insertAllItems(startIndex, newMessages.length);
      scrollToBottom();
    } else {}
  }

  void scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void dispose() {
    super.dispose();
    if (messageStreamSubscription != null) {
      messageStreamSubscription!.cancel();
    }
    if (pendingMessageStreamSubscription != null) {
      pendingMessageStreamSubscription!.cancel();
    }
    if (failedMessageStreamSubscription != null) {
      failedMessageStreamSubscription!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatHandlerViewModel>(
        builder: (context, messageHandlerViewModel, child) {
      if (messageHandlerViewModel.currentChatMessage.isNotEmpty) {
        return ListView.builder(
          padding:
              EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height * 0.10),
          controller: _scrollController,
          key: _messageListKey,
          itemBuilder: (context, index) {
            setCurrentDate(
                messageHandlerViewModel.currentChatMessage[index].timeStamp!);
            _keys[index] = GlobalKey();
            return Stack(
              children: [
                Column(
                  children: [
                    !messageHandlerViewModel.checkIfDateAppeared(
                            messageHandlerViewModel
                                .currentChatMessage[index].timeStamp!)
                        ? Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.neutralGrayLight,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                      color:
                                          Colors.black.withValues(alpha: 0.2))
                                ]),
                            child: BodySmall(
                                text: messageHandlerViewModel
                                    .messageListTopDate(messageHandlerViewModel
                                            .currentChatMessage[index]
                                            .timeStamp ??
                                        "")))
                        : SizedBox(),
                    GestureDetector(
                      onTap: () {
                        if (messageHandlerViewModel.isSelectionModeOn) {
                          messageHandlerViewModel.modifySelectedMessage(
                              messageHandlerViewModel
                                  .currentChatMessage[index].messageId!);
                        }
                      },
                      onLongPress: () {
                        messageHandlerViewModel.modifySelectedMessage(
                            messageHandlerViewModel
                                .currentChatMessage[index].messageId!);
                      },
                      onPanStart: (details) {
                        startPosition = details.globalPosition;
                      },
                      onPanEnd: (details) {
                        log("swipe ended");

                        double dx =
                            details.globalPosition.dx - startPosition!.dx;

                        log("start value ${startPosition!.dx} end value ${details.globalPosition.dx}");
                        log("dx value $dx selected ");
                        if (dx < -50) {
                          messageHandlerViewModel.setQuotedMessage =
                              messageHandlerViewModel.currentChatMessage[index];
                        }
                      },
                      child: ChatMaskPicker(
                        onBottomButtonTaped: () {
                          log("on bottom button presed ${messageHandlerViewModel.currentChatMessage[index].messageStatus}");
                          if (messageHandlerViewModel
                                  .currentChatMessage[index].messageStatus ==
                              "pending") {
                            log("stop message called");
                            messageHandlerViewModel.stopMessage(
                                messageHandlerViewModel
                                    .currentChatMessage[index]);
                          } else if (messageHandlerViewModel
                                  .currentChatMessage[index].messageStatus ==
                              "failed") {
                            messageHandlerViewModel.sendMessage(
                                messageHandlerViewModel
                                    .currentChatMessage[index]);
                          }
                        },
                        key: _keys[index],
                        message:
                            messageHandlerViewModel.currentChatMessage[index],
                        isGroupChat: false,
                        quotedMessage: messageHandlerViewModel
                            .getQuotedMessageIfExits(messageHandlerViewModel
                                    .currentChatMessage[index]
                                    .quotedMessageId ??
                                ""),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                    child: messageHandlerViewModel.selectedMessage.contains(
                            messageHandlerViewModel
                                .currentChatMessage[index].messageId)
                        ? IgnorePointer(
                            child: Container(
                              color: Colors.blueAccent.withValues(alpha: 0.2),
                              width: MediaQuery.sizeOf(context).width,
                            ),
                          )
                        : IgnorePointer(child: SizedBox())),
              ],
            );
          },
          itemCount: messageHandlerViewModel.currentChatMessage.length,
        );
      } else if (!messageHandlerViewModel.isPreMessageLoadingDone &&
          !messageHandlerViewModel.noMessageYet) {
        return Align(child: DummayChatShimmer());
      } else {
        return Center(
          child: Container(
            child: TitleMedium(text: "No message yet"),
          ),
        );
      }
    });
  }
}

class ChatMaskPicker extends StatelessWidget {
  Message message;
  String? senderName;
  bool isGroupChat;
  Message? quotedMessage;
  Function() onBottomButtonTaped;
  ChatMaskPicker(
      {super.key,
      required this.message,
      required this.isGroupChat,
      required this.onBottomButtonTaped,
      this.senderName,
      this.quotedMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeOf.intance.getWidth(context, 0.01)),
      child: Stack(
        children: [
          Consumer<ChatHandlerViewModel>(
              builder: (context, chatHandlerViewModel, child) {
            return chatHandlerViewModel.selectedMessage.isEmpty
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton.filled(
                        onPressed: () {
                          getIt<AppRouter>()
                              .push(ForwardMessage(message: [message]));
                        },
                        icon: Icon(Icons.keyboard_double_arrow_right_outlined)))
                : SizedBox.shrink();
          }),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ChatMaskChooser(
                message: message,
                isGroupChat: isGroupChat,
                quotedMessage: quotedMessage,
              ),
              message.messageStatus == "pending" ||
                      message.messageStatus == "failed"
                  ? GestureDetector(
                      onTap: onBottomButtonTaped,
                      child: Container(
                        padding: EdgeInsets.all(
                            SizeOf.intance.getWidth(context, 0.02)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.neutralGrayLight),
                        child: Text(
                          message.messageStatus == "pending"
                              ? "Cancel"
                              : "Retry",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: BodyMedium(text: "Profile Detail"),
      content: Column(),
    );
  }
}
