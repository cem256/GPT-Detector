import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
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
  })  : _detectUseCase = detectUseCase,
        _ocrFromGalleryUseCase = ocrFromGalleryUseCase,
        _ocrFromCameraUseCase = ocrFromCameraUseCase,
        super(DetectorState());

  final DetectUseCase _detectUseCase;
  final OCRFromGalleryUseCase _ocrFromGalleryUseCase;
  final OCRFromCameraUseCase _ocrFromCameraUseCase;

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
    emit(DetectorState());
  }

  Future<void> ocrFromGalleryPressed() async {
    final result = await _ocrFromGalleryUseCase.call();

    result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
      },
      (recognizedImage) {
        final userInput = UserInputForm.dirty(recognizedImage);
        emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
      },
    );
  }

  Future<void> ocrFromCameraPressed() async {
    final result = await _ocrFromCameraUseCase.call();

    result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
      },
      (recognizedImage) {
        final userInput = UserInputForm.dirty(recognizedImage);
        emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
      },
    );
  }
}
