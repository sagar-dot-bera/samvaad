import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/core/utils/invite_sender.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/widgets/chats/app_read_receipt.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/audio_loader.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

class ContactMessageViewer extends StatefulWidget {
  Message message;
  ContactMessageViewer({super.key, required this.message});

  @override
  State<ContactMessageViewer> createState() => _ContactMessageViewerState();
}

class _ContactMessageViewerState extends State<ContactMessageViewer> {
  MediaHandler mediaHandler = MediaHandler();
  User? userDetaile;
  Map<String, dynamic>? contact;

  void getContact() {
    contact = mediaHandler.decodeContact(widget.message.content!);
  }

  @override
  void initState() {
    super.initState();
    getContact();
  }

  @override
  Widget build(BuildContext context) {
    return contact != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MessageContainer(
                widget: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  minVerticalPadding: 0.0,
                  leading: InitialLetterAvatar(
                    name: contact!['name'],
                  ),
                  title: Text(contact!['name']),
                ),
              ),
              FutureBuilder(
                  future: UserDetailsHelper.intance
                      .searchForUser("+91${contact?["phoneNumber"]}"),
                  builder: (context, snapshot) {
                    log("number ${contact?["phoneNumber"]}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return TextButton(
                          onPressed: () {}, child: Text("Checking"));
                    } else if (snapshot.data == null) {
                      return TextButton(
                          onPressed: () {
                            InviteSender.sendSms(
                                contact!["name"], contact!["phoneNumber"]);
                          },
                          child: Text("Invite"));
                    } else {
                      log("data ${snapshot.data!.toJson()}");
                      userDetaile = snapshot.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                getIt<AppRouter>().replace(
                                    SingelChatRouteWrapperRoute(
                                        userWithDetails: userDetaile!,
                                        participantDetail: null));
                              },
                              child: Text("Chat")),
                        ],
                      );
                    }
                  })
            ],
          )
        : SizedBox(
            child: Text("Error decoded contact"),
          );
    ;
  }
}

class InitialLetterAvatar extends StatelessWidget {
  const InitialLetterAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.neutralDarkGray,
      child: Text(name.substring(0, 1).toUpperCase(),
          style: TextStyle(
              color: AppColors.neutralWhite,
              fontSize: radius == 30 ? 32 : 21,
              fontWeight: FontWeight.bold)),
    );
  }
}
