// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class AppSpacingTiny extends StatelessWidget {
  const AppSpacingTiny({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.0,
    );
  }
}

class AppSpacingSmall extends StatelessWidget {
  const AppSpacingSmall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.0,
    );
  }
}

class AppSpacingMedium extends StatelessWidget {
  const AppSpacingMedium({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
    );
  }
}

class AppSpacingLarge extends StatelessWidget {
  const AppSpacingLarge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130.0,
    );
  }
}
