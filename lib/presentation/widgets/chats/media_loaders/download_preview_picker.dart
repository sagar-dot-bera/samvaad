import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/app_enums.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/contact_message_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/audio_file_loader.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/pdf_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/video_view.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/location_loader.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/media_loader_widget.dart';

class DownloadPreviewPicker extends StatefulWidget {
  final Message message;
  const DownloadPreviewPicker({super.key, required this.message});

  @override
  State<DownloadPreviewPicker> createState() => _DownloadPreviewPickerState();
}

class _DownloadPreviewPickerState extends State<DownloadPreviewPicker> {
  bool doesUserWantToDownload = false;

  MediaType getMediaType() {
    if (widget.message.contentType == "image") {
      return MediaType.image;
    } else if (widget.message.contentType == "video") {
      return MediaType.video;
    } else if (widget.message.contentType == "document" ||
        widget.message.contentType == "pdf") {
      return MediaType.document;
    } else if (widget.message.contentType == "audio") {
      return MediaType.audio;
    } else if (widget.message.contentType == "contact") {
      return MediaType.contact;
    } else if (widget.message.contentType == "location") {
      return MediaType.location;
    } else {
      return MediaType.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (doesUserWantToDownload) {
      return MediaLoaderWidget(
          mediaType: getMediaType(), message: widget.message);
    } else if (getMediaType() == MediaType.image) {
      return ImagePreviewWithDownloadButton(
          message: widget.message,
          onPressed: () {
            setState(() {
              doesUserWantToDownload = true;
            });
          });
    } else if (getMediaType() == MediaType.document) {
      return PdfPreviewWithDownloadButton(
          onDownloadTap: () {
            setState(() {
              doesUserWantToDownload = true;
            });
          },
          message: widget.message);
    } else if (getMediaType() == MediaType.audio) {
      return AudioPlayerWithDownloadButton(onDownloadPress: () {
        setState(() {
          doesUserWantToDownload = true;
        });
      });
    } else if (getMediaType() == MediaType.video) {
      return VideoPreviewWithDownloadButton(
          message: widget.message,
          onDownloadTap: () {
            setState(() {
              doesUserWantToDownload = true;
            });
          });
    } else if (getMediaType() == MediaType.contact) {
      return ContactMessageViewer(message: widget.message);
    } else if (getMediaType() == MediaType.location) {
      return LocationLoader(message: widget.message);
    } else {
      return SizedBox(
        child: Text("Error"),
      );
    }
  }
}
