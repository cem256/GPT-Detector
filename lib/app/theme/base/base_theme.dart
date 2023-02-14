import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/app_borders.dart';

abstract class BaseTheme {
  ThemeData get theme {
    return ThemeData(
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
    ).copyWith(typography: Typography.material2021());
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: AppBorders.radiusCircular,
        ),
      ),
    );
  }

  CardTheme get _cardTheme {
    return CardTheme(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: AppBorders.borderRadiusCircular,
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.borderRadiusCircular,
        ),
      ),
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: AppBorders.borderRadiusCircular,
      ),
    );
  }
}
