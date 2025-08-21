import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/avatar_image_loader.dart';
import 'package:samvaad/presentation/widgets/participant_cell.dart';

class GroupCell extends StatefulWidget {
  Group groupDetail;
  bool boldText;
  bool isSelected;
  bool priyaChe;
  GroupCell({
    super.key,
    required this.groupDetail,
    required this.boldText,
    required this.isSelected,
    required this.priyaChe,
  });

  @override
  State<GroupCell> createState() => _GroupCellState();
}

class _GroupCellState extends State<GroupCell> {
  File? profilePic;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: LeadingProfilePictureWidget(
          profileUrl: widget.groupDetail.profilePhotoUrl,
          profileId: widget.groupDetail.chatId,
          userName: widget.groupDetail.name,
          isSelected: widget.isSelected,
        ),
        title: BodyLarge(text: widget.groupDetail.name),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [widget.priyaChe ? Icon(Remix.star_fill) : SizedBox()],
        ),
      ),
    );
  }
}
