import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';
import 'package:samvaad/core/themes/chat_bubble_colors.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:shimmer/shimmer.dart';

class ProfileCellShimmer extends StatelessWidget {
  const ProfileCellShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: AppColors.brandColorLightGray,
        highlightColor: AppColors.neutralWhite,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).width * 0.04,
            horizontal: MediaQuery.sizeOf(context).width * 0.05,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.neutralGray,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ShimmerFakeText(
                      textWidth: 0.40,
                      textHeight: 0.04,
                      backColor: AppColors.neutralGray),
                  SizedBox(height: MediaQuery.sizeOf(context).width * 0.02),
                  ShimmerFakeText(
                    textWidth: 0.30,
                    textHeight: 0.04,
                    backColor: AppColors.neutralGray,
                  )
                ],
              )
            ],
          ),
        ));
  }
}

class ProfilePictureShimmer extends StatelessWidget {
  const ProfilePictureShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.neutralGray,
        ),
        baseColor: AppColors.brandColorLightGray,
        highlightColor: AppColors.neutralWhite);
  }
}

class ShimmerFakeText extends StatelessWidget {
  final double textWidth;
  final double textHeight;
  final Color backColor;

  const ShimmerFakeText(
      {super.key,
      required this.textWidth,
      required this.textHeight,
      required this.backColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * textWidth,
      height: MediaQuery.sizeOf(context).width * textHeight,
      color: backColor,
    );
  }
}

class ProfileCellShimmerList extends StatelessWidget {
  const ProfileCellShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProfileCellShimmer(),
        ProfileCellShimmer(),
        ProfileCellShimmer(),
        ProfileCellShimmer(),
        ProfileCellShimmer(),
      ],
    );
  }
}

class DummayChatShimmer extends StatelessWidget {
  const DummayChatShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              constraints: BoxConstraints(maxWidth: 280, minHeight: 50),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppColors.neutralGrayLight),
              child: ShimmerFackChat(
                align: CrossAxisAlignment.start,
              )),
          SizedBox(
            height: 6.0,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                constraints: BoxConstraints(maxWidth: 250, minHeight: 50),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    color: AppColors.brandColorLightGray),
                child: ShimmerFackChat(
                  align: CrossAxisAlignment.end,
                )),
          )
        ],
      ),
    );
  }
}

class ShimmerFackChat extends StatelessWidget {
  final CrossAxisAlignment align;
  const ShimmerFackChat({super.key, required this.align});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.neutralGray,
      highlightColor: AppColors.neutralWhite,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: align,
          children: [
            ShimmerFakeText(
              textWidth: 0.40,
              textHeight: 0.05,
              backColor: AppColors.neutralBlack,
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.02,
            ),
            ShimmerFakeText(
              textWidth: 0.20,
              textHeight: 0.05,
              backColor: AppColors.neutralGray,
            )
          ],
        ),
      ),
    );
  }
}

enum TransitionType { fade, slide, scale, scaleFade, slideFade }

class AnimatedSwitcherWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final TransitionType transitionType;

  const AnimatedSwitcherWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.transitionType = TransitionType.slide,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (Widget child, Animation<double> animation) {
        final inAnim = animation;
        final outAnim = Tween<double>(begin: 1.0, end: 0.0).animate(animation);

        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(opacity: inAnim, child: child);

          case TransitionType.scale:
            return ScaleTransition(scale: inAnim, child: child);

          case TransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(inAnim),
              child: child,
            );

          case TransitionType.slideFade:
            return FadeTransition(
              opacity: inAnim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(inAnim),
                child: child,
              ),
            );

          case TransitionType.scaleFade:
            return FadeTransition(
              opacity: inAnim,
              child: ScaleTransition(
                scale: inAnim,
                child: child,
              ),
            );

          default:
            return child;
        }
      },
      child: child,
    );
  }
}
