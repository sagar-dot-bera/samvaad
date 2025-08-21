import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ContactHostScreen extends StatelessWidget {
  const ContactHostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoRouter();
  }
}
