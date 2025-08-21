// ignore_for_file: unused_import, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/image_view.dart';
import 'package:samvaad/presentation/widgets/chats/file_loader/view_pdf_single_page.dart';
import 'package:samvaad/presentation/widgets/chats/media_loaders/audio_loader.dart';

class PdfThumbnailWidget extends StatelessWidget {
  File file;
  String? thumbnail;
  bool isPendingMessage;
  String pdfName;

  PdfThumbnailWidget(
      {super.key,
      required this.file,
      required this.isPendingMessage,
      required this.thumbnail,
      required this.pdfName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.neutralGray,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 2,
                spreadRadius: 1,
                color: Colors.black26,
              )
            ]),
        child: Column(
          children: [
            ClipHalfImage(childWidget: Image.memory(base64Decode(thumbnail!))),
            PdfNameText(pdfName: pdfName)
          ],
        ),
      ),
    );
  }
}

class PdfPendingMessageView extends StatelessWidget {
  final File file;
  final String name;
  const PdfPendingMessageView(
      {super.key, required this.file, required this.name});

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Column(
      children: [
        ViewPdfSinglePage(file: file),
        PdfNameWithProgressWidget(pdfName: name, isInProgress: true)
      ],
    ));
  }
}

class PdfNameWithProgressWidget extends StatelessWidget {
  const PdfNameWithProgressWidget({
    super.key,
    required this.pdfName,
    required this.isInProgress,
  });

  final String pdfName;
  final bool isInProgress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PdfNameText(pdfName: pdfName),
        ),
        SizedBox(
          width: 9,
        ),
        isInProgress
            ? Padding(
                padding: EdgeInsets.all(2.0),
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : SizedBox()
      ],
    );
  }
}

class PdfNameText extends StatelessWidget {
  const PdfNameText({
    super.key,
    required this.pdfName,
  });

  final String pdfName;

  @override
  Widget build(BuildContext context) {
    return Text(
      pdfName,
      maxLines: 2,
      softWrap: true,
      style: Theme.of(context).textTheme.bodyMedium,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PdfPreviewWithDownloadButton extends StatelessWidget {
  Function() onDownloadTap;
  Message message;
  PdfPreviewWithDownloadButton(
      {super.key, required this.onDownloadTap, required this.message});

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Column(
      children: [
        ClipHalfImage(
            childWidget:
                Image.memory(base64Decode(message.extraInfo!.thumbnail!))),
        Row(
          children: [
            Expanded(child: PdfNameText(pdfName: message.extraInfo!.fileName!)),
            SizedBox(
              height: 9,
            ),
            IconButton.outlined(
                onPressed: onDownloadTap,
                icon: Icon(Icons.file_download_outlined))
          ],
        )
      ],
    ));
  }
}

class ChekingForPdfDocument extends StatelessWidget {
  Message message;
  ChekingForPdfDocument({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Column(
      children: [
        Stack(
          children: [
            ClipHalfImage(
                childWidget:
                    Image.memory(base64Decode(message.extraInfo!.thumbnail!))),
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: CheckingText(),
            ))
          ],
        ),
        PdfNameText(pdfName: message.extraInfo!.fileName!)
      ],
    ));
  }
}

class PdfDownloading extends StatelessWidget {
  Message message;
  PdfDownloading({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return MessageContainer(
        widget: Column(
      children: [
        Stack(
          children: [
            ClipHalfImage(
                childWidget:
                    Image.memory(base64Decode(message.extraInfo!.thumbnail!))),
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ))
          ],
        ),
        PdfNameText(pdfName: message.extraInfo!.fileName!)
      ],
    ));
  }
}
