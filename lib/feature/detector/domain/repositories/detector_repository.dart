import 'package:dartz/dartz.dart';

import '../../../../core/failures/failure.dart';
import '../entities/detector/detector_entity.dart';

abstract class DetectorRepository {
  Future<Either<Failure, DetectorEntity>> detect(String inputText);
}
