import 'package:freezed_annotation/freezed_annotation.dart';

part 'detector_entity.freezed.dart';

@freezed
class DetectorEntity with _$DetectorEntity {
  const factory DetectorEntity({
    required double realProb,
    required double fakeProb,
    required int allTokens,
  }) = _DetectorEntity;
}
