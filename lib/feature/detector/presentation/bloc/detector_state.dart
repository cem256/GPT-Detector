part of 'detector_bloc.dart';

@freezed
class DetectorState with _$DetectorState {
  factory DetectorState({
    @Default(PageState.initial) PageState pageState,
    @Default(DetectorEntity(fakeProb: 0.00, realProb: 0.00, allTokens: 0)) DetectorEntity result,
    @Default(true) bool isValidInput,
    Failure? failure,
  }) = _DetectorState;
}
