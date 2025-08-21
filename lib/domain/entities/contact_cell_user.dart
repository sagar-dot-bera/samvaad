import 'package:samvaad/domain/entities/user.dart';

class ContactCell extends User {
  bool isOnline;

  ContactCell(
      {required String phoneNo,
      required String userName,
      required String profilePicUrl,
      required this.isOnline})
      : super(
            phoneNo: phoneNo,
            userName: userName,
            profilePhotoUrl: profilePicUrl);
}
