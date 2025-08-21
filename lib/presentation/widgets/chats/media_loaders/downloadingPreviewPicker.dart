import 'package:flutter/material.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/audio_file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/video_view.dart';

class DownloadingPreviewPicker extends StatelessWidget {
  Message message;
  DownloadingPreviewPicker({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.contentType == "image") {
      return ImagePreviewWithProgress(message: message);
    } else if (message.contentType == "document" ||
        message.contentType == "pdf") {
      return PdfDownloading(message: message);
    } else if (message.contentType == "audio") {
      return AudioPreviewDownloading();
    } else if (message.contentType == "video") {
      return DownloadingVideoPreview(message: message);
    } else {
      return SizedBox(
        child: Text("Error in loading data"),
      );
    }
  }
}
