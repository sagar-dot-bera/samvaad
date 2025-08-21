// ignore_for_file: unused_import, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/domain/entities/message.dart';

import 'package:samvaad/presentation/widgets/chats/file_loader/file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/downloadingPreviewPicker.dart';

class MediaLoaderWidget extends StatefulWidget {
  MediaLoaderWidget(
      {super.key, required this.mediaType, required this.message});

  final Message message;
  final MediaType mediaType;

  @override
  State<MediaLoaderWidget> createState() => _MediaLoaderWidgetState();
}

class _MediaLoaderWidgetState extends State<MediaLoaderWidget>
    with AutomaticKeepAliveClientMixin {
  MediaHandler mediaHandler = MediaHandler();

  double getAspectRation() {
    double ratio =
        widget.message.extraInfo!.width! / widget.message.extraInfo!.height!;

    if (ratio > 0) {
      return ratio;
    } else {
      return 4 / 6;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: mediaHandler.getMedia(
            widget.message.messageId!,
            widget.message.content!,
            widget.mediaType,
            widget.message.extraInfo!.thumbnail!,
            widget.message.sender!),
        builder: (context, file) {
          if (file.connectionState == ConnectionState.waiting) {
            log("showing downloading preview");
            return DownloadingPreviewPicker(message: widget.message);
          } else if (file.hasError) {
            return Text("Error in loading");
          }

          if (file.hasData) {
            log("showing file  media type ${widget.mediaType}");
            return FileLoader(
              file: file.data!,
              mediaType: widget.mediaType,
              isPendingMessage: false,
              message: widget.message,
            );
          } else {
            return Text("No data");
          }
        });
  }

  @override
  bool get wantKeepAlive => true;
}

enum MediaLoadingState {
  checking,
  dowloading,
  complete,
}
