import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/contact_manager.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/menu.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/message_manager_viewmodel.dart';
import 'package:samvaad/domain/entities/group.dart' as my_app;
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/group_cell.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class MessagesMainScreen extends StatefulWidget {
  const MessagesMainScreen({super.key});

  @override
  State<MessagesMainScreen> createState() => _MessagesMainScreenState();
}

class _MessagesMainScreenState extends State<MessagesMainScreen>
    with TickerProviderStateMixin {
  //service used to get contacts of current user
  ContactManager contactManager = ContactManager();
  late final participantAndGroupStream;
  List<Animation<double>> fadeItemIn = List.empty(growable: true);
  late AnimationController _fadeController;
  ValueNotifier<List<int>> selectedIndex = ValueNotifier<List<int>>([]);
  ValueNotifier<Map<String, String>> trackSelected =
      ValueNotifier<Map<String, String>>({});
  TextEditingController searchFieldTextEditingController =
      TextEditingController();
  bool isSearchModeOn = false;
  @override
  void initState() {
    super.initState();
    participantAndGroupStream =
        Provider.of<UserDetailsViewModel>(context, listen: false)
            .manageNewUserUseCase
            .fetchParticipantAndGroupe();

    _fadeController =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _fadeController.forward();
    _fadeController.addListener(() {
      log("current fade value ${_fadeController.value}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _fadeController.dispose();
  }

  void intiAnimation(int lstSize) {
    Tween<double> fadeInTween = Tween(begin: 0.0, end: 1.0);
    for (var index = 0; index < lstSize; index++) {
      fadeItemIn.add(fadeInTween.animate(CurvedAnimation(
        parent: _fadeController,
        curve: Interval(index * 0.1, 1.0, curve: Curves.easeIn),
      )));
    }
  }

  bool checkIfSingleChat(Object item) {
    return item is Participant;
  }

  void addToSelectedItem(
      Object item, ValueNotifier<Map<String, String>> selectedItem) {
    log("add to selected called");
    if (item is Participant) {
      selectedItem.value = {
        ...selectedItem.value,
        item.withUser!: "participatn"
      };
    } else if (item is my_app.Group) {
      trackSelected.value = {...trackSelected.value, item.chatId: "group"};
    } else {
      log("unknown type");
    }
  }

  void removeFromSelected(
      Object item, ValueNotifier<Map<String, String>> selectedItem) {
    if (item is Participant) {
      selectedItem.value = Map.from(selectedItem.value)..remove(item.withUser);
    } else if (item is my_app.Group) {
      selectedItem.value = Map.from(selectedItem.value)..remove(item.chatId);
    } else {
      log("unknown type");
    }
  }

  List<PopupMenuEntry<String>> getPopUpList(List<String> values) {
    List<PopupMenuEntry<String>> items = List.empty(growable: true);

    for (var element in values) {
      items.add(PopupMenuItem(
          value: element,
          child: Text(
            element,
            style: GoogleFonts.ebGaramond(),
          )));
    }

    return items;
  }

  void popClickHandler(String value) async {
    log("pop up menu button value $value");
    final messageManagerProvider =
        Provider.of<MessageManagerViewModel>(context, listen: false);
    final userDetailProvider =
        Provider.of<UserDetailsViewModel>(context, listen: false);
    switch (value) {
      case "newContact":
        await FlutterContacts.openExternalInsert();
        break;
      case "newGroup":
        getIt<AppRouter>().push(NewGroupRoute(toAddMember: false));
        break;
      case "markedMessage":
        getIt<AppRouter>().push(MarkedMessageRoute(
            markedMessage: UserRecord.instance.markedMessage));
        break;
      case "delete":
        messageManagerProvider.deleteChat();
        break;
      case "addToPriyasuchi":
        messageManagerProvider.addToPriyaSuchi();
        break;
      case "block":
        log("add to block tapped");
        messageManagerProvider.addBlockedUser();
        break;
      case "userInfo":
        break;
      case "groupInfo":
        log("group chat id ${messageManagerProvider.selectedItem.entries.first.key}");
        final groupInfo = userDetailProvider.groupesOfCurrentUser.firstWhere(
            (e) =>
                e.chatId ==
                messageManagerProvider.selectedItem.entries.first.key);
        Provider.of<UserDetailsViewModel>(context, listen: false).setGroupInfo =
            groupInfo;
        getIt<AppRouter>().push(GroupRoute(groupDetail: groupInfo));

        break;
      case "exitGroup":
        messageManagerProvider.exitGroup();
        break;
      default:
    }
  }

  List<String> popUpListContent() {
    log("get popup list content invoked");
    if (isSelectedOnlyTypeOf("participant")) {
      if (trackSelected.value.length == 1) {
        return Menu.intance.singleChatSelectedMenu.keys.toList();
      } else {
        return Menu.intance.multipleSingleChatSelectedMenu.keys.toList();
      }
    } else if (isSelectedOnlyTypeOf("group")) {
      log("only group");
      if (trackSelected.value.length == 1) {
        return Menu.intance.groupChatSelectedMenu.keys.toList();
      } else {
        return Menu.intance.multipleGroupChatSelectedMenu.keys.toList();
      }
    } else if (trackSelected.value.isEmpty) {
      return Menu.intance.messageScreenMenu.keys.toList();
    } else {
      return Menu.intance.bothChatAndGroupSelectedMenu.keys.toList();
    }
  }

  bool isSelectedOnlyTypeOf(String typeOf) {
    //check if selected item is only type of participant
    if (typeOf == "participant") {
      return !trackSelected.value.values.contains("group") &&
          trackSelected.value.isNotEmpty;
    } else if (typeOf == "group") {
      return !trackSelected.value.values.contains("participant") &&
          trackSelected.value.isNotEmpty;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<MessageManagerViewModel>(
            builder: (context, provider, child) {
          return AnimatedSwitcherWrapper(
              transitionType: TransitionType.slideFade,
              duration: Duration(milliseconds: 500),
              child: isSearchModeOn
                  ? AppTextField(
                      key: ValueKey("search"),
                      hint: "Search ",
                      leadingIcon: Icon(Remix.search_2_line),
                      validate: (value) {},
                      onTextChange: (text) {
                        if (text != null && text != "") {
                          Provider.of<UserDetailsViewModel>(context,
                                  listen: false)
                              .filterData(text, true);
                        } else {
                          Provider.of<UserDetailsViewModel>(context,
                                  listen: false)
                              .clearFilterList();
                        }
                      },
                      sufficIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isSearchModeOn = !isSearchModeOn;
                            });
                          },
                          icon: Icon(Remix.close_line)),
                      optionalPadding: 0.05,
                      control: searchFieldTextEditingController,
                      keybordType: TextInputType.text)
                  : HeadlineMedium(key: ValueKey("headline"), text: "Message"));
        }),
        actions: [
          Consumer<MessageManagerViewModel>(
              builder: (context, messageManager, child) {
            return !isSearchModeOn
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isSearchModeOn = !isSearchModeOn;
                            });
                          },
                          icon: Icon(Remix.search_2_line)),
                      PopupMenuButton(onSelected: (value) {
                        log("pop up button pressed");
                        popClickHandler(messageManager.popupMenuMap[value]!);
                      }, itemBuilder: (context) {
                        return Menu.intance
                            .getPopUpList(messageManager.popUpListContent());
                      }),
                    ],
                  )
                : SizedBox();
          })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<UserDetailsViewModel>(
              builder: (context, userDetailProvider, child) {
                final messageManagerProvider =
                    Provider.of<MessageManagerViewModel>(context,
                        listen: false);
                if (userDetailProvider.isParticipantAndGroupDataLoading ||
                    userDetailProvider.isParticipantAndGroupDataLoading) {
                  return ProfileCellShimmerList();
                } else if (userDetailProvider.participantAndGroups.isEmpty ||
                    userDetailProvider.userWhoKnowCurrentUser.isEmpty) {
                  return Center(
                      child: Lottie.asset(
                          "lib/assets/animation/loading_animation_one.json",
                          height: SizeOf.intance.getWidth(context, 0.50),
                          width: SizeOf.intance.getWidth(context, 0.50)));
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      var item = userDetailProvider.commonFliterList.isNotEmpty
                          ? userDetailProvider.commonFliterList[index]
                          : userDetailProvider.participantAndGroups[index];
                      log("message list build invoked ");
                      if (item is User) {
                        item = userDetailProvider.participantOfCurrentUser
                            .firstWhere(
                                (e) => e.withUser == (item as User).phoneNo);
                      }

                      return GestureDetector(onLongPress: () {
                        messageManagerProvider.addToSelectedItem(item);
                      }, onTap: () {
                        if (messageManagerProvider.selectedItem.isEmpty) {
                          if (checkIfSingleChat(item)) {
                            item as Participant;
                            context.router.push(SingelChatRouteWrapperRoute(
                                userWithDetails: userDetailProvider
                                    .getUserDetails(item.withUser!)!,
                                participantDetail: item));
                          } else {
                            context.router.push(
                                GroupChatChangeNotifierWrapperRoute(
                                    chatWithGroup: item as my_app.Group));
                          }
                        } else {
                          if (messageManagerProvider.selectedItem.containsKey(
                              item is Participant
                                  ? item.chatId!
                                  : (item as my_app.Group).chatId)) {
                            messageManagerProvider.removeFromSelected(item);
                          } else {
                            messageManagerProvider.addToSelectedItem(item);
                          }
                        }
                      }, child: Consumer<MessageManagerViewModel>(
                          builder: (context, value, child) {
                        return MessageCellPicker(
                            isItemSelected: value.selectedItem.containsKey(
                                item is Participant
                                    ? item.chatId!
                                    : (item as my_app.Group).chatId),
                            isSigleChat: checkIfSingleChat(item),
                            item: item);
                      }));
                    },
                    itemCount: userDetailProvider.commonFliterList.isNotEmpty
                        ? userDetailProvider.commonFliterList.length
                        : userDetailProvider.participantAndGroups.length,
                  );
                }
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          // ignore: use_build_context_synchronously
          context.router.push(NewMessage());
        },
        child: const Icon(FeatherIcons.edit2),
      ),
    );
  }
}

