import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/presentation/widgets/animations.dart';
import 'package:samvaad/presentation/widgets/avatar_view.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final String profileUrl;
  final String profilePictureId;
  final String name;
  double size;
  String bageIcon;
  ProfileAvatarWidget(
      {super.key,
      required this.profileUrl,
      required this.profilePictureId,
      required this.name,
      this.size = 20,
      this.bageIcon = "NaN"});

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  MediaHandler mediaHandler = MediaHandler();
  File? profileFile;

  @override
  Widget build(BuildContext context) {
    log("Profile url ++++++++++++++++++++++++++++++++++ ${widget.profileUrl}");
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: widget.profileUrl.isEmpty
              ? InitialLetterAvatar(
                  name: widget.name,
                  radius: widget.size,
                )
              : MediaHandler.instance.downloadUrlCache
                          .contains(widget.profileUrl) &&
                      profileFile != null
                  ? AvatarView(
                      avatarImage: profileFile!,
                      size: widget.size,
                    )
                  : FutureBuilder(
                      future: mediaHandler.getMedia(widget.profilePictureId,
                          widget.profileUrl, MediaType.image, "ProfilePicture"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ProfilePictureShimmer();
                        } else if (snapshot.hasError) {
                          return InitialLetterAvatar(
                            name: widget.name,
                            radius: widget.size,
                          );
                        } else {
                          if (snapshot.data != null) {
                            profileFile = snapshot.data!;
                            log("new image loaded from media handler");
                            return AvatarView(
                              avatarImage: snapshot.data!,
                              size: widget.size,
                            );
                          } else {
                            return InitialLetterAvatar(
                              name: widget.name,
                              radius: widget.size,
                            );
                          }
                        }
                      },
                    ),
        ),
        BadgeIconSelector(badgeName: widget.bageIcon)
      ],
    );
  }
}
