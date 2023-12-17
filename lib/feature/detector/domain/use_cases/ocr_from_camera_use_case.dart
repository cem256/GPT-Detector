import 'package:fpdart/fpdart.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class OCRFromCameraUseCase {
  OCRFromCameraUseCase({required DetectorRepository detectorRepository}) : _detectorRepository = detectorRepository;

  final DetectorRepository _detectorRepository;

  Future<Either<Failure, String>> call() {
    return _detectorRepository.ocrFromCamera();
  }
}
