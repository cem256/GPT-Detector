import 'package:flutter/material.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTTitleText extends StatelessWidget {
  const GPTTitleText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }
}
