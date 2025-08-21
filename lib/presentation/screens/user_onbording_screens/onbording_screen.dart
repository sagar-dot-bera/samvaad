// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class OnBordingScreen extends StatelessWidget {
  const OnBordingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              "Samvaad",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 50.0,
            ),
            SvgPicture.asset(
              "lib/assets/image/Illustration_onbording.svg",
              fit: BoxFit.cover,
              width: 240,
              height: 244,
            ),
            Column(
              children: [
                Text(
                  "Lets talk with you friend and family",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  "wherever whenever",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 60.0,
            ),
            AppExtendedElevatedButton(
              buttonLable: "Continue with phone",
              buttonClick: () {
                context.router.push(VerifyPhoneNumber());
              },
            )
          ],
        ),
      ),
    );
  }
}
