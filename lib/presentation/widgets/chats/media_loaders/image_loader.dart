import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';

import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';

class ImageLoader extends StatefulWidget {
  Message message;
  ImageLoader({
    super.key,
    required this.message,
  });

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  bool doesUserWantsToDownload = false;
  bool isDownloaded = false;
  bool isCheking = true;
  HiveHandler hiveHandler = HiveHandler();

  @override
  void initState() {
    super.initState();
    hiveHandler
        .checkIfFileIsDownloaded(widget.message.messageId!)
        .then((value) {
      setState(() {
        isDownloaded = value;
        isCheking = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.message.messageStatus == "sent" && doesUserWantsToDownload ||
        isDownloaded) {
      return MediaLoaderWidget(
          mediaType: MediaType.image, message: widget.message);
    } else if (widget.message.messageStatus == "pending") {
      return PendingImageViewerWidget(imageFile: File(widget.message.content!));
    } else if (isCheking) {
      return ImageViewChecking(message: widget.message);
    } else if (!isDownloaded) {
      return ImagePreviewWithDownloadButton(
          message: widget.message,
          onPressed: () {
            setState(() {
              doesUserWantsToDownload = true;
            });
          });
    } else {
      return SizedBox(
        child: Text("Error in loading image"),
      );
    }
  }
}
