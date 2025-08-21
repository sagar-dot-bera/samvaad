import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/app_tile.dart';
import 'package:samvaad/presentation/widgets/avatar_view.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profileImage;

  Future<File?> getProfileImage() async {
    File? imageFile;
    MediaHandler mediaHandler = MediaHandler();
    if (CurrentUser.instance.currentUser != null) {
      imageFile = await mediaHandler.getMedia(
        CurrentUser.instance.currentUser!.phoneNo!,
        CurrentUser.instance.currentUser!.profilePhotoUrl!,
        MediaType.image,
        CurrentUser.instance.currentUser!.phoneNo!,
      );
    }

    return imageFile;
  }

  @override
  void initState() {
    super.initState();

    final userProfileHandler =
        Provider.of<ProfileHandlerViewModel>(context, listen: false);
    userProfileHandler;
  }

  @override
  Widget build(BuildContext context) {
    final userProfileHandler =
        Provider.of<ProfileHandlerViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: HeadlineMedium(text: "Profile"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: userProfileHandler.setUpUserDetaile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile();
                } else if (snapshot.hasError) {
                  return SizedBox(
                    child: Center(
                      child: Text("Error"),
                    ),
                  );
                } else {
                  return GestureDetector(
                      onTap: () {
                        context.router.push(MyProfileRoute()).then((value) {
                          setState(() {});
                        });
                      },
                      child: ListTile(
                        leading: userProfileHandler.userProfileImage == null &&
                                userProfileHandler.userName.isNotEmpty
                            ? InitialLetterAvatar(
                                name: userProfileHandler.userName,
                                radius: 30,
                              )
                            : AvatarView(
                                avatarImage:
                                    userProfileHandler.userProfileImage!,
                                size: 30.0,
                              ),
                        title: userProfileHandler.userName.isNotEmpty
                            ? HeadlineMedium(
                                text: userProfileHandler.userName,
                                alig: TextAlign.start)
                            : SizedBox(),
                        subtitle: BodyMedium(
                          text: "Online",
                          align: TextAlign.start,
                        ),
                      ));
                }
              },
            ),
            const AppSpacingSmall(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0.8, 0.0, 4.0),
              child: HeadlineMedium(text: "Settings"),
            ),
            AppTile(
                onTileTap: () {
                  context.router.push(NotificationRoute());
                },
                tileTitle: "Notification",
                tileIcon: const Icon(FeatherIcons.bell)),
            AppTile(
                onTileTap: () {
                  context.router.push(ChatSettingRoute());
                },
                tileTitle: "Chats",
                tileIcon: const Icon(FeatherIcons.messageCircle)),
            AppTile(
                onTileTap: () {
                  navigatorKey.currentContext!.pushRoute(StorageSetting());
                },
                tileTitle: "Storage And Data",
                tileIcon: const Icon(FeatherIcons.pieChart)),
            const AppDivider(),
            const AppSpacingTiny(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 8.0, 0.0, 8.0),
              child: HeadlineMedium(text: "Help"),
            ),
            AppTile(
                onTileTap: () {
                  navigatorKey.currentContext
                      ?.pushRoute(FrequentlyAskedQuestionRoute());
                },
                tileTitle: "SamVaad FAQ",
                tileIcon: const Icon(FeatherIcons.helpCircle)),
            AppTile(
                onTileTap: () {
                  navigatorKey.currentContext?.pushRoute(PrivacyPolicyRoute());
                },
                tileTitle: "Privacy Policy",
                tileIcon: const Icon(FeatherIcons.helpCircle)),
          ],
        ));
  }
}
