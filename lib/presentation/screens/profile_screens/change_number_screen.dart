import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/size.dart';
import 'package:samvaad/main.dart';
import 'package:samvaad/presentation/widgets/app_extended_elevated_button.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Change number"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppSpacingLarge(),
          SizedBox(
            width: SizeOf.intance.getWidth(context, 0.70),
            child: Text(
              "You can set up the new number here. Your account and all your data - messages, contacts, media, etc. will migrate to the new number.",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: SizedBox()),
          AppExtendedElevatedButton(
              buttonLable: "Change number",
              buttonClick: () {
                getIt<AppRouter>()
                    .push(VerificationRouteWrapper(isChangeNumber: true));
              })
        ],
      ),
    );
  }
}
