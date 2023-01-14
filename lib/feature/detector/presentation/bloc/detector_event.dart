part of 'detector_bloc.dart';

@freezed
class DetectorEvent with _$DetectorEvent {
  const factory DetectorEvent.detectionRequested({required String textInput}) = _DetectionRequested;
  const factory DetectorEvent.clearTextPressed() = _ClearTextPressed;
}
