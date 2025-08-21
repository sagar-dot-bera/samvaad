import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/domain/entities/group.dart' as my_app;
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/screens/message_screens/messages_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.dart';

@RoutePage()
class ForwardMessage extends StatefulWidget {
  final List<Message> message;
  const ForwardMessage({super.key, required this.message});

  @override
  State<ForwardMessage> createState() => _ForwardMessageState();
}

class _ForwardMessageState extends State<ForwardMessage> {
  Map<String, List<String>> receiverList = {};
  ValueNotifier<List<String>> selectedItem =
      ValueNotifier<List<String>>(List<String>.empty(growable: true));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineLarge(text: "Forward message"),
        actions: [
          ValueListenableBuilder(
              valueListenable: selectedItem,
              builder: (context, value, child) {
                if (value.isNotEmpty) {
                  return Row(
                    children: [
                      Text(value.length.toString()),
                      SizedBox(
                        width: 5.0,
                      ),
                      IconButton(
                          onPressed: () async {
                            await Provider.of<UserDetailsViewModel>(context,
                                    listen: false)
                                .forwardMessage(widget.message,
                                    selectedItem.value, receiverList);
                            getIt<AppRouter>().maybePop();
                          },
                          icon: Icon(FeatherIcons.send))
                    ],
                  );
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<UserDetailsViewModel>(
              builder: (context, userDetailProvider, child) {
                if (userDetailProvider.isParticipantAndGroupDataLoading ||
                    userDetailProvider.isParticipantAndGroupDataLoading) {
                  return ProfileCellShimmerList();
                } else if (userDetailProvider.participantAndGroups.isEmpty ||
                    userDetailProvider.userWhoKnowCurrentUser.isEmpty) {
                  return Center(
                    child: Text("No user found"),
                  );
                } else {
                  return ValueListenableBuilder(
                      valueListenable: selectedItem,
                      builder: (context, value, child) {
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            var item =
                                userDetailProvider.participantAndGroups[index];
                            log("$item");
                            log("message list build invoked ");
                            // if (item is User) {
                            //   item = userDetailProvider.participantOfCurrentUser
                            //       .firstWhere(
                            //           (e) => e.withUser == (item as User).phoneNo);
                            // }

                            return GestureDetector(
                                onTap: () {
                                  if (item is Participant) {
                                    if (value.contains(item.chatId)) {
                                      value.remove(item.chatId);
                                      receiverList.remove(item.chatId);
                                      selectedItem.value = [...value];
                                    } else {
                                      receiverList[item.chatId!] = [
                                        item.withUser!
                                      ];
                                      value.add(item.chatId!);
                                      selectedItem.value = [...value];
                                    }
                                  } else if (item is my_app.Group) {
                                    if (value.contains(item.chatId)) {
                                      value.remove(item.chatId);
                                      receiverList.remove(item.chatId);
                                      selectedItem.value = [...value];
                                    } else {
                                      value.add(item.chatId);
                                      receiverList[item.chatId] =
                                          item.activeMember!;
                                      selectedItem.value = [...value];
                                    }
                                  }
                                },
                                child: MessageCellPicker(
                                    isItemSelected: value.contains(
                                        item is Participant
                                            ? item.chatId!
                                            : (item as my_app.Group).chatId),
                                    isSigleChat: checkIfSingleChat(item),
                                    item: item));
                          },
                          itemCount:
                              userDetailProvider.participantAndGroups.length,
                        );
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }

  bool checkIfSingleChat(Object item) {
    if (item is Participant) {
      return true;
    } else {
      return false;
    }
  }
}
