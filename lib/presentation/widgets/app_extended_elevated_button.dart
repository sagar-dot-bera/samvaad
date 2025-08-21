// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AppExtendedElevatedButton extends StatelessWidget {
  String buttonLable;
  void Function() buttonClick;
  AppExtendedElevatedButton(
      {super.key, required this.buttonLable, required this.buttonClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 366,
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      margin: EdgeInsets.only(bottom: 34.0),
      child: ElevatedButton(
        onPressed: buttonClick,
        child: Text(
          buttonLable,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
