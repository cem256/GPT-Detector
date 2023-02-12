part of 'detector_cubit.dart';

@freezed
class DetectorState with _$DetectorState {
  factory DetectorState({
    @Default(FormzStatus.pure) FormzStatus status,
    @Default(UserInputForm.pure()) UserInputForm userInput,
    @Default(DetectorEntity(fakeProb: 0, realProb: 0, allTokens: 0)) DetectorEntity result,
    Failure? failure,
  }) = _DetectorState;
}
