// ignore_for_file: unused_import, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/video_view.dart';

import 'package:samvaad/presentation/widgets/chats/media_loaders/audio_loader.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/location_loader.dart';
import 'package:samvaad/presentation/widgets/chats/video_message_outgoing_bubble.dart';

class FileLoader extends StatelessWidget {
  MediaType mediaType;
  File file;
  bool isPendingMessage;
  Message message;

  FileLoader(
      {super.key,
      required this.file,
      required this.mediaType,
      required this.isPendingMessage,
      required this.message});

  @override
  Widget build(BuildContext context) {
    if (mediaType == MediaType.document) {
      return PdfThumbnailWidget(
        file: file,
        isPendingMessage: isPendingMessage,
        pdfName: message.extraInfo!.fileName!,
        thumbnail: message.extraInfo!.thumbnail!,
      );
    } else if (mediaType == MediaType.audio) {
      return AudioMessagePlayerWidget(audioFile: file);
    } else if (mediaType == MediaType.image) {
      return ImageViewerWidget(
        imageFile: file,
        aspectRatio: message.extraInfo!.width! / message.extraInfo!.height!,
      );
    } else if (mediaType == MediaType.video) {
      return VideoViewerWidget(videoFile: file, message: message);
    } else if (mediaType == MediaType.contact) {
      return ContactMessageViewer(message: message);
    } else if (mediaType == MediaType.location) {
      return LocationLoader(message: message);
    } else {
      return Placeholder();
    }
  }
}
