// ignore_for_file: unused_import, must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/core/utils/hive_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';

class PdfMessageLoader extends StatefulWidget {
  Message message;
  PdfMessageLoader({super.key, required this.message});

  @override
  State<PdfMessageLoader> createState() => _PdfMessageLoaderState();
}

class _PdfMessageLoaderState extends State<PdfMessageLoader> {
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
      log("pdf is downloaded");
      return MediaLoaderWidget(
          mediaType: MediaType.document, message: widget.message);
    } else if (widget.message.messageStatus == "pending") {
      log("pdf is pending");

      return PdfThumbnailWidget(
        file: File(widget.message.content!),
        isPendingMessage: true,
        pdfName: widget.message.extraInfo!.fileName ?? "NaN",
        thumbnail: widget.message.extraInfo!.thumbnail ?? "NaN",
      );
    } else if (isCheking) {
      log("pdf checking");

      return ChekingForPdfDocument(message: widget.message);
    } else if (!isDownloaded) {
      log("pdf is not downloaded");

      return PdfPreviewWithDownloadButton(
          onDownloadTap: () {
            setState(() {
              doesUserWantsToDownload = true;
            });
          },
          message: widget.message);
    } else {
      return SizedBox(
        child: Text("nathi khabar su karvanu che"),
      );
    }
  }
}
