import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/core/themes/app_colors.dart';

// ignore: must_be_immutable
class ShareContactCell extends StatefulWidget {
  Contact contact;

  ShareContactCell({super.key, required this.contact});

  @override
  State<ShareContactCell> createState() => _ContactCellState();
}

class _ContactCellState extends State<ShareContactCell> {
  Uint8List? userProfileImageBytes;
  FetchFiles fetchFiles = FetchFiles(dio: Dio());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.neutralGray,
        child: Text(widget.contact.fullName!.substring(0, 1).toUpperCase(),
            style: TextStyle(
                color: AppColors.neutralWhite, fontWeight: FontWeight.bold)),
      ),
      title: Text(
        widget.contact.fullName!,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        widget.contact.phoneNumbers!.first,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
