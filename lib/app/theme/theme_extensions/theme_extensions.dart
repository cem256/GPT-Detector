import 'package:flutter/material.dart';

class ThemeExtensions extends ThemeExtension<ThemeExtensions> {
  ThemeExtensions({
    required this.humanContent,
    required this.mixedContent,
    required this.aiContent,
  });

  final Color? humanContent;
  final Color? mixedContent;
  final Color? aiContent;

  @override
  ThemeExtension<ThemeExtensions> lerp(ThemeExtension<ThemeExtensions>? other, double t) {
    if (other is! ThemeExtensions) {
      return this;
    }
    return ThemeExtensions(
      humanContent: Color.lerp(humanContent, other.humanContent, t),
      mixedContent: Color.lerp(mixedContent, other.mixedContent, t),
      aiContent: Color.lerp(aiContent, other.aiContent, t),
    );
  }

  @override
  ThemeExtensions copyWith({
    Color? humanContent,
    Color? mixedContent,
    Color? aiContent,
  }) {
    return ThemeExtensions(
      humanContent: humanContent ?? this.humanContent,
      mixedContent: mixedContent ?? this.mixedContent,
      aiContent: aiContent ?? this.aiContent,
    );
  }

  @override
  String toString() =>
      'ThemeExtensions(humanContent: $humanContent, mixedContent: $mixedContent, aiContent: $aiContent)';
}
