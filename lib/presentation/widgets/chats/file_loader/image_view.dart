import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.gr.dart';

class ImageViewerWidget extends StatelessWidget {
  File imageFile;
  double aspectRatio;
  ImageViewerWidget(
      {super.key, required this.imageFile, required this.aspectRatio});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(ViewImageRoute(imageFile: imageFile));
      },
      child: Image.file(
        imageFile,
        fit: BoxFit.contain,
      ),
    );
  }
}

class PendingImageViewerWidget extends StatelessWidget {
  File imageFile;
  PendingImageViewerWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(imageFile),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: AppColors.accentGreen,
          ),
        ))
      ],
    );
  }
}

class ImagePreviewWithDownloadButton extends StatelessWidget {
  Message message;
  Function() onPressed;
  ImagePreviewWithDownloadButton(
      {super.key, required this.message, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImagePreview(
            widhtOfImage: message.extraInfo!.width!,
            heightOfImage: message.extraInfo!.width!,
            imageBytes: base64Decode(message.extraInfo!.thumbnail!)),
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: IconButton.filled(
                    onPressed: onPressed,
                    icon: Icon(Icons.file_download_outlined))))
      ],
    );
  }
}

class ImagePreviewWithProgress extends StatelessWidget {
  Message message;
  ImagePreviewWithProgress({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImagePreview(
            widhtOfImage: message.extraInfo!.width!,
            heightOfImage: message.extraInfo!.width!,
            imageBytes: base64Decode(message.extraInfo!.thumbnail!)),
        Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: SizedBox())) //CircularProgressIndicator()))
      ],
    );
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    super.key,
    required this.widhtOfImage,
    required this.heightOfImage,
    required this.imageBytes,
  });

  final int widhtOfImage;
  final int heightOfImage;
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: heightOfImage / widhtOfImage > 0.0
          ? heightOfImage / widhtOfImage
          : 16 / 9,
      child: ClipRRect(
        child: ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: 9, sigmaY: 9),
          child: Image.memory(
            imageBytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ImageViewChecking extends StatelessWidget {
  final Message message;
  const ImageViewChecking({super.key, required this.message});

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
            child: CheckingText(),
          ),
        )
      ],
    );
  }
}

class ImagePreviewWithOutBlur extends StatelessWidget {
  final int widhtOfImage;
  final int heightOfImage;
  final Uint8List imageBytes;

  const ImagePreviewWithOutBlur({
    required this.widhtOfImage,
    required this.heightOfImage,
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: heightOfImage / widhtOfImage > 0.0
          ? heightOfImage / widhtOfImage
          : 16 / 9,
      child: ClipRRect(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
        ),
      ),
    );
    ;
  }
}

class CheckingText extends StatelessWidget {
  const CheckingText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(child: TitleMedium(text: "Checking.."));
  }
}
