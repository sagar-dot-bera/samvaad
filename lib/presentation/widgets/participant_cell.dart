import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/format.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/widgets/profile_avatar_widget.dart';

class ParticipantCell extends StatefulWidget {
  Participant participant;
  User participantUserDetails;
  bool isSelected;
  bool priyaChe;
  ParticipantCell(
      {super.key,
      required this.participant,
      required this.participantUserDetails,
      required this.isSelected,
      required this.priyaChe});

  @override
  State<ParticipantCell> createState() => _ParticipantCellState();
}

class _ParticipantCellState extends State<ParticipantCell> {
  Uint8List? userProfileImageBytes;

  FetchFiles fetchFiles = FetchFiles(dio: Dio());
  Format format = Format();
  void setUserImage() async {
    final tempFile = await fetchFiles
        .fetchFile(widget.participantUserDetails.profilePhotoUrl!);
    setState(() {
      userProfileImageBytes = tempFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: 0.0,
        leading: LeadingProfilePictureWidget(
            isSelected: widget.isSelected,
            profileUrl: widget.participantUserDetails.profilePhotoUrl!,
            profileId: widget.participantUserDetails.phoneNo!,
            userName: widget.participantUserDetails.userName!),
        title: Text(
          widget.participantUserDetails.userName!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          widget.participant.lastMessage!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              format
                  .dateFormat24Hourse(widget.participant.lastMessageTimeStamp!),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            //  widget.participant.newMessageCount! > 0
            //     ? Container(
            //         width: 26.0,
            //         height: 26.0,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(100),
            //           color: AppColors.brandColorDark,
            //         ),
            //         child: Center(
            //           child: Text(
            //             widget.participant.newMessageCount.toString(),
            //             style: TextStyle(
            //                 fontSize: 14.0,
            //                 color: Theme.of(context).colorScheme.onPrimary),
            //           ),
            //         ),
            //       )
            //     : const SizedBox(
            //         width: 26,
            //         height: 26,
            //       ),
            widget.priyaChe ? Icon(Remix.star_fill) : SizedBox()
          ],
        ));
  }
}

class LeadingProfilePictureWidget extends StatelessWidget {
  const LeadingProfilePictureWidget(
      {super.key,
      required this.profileUrl,
      required this.profileId,
      required this.isSelected,
      required this.userName});

  final String profileUrl;
  final String profileId;
  final String userName;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: SizeOf.intance.getHight(context, 0.10),
        width: SizeOf.intance.getWidth(context, 0.14),
        child: ProfileAvatarWidget(
          size: 30,
          profileUrl: profileUrl,
          profilePictureId: profileId,
          name: userName,
          bageIcon: isSelected ? "selected" : "NaN",
        ));
  }
}
