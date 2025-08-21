import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_text_field.dart';
import 'package:samvaad/presentation/widgets/app_tile.dart';
import 'package:samvaad/presentation/widgets/user_cell.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class ContactScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late final contactStream;
  late final userWhoKnowCurrentUser;
  TextEditingController textEditingController = TextEditingController();
  ValueNotifier<bool> isSearchOn = ValueNotifier<bool>(false);
  ValueNotifier<List<User>> searchList =
      ValueNotifier<List<User>>(List.empty());
  bool noResutlFound = false;

  @override
  void initState() {
    super.initState();
    contactStream = Provider.of<UserDetailsViewModel>(context, listen: false)
        .manageNewUserUseCase
        .execFetchParticipants();
    userWhoKnowCurrentUser =
        Provider.of<UserDetailsViewModel>(context, listen: false)
            .setUserWhoKnowCurrentUserRealTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
            valueListenable: isSearchOn,
            builder: (context, value, child) {
              if (value) {
                return GestureDetector(
                  child: AppTextField(
                    hint: "Search contect",
                    leadingIcon: Icon(Remix.user_2_line),
                    validate: (value) {},
                    control: textEditingController,
                    keybordType: TextInputType.text,
                    optionalPadding: SizeOf.intance.getWidth(context, 0.02),
                    sufficIcon: IconButton(
                        onPressed: () {
                          isSearchOn.value = false;
                        },
                        icon: Icon(Remix.close_line)),
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
                        }
                      } else if (p0 == null || p0.isEmpty) {
                        searchList.value = [];
                      }
                    },
                  ),
                );
              } else {
                return HeadlineMedium(text: "Contacts");
              }
            }),
        actions: [
          ValueListenableBuilder(
              valueListenable: isSearchOn,
              builder: (context, value, child) {
                if (!value) {
                  return IconButton(
                      onPressed: () {
                        isSearchOn.value = !isSearchOn.value;
                      },
                      icon: Icon(Remix.search_2_line));
                } else {
                  return SizedBox();
                }
              })
        ],
      ),
      body: Column(
        children: [
          AppTile(
              onTileTap: () {
                navigatorKey.currentContext!.pushRoute(InviteFriendRoute());
              },
              tileTitle: "Invite firends",
              tileIcon: const Icon(
                Remix.user_add_line,
                size: 26,
              )),
          AppDivider(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeOf.intance.getWidth(context, 0.02)),
            child: Consumer<UserDetailsViewModel>(
                builder: (context, provider, child) {
              if (provider.userWhoKnowCurrentUser.isNotEmpty) {
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
                                getIt<AppRouter>().push(
                                    SingelChatRouteWrapperRoute(
                                        userWithDetails: provider
                                            .userWhoKnowCurrentUser[index]));
                              },
                              child: UserCell(
                                  userDetails: value.isEmpty
                                      ? provider.userWhoKnowCurrentUser[index]
                                      : value[index],
                                  showStatus: false,
                                  showBio: true,
                                  isSelected: false),
                            );
                          },
                          itemCount: value.isEmpty
                              ? provider.userWhoKnowCurrentUser.length
                              : value.length,
                        );
                      } else {
                        return Center(
                          child: Text("No Result found"),
                        );
                      }
                    });
              } else {
                return Center(
                  child: Text("No data found"),
                );
              }
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          // context.router.push(AddToContactRoute());
          FlutterContacts.openExternalInsert();
        },
        child: Icon(Remix.user_add_line),
      ),
    );
  }
}
