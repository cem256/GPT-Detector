import 'package:dartz/dartz.dart';

import 'package:gpt_detector/core/failures/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';
import 'package:gpt_detector/feature/detector/domain/repositories/detector_repository.dart';

class DetectUseCase {
  DetectUseCase({required this.detectorRepository});

  final DetectorRepository detectorRepository;

  Future<Either<Failure, DetectorEntity>> call(String inputText) {
    return detectorRepository.detect(inputText);
  }
}
