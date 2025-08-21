import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:samvaad/presentation/widgets/app_text.dart';
import 'package:samvaad/presentation/widgets/spacing.dart';

@RoutePage()
class FAQAnswerScreen extends StatelessWidget {
  String question;
  String answer;
  FAQAnswerScreen({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                  fontSize: 24, color: Theme.of(context).colorScheme.primary),
            ),
            AppSpacingSmall(),
            Text(answer)
          ],
        ),
      ),
    );
  }
}
