// ignore_for_file: invalid_annotation_target
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';

part 'detector_model.freezed.dart';
part 'detector_model.g.dart';

@freezed
class DetectorModel with _$DetectorModel {
  const factory DetectorModel({
    @JsonKey(name: 'average_perplexity') required double? averagePerplexity,
    @JsonKey(name: 'max_perplexity') required double? maxPerplexity,
    @JsonKey(name: 'classification') Classification? classification,
  }) = _DetectorModel;

  factory DetectorModel.fromJson(Map<String, dynamic> json) => _$DetectorModelFromJson(json);
}

extension DetectorModelX on DetectorModel {
  DetectorEntity toDetectorEntity({required bool isSupportedLanguage}) {
    return DetectorEntity(
      averagePerplexity: averagePerplexity ?? 0.0,
      maxPerplexity: maxPerplexity ?? 0.0,
      classification: classification ?? Classification.initial,
      isSupportedLanguage: isSupportedLanguage,
    );
  }
}

@JsonEnum(valueField: 'value')
enum Classification {
  initial(null),
  ai('AI'),
  mixed('MIXED'),
  human('HUMAN');

  const Classification(this.value);
  final String? value;

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
