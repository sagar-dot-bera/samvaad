import 'package:flutter/material.dart';

class AppRoundedButton extends StatelessWidget {
  Widget buttonIcon;
  void Function() onClikc;
  Color? backgroundColor;
  AppRoundedButton(
      {super.key,
      required this.buttonIcon,
      required this.onClikc,
      required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      shape: const CircleBorder(),
      backgroundColor: backgroundColor,
      onPressed: onClikc,
      child: buttonIcon,
    );
  }
}
