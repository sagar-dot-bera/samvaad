import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';

class AppTopBar extends StatelessWidget {
  String topBarTitle;
  Widget topBarIcon;
  double topBartitleSpacing;
  void Function() topBarIconOnTap;
  AppTopBar(
      {required this.topBarTitle,
      required this.topBarIcon,
      required this.topBarIconOnTap,
      this.topBartitleSpacing = 10});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      scrolledUnderElevation: 0.0,
      pinned: true,
      title: HeadlineMedium(text: topBarTitle),
      titleSpacing: topBartitleSpacing,
      actions: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(onPressed: topBarIconOnTap, icon: topBarIcon),
        )
      ],
    );
  }
}
