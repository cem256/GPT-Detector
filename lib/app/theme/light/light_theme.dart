import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/base/base_theme.dart';
import 'package:gpt_detector/app/theme/theme_extensions/theme_extensions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class LightTheme extends BaseTheme {
  @override
  Brightness get brightness => Brightness.light;

  @override
  Iterable<ThemeExtension<AppThemeExtensions>> get extensions => [
        AppThemeExtensions(
          humanContent: const Color(0xFF007256),
          aiContent: const Color(0xFFBA1A1A),
          mixedContent: const Color(0xFFFF7E79),
        ),
      ];
}
