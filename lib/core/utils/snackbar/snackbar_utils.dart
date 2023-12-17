import 'package:flutter/material.dart';
import 'package:gpt_detector/app/constants/duration_constants.dart';

abstract final class SnackbarUtils {
  static void showSnackbar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: DurationConstants.s4()));
  }
}
