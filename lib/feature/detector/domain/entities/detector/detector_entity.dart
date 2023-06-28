import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/feature/detector/data/model/detector/detector_model.dart';

part 'detector_entity.freezed.dart';

@freezed
class DetectorEntity with _$DetectorEntity {
  const factory DetectorEntity({
    required double averagePerplexity,
    required double maxPerplexity,
    required Classification classification,
    required bool isSupportedLanguage,
  }) = _DetectorEntity;

  factory DetectorEntity.initial() => const DetectorEntity(
        averagePerplexity: 0,
        maxPerplexity: 0,
        classification: Classification.initial,
        isSupportedLanguage: true,
      );
}
