import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HasCameraPermissionUseCase {
  HasCameraPermissionUseCase({required DetectorRepository detectorRepository})
      : _detectorRepository = detectorRepository;

  final DetectorRepository _detectorRepository;

  Future<bool> call() {
    return _detectorRepository.hasCameraPermission();
  }
}
