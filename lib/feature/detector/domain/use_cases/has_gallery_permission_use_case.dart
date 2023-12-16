import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class HasGalleryPermissionUseCase {
  HasGalleryPermissionUseCase({required DetectorRepository detectorRepository})
      : _detectorRepository = detectorRepository;

  final DetectorRepository _detectorRepository;

  Future<bool> call() {
    return _detectorRepository.hasGalleryPermission();
  }
}
