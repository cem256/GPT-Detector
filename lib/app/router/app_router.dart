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

  static Future<T?> pushReplacement<T>(BuildContext context, Widget widget) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
      ),
    );
  }
}
