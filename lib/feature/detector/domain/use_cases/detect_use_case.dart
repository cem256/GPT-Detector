import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../entities/detector/detector_entity.dart';
import '../repositories/detector_repository.dart';

class DetectUseCase {
  DetectUseCase({required this.detectorRepository});

  final DetectorRepository detectorRepository;

  Future<Either<Failure, DetectorEntity>> call(String inputText) {
    return detectorRepository.detect(inputText);
  }
}
