import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_divider.dart';

class AppSliverDivider extends StatelessWidget {
  const AppSliverDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: AppDivider(),
    );
  }
}
