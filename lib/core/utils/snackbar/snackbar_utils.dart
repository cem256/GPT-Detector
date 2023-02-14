import 'package:flutter/material.dart';
import 'package:gpt_detector/core/extensions/context_extensions.dart';

abstract class SnackbarUtils {
  static void showSnackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          padding: context.paddingAllDefault,
          content: Text(message),
        ),
      );
  }
}
