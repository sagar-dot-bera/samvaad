import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:nanoid/async.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/user.dart' as my_app;
import 'dart:developer';

class HandelProfileDataToFirebase {
  FirebaseFirestore firestore;
  FirebaseStorage firebaseStorage;
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);

  FileHandler fileHandler = FileHandler();

  HandelProfileDataToFirebase(
      {required this.firestore, required this.firebaseStorage});

  Future<void> uploadUserDataToFirestore(my_app.User user) async {
    try {
      var userCollectionReference = firestore.collection("users");

      await userCollectionReference.doc(user.phoneNo).set(user.toJson());
    } on Exception catch (e) {
      (e.toString());
    }
  }

  Future<String> uploadUserProfileImage(
      File imageFile, String whereInStorage) async {
    try {
      log("starting file upload");
      final imagesStorageRef = firebaseStorage.ref();
      final currentUserNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      final imageId = await nanoid();
      final userPofileImageStorageRef = whereInStorage == 'userGeneratedMedia'
          ? imagesStorageRef.child("$whereInStorage/$imageId")
          : imagesStorageRef.child("$whereInStorage/$currentUserNumber");

      await userPofileImageStorageRef.putFile(imageFile);

      return userPofileImageStorageRef.getDownloadURL().then((value) async {
        log("profiel image download url $value");

        return value;
      });
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  Future<void> updateProfilePhotoUrl(String downloadUrl) async {
    try {
      log("new user name $downloadUrl");
      final currentUser = FirebaseAuth.instance.currentUser;
      final userReference =
          firestore.collection('users').doc(currentUser!.phoneNumber);

      await userReference.update({'profilePhotoUrl': downloadUrl});

      log("Profile photo updated");
    } on Exception catch (e) {
      log("Error in updating user name $e");
    }
  }

  Future<void> updateUserName(String userName) async {
    try {
      log("new user name $userName");
      final currentUser = FirebaseAuth.instance.currentUser;

      final userReference =
          firestore.collection('users').doc(currentUser!.phoneNumber);

      await userReference.update({'userName': userName});
      my_app.User tempUserData = CurrentUser.instance.getCurrentUser;
      tempUserData.userName = userName;
      CurrentUser.instance.setUser = tempUserData;
      log("User name updated");
    } on Exception catch (e) {
      log("Error in updating user name $e");
    }
  }

  Future<void> changeBio(String bio) async {
    try {
      log("new user bio $bio");
      final currentUser = FirebaseAuth.instance.currentUser;

      final userReference =
          firestore.collection('users').doc(currentUser!.phoneNumber);

      await userReference.update({'bio': bio});
      log("bio updation complete");

      my_app.User tempUserData = CurrentUser.instance.currentUser!;
      tempUserData.bio = bio;
      CurrentUser.instance.setUser = tempUserData;
    } on Exception catch (e) {
      log("Error in updating user bio e");
    }
  }

  Future<void> updateMobileNumber(String newNumber, String oldNumber) async {
    await fetchUserDataFromFirebase.updateMobileNumber(newNumber, oldNumber);
  }
}
