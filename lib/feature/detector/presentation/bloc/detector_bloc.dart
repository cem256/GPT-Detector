import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/use_cases/detect_use_case.dart';

part 'detector_bloc.freezed.dart';
part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  DetectorBloc({required DetectUseCase detectUseCase})
      : _detectUseCase = detectUseCase,
        super(DetectorState()) {
    on<_DetectionRequested>(_onDetectionRequested);
    on<_ClearTextPressed>(_onClearTextPressed);
  }
  final DetectUseCase _detectUseCase;

  Future<void> _onDetectionRequested(_DetectionRequested event, Emitter<DetectorState> emit) async {
    if (event.textInput.trim().isEmpty) {
      emit(state.copyWith(isValidInput: false));
    } else {
      emit(DetectorState(detectorStatus: DetectorStatus.loading, isValidInput: true));
      final response = await _detectUseCase(event.textInput);

      response.fold(
        (failure) => emit(state.copyWith(detectorStatus: DetectorStatus.failure, failure: failure)),
        (result) => emit(state.copyWith(detectorStatus: DetectorStatus.success, result: result)),
      );
    }
  }

  void _onClearTextPressed(_ClearTextPressed event, Emitter<DetectorState> emit) {
    emit(DetectorState(detectorStatus: DetectorStatus.initial));
  }
}
