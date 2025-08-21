import 'package:flutter/material.dart';
import 'package:samvaad/core/themes/app_colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 10,
      thickness: 10,
      color: AppColors.neutralGray,
    );
  }
}
