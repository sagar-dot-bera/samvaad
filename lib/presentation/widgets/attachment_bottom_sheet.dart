// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showMyBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return AttachmentBottomSheet();
        },
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width - 40));
  }
}
