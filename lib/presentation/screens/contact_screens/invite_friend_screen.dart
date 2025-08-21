import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/presentation/viewmodels/user_detail_view_model.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_view.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class InviteFriendScreen extends StatefulWidget {
  const InviteFriendScreen({super.key});

  @override
  State<InviteFriendScreen> createState() => _InviteFriendScreenState();
}

class _InviteFriendScreenState extends State<InviteFriendScreen> {
  final List<Contact> inviteList = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  Future<void> getInviteList() async {
    final userDetailProvider = Provider.of<UserDetailsViewModel>(context);
    log("get invite list called");
    log("current user contact size ${CurrentUser.instance.currentUserContacts!.length}");

    for (var e in CurrentUser.instance.currentUserContacts!) {
      if (e.phones.isNotEmpty) {
        if (userDetailProvider.userWhoKnowCurrentUser.indexWhere((e2) {
              return e.phones.first.normalizedNumber == e2.phoneNo;
            }) ==
            -1) {
          log("element added");
          inviteList.add(e);
        } else {
          log("element not added");
        }
      } else {
        log("phone is empty");
      }
    }
  }

  String messageStr(String name) {
    return "Hey $name! Join me on Samvaad the best place to connect and chat! Download now:[App Link] (This is a test message,do not respond)";
  }

  Future<void> sendSms(String name, String number) async {
    // final Uri sms = Uri(
    //     scheme: 'sms',
    //     path: number,
    //     queryParameters: <String, String>{'body': });

    String msg = messageStr(name);

    final Uri sms = Uri.parse("sms:$number?body=${Uri.encodeComponent(msg)}");

    if (await canLaunchUrl(sms)) {
      log("sms launche successful");
      launchUrl(sms);
    } else {
      log("can not launche sms");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Invite firend"),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getInviteList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading data"),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error"));
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: InitialLetterAvatar(
                            name: inviteList[index].displayName),
                        title: TitleSmall(text: inviteList[index].displayName),
                        subtitle: BodySmall(
                            text: inviteList[index]
                                .phones
                                .first
                                .normalizedNumber),
                        trailing: TextButton(
                            onPressed: () {
                              sendSms(
                                  inviteList[index].displayName,
                                  inviteList[index]
                                      .phones
                                      .first
                                      .normalizedNumber);
                            },
                            child: TitleSmall(text: "invite")),
                      );
                    },
                    itemCount: inviteList.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
