import 'package:flutter/material.dart';

abstract class AppRouter {
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
}
