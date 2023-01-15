import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final ThemeData appTheme = FlexThemeData.light(
    scheme: FlexScheme.material,
    typography: Typography.material2021(),
    blendLevel: 6,
  );
}
