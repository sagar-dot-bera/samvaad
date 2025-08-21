import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/user.dart' as app_user;
import 'package:samvaad/domain/use_case/user_profile_handler_use_case.dart';

class ProfileHandlerViewModel extends ChangeNotifier {
  String profileImageUrl = "";
  String userName = "";

  final currentUserPhoneNo = FirebaseAuth.instance.currentUser!.phoneNumber;
  ProfileDetailHandlerUseCase setupUserProfileDetailsUseCase;
  UserDetailsHelper getUserDetailsHelper = UserDetailsHelper();
  ProfileHandlerViewModel({required this.setupUserProfileDetailsUseCase});
  MediaHandler mediaHandler = MediaHandler();

  File? userProfileImage;

  void setUserName(String name) {
    log("updating user name");
    userName = name;
    notifyListeners();
  }

  Future<void> uploadUserDetails() async {
    app_user.User newUser = app_user.User(
        phoneNo: currentUserPhoneNo,
        userName: userName,
        profilePhotoUrl: profileImageUrl,
        userStatus: app_user.UserStatus(
            isOnline: true,
            lastSeenTimeStamp: DateTime.now().toString(),
            isTyping: false));
    log("setting new user");
    log("user name ${newUser.userName}");
    log("user online status ${newUser.userStatus!.isOnline}");
    await setupUserProfileDetailsUseCase.setUpUserDetails(newUser);
    notifyListeners();
  }

  Future<void> updateUserProfileImage(File profileImage) async {
    String? profileUrl = await setupUserProfileDetailsUseCase
        .uploadUserProfileImage(profileImage, "userProfileImages");
    log("downloadUrl view model $profileUrl");
    if (profileUrl != null) {
      await setUpdateUserProfilePhotoUrl(profileUrl);
    }
    await removeOldProfileImage(currentUserPhoneNo!);

    await getProfileImage().then((data) {
      if (data != null) {
        setUserProfileImage(data);
      }
    });
    notifyListeners();
  }

  //updating user name
  Future<void> updateUserName(String newUserName) async {
    log("update user name called");
    await setupUserProfileDetailsUseCase.execUpdateUserName(newUserName);
    getUserName();
  }

  //updating bio
  Future<void> updateBio(String newBio) async {
    log("update user bio");
    await setupUserProfileDetailsUseCase.exceUpdateBio(newBio);
  }

  Future<File?> getProfileImage() async {
    File? imageFile;

    if (CurrentUser.instance.currentUser != null &&
        CurrentUser.instance.currentUser?.profilePhotoUrl != null) {
      imageFile = await mediaHandler.getMedia(
          CurrentUser.instance.currentUser!.phoneNo!,
          CurrentUser.instance.currentUser!.profilePhotoUrl!,
          MediaType.image,
          CurrentUser.instance.currentUser!.phoneNo!);
    } else {
      CurrentUser.instance.currentUser = await getUserDetailsHelper
          .getSingleUser(FirebaseAuth.instance.currentUser?.phoneNumber ??
              "+915959966566");
      imageFile = await mediaHandler.getMedia(
          CurrentUser.instance.currentUser!.phoneNo!,
          CurrentUser.instance.currentUser!.profilePhotoUrl!,
          MediaType.image,
          CurrentUser.instance.currentUser!.phoneNo!);
    }

    if (imageFile == null) {}
    notifyListeners();
    return imageFile;
  }

  Future<void> setUserProfileImage(File profileImage) async {
    log("setting profile image");
    userProfileImage = profileImage;
    notifyListeners();
  }

  Future<void> removeOldProfileImage(String userId) async {
    mediaHandler.removeMedia(userId);
  }

  Future<void> setUpdateUserProfilePhotoUrl(String url) async {
    await setupUserProfileDetailsUseCase.execUpdateUserProfileUrl(url);
  }

  Future<void> getUserName() async {
    userName = CurrentUser.instance.currentUser!.userName ?? "Guest User";
    notifyListeners();
  }

  Future<void> setUpUserDetaile() async {
    await getProfileImage().then((data) {
      data != null ? setUserProfileImage(data) : null;
    });
    await getUserName();
    log("user name $userName");
    log("user profile name $userProfileImage");

    notifyListeners();
  }

  Future<void> changeMobileNumber(String newNumber, String oldNumber) async {
    FetchUserDataFromFirebase fetchUserDataFromFirebase =
        FetchUserDataFromFirebase(
            firebaseFirestore: FirebaseFirestore.instance);
    await fetchUserDataFromFirebase.updateMobileNumber(newNumber, oldNumber);
  }

  Future<void> updateNotification() async {
    FetchUserDataFromFirebase fetchUserDataFromFirebase =
        FetchUserDataFromFirebase(
            firebaseFirestore: FirebaseFirestore.instance);
    await fetchUserDataFromFirebase.updateNotification();
  }

  void ringtoneChangeNotifier() {
    notifyListeners();
  }
}
