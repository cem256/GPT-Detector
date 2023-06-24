import 'package:freezed_annotation/freezed_annotation.dart';

part 'detector_entity.freezed.dart';

@freezed
class DetectorEntity with _$DetectorEntity {
  const factory DetectorEntity({
    required double realProb,
    required double fakeProb,
    required bool isSupportedLanguage,
  }) = _DetectorEntity;

  factory DetectorEntity.initial() => const DetectorEntity(
        realProb: 0,
        fakeProb: 0,
        isSupportedLanguage: true,
      );
}
