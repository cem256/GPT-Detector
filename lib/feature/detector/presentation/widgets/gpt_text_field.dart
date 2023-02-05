import 'package:flutter/material.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTTextField extends StatelessWidget {
  const GPTTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.errorText,
    required this.helperText,
    required this.counterText,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final String helperText;
  final String counterText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: TextInputType.multiline,
      expands: true,
      maxLines: null,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: context.defaultBorderRadius,
        ),
        errorText: errorText,
        helperText: helperText,
        counterText: counterText,
      ),
    );
  }
}
