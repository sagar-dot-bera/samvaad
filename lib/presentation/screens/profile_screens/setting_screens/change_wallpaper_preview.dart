import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/presentation/screens/profile_screens/setting_screens/chat_setting_screen.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';

@RoutePage()
class ChangeWallpaperPreviewScreen extends StatelessWidget {
  File wallpaper;
  ChangeWallpaperPreviewScreen({super.key, required this.wallpaper});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Wallpaper preview"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.file(
            wallpaper,
            fit: BoxFit.cover,
          )),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DummayChat(),
                  SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 30,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandColorLightGray,
                        ),
                        onPressed: () {
                          CurrentUserSetting.instance.userSetting
                              .userBackgroundWallpaper = "";
                          CurrentUserSetting.instance
                              .setChatBackgroundWallpaper(wallpaper);
                        },
                        child: BodyMedium(text: "Set Background")),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
