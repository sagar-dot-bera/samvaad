import 'dart:io';

import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/audio_file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/video_view.dart';

class PendingMessageViewLoader extends StatelessWidget {
  Message message;
  MediaType mediaType;
  PendingMessageViewLoader(
      {super.key, required this.message, required this.mediaType});

  @override
  Widget build(BuildContext context) {
    if (mediaType == MediaType.image) {
      return PendingImageViewerWidget(imageFile: File(message.content!));
    } else if (mediaType == MediaType.document) {
      return PdfPendingMessageView(
          file: File(message.content!), name: message.extraInfo!.fileName!);
    } else if (mediaType == MediaType.audio) {
      return AudioPreviewDownloading();
    } else if (mediaType == MediaType.video) {
      return PendingVideoViewer(message: message);
    } else {
      return SizedBox();
    }
  }
}
