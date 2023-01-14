import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/page_state.dart';
import '../../../../core/failures/failure.dart';
import '../../domain/entities/detector/detector_entity.dart';
import '../../domain/use_cases/detect_use_case.dart';

part 'detector_bloc.freezed.dart';
part 'detector_event.dart';
part 'detector_state.dart';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  final DetectUseCase detectUseCase;

  DetectorBloc({required this.detectUseCase}) : super(DetectorState()) {
    on<_DetectionRequested>(_onDetectionRequested);
    on<_ClearTextPressed>(_onClearTextPressed);
  }

  Future<void> _onDetectionRequested(_DetectionRequested event, Emitter<DetectorState> emit) async {
    if (event.textInput.trim().isEmpty) {
      emit(state.copyWith(isValidInput: false));
    } else {
      emit(DetectorState(pageState: PageState.loading, isValidInput: true));
      final response = await detectUseCase(event.textInput);

      response.fold(
        (failure) => emit(state.copyWith(pageState: PageState.failure, failure: failure)),
        (result) => emit(state.copyWith(pageState: PageState.loaded, result: result)),
      );
    }
  }

  void _onClearTextPressed(_ClearTextPressed event, Emitter<DetectorState> emit) {
    emit(DetectorState(pageState: PageState.initial));
  }
}
