import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samvaad/domain/repositories/setup_profile_details_repository_impl.dart';
import 'package:samvaad/domain/entities/user.dart';

class ProfileDetailHandlerUseCase {
  ProfileDetailsHandlerRepository setUpProfileDetailsRepository;

  ProfileDetailHandlerUseCase({required this.setUpProfileDetailsRepository});

  Future<void> setUpUserDetails(User userDetails) async {
    await setUpProfileDetailsRepository.setUpUserDetails(userDetails);
  }

  Future<String?> uploadUserProfileImage(
      File file, String whereInStorage) async {
    return await setUpProfileDetailsRepository.uploadUserProfilePicture(
        file, whereInStorage);
  }

  //update user name
  Future<void> execUpdateUserName(String userName) async {
    await setUpProfileDetailsRepository.updateUserName(userName);
  }

  //updating user bio
  Future<void> exceUpdateBio(String bio) async {
    await setUpProfileDetailsRepository.changeUserBio(bio);
  }

  Future<void> execUpdateUserProfileUrl(String profilePhotoUrl) async {
    await setUpProfileDetailsRepository
        .updateUserProfileImageUrl(profilePhotoUrl);
  }

  Future<void> execUpdateUserPhoneNumber(
      String newNumber, String oldNumber) async {
    await setUpProfileDetailsRepository.changePhoneNumber(newNumber, oldNumber);
  }
}
