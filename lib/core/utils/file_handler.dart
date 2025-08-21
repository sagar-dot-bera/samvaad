import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nanoid/nanoid.dart';

class FileHandler {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadFileToRemote(
      File imageFile, String whereInStorage) async {
    try {
      log("starting file upload");
      final imagesStorageRef = firebaseStorage.ref();
      final currentUserNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      final imageId = nanoid();
      final userPofileImageStorageRef = whereInStorage == 'userGeneratedMedia'
          ? imagesStorageRef.child("$whereInStorage/$imageId")
          : imagesStorageRef.child("$whereInStorage/$currentUserNumber");

      await userPofileImageStorageRef.putFile(imageFile);

      return userPofileImageStorageRef.getDownloadURL().then((value) async {
        log("file download url $value");
        return value;
      });
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
