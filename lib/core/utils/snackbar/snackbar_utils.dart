import 'package:flutter/material.dart';
import 'package:gpt_detector/app/constants/duration_constants.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

abstract final class SnackbarUtils {
  static void showSnackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          padding: context.paddingAllDefault,
          content: Text(
            message,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onPrimary,
              fontWeight: ThemeConstants.fontWeightSemiBold,
            ),
          ),
          duration: DurationConstants.s4(),
          showCloseIcon: true,
        ),
      );
  }
}
