// ignore_for_file: one_member_abstracts

import 'package:dartz/dartz.dart';
import 'package:gpt_detector/app/errors/failure.dart';
import 'package:gpt_detector/feature/detector/domain/entities/detector/detector_entity.dart';

abstract class DetectorRepository {
  Future<Either<Failure, DetectorEntity>> detect(String userInput);
}
