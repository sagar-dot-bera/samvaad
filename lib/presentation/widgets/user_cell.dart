import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_image_loader.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';

class UserCell extends StatefulWidget {
  final User userDetails;
  final bool showStatus;
  final bool showBio;
  bool isSelected;
  bool isAdmin;
  UserCell(
      {super.key,
      required this.userDetails,
      required this.showStatus,
      required this.showBio,
      required this.isSelected,
      this.isAdmin = false});

  @override
  State<UserCell> createState() => _UserCellState();
}

class _UserCellState extends State<UserCell> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: 0.0,
        contentPadding: const EdgeInsets.all(0.0),
        leading: LeadingProfilePictureWidget(
            profileUrl: widget.userDetails.profilePhotoUrl!,
            profileId: widget.userDetails.phoneNo!,
            isSelected: widget.isSelected,
            userName: widget.userDetails.userName!),
        title: BodyLarge(text: widget.userDetails.userName!),
        trailing: widget.isAdmin
            ? Text(
                "Admin",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )
            : SizedBox(),
        subtitle: BodySmall(text: widget.userDetails.bio!));
  }
}
