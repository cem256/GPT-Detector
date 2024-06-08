import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

class GPTElevatedButton extends StatelessWidget {
  const GPTElevatedButton({required this.text, required this.onPressed, super.key, this.showingLoadingIndicator});

  final bool? showingLoadingIndicator;
  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colorScheme.primary,
        foregroundColor: context.colorScheme.onPrimary,
      ),
      onPressed: showingLoadingIndicator ?? false ? null : onPressed,
      child: showingLoadingIndicator ?? false
          ? const CircularProgressIndicator.adaptive()
          : Text(
              text,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colorScheme.onPrimary,
                fontWeight: ThemeConstants.fontWeightBold,
              ),
            ),
    );
  }
}
