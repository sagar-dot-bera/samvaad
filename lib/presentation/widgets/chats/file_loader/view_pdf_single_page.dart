// ignore_for_file: unused_import, must_be_immutable

import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class ViewPdfSinglePage extends StatelessWidget {
  File file;
  ViewPdfSinglePage({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PdfDocumentViewBuilder.file(file.path, builder: (context, document) {
      log("loading pdf");
      return ClipHalfImage(
          childWidget: PdfPageView(document: document, pageNumber: 1));
    });
  }
}

class ClipHalfImage extends StatelessWidget {
  Widget childWidget;
  ClipHalfImage({super.key, required this.childWidget});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Align(
            alignment: Alignment.topCenter,
            heightFactor: 0.3,
            child: childWidget));
  }
}
