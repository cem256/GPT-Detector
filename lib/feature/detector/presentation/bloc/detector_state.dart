part of 'detector_bloc.dart';

enum DetectorStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
class DetectorState with _$DetectorState {
  factory DetectorState({
    @Default(DetectorStatus.initial) DetectorStatus detectorStatus,
    @Default(DetectorEntity(fakeProb: 0, realProb: 0, allTokens: 0)) DetectorEntity result,
    @Default(true) bool isValidInput,
    Failure? failure,
  }) = _DetectorState;
}
