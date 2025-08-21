import 'dart:io';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:samvaad/core/utils/size.dart';

class AvatarView extends StatelessWidget {
  File avatarImage;
  double size;

  AvatarView({
    super.key,
    required this.avatarImage,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: size,
          backgroundImage: Image.file(avatarImage).image,
        ),
      ],
    );
  }
}

class BadgePoistionerWidget extends StatelessWidget {
  Widget child;
  BadgePoistionerWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: TextDirection.ltr,
      bottom: -2,
      end: -2,
      child: BadgeIcon(
        child: child,
      ),
    );
  }
}

class BadgeIcon extends StatelessWidget {
  Widget child;
  BadgeIcon({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2.0),
        constraints: BoxConstraints(
            maxHeight: SizeOf.intance.getHight(context, 0.05),
            maxWidth: SizeOf.intance.getWidth(context, 0.10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Theme.of(context).colorScheme.primary),
        child: child);
  }
}

class SelectedBadgeIcon extends StatelessWidget {
  const SelectedBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BadgePoistionerWidget(
      child: BadgeIcon(
          child: Icon(
        Remix.check_line,
        size: 20,
        color: Theme.of(context).colorScheme.onPrimary,
      )),
    );
  }
}

class MessageCountBadgeIcon extends StatelessWidget {
  const MessageCountBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BadgePoistionerWidget(child: BadgeIcon(child: Placeholder()));
  }
}

class BadgeIconSelector extends StatelessWidget {
  String badgeName;
  BadgeIconSelector({super.key, required this.badgeName});

  @override
  Widget build(BuildContext context) {
    return switch (badgeName) {
      "selected" => SelectedBadgeIcon(),
      "messageCount" => MessageCountBadgeIcon(),
      _ => SizedBox()
    };
  }
}
