import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/base/base_theme.dart';
import 'package:gpt_detector/app/theme/theme_extensions/theme_extensions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
final class DarkTheme extends BaseTheme {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  Iterable<ThemeExtension<AppThemeExtensions>> get extensions => [
        AppThemeExtensions(
          humanContent: const Color(0xFF479985),
          aiContent: const Color(0xFF93000A),
          mixedContent: const Color(0xFFFF7E79),
        ),
      ];
}
