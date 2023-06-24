// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';

part 'detector_model.freezed.dart';
part 'detector_model.g.dart';

@freezed
class DetectorModel with _$DetectorModel {
  const factory DetectorModel({
    @JsonKey(name: 'real_probability') double? realProb,
    @JsonKey(name: 'fake_probability') double? fakeProb,
  }) = _DetectorModel;

  factory DetectorModel.fromJson(Map<String, dynamic> json) => _$DetectorModelFromJson(json);
}

extension DetectorModelX on DetectorModel {
  DetectorEntity toDetectorEntity({required bool isSupportedLanguage}) {
    return DetectorEntity(
      realProb: (realProb ?? 0.0) * 100,
      fakeProb: (fakeProb ?? 0.0) * 100,
      isSupportedLanguage: isSupportedLanguage,
    );
  }
}
