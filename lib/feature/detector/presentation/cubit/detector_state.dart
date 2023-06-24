part of 'detector_cubit.dart';

@freezed
class DetectorState with _$DetectorState {
  factory DetectorState({
    required FormzStatus status,
    required UserInputForm userInput,
    required DetectorEntity result,
    Failure? failure,
  }) = _DetectorState;

  factory DetectorState.initial() => DetectorState(
        status: FormzStatus.pure,
        userInput: const UserInputForm.pure(),
        result: DetectorEntity.initial(),
      );
}
