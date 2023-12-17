import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';
import 'package:gpt_detector/app/theme/theme_extensions/theme_extensions.dart';

abstract base class BaseTheme {
  Brightness get brightness;
  Iterable<ThemeExtension<ThemeExtensions>> get extensions;

  ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: extensions,
      colorSchemeSeed: Colors.deepPurple,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      centerTitle: true,
    );
  }

  CardTheme get _cardTheme {
    return CardTheme(
      margin: EdgeInsets.zero,
      elevation: ThemeConstants.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    );
  }

  DialogTheme get _dialogTheme {
    return DialogTheme(
      elevation: ThemeConstants.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: ThemeConstants.elevation,
          minimumSize: const Size.fromHeight(kToolbarHeight),
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
