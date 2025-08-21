import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 86)
class User {
  @HiveType(typeId: 0)
  String? phoneNo;
  @HiveType(typeId: 1)
  String? userName;
  @HiveType(typeId: 2)
  String? profilePhotoUrl;
  @HiveType(typeId: 3)
  String? bio;
  @HiveType(typeId: 4)
  UserStatus? userStatus;
  @HiveType(typeId: 5)
  String? fcmToken;

  User(
      {required this.phoneNo,
      required this.userName,
      required this.profilePhotoUrl,
      this.userStatus,
      this.fcmToken,
      this.bio = "Always up for good chat. Let's connect"});

  User.fromJson(Map<String, dynamic> userInJsonForm) {
    phoneNo = userInJsonForm['phoneNo'];
    userName = userInJsonForm['userName'];
    profilePhotoUrl = userInJsonForm['profilePhotoUrl'];
    bio = userInJsonForm['bio'];
    userStatus = UserStatus.fromJson(
        Map<String, dynamic>.from(userInJsonForm['userStatus']));
    fcmToken = userInJsonForm['fcmToken'];
  }

  Map<String, dynamic> toJson() => {
        'phoneNo': phoneNo,
        'userName': userName,
        'profilePhotoUrl': profilePhotoUrl,
        'bio': bio,
        'userStatus': userStatus!.toJson(),
        'fcmToken': fcmToken
      };
}

@HiveType(typeId: 55)
class UserStatus {
  @HiveType(typeId: 0)
  bool? isOnline;
  @HiveType(typeId: 1)
  String? lastSeenTimeStamp;
  @HiveType(typeId: 2)
  bool? isTyping;

  UserStatus(
      {required this.isOnline, required this.lastSeenTimeStamp, this.isTyping});

  UserStatus.fromJson(Map<String, dynamic> data) {
    isOnline = data['isOnline'];
    lastSeenTimeStamp = data['lastSeenTimeStamp'];
    isTyping = data['isTyping'];
  }

  Map<String, dynamic> toJson() => {
        'isOnline': isOnline,
        'lastSeenTimeStamp': lastSeenTimeStamp,
        'isTyping': isTyping
      };
}
