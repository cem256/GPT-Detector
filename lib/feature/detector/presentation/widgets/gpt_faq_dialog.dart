import 'package:flutter/material.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTFAQDialog extends StatelessWidget {
  const GPTFAQDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: context.paddingAllDefault,
      titlePadding: EdgeInsets.only(top: context.defaultValue, left: context.defaultValue),
      title: Text(context.l10n.faqTitle),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FAQQuestion(text: context.l10n.faqQuestion1),
            _FAQAnswer(text: context.l10n.faqQuestion1answer1),
            SizedBox(
              height: context.lowValue,
            ),
            _FAQQuestion(text: context.l10n.faqQuestion2),
            _FAQAnswer(text: context.l10n.faqQuestion2answer1),
            _FAQAnswer(text: context.l10n.faqQuestion2answer2),
          ],
        ),
      ],
    );
  }
}

class _FAQQuestion extends StatelessWidget {
  const _FAQQuestion({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleMedium,
    );
  }
}

class _FAQAnswer extends StatelessWidget {
  const _FAQAnswer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodySmall,
    );
  }
}
