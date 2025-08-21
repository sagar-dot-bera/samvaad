import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/themes/app_theme.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/notification_screen.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';
import 'package:samvaad/presentation/widgets/app_photo_pick_icon_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class ChatSettingScreen extends StatefulWidget {
  ChatSettingScreen({super.key});

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  final ImagePicker _picker = ImagePicker();

  int chatBubbleSelectedIndex =
      CurrentUserSetting.instance.userSetting.chatBubbleColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Chats"),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleMedium(
                    text: "Display",
                  ),
                  GestureDetector(
                    onTap: () {
                      if (CurrentUserSetting
                              .instance.userSetting.selectedMessageFont ==
                          "Medium") {
                        CurrentUserSetting.instance.userSetting.setMessageFont =
                            "Large";
                      } else if (CurrentUserSetting
                              .instance.userSetting.selectedMessageFont ==
                          "Large") {
                        CurrentUserSetting.instance.userSetting.setMessageFont =
                            "Small";
                      } else if (CurrentUserSetting
                              .instance.userSetting.selectedMessageFont ==
                          "Small") {
                        CurrentUserSetting.instance.userSetting.setMessageFont =
                            "Medium";
                      }
                      log("current message font ${CurrentUserSetting.instance.userSetting.selectedMessageFont} size ${AppTheme.chatTextSize[CurrentUserSetting.instance.userSetting.selectedMessageFont]}");
                      setState(() {});
                    },
                    child: ListTile(
                      minVerticalPadding: 0.0,
                      contentPadding: EdgeInsets.all(0.0),
                      title: TitleMedium(text: "Message Font Size"),
                      trailing: TitleMedium(
                          text: CurrentUserSetting
                              .instance.userSetting.selectedMessageFont),
                    ),
                  )
                ],
              ),
            ),
            AppDivider(),
            SizedBox(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CurrentUserSetting
                                .instance.userSetting.userBackgroundWallpaper ==
                            "lib/assets/image/chat_background_3.jpg"
                        ? Image.asset(
                            fit: BoxFit.cover,
                            "lib/assets/image/chat_background_3.jpg")
                        : Image.file(
                            fit: BoxFit.cover,
                            File(CurrentUserSetting.instance.userSetting
                                .userBackgroundWallpaper!)),
                  ),
                  DummayChat(),
                ],
              ),
            ),
            AppDivider(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: ListTileWithIconAndTitle(
                onTileTapped: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: 150,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AppPhotoPickIconButton(
                                buttonIcon: Icon(Icons.photo_album_outlined),
                                buttonText: "Gallery",
                                buttonPressed: () async {
                                  var image = await _picker.pickImage(
                                      source: ImageSource.gallery);

                                  Navigator.pop(context);
                                  if (image != null) {
                                    navigatorKey.currentContext!
                                        .pushRoute(ChangeWallpaperPreviewRoute(
                                            wallpaper: File(image.path)))
                                        .whenComplete(() {
                                      setState(() {});
                                    });
                                  }
                                },
                              ),
                              AppPhotoPickIconButton(
                                  buttonIcon: Icon(FeatherIcons.camera),
                                  buttonText: "Camera",
                                  buttonPressed: () async {
                                    var image = await _picker.pickImage(
                                        source: ImageSource.camera);

                                    if (image != null) {}
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        );
                      });
                },
                tileIcon: Icon(Icons.wallpaper_rounded),
                title: "Change Chat Wallpaper",
              ),
            ),
            AppDivider(),
            AppSpacingTiny(),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.05),
              child: TitleLarge(text: "Color theme"),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  bool isSelected =
                      CurrentUserSetting.instance.userSetting.chatBubbleColor ==
                              index
                          ? true
                          : false;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        CurrentUserSetting
                            .instance.userSetting.setChatBubbleColor = index;
                        log("selected index $index");
                        setState(() {});
                      },
                      child: ChangeThemeContainer(
                          isSelected: isSelected,
                          containerColor:
                              ChatBubbleColors.availableColors[index]),
                    ),
                  );
                },
                itemCount: ChatBubbleColors.availableColors.length,
              ),
            ),
            AppDivider(),
            Container(
                padding:
                    EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
                child: Column(
                  children: [
                    ListTileWithSwitch(
                        tileTitle: "Enter is send",
                        isActive:
                            CurrentUserSetting.instance.userSetting.enterIsSend,
                        onPress: (value) {
                          CurrentUserSetting
                              .instance.userSetting.setEnterIsSend = value;

                          setState(() {});
                        },
                        tileIcon: Icon(FeatherIcons.messageSquare)),
                    SmallDivider(),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class DummayChat extends StatelessWidget {
  const DummayChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Container(
                constraints: BoxConstraints(
                    maxWidth: AppTheme.defineMsgBoxSize(context),
                    minHeight: 50),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: AppColors.brandColorLightGray),
                child: ChatBoxTextIncoming(
                    text: "Did you watch the new episode? of MHA")),
          ),
          SizedBox(
            height: 6.0,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: 250, minHeight: 50),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: ChatBubbleColors.availableColors[
                      CurrentUserSetting.instance.userSetting.chatBubbleColor]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatBoxTextOutgoing(text: "Yeah... i did"),
                  SizedBox(
                    width: 2.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          // Text(
                          //   "7:23",
                          //   style: TextStyle(
                          //       fontSize: 14,
                          //       color: ChatBubbleColors
                          //               .chatBubbleColorWithTextColor[
                          //           ChatBubbleColors.availableColors[
                          //               CurrentUserSetting.instance.userSetting
                          //                   .chatBubbleColor]]),
                          // ),
                          // SizedBox(
                          //   width: 3.0,
                          // ),
                          // Icon(
                          //   Icons.done_all,
                          //   color: AppColors.brandColorLightGray,
                          //   size: 20,
                          // )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatBoxTextIncoming extends StatelessWidget {
  String text;
  double? optionalFontSize;
  ChatBoxTextIncoming({super.key, required this.text, this.optionalFontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      softWrap: true,
      style: TextStyle(
        fontSize: optionalFontSize == null
            ? AppTheme.chatTextSize[
                CurrentUserSetting.instance.userSetting.selectedMessageFont]
            : optionalFontSize,
      ),
    );
  }
}

class ChatBoxTextOutgoing extends StatelessWidget {
  String text;
  double? optionalFont;
  ChatBoxTextOutgoing({super.key, required this.text, this.optionalFont});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: optionalFont == null
              ? AppTheme.chatTextSize[
                  CurrentUserSetting.instance.userSetting.selectedMessageFont]
              : optionalFont,
          color: ChatBubbleColors.chatBubbleColorWithTextColor[
              ChatBubbleColors.availableColors[
                  CurrentUserSetting.instance.userSetting.chatBubbleColor]]),
    );
    ;
  }
}

