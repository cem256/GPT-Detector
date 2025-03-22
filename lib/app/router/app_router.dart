import 'package:flutter/material.dart';

abstract final class AppRouter {
  static Future<T?> push<T>(BuildContext context, Widget widget) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  static Future<void> pushReplacement(BuildContext context, Widget widget) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }
}
