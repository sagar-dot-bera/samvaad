import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';

// ignore: must_be_immutable
class MakeCallCell extends StatefulWidget {
  User user;
  void Function() onAudioCallTap;
  bool isSelected;
  MakeCallCell(
      {super.key,
      required this.user,
      required this.onAudioCallTap,
      required this.isSelected});

  @override
  State<MakeCallCell> createState() => _MakeCallCellState();
}

class _MakeCallCellState extends State<MakeCallCell> {
  Uint8List? userProfileImageBytes;
  FetchFiles fetchFiles = FetchFiles(dio: Dio());
  void setUserImage() async {
    final tempFile = await fetchFiles.fetchFile(widget.user.profilePhotoUrl!);
    setState(() {
      userProfileImageBytes = tempFile;
    });
  }

  @override
  void initState() {
    super.initState();
    setUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0.0,
      contentPadding: EdgeInsets.all(0.0),
      leading: LeadingProfilePictureWidget(
          profileUrl: widget.user.profilePhotoUrl!,
          profileId: widget.user.phoneNo!,
          isSelected: widget.isSelected,
          userName: widget.user.userName!),
      title: Text(
        widget.user.userName!,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: IconButton(
        icon: Icon(
          FeatherIcons.phone,
          color: AppColors.neutralBlack,
        ),
        onPressed: widget.onAudioCallTap,
      ),
    );
  }
}
