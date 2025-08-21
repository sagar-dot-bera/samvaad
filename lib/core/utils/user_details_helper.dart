import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:samvaad/core/services/contact_manager.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/data/datasources/local/fetch_user_data_from_local.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/user.dart';

class UserDetailsHelper {
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);
  FetchUserDataFromLocal fetchUserDataFromLocal = FetchUserDataFromLocal();
  ContactManager contactManager = ContactManager();
  Future<User> getSingleUser(String phoneNo) async {
    return await fetchUserDataFromFirebase.getSingleUser(phoneNo);
  }

  static final intance = UserDetailsHelper._private();

  UserDetailsHelper._private();

  factory UserDetailsHelper() {
    return intance;
  }
  //method to fetch user profile image from local or firebase
  Future<Uint8List?> getUserProfileImage() async {
    final fetchFiles = FetchFiles(dio: Dio());
    final userImage = await fetchUserDataFromLocal
        .fetchUserProfileLocal(CurrentUser.instance.currentUser!.phoneNo!);

    if (userImage == null) {
      log("Profile image loaded from network ");
      return await fetchFiles
          .fetchFile(CurrentUser.instance.currentUser!.profilePhotoUrl!);
    } else {
      log("profile image loaded from local storage");
      return userImage;
    }
  }

  Future<List<Contact>> getContact() async {
    return await contactManager.getUserContact();
  }

  Future<void> setFcmTokken() async {
    log("saving fcm tokken");
    fetchUserDataFromFirebase.saveUserFcmToken();
    log("fcmtokken saving complete");
  }

  Future<void> updateUserStatus(UserStatus userStatus) async {
    if (userStatus.isOnline! && !userStatus.isTyping!) {
      fetchUserDataFromFirebase.setOnline();
    } else if (!userStatus.isOnline!) {
      fetchUserDataFromFirebase.setOffline();
    } else if (userStatus.isOnline! && userStatus.isTyping!) {
      fetchUserDataFromFirebase.setTyping();
    }
  }

  Stream<User> getUpdatedUserDetail(String phoneNumber) {
    return fetchUserDataFromFirebase.singleUserChangeListener(phoneNumber);
  }

  Future<User?> searchForUser(String query) async {
    return fetchUserDataFromFirebase.deepSearch(query);
  }
}
