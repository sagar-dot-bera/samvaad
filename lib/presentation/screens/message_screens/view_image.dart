import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';

@RoutePage()
class ViewImageScreen extends StatelessWidget {
  File? imageFile;
  ViewImageScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: InteractiveViewer(
            child: AspectRatio(
              aspectRatio: 16.0 / 9.0,
              child: Image.file(
                imageFile!,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
