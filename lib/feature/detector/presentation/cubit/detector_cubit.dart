import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/constants/cache_constants.dart';
import 'package:gpt_detector/app/constants/duration_constants.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/app/l10n/extensions/app_l10n_extensions.dart';
import 'package:gpt_detector/core/clients/cache/cache_client.dart';
import 'package:gpt_detector/core/clients/gdpr_consent/gdpr_constent_client.dart';
import 'package:gpt_detector/core/utils/snackbar/snackbar_utils.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/has_camera_permission_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/has_gallery_permission_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_camera_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';
import 'package:injectable/injectable.dart';

part 'detector_cubit.freezed.dart';
part 'detector_state.dart';

@injectable
class DetectorCubit extends Cubit<DetectorState> {
  DetectorCubit({
    required DetectUseCase detectUseCase,
    required OCRFromGalleryUseCase ocrFromGalleryUseCase,
    required OCRFromCameraUseCase ocrFromCameraUseCase,
    required HasCameraPermissionUseCase hasCameraPermissionUseCase,
    required HasGalleryPermissionUseCase hasGalleryPermissionUseCase,
    required CacheClient cacheClient,
    required GdprConsentClient gdprConsentClient,
  })  : _detectUseCase = detectUseCase,
        _ocrFromGalleryUseCase = ocrFromGalleryUseCase,
        _ocrFromCameraUseCase = ocrFromCameraUseCase,
        _hasCameraPermissionUseCase = hasCameraPermissionUseCase,
        _hasGalleryPermissionUseCase = hasGalleryPermissionUseCase,
        _cacheClient = cacheClient,
        _gdprConsentClient = gdprConsentClient,
        super(DetectorState.initial());

  final DetectUseCase _detectUseCase;
  final OCRFromGalleryUseCase _ocrFromGalleryUseCase;
  final OCRFromCameraUseCase _ocrFromCameraUseCase;
  final HasCameraPermissionUseCase _hasCameraPermissionUseCase;
  final HasGalleryPermissionUseCase _hasGalleryPermissionUseCase;
  final CacheClient _cacheClient;
  final GdprConsentClient _gdprConsentClient;

  Future<void> initialize() async {
    final successfulAnalysisCount = _cacheClient.getInt(CacheConstants.successfulAnalysisCount) ?? 0;
    final totalAnalysisCount = _cacheClient.getInt(CacheConstants.totalAnalysisCount) ?? 0;
    emit(state.copyWith(successfulAnalysisCount: successfulAnalysisCount, totalAnalysisCount: totalAnalysisCount));
  }

  Future<void> requestGdprConsent() async {
    emit(state.copyWith(requestingGdprConsent: true));
    await _gdprConsentClient.initialize();
    emit(state.copyWith(requestingGdprConsent: false));
  }

  Future<void> checkCameraPermission() async {
    final hasCameraPermission = await _hasCameraPermissionUseCase.call();
    emit(state.copyWith(hasCameraPermission: hasCameraPermission));
  }

  Future<void> checkGalleryPermission() async {
    final hasGalleryPermission = await _hasGalleryPermissionUseCase.call();
    emit(state.copyWith(hasGalleryPermission: hasGalleryPermission));
  }

  Future<void> detectionRequested({required BuildContext context, required String text}) async {
    // Validate user input
    final formStatus = UserInputForm.dirty(text);
    if (formStatus.invalid) {
      switch (formStatus.error) {
        case UserInputFormError.tooShort:
          SnackbarUtils.showSnackbar(context: context, message: context.l10n.textFieldHelperShortText);
        case UserInputFormError.tooLong:
          SnackbarUtils.showSnackbar(context: context, message: context.l10n.textFieldHelperLongText);
        case null:
      }
      return;
    }

    emit(state.copyWith(status: FormzStatus.submissionInProgress, totalAnalysisCount: state.totalAnalysisCount + 1));
    await _cacheClient.setInt(CacheConstants.totalAnalysisCount, state.totalAnalysisCount);
    // Show interstitial ad after each 3 detection requests
    if (state.totalAnalysisCount % 3 == 0) {
      emit(state.copyWith(showInterstitialAd: true));
      await Future<void>.delayed(DurationConstants.ms250());
      emit(state.copyWith(showInterstitialAd: false));
    }

    final response = await _detectUseCase.call(text);

    await response.fold((failure) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionFailure,
          failure: failure,
        ),
      );
    }, (result) async {
      emit(
        state.copyWith(
          status: FormzStatus.submissionSuccess,
          result: result,
          successfulAnalysisCount: state.successfulAnalysisCount + 1,
        ),
      );

      await _cacheClient.setInt(CacheConstants.successfulAnalysisCount, state.successfulAnalysisCount);
      // Show rate app dialog after 2 successful detection requests
      if (state.successfulAnalysisCount == 2) {
        emit(state.copyWith(showRateAppDialog: true));
        await Future<void>.delayed(DurationConstants.ms250());
        emit(state.copyWith(showRateAppDialog: false));
      }
    });
  }

  void textChanged({required String text}) {
    final userInput = UserInputForm.dirty(text);
    emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
  }

  void clearTextPressed() {
    emit(
      state.copyWith(
        status: FormzStatus.pure,
        userInput: const UserInputForm.pure(),
        result: DetectorEntity.initial(),
      ),
    );
  }

  Future<void> ocrFromGalleryPressed() async {
    final result = await _ocrFromGalleryUseCase.call();

    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (recognizedImage) {
        final userInput = UserInputForm.dirty(recognizedImage);
        emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
      },
    );
  }

  Future<void> ocrFromCameraPressed() async {
    final result = await _ocrFromCameraUseCase.call();

    result.fold(
      (failure) => emit(state.copyWith(failure: failure)),
      (recognizedImage) {
        final userInput = UserInputForm.dirty(recognizedImage);
        emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
      },
    );
  }
}
