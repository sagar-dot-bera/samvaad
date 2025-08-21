// ignore_for_file: unused_import, must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';

class PdfMessageLoader extends StatelessWidget {
  Message message;
  PdfMessageLoader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return message.messageStatus == 'sent'
        ? MediaLoaderWidget(mediaType: MediaType.document, message: message)
        : PdfThumbnailWidget(
            file: File(message.content!),
            isPendingMessage: false,
            thumbnail: message.extraInfo!.thumbnail!,
            pdfName: message.extraInfo!.fileName ?? "NaN.pdf",
          );
  }
}
