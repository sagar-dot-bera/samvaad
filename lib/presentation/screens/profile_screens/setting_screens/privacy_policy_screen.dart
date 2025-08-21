import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/core/utils/samvaad_faq.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';

@RoutePage()
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                SamVaadFAQsAndPrivacy.privacyPolicyIntro,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ListView.builder(
                primary: false,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.sizeOf(context).width * 0.02),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 10,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          BodyMedium(
                            text: SamVaadFAQsAndPrivacy.privacyPolicy.keys
                                .elementAt(index),
                            align: TextAlign.start,
                          ),
                        ],
                      ),
                      BodySmall(
                          text: SamVaadFAQsAndPrivacy.privacyPolicy.values
                              .elementAt(index))
                    ],
                  );
                },
                itemCount: SamVaadFAQsAndPrivacy.privacyPolicy.keys.length,
              )
            ],
          ),
        ),
      ),
    );
  }
}
