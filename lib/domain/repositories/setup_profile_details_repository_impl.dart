import "dart:io";
import "dart:typed_data";

import "package:samvaad/domain/entities/user.dart" as my_app;

//repository to set up profile data
abstract class ProfileDetailsHandlerRepository {
  //method to set up user profile details in database
  Future<void> setUpUserDetails(my_app.User user);
  //method to upload user profile data
  Future<String?> uploadUserProfilePicture(File file, String whereInStorage);
  Future<void> updateUserName(String newName);
  Future<void> changeUserBio(String newBio);
  Future<void> changePhoneNumber(String newPhone, String oldPhone);
  Future<void> updateUserProfileImageUrl(String profilePicUrl);
}
