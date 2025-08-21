import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:samvaad/core/utils/samvaad_faq.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/router.dart';
import 'package:samvaad/router.gr.dart';

@RoutePage()
class FrequentlyAskedQuestionScreen extends StatelessWidget {
  const FrequentlyAskedQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HeadlineMedium(text: "Samvaad FAQs"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.05),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleLarge(
                    text: SamVaadFAQsAndPrivacy.faqData.keys.elementAt(index)),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.02,
                      vertical: MediaQuery.sizeOf(context).width * 0.01),
                  shrinkWrap: true,
                  itemBuilder: (context, innerIndex) {
                    return GestureDetector(
                      onTap: () {
                        navigatorKey.currentContext?.pushRoute(FAQAnswerRoute(
                            question: SamVaadFAQsAndPrivacy.faqData.values
                                .elementAt(index)
                                .keys
                                .elementAt(innerIndex),
                            answer: SamVaadFAQsAndPrivacy.faqData.values
                                .elementAt(index)
                                .values
                                .elementAt(innerIndex)));
                      },
                      child: TitleSmall(
                          text:
                              "${innerIndex + 1} ${SamVaadFAQsAndPrivacy.faqData.values.elementAt(index).keys.elementAt(innerIndex)}"),
                    );
                  },
                  itemCount: SamVaadFAQsAndPrivacy.faqData.values
                      .elementAt(index)
                      .keys
                      .length,
                )
              ],
            );
          },
          itemCount: SamVaadFAQsAndPrivacy.faqData.keys.length,
        ),
      ),
    );
  }
}
