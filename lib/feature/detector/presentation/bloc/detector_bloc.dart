import 'package:bloc/bloc.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/ocr_from_gallery_use_case.dart';

part 'detector_bloc.freezed.dart';
part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  DetectorBloc({
    required DetectUseCase detectUseCase,
    required OCRFromGalleryUseCase ocrFromGalleryUseCase,
  })  : _detectUseCase = detectUseCase,
        _ocrFromGalleryUseCase = ocrFromGalleryUseCase,
        super(DetectorState()) {
    on<_DetectionRequested>(_onDetectionRequested);
    on<_TextChanged>(_onTextChanged);
    on<_ClearTextPressed>(_onClearTextPressed);
    on<_OCRFromGalleryPressed>(_onOCRFromGalleryPressed);
  }
  final DetectUseCase _detectUseCase;
  final OCRFromGalleryUseCase _ocrFromGalleryUseCase;

  Future<void> _onDetectionRequested(_DetectionRequested event, Emitter<DetectorState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final response = await _detectUseCase.call(event.userInput);

    response.fold(
      (failure) => emit(state.copyWith(status: FormzStatus.submissionFailure, failure: failure)),
      (result) => emit(state.copyWith(status: FormzStatus.submissionSuccess, result: result)),
    );
  }

  void _onTextChanged(_TextChanged event, Emitter<DetectorState> emit) {
    final userInput = UserInputForm.dirty(event.text);
    emit(state.copyWith(userInput: userInput, status: Formz.validate([userInput])));
  }

  void _onClearTextPressed(_ClearTextPressed event, Emitter<DetectorState> emit) {
    emit(DetectorState());
  }

  Future<void> _onOCRFromGalleryPressed(_OCRFromGalleryPressed event, Emitter<DetectorState> emit) async {
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
}
