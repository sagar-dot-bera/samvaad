import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/data/datasources/remote/upload_profile_data_to_firebase.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/repositories/setup_profile_details_repository_impl.dart';

class ProfileDetailsHandlerRepositoryImpl
    extends ProfileDetailsHandlerRepository {
  HandelProfileDataToFirebase profileDataHandler;

  ProfileDetailsHandlerRepositoryImpl({required this.profileDataHandler});

  @override
  Future<void> setUpUserDetails(User user) async {
    await profileDataHandler.uploadUserDataToFirestore(user);
  }

  @override
  Future<String?> uploadUserProfilePicture(
      File file, String whereInStorage) async {
    return await profileDataHandler.uploadUserProfileImage(
        file, whereInStorage);
  }

  @override
  Future<void> changePhoneNumber(String newPhone, String oldPhone) async {
    await changePhoneNumber(newPhone, oldPhone);
  }

  @override
  Future<void> changeUserBio(String newBio) async {
    await profileDataHandler.changeBio(newBio);
  }

  @override
  Future<void> updateUserName(String newName) async {
    await profileDataHandler.updateUserName(newName);
  }

  @override
  Future<void> updateUserProfileImageUrl(String profilePicUrl) async {
    await profileDataHandler.updateProfilePhotoUrl(profilePicUrl);
  }
}
