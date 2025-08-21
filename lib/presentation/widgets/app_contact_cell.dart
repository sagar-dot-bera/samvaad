import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:transparent_image/transparent_image.dart';

// ignore: must_be_immutable
class ContactCell extends StatefulWidget {
  User user;

  ContactCell({super.key, required this.user});

  @override
  State<ContactCell> createState() => _ContactCellState();
}

class _ContactCellState extends State<ContactCell> {
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
        widget.user.bio!,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
