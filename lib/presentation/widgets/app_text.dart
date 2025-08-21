// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class BodyMedium extends StatelessWidget {
  String text;
  TextAlign align;
  BodyMedium({required this.text, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: align,
    );
  }
}

class HeadlineMedium extends StatelessWidget {
  String text;
  TextAlign alig;
  HeadlineMedium({super.key, required this.text, this.alig = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineMedium,
      textAlign: alig,
    );
  }
}

class HeadlineLarge extends StatelessWidget {
  String text;
  HeadlineLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

class BodyLarge extends StatelessWidget {
  String text;
  BodyLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class BodySmall extends StatelessWidget {
  String text;
  BodySmall({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class TitleLarge extends StatelessWidget {
  String text;
  TitleLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      overflow: TextOverflow.visible,
      softWrap: true,
      maxLines: 1,
    );
  }
}

class TitleMedium extends StatelessWidget {
  String text;
  TitleMedium({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium,
      softWrap: false,
      overflow: TextOverflow.fade,
      maxLines: 1,
    );
  }
}

class TitleSmall extends StatelessWidget {
  String text;
  TitleSmall({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }
}

class HeadlineLargeWithOnPrimary extends StatelessWidget {
  String text;
  HeadlineLargeWithOnPrimary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 32.0,
          fontWeight: FontWeight.normal),
    );
  }
}

class BodySmallWithOnPrimary extends StatelessWidget {
  String text;
  BodySmallWithOnPrimary({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 16.0,
          fontWeight: FontWeight.normal),
    );
  }
}
