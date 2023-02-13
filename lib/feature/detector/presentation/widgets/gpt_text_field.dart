import 'package:flutter/material.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTTextField extends StatelessWidget {
  const GPTTextField({
    required this.controller,
    required this.onChanged,
    required this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: TextInputType.multiline,
      expands: true,
      maxLines: null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(16, 16, 32, 40),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: context.defaultBorderRadius,
        ),
      ),
    );
  }
}
