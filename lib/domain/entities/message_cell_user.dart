import 'package:samvaad/domain/entities/user.dart';

class MessageCellUser extends User {
  String lastMessage;
  String lateContactDate;
  int newMessagesCount;

  MessageCellUser(
      {required String userPhoneNumber,
      required String userName,
      required String profileUrl,
      required String bio,
      required this.lastMessage,
      required this.lateContactDate,
      required this.newMessagesCount})
      : super(
            phoneNo: userPhoneNumber,
            userName: userName,
            profilePhotoUrl: profileUrl,
            bio: bio);
}
