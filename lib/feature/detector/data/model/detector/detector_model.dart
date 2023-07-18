// ignore_for_file: invalid_annotation_target
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/l10n/l10n.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';

part 'detector_model.freezed.dart';
part 'detector_model.g.dart';

@freezed
class DetectorModel with _$DetectorModel {
  const factory DetectorModel({
    @JsonKey(name: 'average_perplexity') double? averagePerplexity,
    @JsonKey(name: 'max_perplexity') double? maxPerplexity,
    String? classification,
  }) = _DetectorModel;

  factory DetectorModel.fromJson(Map<String, dynamic> json) => _$DetectorModelFromJson(json);
}

extension DetectorModelX on DetectorModel {
  DetectorEntity toDetectorEntity({required bool isSupportedLanguage}) {
    return DetectorEntity(
      averagePerplexity: averagePerplexity ?? 0.0,
      maxPerplexity: maxPerplexity ?? 0.0,
      classification: Classification.fromName(classification),
      isSupportedLanguage: isSupportedLanguage,
    );
  }
}

enum Classification {
  initial,
  ai,
  mixed,
  human;

  /// Converts the api response into [Classification] enum
  static Classification fromName(String? name) {
    switch (name) {
      case 'AI':
        return Classification.ai;
      case 'MIXED':
        return Classification.mixed;
      case 'HUMAN':
        return Classification.human;
      default:
        return Classification.initial;
    }
  }

  /// Returns localized string depending on [Classification] enum
  String convertToLocalizedString(AppLocalizations l10n) {
    switch (this) {
      case Classification.initial:
        return l10n.classificationInitial;
      case Classification.ai:
        return l10n.classificationAI;
      case Classification.mixed:
        return l10n.classificationMixed;
      case Classification.human:
        return l10n.classificationHuman;
    }
  }

  /// Returns color depending on [Classification] enum
  Color getCardColor(ColorScheme colorScheme) {
    switch (this) {
      // Return light green in case of initial state or human content
      case Classification.initial:
      case Classification.human:
        return colorScheme.tertiaryContainer;
      // Return light red in case of ai or mixed content
      case Classification.ai:
      case Classification.mixed:
        return colorScheme.errorContainer;
    }
  }
}
