import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';

class GrainyBackground extends StatelessWidget {
  Widget child;
  GrainyBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
            child: IgnorePointer(
          child: Opacity(
            opacity: 0.15,
            child: Image.asset(
              "lib/assets/image/noisy-background.jpg",
              fit: BoxFit.cover,
            ),
          ),
        )),
      ],
    );
  }
}
