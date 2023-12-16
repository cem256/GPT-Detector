import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';

abstract base class BaseTheme {
  Brightness get brightness;
  ColorScheme get colorScheme;

  ThemeData get theme {
    return ThemeData(
      useMaterial3: false,
      brightness: brightness,
      colorScheme: colorScheme,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      typography: Typography.material2021(),
    );
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: ThemeConstants.radiusCircular,
        ),
      ),
    );
  }

  CardTheme get _cardTheme {
    return CardTheme(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    );
  }

  DialogTheme get _dialogTheme {
    return DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: ThemeConstants.borderRadiusCircular,
          ),
        ),
      );

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    );
  }
}
