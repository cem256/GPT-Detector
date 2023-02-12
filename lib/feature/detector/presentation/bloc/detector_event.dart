part of 'detector_bloc.dart';

@freezed
class DetectorEvent with _$DetectorEvent {
  const factory DetectorEvent.detectionRequested({required String userInput}) = _DetectionRequested;
  const factory DetectorEvent.textChanged({required String text}) = _TextChanged;
  const factory DetectorEvent.clearTextPressed() = _ClearTextPressed;
  const factory DetectorEvent.ocrFromGalleryPressed() = _OCRFromGalleryPressed;
  const factory DetectorEvent.ocrFromCameraPressed() = _OCRFromCameraPressed;
}
