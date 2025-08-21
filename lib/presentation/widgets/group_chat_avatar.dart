import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';

class GroupChatAvatar extends StatelessWidget {
  final Group groupDetail;
  const GroupChatAvatar({super.key, required this.groupDetail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      minVerticalPadding: 0.0,
      leading: LeadingProfilePictureWidget(
          profileUrl: groupDetail.profilePhotoUrl,
          profileId: groupDetail.chatId,
          isSelected: false,
          userName: groupDetail.name),
      title: BodyLarge(text: groupDetail.name),
      subtitle: Text(""),
    );
  }
}
