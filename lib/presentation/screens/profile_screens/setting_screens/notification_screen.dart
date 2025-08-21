import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:samvaad/core/utils/audio_files.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/pick_sound.dart';
import 'package:samvaad/presentation/viewmodels/profile_handler_view_model.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/audio_file_view.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    final profileProvider =
        Provider.of<ProfileHandlerViewModel>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: HeadlineMedium(text: "Notifications And Sound"),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleMedium(text: "Notification"),
                  ListTileWithSwitch(
                      tileTitle: "Private Chat",
                      isActive: CurrentUserSetting
                          .instance.userSetting.isPrivateChatNotificationOn,
                      onPress: (value) {
                        CurrentUserSetting.instance.userSetting
                            .setPrivateChatNotification = value;
                        setState(() {});
                        profileProvider.updateNotification();
                      },
                      tileIcon: Icon(FeatherIcons.user)),
                  SmallDivider(),
                  ListTileWithSwitch(
                      tileTitle: "Groups",
                      isActive: CurrentUserSetting
                          .instance.userSetting.isGroupChatNotificationON,
                      onPress: (value) {
                        CurrentUserSetting.instance.userSetting
                            .setGroupChatNotification = value;
                        setState(() {});
                        profileProvider.updateNotification();
                      },
                      tileIcon: Icon(FeatherIcons.users)),
                  SmallDivider(),
                  ListTileWithSwitch(
                      tileTitle: "Show Badge Icon",
                      isActive: CurrentUserSetting
                          .instance.userSetting.isShowBadgeIcon,
                      onPress: (value) {
                        CurrentUserSetting.instance.userSetting.setShowBadge =
                            value;
                        setState(() {});
                      },
                      tileIcon: Icon(FeatherIcons.heart)),
                  SmallDivider(),
                  ListTileWithSwitch(
                      tileTitle: "Converstion tone",
                      isActive: CurrentUserSetting
                          .instance.userSetting.isConversationToneOn,
                      onPress: (value) {
                        CurrentUserSetting
                            .instance.userSetting.setConversationTone = value;
                        setState(() {});
                      },
                      tileIcon: Icon(FeatherIcons.music)),
                ],
              ),
            ),
            AppDivider(),
            Container(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacingSmall(),
                  TitleLarge(text: "call"),
                  AppSpacingSmall(),
                  Consumer<ProfileHandlerViewModel>(
                      builder: (context, profileHandler, child) {
                    return ListTileWithJustTitle(
                      onTileTap: () {
                        navigatorKey.currentContext!
                            .pushRoute(PickSoundRoute(
                                audioFileType: AudioFileType.ringtone))
                            .whenComplete(() {
                          profileProvider.ringtoneChangeNotifier();
                        });
                      },
                      title: "Ringtone",
                      trailingTitle: AudioFiles.intance.ringtons.entries
                          .firstWhere((entry) =>
                              entry.value ==
                                  CurrentUserSetting
                                      .instance.userSetting.ringtoneSound ||
                              entry.key ==
                                  CurrentUserSetting
                                      .instance.userSetting.ringtoneSound)
                          .key,
                    );
                  })
                ],
              ),
            )
          ],
        ));
  }
}

class SmallDivider extends StatelessWidget {
  const SmallDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.20,
      color: Theme.of(context).colorScheme.primary,
    );
  }
}

class ListTileWithJustTitle extends StatelessWidget {
  String title;
  String trailingTitle;
  Function() onTileTap;
  ListTileWithJustTitle(
      {super.key,
      required this.title,
      required this.trailingTitle,
      required this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTileTap,
      contentPadding: EdgeInsets.all(0.0),
      title: TitleLarge(text: title),
      trailing: TitleMedium(text: trailingTitle),
    );
  }
}

class ListTileWithSwitch extends StatelessWidget {
  bool isActive;
  Function(bool value) onPress;
  Widget tileIcon;
  String tileTitle;

  ListTileWithSwitch({
    super.key,
    required this.tileTitle,
    required this.isActive,
    required this.onPress,
    required this.tileIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      minVerticalPadding: 2.0,
      leading: tileIcon,
      title: TitleMedium(text: tileTitle),
      trailing: Switch(
          value: isActive,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: onPress),
    );
  }
}
