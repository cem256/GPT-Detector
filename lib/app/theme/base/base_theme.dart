import 'package:flutter/material.dart';
import 'package:gpt_detector/app/theme/theme_constants.dart';

abstract base class BaseTheme {
  Brightness get brightness;
  Iterable<ThemeExtension<ThemeExtension>> get extensions;

  ThemeData get theme {
    return ThemeData(
      fontFamily: 'Poppins',
      brightness: brightness,
      extensions: extensions,
      colorSchemeSeed: Colors.deepPurple,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      expansionTileTheme: _expansionTileThemeData,
      listTileTheme: _listTileThemeData,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }

  final AppBarTheme _appBarTheme = const AppBarTheme(
    centerTitle: true,
  );

  final CardTheme _cardTheme = CardTheme(
    margin: EdgeInsets.zero,
    elevation: ThemeConstants.elevation,
    shape: RoundedRectangleBorder(
      borderRadius: ThemeConstants.borderRadiusCircular,
    ),
  );

  final DialogTheme _dialogTheme = DialogTheme(
    elevation: ThemeConstants.elevation,
    shape: RoundedRectangleBorder(
      borderRadius: ThemeConstants.borderRadiusCircular,
    ),
  );

  final ExpansionTileThemeData _expansionTileThemeData = const ExpansionTileThemeData(
    tilePadding: EdgeInsets.zero,
    shape: Border(),
  );

  final ListTileThemeData _listTileThemeData = const ListTileThemeData(
    contentPadding: EdgeInsets.zero,
  );

  final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: ThemeConstants.elevation,
      minimumSize: const Size.fromHeight(kToolbarHeight),
      shape: RoundedRectangleBorder(
        borderRadius: ThemeConstants.borderRadiusCircular,
      ),
    ),
  );

  final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: ThemeConstants.borderRadiusCircular,
    ),
  );
}
