import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';

class DetectUseCase {
  DetectUseCase({
    required DetectorRepository detectorRepository,
  }) : _detectorRepository = detectorRepository;

  final DetectorRepository _detectorRepository;

  Future<Either<Failure, DetectorEntity>> call(String inputText) {
    return _detectorRepository.detect(inputText);
  }
}
