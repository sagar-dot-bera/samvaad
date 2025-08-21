import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_image_loader.dart';

class UserAppBarCell extends StatefulWidget {
  final User userDetails;
  final bool showStatus;
  final bool showBio;
  UserAppBarCell(
      {super.key,
      required this.userDetails,
      required this.showStatus,
      required this.showBio});

  @override
  State<UserAppBarCell> createState() => _UserAppBarCellState();
}

class _UserAppBarCellState extends State<UserAppBarCell> {
  String getSubtitle() {
    if (widget.showStatus) {
      if (widget.userDetails.userStatus!.isOnline! &&
          widget.userDetails.userStatus!.isTyping! != true) {
        return "Online";
      } else if (widget.userDetails.userStatus!.isTyping! &&
          widget.userDetails.userStatus!.isOnline!) {
        return "Typing...";
      } else {
        return "Offline";
      }
    } else if (widget.showBio) {
      return widget.userDetails.bio!;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: 0.0,
        contentPadding: const EdgeInsets.all(0.0),
        leading: AvatarImageLoader(
            userId: widget.userDetails.phoneNo!,
            userName: widget.userDetails.userName!,
            profilePhotoUrl: widget.userDetails.profilePhotoUrl!,
            avatarSize: 20),
        title: BodyLarge(text: widget.userDetails.userName!),
        subtitle: BodySmall(text: getSubtitle()));
  }
}
