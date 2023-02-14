import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/base/base_theme.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DarkTheme extends BaseTheme {
  @override
  ThemeData get theme {
    return ThemeData(
      appBarTheme: super.theme.appBarTheme,
      cardTheme: super.theme.cardTheme,
      elevatedButtonTheme: super.theme.elevatedButtonTheme,
      inputDecorationTheme: super.theme.inputDecorationTheme,
      colorScheme: _colorScheme,
    ).copyWith(typography: super.theme.typography);
  }

  ColorScheme get _colorScheme {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb39ddb),
      onPrimary: Color(0xff121014),
      primaryContainer: Color(0xff7e57c2),
      onPrimaryContainer: Color(0xfff3edfe),
      secondary: Color(0xff80d8ff),
      onSecondary: Color(0xff0e1414),
      secondaryContainer: Color(0xff00497b),
      onSecondaryContainer: Color(0xffdfebf3),
      tertiary: Color(0xff40c4ff),
      onTertiary: Color(0xff091314),
      tertiaryContainer: Color(0xff0179b6),
      onTertiaryContainer: Color(0xffdff2fc),
      error: Color(0xffcf6679),
      onError: Color(0xff140c0d),
      errorContainer: Color(0xffb1384e),
      onErrorContainer: Color(0xfffbe8ec),
      background: Color(0xff1a191c),
      onBackground: Color(0xffedeced),
      surface: Color(0xff1a191c),
      onSurface: Color(0xffedeced),
      surfaceVariant: Color(0xff242128),
      onSurfaceVariant: Color(0xffdcdcdd),
      outline: Color(0xffa39da3),
      shadow: Color(0xff000000),
      inverseSurface: Color(0xfffaf9fc),
      onInverseSurface: Color(0xff131313),
      inversePrimary: Color(0xff5c536d),
      surfaceTint: Color(0xffb39ddb),
    );
  }
}
