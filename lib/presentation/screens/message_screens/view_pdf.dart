import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

@RoutePage()
// ignore: must_be_immutable
class ViewPdfScreen extends StatelessWidget {
  File pdfFile;
  ViewPdfScreen({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: PdfViewer.file(pdfFile.path)),
    );
  }
}
