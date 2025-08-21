import 'dart:developer';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:samvaad/core/utils/local_storage_handler.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/domain/entities/user.dart';

class CurrentUserSetting {
  UserSetting? _userSetting;

  static final instance = CurrentUserSetting._private();

  CurrentUserSetting._private();

  get userBackgroundWallpaper => null;

  set setCurrentUser(UserSetting settings) {
    _userSetting = settings;
  }

  UserSetting get userSetting => _userSetting!;

  static Future<UserSetting> fetchUserSetting() async {
    var userSettingBox = await Hive.openBox<UserSetting>("setting");
    UserSetting userSetting =
        userSettingBox.get("settings", defaultValue: UserSetting())!;
    await userSettingBox.close();
    return userSetting;
  }

  Future<void> saveUserSetting() async {
    var userSettingBox = await Hive.openBox<UserSetting>("setting");
    userSettingBox.put("setting", _userSetting!);
    await userSettingBox.close();
  }

  Future<void> setChatBackgroundWallpaper(File file) async {
    log("user background wallpaper path ");
    LocalStorageHandler localStorageHandler = LocalStorageHandler();

    String pathToImage = await localStorageHandler.imageLocalStorage(
      file,
    );
    instance._userSetting!.chatBackgroundSetter = pathToImage;
    log("user background wallpaper path  $pathToImage");
    log("user background changed path to new wallpaper ${instance.userBackgroundWallpaper}");
  }
}
