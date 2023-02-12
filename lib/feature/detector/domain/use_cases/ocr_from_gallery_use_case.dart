import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';

import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';

class OCRFromGalleryUseCase {
  OCRFromGalleryUseCase({required DetectorRepository detectorRepository}) : _detectorRepository = detectorRepository;

  final DetectorRepository _detectorRepository;

  Future<Either<Failure, String>> call() {
    return _detectorRepository.ocrFromGallery();
  }
}
