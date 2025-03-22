part of 'detector_cubit.dart';

@freezed
class DetectorState with _$DetectorState {
  factory DetectorState({
    required FormzStatus status,
    required UserInputForm userInput,
    required DetectorEntity result,
    required bool requestingGdprConsent,
    required bool showInterstitialAd,
    required bool showRateAppDialog,
    required int totalAnalysisCount,
    required int successfulAnalysisCount,
    Failure? failure,
    bool? hasCameraPermission,
    bool? hasGalleryPermission,
  }) = _DetectorState;

  factory DetectorState.initial() => DetectorState(
        status: FormzStatus.pure,
        userInput: const UserInputForm.pure(),
        result: DetectorEntity.initial(),
        requestingGdprConsent: false,
        showInterstitialAd: false,
        showRateAppDialog: false,
        totalAnalysisCount: 0,
        successfulAnalysisCount: 0,
      );
}
