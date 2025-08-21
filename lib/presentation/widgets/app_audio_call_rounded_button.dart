// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';

class RoundedLableButton extends StatelessWidget {
  Widget buttonIcon;
  void Function() onClick;
  String label;
  Color? enabledBackgroundColor;
  Color? backgroundColor;
  bool? isEnabled = false;

  RoundedLableButton(
      {super.key,
      required this.buttonIcon,
      required this.label,
      required this.backgroundColor,
      required this.onClick,
      this.enabledBackgroundColor,
      this.isEnabled});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: null,
          elevation: 0.0,
          shape: const CircleBorder(),
          backgroundColor:
              isEnabled! ? enabledBackgroundColor : backgroundColor,
          onPressed: onClick,
          child: buttonIcon,
        ),
        const AppSpacingTiny(),
        BodySmallWithOnPrimary(text: label)
      ],
    );
  }
}