class ChangeThemeContainer extends StatelessWidget {
  Color containerColor;
  bool isSelected;
  ChangeThemeContainer(
      {super.key, required this.containerColor, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minHeight: SizeOf.intance.getHight(context, 0.05),
          maxHeight: SizeOf.intance.getHight(context, 0.05),
          minWidth: SizeOf.intance.getWidth(context, 0.18),
          maxWidth: SizeOf.intance.getWidth(context, 0.20)),
      decoration: BoxDecoration(
          border: isSelected
              ? Border.all(width: 1.0, color: AppColors.accentGreen)
              : null,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: AppColors.brandColorLightGray),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.all(8.0),
              constraints: BoxConstraints(
                  minHeight: 20, maxHeight: 20, minWidth: 40, maxWidth: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.neutralGrayLight),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              constraints:
                  BoxConstraints(minHeight: 20, minWidth: 40, maxWidth: 40),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: containerColor),
            ),
          )
        ],
      ),
    );
  }
}

class ListTileWithIconAndTitle extends StatelessWidget {
  Widget tileIcon;
  String title;
  Function() onTileTapped;
  String? trailingText;
  ListTileWithIconAndTitle(
      {super.key,
      required this.tileIcon,
      required this.title,
      required this.onTileTapped,
      this.trailingText});

  @override
  Widget build(BuildContext context) {
    return trailingText == null
        ? ListTile(
            onTap: onTileTapped,
            minVerticalPadding: 0.0,
            contentPadding: EdgeInsets.all(0.0),
            title: TitleMedium(text: title),
            leading: tileIcon)
        : ListTile(
            onTap: onTileTapped,
            minVerticalPadding: 0.0,
            contentPadding: EdgeInsets.all(0.0),
            title: TitleMedium(text: title),
            leading: tileIcon,
            trailing: TitleMedium(text: trailingText!),
          );
  }
}
