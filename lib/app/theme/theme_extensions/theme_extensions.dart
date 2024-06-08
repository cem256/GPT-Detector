import 'package:flutter/material.dart';

class AppThemeExtensions extends ThemeExtension<AppThemeExtensions> {
  AppThemeExtensions({
    required this.humanContent,
    required this.mixedContent,
    required this.aiContent,
  });

  final Color? humanContent;
  final Color? mixedContent;
  final Color? aiContent;

  @override
  ThemeExtension<AppThemeExtensions> lerp(ThemeExtension<AppThemeExtensions>? other, double t) {
    if (other is! AppThemeExtensions) {
      return this;
    }
    return AppThemeExtensions(
      humanContent: Color.lerp(humanContent, other.humanContent, t),
      mixedContent: Color.lerp(mixedContent, other.mixedContent, t),
      aiContent: Color.lerp(aiContent, other.aiContent, t),
    );
  }

  @override
  AppThemeExtensions copyWith({
    Color? humanContent,
    Color? mixedContent,
    Color? aiContent,
  }) {
    return AppThemeExtensions(
      humanContent: humanContent ?? this.humanContent,
      mixedContent: mixedContent ?? this.mixedContent,
      aiContent: aiContent ?? this.aiContent,
    );
  }

  @override
  String toString() =>
      'AppThemeExtensions(humanContent: $humanContent, mixedContent: $mixedContent, aiContent: $aiContent)';
}
