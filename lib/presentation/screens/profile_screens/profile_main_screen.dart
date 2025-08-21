import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/presentation/screens/profile_screens/profile_screen.dart';

@RoutePage()
class ProfileMainScreen extends StatelessWidget {
  const ProfileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}
