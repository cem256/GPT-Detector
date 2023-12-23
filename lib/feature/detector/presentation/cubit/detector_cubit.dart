import 'package:form_inputs/form_inputs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/base/cubit/base_cubit.dart';

import 'package:gpt_detector/app/errors/failure.dart';
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
class DetectorCubit extends BaseCubit<DetectorState> {
  DetectorCubit({
    required DetectUseCase detectUseCase,
    required OCRFromGalleryUseCase ocrFromGalleryUseCase,
    required OCRFromCameraUseCase ocrFromCameraUseCase,
    required HasCameraPermissionUseCase hasCameraPermissionUseCase,
    required HasGalleryPermissionUseCase hasGalleryPermissionUseCase,
  })  : _detectUseCase = detectUseCase,
        _ocrFromGalleryUseCase = ocrFromGalleryUseCase,
        _ocrFromCameraUseCase = ocrFromCameraUseCase,
        _hasCameraPermissionUseCase = hasCameraPermissionUseCase,
        _hasGalleryPermissionUseCase = hasGalleryPermissionUseCase,
        super(DetectorState.initial());

  final DetectUseCase _detectUseCase;
  final OCRFromGalleryUseCase _ocrFromGalleryUseCase;
  final OCRFromCameraUseCase _ocrFromCameraUseCase;
  final HasCameraPermissionUseCase _hasCameraPermissionUseCase;
  final HasGalleryPermissionUseCase _hasGalleryPermissionUseCase;

  Future<void> checkCameraPermission() async {
    final hasCameraPermission = await _hasCameraPermissionUseCase.call();
    emit(state.copyWith(hasCameraPermission: hasCameraPermission));
  }

  Future<void> checkGalleryPermission() async {
    final hasGalleryPermission = await _hasGalleryPermissionUseCase.call();
    emit(state.copyWith(hasGalleryPermission: hasGalleryPermission));
  }

  Future<void> detectionRequested({required String text}) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));

    final response = await _detectUseCase.call(text);

    response.fold(
      (failure) => emit(state.copyWith(status: FormzStatus.submissionFailure, failure: failure)),
      (result) => emit(state.copyWith(status: FormzStatus.submissionSuccess, result: result)),
    );
  }

  void textChanged({required String text}) {
    final userInput = UserInputForm.dirty(text);
    emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
  }

  void clearTextPressed() {
    emit(DetectorState.initial());
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