class LoadSvgImage extends StatelessWidget {
  final String text;
  final String imageAsset;
  const LoadSvgImage({super.key, required this.imageAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          imageAsset,
          width: SizeOf.intance.getHight(context, 0.30),
          height: SizeOf.intance.getHight(context, 0.30),
        ),
        Container(
            padding: EdgeInsets.all(SizeOf.intance.getWidth(context, 0.05)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.brandColorLightGray),
            child: BodyMedium(text: text)),
      ],
    );
  }
}

class MessageCellPicker extends StatelessWidget {
  final bool isSigleChat;
  final Object item;
  final bool isItemSelected;
  const MessageCellPicker(
      {super.key,
      required this.isSigleChat,
      required this.item,
      required this.isItemSelected});

  @override
  Widget build(BuildContext context) {
    if (isSigleChat) {
      Participant participant = item as Participant;
      return ParticipantCell(
          participant: participant,
          isSelected: isItemSelected,
          priyaChe:
              UserRecord.instance.priyasuchi.containsKey(participant.chatId),
          participantUserDetails: Provider.of<UserDetailsViewModel>(context)
              .getUserDetails(participant.withUser!)!);
    } else {
      return GroupCell(
        groupDetail: item as my_app.Group,
        boldText: false,
        priyaChe: UserRecord.instance.priyasuchi
            .containsKey((item as my_app.Group).chatId),
        isSelected: isItemSelected,
      );
    }
  }
}
