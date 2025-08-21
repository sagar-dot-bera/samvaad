import 'dart:io';

import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';

class AvatarImageLoader extends StatefulWidget {
  String userId;
  String profilePhotoUrl;
  double avatarSize;
  String userName;
  AvatarImageLoader(
      {super.key,
      required this.userId,
      required this.userName,
      required this.profilePhotoUrl,
      required this.avatarSize});

  @override
  State<AvatarImageLoader> createState() => _AvatarImageLoaderState();
}

class _AvatarImageLoaderState extends State<AvatarImageLoader> {
  MediaHandler mediaHandler = MediaHandler();
  File? profilePic;
  Future<File?> getProfilePic(String mediaId, String downloadUrl) async {
    return await mediaHandler.getMedia(
        mediaId, downloadUrl, MediaType.image, "");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getProfilePic(widget.userId, widget.profilePhotoUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: widget.avatarSize,
              backgroundColor: AppColors.neutralGray,
            );
          } else if (snapshot.data == null || snapshot.hasError) {
            return InitialLetterAvatar(
              name: widget.userName,
              radius: widget.avatarSize,
            );
          } else {
            return CircleAvatar(
              radius: widget.avatarSize,
              backgroundImage: Image.file(snapshot.data!).image,
            );
          }
        });
  }
}
