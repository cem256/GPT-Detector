import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';

abstract class DetectorRepository {
  Future<Either<Failure, DetectorEntity>> detect(String userInput);
  Future<Either<Failure, String>> ocrFromGallery();
  Future<Either<Failure, String>> ocrFromCamera();
}
