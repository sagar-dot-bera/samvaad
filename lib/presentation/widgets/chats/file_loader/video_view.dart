import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/utils/media_handler.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/router.gr.dart';

class VideoViewerWidget extends StatefulWidget {
  File videoFile;
  Message message;
  VideoViewerWidget(
      {super.key, required this.videoFile, required this.message});

  @override
  State<VideoViewerWidget> createState() => _VideoViewerWidgetState();
}

class _VideoViewerWidgetState extends State<VideoViewerWidget> {
  MediaHandler mediaHandler = MediaHandler();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ImagePreviewWithOutBlur(
          widhtOfImage: widget.message.extraInfo!.width!,
          heightOfImage: widget.message.extraInfo!.height!,
          imageBytes: base64Decode(widget.message.extraInfo!.thumbnail!)),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Icon(
                  FeatherIcons.play,
                  color: AppColors.neutralWhite,
                ),
                onPressed: () {
                  context.router.push(VideoPlayerRoute(file: widget.videoFile));
                },
              )))
    ]);
  }
}

// ignore: must_be_immutable
class PendingVideoViewer extends StatefulWidget {
  Message message;

  PendingVideoViewer({super.key, required this.message});

  @override
  State<PendingVideoViewer> createState() => _PendingVideoViewerState();
}

class _PendingVideoViewerState extends State<PendingVideoViewer> {
  MediaHandler mediaHandler = MediaHandler();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.file(File(widget.message.extraInfo!.thumbnail!)),
      Positioned.fill(
          child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: AppColors.accentGreen,
              )))
    ]);
  }
}

class VideoFileChekingLoader extends StatelessWidget {
  final Message message;
  const VideoFileChekingLoader({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImagePreview(
            widhtOfImage: message.extraInfo!.width!,
            heightOfImage: message.extraInfo!.height!,
            imageBytes: base64Decode(message.extraInfo!.thumbnail!)),
        Positioned.fill(
            child: Align(alignment: Alignment.center, child: CheckingText()))
      ],
    );
  }
}

class VideoPreviewWithDownloadButton extends StatelessWidget {
  final Message message;
  final Function() onDownloadTap;
  const VideoPreviewWithDownloadButton(
      {super.key, required this.message, required this.onDownloadTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImagePreview(
            widhtOfImage: message.extraInfo!.width!,
            heightOfImage: message.extraInfo!.height!,
            imageBytes: base64Decode(message.extraInfo!.thumbnail!)),
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: IconButton(
                    onPressed: onDownloadTap,
                    icon: Icon(Icons.file_download_outlined))))
      ],
    );
  }
}

class DownloadingVideoPreview extends StatelessWidget {
  final Message message;
  const DownloadingVideoPreview({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImagePreview(
            widhtOfImage: message.extraInfo!.width!,
            heightOfImage: message.extraInfo!.height!,
            imageBytes: base64Decode(message.extraInfo!.thumbnail!)),
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator()))
      ],
    );
    ;
  }
}
