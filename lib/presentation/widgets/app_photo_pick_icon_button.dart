// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppPhotoPickIconButton extends StatelessWidget {
  Widget buttonIcon;
  String buttonText;
  void Function()? buttonPressed;
  AppPhotoPickIconButton({
    required this.buttonIcon,
    required this.buttonText,
    required this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
            onPressed: buttonPressed,
            icon:
                Padding(padding: const EdgeInsets.all(8.0), child: buttonIcon)),
        Text(buttonText)
      ],
    );
  }
}
