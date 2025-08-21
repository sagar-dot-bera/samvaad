import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/domain/entities/user.dart';

// ignore: must_be_immutable
class ContactWithStatusCell extends StatefulWidget {
  User user;

  ContactWithStatusCell({super.key, required this.user});

  @override
  State<ContactWithStatusCell> createState() => _ContactWithStatusState();
}

class _ContactWithStatusState extends State<ContactWithStatusCell> {
  Uint8List? userProfileImageBytes;
  FetchFiles fetchFiles = FetchFiles(dio: Dio());
  late String userStatus;

  void setUserImage() async {
    final tempFile = await fetchFiles.fetchFile(widget.user.profilePhotoUrl!);
    setState(() {
      userProfileImageBytes = tempFile;
    });
  }

  String setUserStatus() {
    if (widget.user.userStatus != null) {
      if (widget.user.userStatus!.isOnline == true) {
        return "Online";
      } else if (widget.user.userStatus!.isTyping == true) {
        return "Typing..";
      } else {
        return "Offline";
      }
    } else {
      return "";
    }
  }

  @override
  void initState() {
    super.initState();
    setUserImage();
    userStatus = setUserStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width - 80,
      constraints: const BoxConstraints(maxHeight: 100.0),
      padding: const EdgeInsets.fromLTRB(2.0, 0.0, 0.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: userProfileImageBytes != null
                ? Image.memory(userProfileImageBytes!).image
                : Image.network(
                        "https://images.unsplash.com/photo-1515405295579-ba7b45403062?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGFydCUyMHZhbiUyMGdvZ2h8ZW58MHx8MHx8fDA%3D")
                    .image),
        title: Text(
          widget.user.userName!,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          widget.user.phoneNo!,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
    );
  }
}
