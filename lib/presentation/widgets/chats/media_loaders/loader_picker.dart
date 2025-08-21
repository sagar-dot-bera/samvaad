import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/domain/entities/failed_message.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/download_preview_picker.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/pending_message_view.dart';

class LoaderPicker extends StatefulWidget {
  Message message;
  MediaType mediaType;

  LoaderPicker({super.key, required this.mediaType, required this.message});

  @override
  State<LoaderPicker> createState() => _LoaderPickerState();
}

class _LoaderPickerState extends State<LoaderPicker> {
  HiveHandler hiveHandler = HiveHandler();
  MediaHandler mediaHandler = MediaHandler();
  File? messageContentFile;

  bool checkIfPending() {
    if (widget.message.messageStatus == "sent") {
      return false;
    } else {
      return true;
    }
  }

  bool checkIfIsFailed() {
    return widget.message.messageStatus == "failed";
  }

  File? getFileFromCache() {
    log("get file from cache called in loader picker");
    return mediaHandler.getFileFromCache(widget.message.messageId!);
  }

  @override
  void initState() {
    super.initState();
    messageContentFile = getFileFromCache();
  }

  @override
  Widget build(BuildContext context) {
    if (messageContentFile != null && !checkIfPending() || checkIfIsFailed()) {
      return FileLoader(
        file: messageContentFile!,
        mediaType: widget.mediaType,
        isPendingMessage: checkIfPending(),
        message: widget.message,
      );
    } else if (checkIfPending()) {
      return PendingMessageViewLoader(
          message: widget.message, mediaType: widget.mediaType);
    } else {
      return DownloadPreviewPicker(message: widget.message);
    }
  }
}
