import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/contact_manager.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/screens/message_screens/messages_screen.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_contact_cell.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/app_tile.dart';
import 'package:samvaad/presentation/widgets/user_cell.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class NewMessage extends StatefulWidget {
  NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  @override
  void initState() {
    super.initState();
    setContect();
  }

  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<bool> isSearchOn = ValueNotifier<bool>(false);
  ValueNotifier<List<User>> searchList =
      ValueNotifier<List<User>>(List.empty());
  bool noResutlFound = false;

  Future<void> setContect() async {
    final userDetailProvider =
        Provider.of<UserDetailsViewModel>(context, listen: false);
    List<Contact> contactLst = await getContact();
    if (userDetailProvider.currentUserContacts.isEmpty) {
      userDetailProvider.setContacts(contactLst);
    } else if (userDetailProvider.currentUserContacts.length <
        contactLst.length) {
      userDetailProvider.setContacts(contactLst);
    }
  }

  Future<List<Contact>> getContact() async {
    ContactManager contactManager = ContactManager();
    final lst = await contactManager.getUserContact();

    List<Contact> finalList = List.empty(growable: true);
    for (var element in lst) {
      if (element.phones.isNotEmpty) {
        finalList.add(element);
      }
    }
    return finalList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: isSearchOn,
            builder: (context, value, child) {
              if (value) {
                return AppTextField(
                  hint: "Search contect",
                  leadingIcon: Icon(Remix.user_2_line),
                  validate: (value) {},
                  control: textEditingController,
                  keybordType: TextInputType.text,
                  optionalPadding: SizeOf.intance.getWidth(context, 0.02),
                  onTextChange: (p0) {
                    if (p0 != null && p0.isNotEmpty) {
                      searchList.value = Provider.of<UserDetailsViewModel>(
                              context,
                              listen: false)
                          .userQuerySearch(p0);

                      if (searchList.value.isEmpty) {
                        noResutlFound = true;
                      } else {
                        noResutlFound = false;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Try to search number to find user in our database")));
                      }
                    } else if (p0 == null || p0.isEmpty) {
                      searchList.value = [];
                    }
                  },
                );
              } else {
                return HeadlineMedium(text: "New Message");
              }
            }),
        actions: [
          IconButton(
              onPressed: () {
                isSearchOn.value = !isSearchOn.value;
              },
              icon: Icon(Remix.search_2_line)),
          PopupMenuButton(onSelected: (value) {
            if (value == "refresh") {
              Provider.of<UserDetailsViewModel>(context, listen: false)
                  .contectSync();
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text("Refresh"),
                value: "refresh",
              )
            ];
          })
        ],
      ),
      body: Column(children: [
        //new message tile
        // AppTile(
        //     onTileTap: () {},
        //     tileTitle: "New Message",
        //     tileIcon: const Icon(
        //       FeatherIcons.userPlus,
        //       size: 26,
        //     )),
        //new groupe tile
        AppTile(
          onTileTap: () {
            context.router.push(NewGroupRoute(toAddMember: false));
          },
          tileTitle: "New Group",
          tileIcon: const Icon(
            FeatherIcons.users,
            size: 26,
          ),
        ),
        AppDivider(),
        Consumer<UserDetailsViewModel>(
            builder: (context, userDetailManager, child) {
          if (userDetailManager.userWhoKnowCurrentUser.isNotEmpty) {
            return ValueListenableBuilder(
                valueListenable: searchList,
                builder: (context, value, child) {
                  if (!noResutlFound) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            log("on tap pressed");
                            getIt<AppRouter>().push(SingelChatRouteWrapperRoute(
                                userWithDetails: userDetailManager
                                    .userWhoKnowCurrentUser[index]));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    SizeOf.intance.getWidth(context, 0.02)),
                            child: UserCell(
                                userDetails: value.isEmpty
                                    ? userDetailManager
                                        .userWhoKnowCurrentUser[index]
                                    : value[index],
                                showStatus: false,
                                showBio: true,
                                isSelected: false),
                          ),
                        );
                      },
                      itemCount: value.isEmpty
                          ? userDetailManager.userWhoKnowCurrentUser.length
                          : value.length,
                    );
                  } else {
                    return Center(
                        child: LoadSvgImage(
                            imageAsset: "lib/assets/image/No_data_bro.svg",
                            text: "No data found"));
                  }
                });
          } else {
            userDetailManager.setUserWhoknowCurrentUser(
                userDetailManager.currentUserContacts);
            return ProfileCellShimmerList();
          }
        }),
      ]),
    );
  }
}
