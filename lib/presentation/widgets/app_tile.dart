// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AppTile extends StatelessWidget {
  Widget tileIcon;
  String tileTitle;
  void Function()? onTileTap;
  AppTile(
      {required this.onTileTap,
      required this.tileTitle,
      required this.tileIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(tileTitle, style: Theme.of(context).textTheme.bodyLarge),
        leading: tileIcon,
        onTap: onTileTap,
      ),
    );
  }
}
